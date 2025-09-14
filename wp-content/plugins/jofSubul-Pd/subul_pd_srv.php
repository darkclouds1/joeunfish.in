<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=UTF-8');
session_start();
date_default_timezone_set('Asia/Seoul');

require($_SERVER['DOCUMENT_ROOT'] . '/classphp/dbConn_fish.php');
$dbConn = new dbconnClassFish;
$conn = $dbConn->conn();

mysqli_set_charset($conn, 'utf8');
mysqli_query($conn, "SET time_zone = '+09:00'");

$logFilePath = __DIR__ . "/logfile.log";

// 파라미터
$category = $_GET['category'] ?? '';
$from_date = $_GET['from_date'] ?? '';
$to_date = $_GET['to_date'] ?? '';

// 수불 추적 데이터 조회
if ($category === "search_pd") {
    $data = getPdData($from_date, $to_date, $conn);
    
    // 맨 앞에 추가했던 디버깅 코드가 오류 메시지를 출력하지 않도록 헤더를 다시 설정
    header('Content-Type: application/json; charset=UTF-8');
    $json = json_encode(['status' => 'success', 'data' => $data], JSON_UNESCAPED_UNICODE);
    if ($json === false) {
        error_log('json_encode error: ' . json_last_error_msg(), 3, $logFilePath);
        echo json_encode(['status' => 'error', 'message' => 'JSON 인코딩 실패: ' . json_last_error_msg()], JSON_UNESCAPED_UNICODE);
        exit;
    }
    echo $json;
    exit;
}

$conn->close();

function getPdData($from_date, $to_date, $conn)
{
    global $logFilePath;
    $product_spec = 'Salmon Trim E BB'; // 제품 규격
    $product_name = '연어필렛-5mm';    // 제품명

    // 1. 초기 재고 계산 (from_date 이전)
    $initial_tongwan_stock = 0;
    $initial_saengsan_stock = 0;

    $sql_initial = "
        SELECT 
            (SELECT COALESCE(SUM(vol), 0) FROM tpurchase_imp WHERE spec = ? AND import_dt < ?) -
            (SELECT COALESCE(COUNT(1), 0) FROM tbarcodein a JOIN tpurchase_imp b ON RIGHT(b.awb, 4) = LEFT(a.lc_no, 4) WHERE b.spec = ? AND a.increate_dt < ?) 
            AS tongwan_stock,
            
            (SELECT COALESCE(COUNT(1), 0) FROM tbarcodeout WHERE origin_store_code = '000' AND prod_nm LIKE CONCAT('%', ?, '%') AND manu_date < ?) -
            (SELECT COALESCE(COUNT(1), 0) FROM tbarcodeout a WHERE a.store_code NOT IN ('000','001','002','003','004','005','006','007') AND prod_nm LIKE CONCAT('%', ?, '%') AND a.increate_dt < ?)
            AS saengsan_stock
    ";
    
    $stmt_initial = $conn->prepare($sql_initial);
    $stmt_initial->bind_param("ssssssss", 
        $product_spec, $from_date, 
        $product_spec, $from_date,
        $product_name, $from_date,
        $product_name, $from_date
    );

    // 로깅을 위해 추가
    $params_initial = [$product_spec, $from_date, $product_spec, $from_date, $product_name, $from_date, $product_name, $from_date];
    $completed_sql_initial = preg_replace_callback(
        '/\?/',
        function ($matches) use (&$params_initial, $conn) {
            $param = array_shift($params_initial);
            return "'" . $conn->real_escape_string($param) . "'";
        },
        $sql_initial
    );
    error_log("[subul_pd_srv.php] Completed initial SQL: " . $completed_sql_initial, 3, $logFilePath);

    $stmt_initial->execute();
    $result_initial = $stmt_initial->get_result();
    if ($row = $result_initial->fetch_assoc()) {
        $initial_tongwan_stock = $row['tongwan_stock'];
        $initial_saengsan_stock = $row['saengsan_stock'];
    }
    $stmt_initial->close();
    
    // 2. 날짜 범위 데이터 조회
    $period = new DatePeriod(
        new DateTime($from_date),
        new DateInterval('P1D'),
        (new DateTime($to_date))->modify('+1 day')
    );

    $dates = [];
    foreach ($period as $date) {
        $dates[] = $date->format('Y-m-d');
    }
    
    // 일별 데이터 조회 쿼리
    $sql_daily = "
        SELECT DATE(`date`) as `date`, `type`, SUM(`value`) as `value` FROM (
            -- 통관계획 (원료입고): vol 컬럼을 value로 사용
            SELECT import_dt AS `date`, 'tongwan' AS `type`, vol AS `value` 
            FROM tpurchase_imp WHERE spec = ? AND import_dt BETWEEN ? AND ?
            UNION ALL
            -- 실제작업 (원료출고): 행(row)당 1개의 박스로 계산
            SELECT a.increate_dt AS `date`, 'silje' AS `type`, 1 AS `value`
            FROM tbarcodein a INNER JOIN tpurchase_imp b ON RIGHT(b.awb, 4) = LEFT(a.lc_no, 4)
            WHERE b.spec = ? AND a.increate_dt BETWEEN ? AND ?
            UNION ALL
            -- 실생산 (생산내역): 행(row)당 1개의 박스로 계산
            SELECT manu_date AS `date`, 'silsaeng' AS `type`, 1 AS `value`
            FROM tbarcodeout WHERE origin_store_code = '000' AND prod_nm LIKE CONCAT('%', ?, '%') AND manu_date BETWEEN ? AND ?
            UNION ALL
            -- 실판매 (납품내역): 행(row)당 1개의 박스로 계산
            SELECT a.increate_dt AS `date`, 'silpan' AS `type`, 1 AS `value`
            FROM tbarcodeout a 
            WHERE a.store_code NOT IN ('000','001','002','003','004','005','006','007') AND prod_nm LIKE CONCAT('%', ?, '%') AND a.increate_dt BETWEEN ? AND ?
            UNION ALL
            -- 예상판매
            SELECT predict_dt as `date`, 'yesangpan' as `type`, (predict_qty DIV 10) as `value`
            FROM torder_predict
            WHERE product_code = ? AND predict_dt BETWEEN ? AND ?

        ) AS daily_data GROUP BY DATE(`date`), `type`
    ";


    $stmt_daily = $conn->prepare($sql_daily);
    if ($stmt_daily === false) {
        die("SQL prepare failed: " . htmlspecialchars($conn->error));
    }

    $stmt_daily->bind_param("sssssssssssssss", 
        $product_spec, $from_date, $to_date,
        $product_spec, $from_date, $to_date,
        $product_name, $from_date, $to_date,
        $product_name, $from_date, $to_date,
        $product_spec, $from_date, $to_date
    );
    
    // 로깅을 위해 추가
    $params_daily = [
        $product_spec, $from_date, $to_date,
        $product_spec, $from_date, $to_date,
        $product_name, $from_date, $to_date,
        $product_name, $from_date, $to_date,
        $product_spec, $from_date, $to_date
    ];
    $completed_sql_daily = preg_replace_callback(
        '/\?/',
        function ($matches) use (&$params_daily, $conn) {
            $param = array_shift($params_daily);
            return "'" . $conn->real_escape_string($param) . "'";
        },
        $sql_daily
    );
    error_log("[subul_pd_srv.php] Completed daily SQL: " . $completed_sql_daily, 3, $logFilePath);
    
    $stmt_daily->execute();
    if ($stmt_daily->error) {
        die("SQL execute failed: " . htmlspecialchars($stmt_daily->error));
    }

    $result_daily = $stmt_daily->get_result();
    $daily_values = [];
    while ($row = $result_daily->fetch_assoc()) {
        $daily_values[$row['date']][$row['type']] = $row['value'];
    }
    $stmt_daily->close();


    // 3. 최종 데이터 가공
    $result_data = [];
    $categories = ['통관계획', '실제작업', '예상생산', '실생산', '예상판매', '실판매', '생산재고', '통관재고'];
    foreach ($categories as $cat) {
        $result_data[$cat] = ['구분' => $cat, '합계' => 0];
    }

    // 1. 조회 시작일 이전의 초기 재고를 계산해서 변수에 할당
    $tongwan_stock = $initial_tongwan_stock;
    $saengsan_stock = $initial_saengsan_stock;

    // 2. 날짜별로 반복하면서 재고를 누적 계산
    foreach ($dates as $date) {
        // 당일 데이터 가져오기
        $tongwan = $daily_values[$date]['tongwan'] ?? 0;   // 당일 통관계획
        $silje = $daily_values[$date]['silje'] ?? 0;       // 당일 실제작업
        $silsaeng = $daily_values[$date]['silsaeng'] ?? 0; // 당일 실생산
        $silpan = $daily_values[$date]['silpan'] ?? 0;     // 당일 실판매
        $yesangpan = $daily_values[$date]['yesangpan'] ?? 0; // 당일 예상판매
        $yesangsaeng = 0; // 예상생산은 현재 로직에 없음

        // 일별 데이터 저장
        $result_data['통관계획'][$date] = round($tongwan, 1);
        $result_data['실제작업'][$date] = round($silje, 1);
        $result_data['예상생산'][$date] = round($yesangsaeng, 1);
        $result_data['실생산'][$date] = round($silsaeng, 1);
        $result_data['예상판매'][$date] = round($yesangpan, 1);
        $result_data['실판매'][$date] = round($silpan, 1);

        // 합계 누적
        $result_data['통관계획']['합계'] += $tongwan;
        $result_data['실제작업']['합계'] += $silje;
        $result_data['예상생산']['합계'] += $yesangsaeng;
        $result_data['실생산']['합계'] += $silsaeng;
        $result_data['예상판매']['합계'] += $yesangpan;
        $result_data['실판매']['합계'] += $silpan;

        // 통관재고 누적 계산 (전일재고 + 당일 통관계획 - 당일 실제작업)
        $tongwan_stock += $tongwan - $silje;

        // 생산재고 누적 계산 (전일재고 + 당일 실생산 - 당일 실판매)
        $saengsan_stock += $silsaeng - $silpan;

        // 계산된 재고를 결과 배열에 저장
        $result_data['생산재고'][$date] = round($saengsan_stock, 1);
        $result_data['통관재고'][$date] = round($tongwan_stock, 1);
    }
     // 합계 처리
    foreach ($categories as $cat) {
        if ($cat !== '생산재고' && $cat !== '통관재고') {
             $result_data[$cat]['합계'] = round($result_data[$cat]['합계'], 1);
        }
    }
    // 재고의 합계는 마지막 날의 재고로 설정
    $result_data['생산재고']['합계'] = round($saengsan_stock, 1);
    $result_data['통관재고']['합계'] = round($tongwan_stock, 1);


    return array_values($result_data);
}