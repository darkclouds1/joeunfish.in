<?PHP
mb_internal_encoding('UTF-8');

// 개발 환경 에러 출력
ini_set('display_errors', 1);
error_reporting(E_ALL);

// 출력 버퍼링 비활성화
if (ob_get_length()) {
    ob_end_clean();
}

session_start();
date_default_timezone_set('Asia/Seoul');

require($_SERVER['DOCUMENT_ROOT'] . '/classphp/dbConn_fish.php');

$dbConn   = new dbconnClassFish;
$conn     = $dbConn->conn();
mysqli_set_charset($conn, 'utf8');
mysqli_query($conn, "SET time_zone = '+09:00'");

$logFilePath = __DIR__ . "/logfile.log";

$category    = isset($_GET['category']) ? $_GET['category'] : 'order';
isset($_GET['user_id']) ? $user_id = $_GET['user_id'] : $user_id = "";
$supply_date = isset($_GET['date']) ? date('Ymd', strtotime($_GET['date'])) : date('Ymd'); // 날짜 형식을 yyyymmdd로 변경

// Require the autoload file
$vendorPath = $_SERVER['DOCUMENT_ROOT'] . '/vendor';
$autoloadPath = $vendorPath . '/autoload.php';

if (file_exists($autoloadPath)) {
    error_log("autoload.php 파일을 찾았습니다: $autoloadPath", 3, $logFilePath);
    require $autoloadPath;
} else {
    error_log("autoload.php 파일을 찾을 수 없습니다: $autoloadPath", 3, $logFilePath);
    die("필요한 파일을 로드할 수 없습니다.");
}

try {
    $spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
    // 스프레드시트 생성 후 추가
    $spreadsheet->getDefaultStyle()->getFont()->setName('맑은 고딕');
    $spreadsheet->getDefaultStyle()->getFont()->setSize(11);

    error_log("PhpSpreadsheet 클래스를 성공적으로 로드했습니다.", 3, $logFilePath);
} catch (Exception $e) {
    error_log("PhpSpreadsheet 클래스 로드 실패: " . $e->getMessage(), 3, $logFilePath);
    die("PhpSpreadsheet 클래스를 로드할 수 없습니다.");
}

// Composer 의존성 확인
$composerJsonPath = $vendorPath . '/composer.json';
if (file_exists($composerJsonPath)) {
    $composerJson = json_decode(file_get_contents($composerJsonPath), true);
    error_log("설치된 의존성: " . print_r($composerJson['require'], true), 3, $logFilePath);
} else {
    error_log("composer.json 파일을 찾을 수 없습니다.", 3, $logFilePath);
}

// Use PhpSpreadsheet classes
// use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xls;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;
// use PhpOffice\PhpSpreadsheet\Style\Border;
// use PhpOffice\PhpSpreadsheet\Style\Alignment;
// use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
// Create a new Spreadsheet object
// $spreadsheet = new Spreadsheet();
// $sheet = $spreadsheet->getActiveSheet();
// $sheet->setTitle('Sheet1');

// 기존 파일 로드
$filePath = __DIR__ . '/DEJON-.xls';
error_log("filePath: " . $filePath, 3, $logFilePath);

$reader = IOFactory::createReader('Xls');
$spreadsheet = $reader->load($filePath);

// 스프레드시트 정보를 문자열로 변환
$spreadsheetInfo = "스프레드시트 로드됨: " . $spreadsheet->getProperties()->getTitle();
error_log($spreadsheetInfo, 3, $logFilePath);

// 로그 파일 권한 확인
if (!is_writable($logFilePath)) {
    die("로그 파일에 쓰기 권한이 없습니다: $logFilePath");
}

// error_log("data: " . print_r($spreadsheet, true), 3, $logFilePath);
$sheet = $spreadsheet->getSheetByName('Sheet1');

// 4행부터 모든 데이터 삭제
$highestRow = $sheet->getHighestRow(); // 시트의 가장 높은 행 번호를 가져옵니다.
$sheet->removeRow(4, $highestRow - 3); // 4행부터 마지막 행까지 삭제

// 데이터베이스에서 데이터를 조회
$data = fetchDataFromDatabase($supply_date);

try {
    // colindex 값이 배열순서
    foreach ($data as &$row) {
        $row = array_values($row);
    }
    unset($row); // 참조 해제
    // // $data의 rowIndex 값을 배열 순서로 변경
    // $data = array_values($data);
    // error_log("data: " . print_r($data, true), 3, $logFilePath);
    foreach ($data as $rowIndex => $row) {
        foreach ($row as $colIndex => $value) {
            try {
                if ($value === null) {
                    $value = '';
                } else {
                    if (in_array($colIndex, [12, 13, 15])) { // M, N, P 열은 숫자로 입력
                        $value = is_numeric($value) ? $value : 0;
                    }
                    $value = strval($value); // 모든 데이터를 문자열로 변환
                }

                $cell = Coordinate::stringFromColumnIndex($colIndex + 1) . ($rowIndex + 4);
                if (in_array($colIndex, [12, 13, 15])) { // M, N, P 열은 숫자로 입력
                    $sheet->getStyle($cell)->getNumberFormat()->setFormatCode(\PhpOffice\PhpSpreadsheet\Style\NumberFormat::FORMAT_NUMBER);
                    $sheet->setCellValue($cell, $value);
                } else {
                    $sheet->setCellValueExplicit($cell, $value, \PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
                }
            } catch (Exception $e) {
                error_log("Row $rowIndex, Column $colIndex: 셀 값 설정 중 오류 발생 - " . $e->getMessage(), 3, $logFilePath);
            }
        }
    }
} catch (Exception $e) {
    error_log("Exception: " . $e->getMessage(), 3, $logFilePath);
    echo "오류가 발생했습니다: " . $e->getMessage();
}

// error_log("data: " . print_r($data, true), 3, $logFilePath);

// 파일 저장
// $writer = new Xls($spreadsheet);  // Excel5 포맷 사용
$writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter($spreadsheet, 'Xls');
$writer->setPreCalculateFormulas(false);

$savePath = __DIR__ . '/DEJON-' . $supply_date . '.xls'; // 새 파일 이름
// error_log("data: " . print_r($savePath, true), 3, $logFilePath);
$writer->save($savePath);


// 파일 다운로드 부분 수정
header('Content-Type: application/vnd.ms-excel');
header('Content-Disposition: attachment; filename="' . rawurlencode(basename($savePath)) . '"');
header('Cache-Control: max-age=0');
$writer->save('php://output');

// 파일 삭제 (옵션)
unlink($savePath);
exit;

// End of Selection

function fetchDataFromDatabase($date)
{
    global $conn;

    $query = "
        SELECT '54115' AS '고객코드',
            tord.supply_dt AS '주문일자',
            'KRW' AS '환종',
            '0' AS '거래구분',
            CASE 
                WHEN (tcomgrp2.tax_rate = 10) THEN 0    -- 과세
                WHEN (tcomgrp2.tax_rate = 0)   THEN 2    -- 면세
            END AS '과세구분',
            '' AS '비고(건)',
            tcomgrp1.store_no AS '납품처코드',
            '' AS '담당자코드',
            '0' AS '단가구분',
            tcomgrp2.store_no AS '품번',
            tord.supply_dt AS '납기일',
            tord.supply_dt AS '출하예정일',
            tprd.quantity AS '주문수량',
            tprd.unit_price AS '주문단가(부가세미포함)',
            '' AS '주문단가(부가세포함)',
            tprd.total_price AS '공급가',
            '' AS '부가세',
            '' AS '합계액',
            '' AS '비고(내역)',
            '' AS '외화단가',
            '' AS '외화금액',
            '' AS '프로젝트코드',
            '' AS '관리구분코드',
            '' AS '검사구분',
            '' AS '단가유형',
            CONCAT(
                    SUBSTRING(tord.doc_no, 5, 3), '-', 
                    SUBSTRING(tord.doc_no, 8, 4), '-', 
                    SUBSTRING(tord.doc_no, 12, 3)
                ) AS '주문번호',
            '' AS 'LC번호',
            '' AS '주문순번',
            '' AS '견적번호',
            '' AS '견적순번',
            '' AS '모품목코드',
            '' AS '거래처명',
            '' AS '사업자번호',
            '' AS '주민번호',
            '' AS '대표자명',
            '' AS '업태',
            '' AS '종목',
            '' AS '주소',
            '' AS '전화번호',
            '' AS '팩스번호'
        FROM torders AS tord
        JOIN torderproducts tprd ON tord.doc_no = tprd.doc_no    -- 문서번호
        JOIN tcomcode tcomgrp1 ON tcomgrp1.store_code = tord.dest_code AND tcomgrp1.grp_code = '1'    -- 점코드
        JOIN tcomcode tcomgrp2 ON tcomgrp2.store_code = tprd.product_code AND tcomgrp2.grp_code = '2' AND tcomgrp2.use_yn = 'y' -- 품번
        WHERE tord.supply_dt = ?
        ORDER BY tcomgrp1.store_no ASC,
         CONCAT(
                    SUBSTRING(tord.doc_no, 5, 3), '-', 
                    SUBSTRING(tord.doc_no, 8, 4), '-', 
                    SUBSTRING(tord.doc_no, 12, 3)
                ) ASC;
    ";

    // 데이터베이스에서 데이터를 조회    
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $date);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    return $data;
}
