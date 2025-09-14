<?php
/* Plugin Name: jofMain-jofMain_ordcntchart : 수량-주문챠트
Plugin URI: https://test.joeunfish.online
Description: 조은수산 입|출고 관리
Version: 1.0
Author: Monolith
Author URI: https://uloca.net
License: GPL2 */

function jof_start_session_ordcnt() {
    if (!session_id()) {
        session_start();
    }
}
add_action('init', 'jof_start_session_ordcnt');

function enqueue_chartjs()
{
    wp_enqueue_script('chartjs', 'https://cdn.jsdelivr.net/npm/chart.js', array(), null, true);
}
add_action('wp_enqueue_scripts', 'enqueue_chartjs');

function jofMainOrdCntChartShortCode()
{
    global $wpdb;
    $logFilePath = __DIR__ . "/logfile.log";
    
    // 간단한 테스트 로그
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] === FUNCTION CALLED ===\n", FILE_APPEND | LOCK_EX);
    
    // 파일 쓰기 권한 테스트
    if (is_writable($logFilePath)) {
        file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] File is writable\n", FILE_APPEND | LOCK_EX);
    } else {
        file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] File is NOT writable\n", FILE_APPEND | LOCK_EX);
    }
    
    // PHP 오류 로그 확인
    $error_log_path = ini_get('error_log');
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] PHP error_log path: " . $error_log_path . "\n", FILE_APPEND | LOCK_EX);
    
    // WordPress 디버그 모드 확인
    if (defined('WP_DEBUG') && WP_DEBUG) {
        file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] WP_DEBUG is enabled\n", FILE_APPEND | LOCK_EX);
    } else {
        file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] WP_DEBUG is disabled\n", FILE_APPEND | LOCK_EX);
    }
    
    $orders_table = 'torders';
    $orderproducts_table = 'torderproducts';

    
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Session started\n", FILE_APPEND | LOCK_EX);

    // 상품 목록 가져오기
    $products = $wpdb->get_results("
        SELECT DISTINCT
            c.store_code AS product_code,
            c.code_exp AS product_name,
            c.unit
        FROM
            tcomcode c
        JOIN
            torderproducts p ON c.store_code = p.product_code
        WHERE
            c.grp_code = '2'
            AND c.use_yn = 'y'
        ORDER BY
            c.order_num ASC
    ");
    
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Products query executed, count: " . count($products) . "\n", FILE_APPEND | LOCK_EX);
    
    if ($wpdb->last_error) {
        file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Products query error: " . $wpdb->last_error . "\n", FILE_APPEND | LOCK_EX);
    }

    // 선택된 상품 설정 => 세션 사용하지 않음 -by darkcloud 2024-11-15
    if (isset($_POST['product_select_ordcnt'])) {
        $selected_product = $_POST['product_select_ordcnt'];
        $_SESSION['selected_product_ordcnt'] = $selected_product;
    } elseif (isset($_SESSION['selected_product_ordcnt'])) {
        $selected_product = $_SESSION['selected_product_ordcnt'];
    } else {
        $selected_product = '2000000560770'; // 기본 상품 코드 설정
        $_SESSION['selected_product_ordcnt'] = $selected_product;
    }

    $_SESSION['selected_product'] = $selected_product;
    
    // 선택된 상품 로그
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Selected product: " . $selected_product . "\n", FILE_APPEND | LOCK_EX);

    // 선택된 상품의 단위 찾기
    $selected_unit = '';
    foreach ($products as $product) {
        if ($product->product_code == $selected_product) {
            $selected_unit = $product->unit;
            break;
        }
    }

    $months = 3;
    $weeks = $months * 4.33; // 한 달 평균 4.33주
    $limit = ceil($weeks); // 주 수를 올림하여 정수로 변환

    $months_ago = date('Ymd', strtotime("-$months months"));
    $today = date('Ymd');
    
    // 날짜 정보 로그
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Date range: $months_ago to $today\n", FILE_APPEND | LOCK_EX);

    // $wpdb->prepare() 대신 직접 쿼리 작성
    $query = "
        SELECT 
            YEARWEEK(STR_TO_DATE(ord.supply_dt, '%Y%m%d'),1) AS year_week,
            MIN(STR_TO_DATE(ord.supply_dt, '%Y%m%d')) AS week_start,
            MAX(STR_TO_DATE(ord.supply_dt, '%Y%m%d')) AS week_end,
            SUM(prd.quantity) AS total_cnt,
            MAX(prd.product_name) AS product_name,
            MAX(prd.create_dt) AS create_dt
        FROM 
            $orders_table ord
        JOIN 
            $orderproducts_table prd ON ord.doc_no = prd.doc_no
        WHERE 
            prd.product_code = '$selected_product'
            AND ord.supply_dt BETWEEN '$months_ago' AND '$today'
        GROUP BY 
            YEARWEEK(STR_TO_DATE(ord.supply_dt, '%Y%m%d'), 1)
        ORDER BY 
            year_week DESC
        LIMIT $limit
    ";

    // 쿼리 로그
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Query: " . $query . "\n", FILE_APPEND | LOCK_EX);
    
    $results = $wpdb->get_results($query);
    
    // 결과 로그
    file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Results count: " . count($results) . "\n", FILE_APPEND | LOCK_EX);
    
    if ($wpdb->last_error) {
        file_put_contents($logFilePath, "[" . date('Y-m-d H:i:s') . "] Database error: " . $wpdb->last_error . "\n", FILE_APPEND | LOCK_EX);
    }

    if (empty($results)) {
        // 기본 제품으로 전환 시도
        $default_product = '2000000560770';
        
        // 기본 제품이 현재 선택된 제품과 다른 경우에만 전환
        if ($selected_product !== $default_product) {
            $_SESSION['selected_product_ordcnt'] = $default_product;
            
            echo "<script>
                alert('데이터가 없습니다. 기본 제품으로 조회합니다.');
                // 폼 생성 및 제출
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = window.location.href;

                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'product_select_ordcnt';
                input.value = '2000000560770';

                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            </script>";
            return;
        } else {
            // 기본 제품에도 데이터가 없는 경우
            echo "<div style='text-align: center; padding: 20px; color: #666;'>";
            echo "<h3>데이터가 없습니다</h3>";
            echo "<p>선택된 기간(" . date('Y-m-d', strtotime($months_ago)) . " ~ " . date('Y-m-d', strtotime($today)) . ")에 주문 데이터가 없습니다.</p>";
            echo "<p>다른 상품을 선택하거나 기간을 확인해주세요.</p>";
            echo "</div>";
            
            // 상품 선택 드롭다운만 표시
            $output = "<form method='post'>";
            $output .= "<select name='product_select_ordcnt' onchange='this.form.submit()'>";
            foreach ($products as $product) {
                $selected = ($product->product_code == $selected_product) ? 'selected' : '';
                $output .= "<option value='{$product->product_code}' {$selected}>{$product->product_name}</option>";
            }
            $output .= "</select>";
            $output .= "</form>";
            
            return $output;
        }
    }

    $results = array_reverse($results);

    $labels = array();
    $data = array();
    $product_name = '';

    // 한글 요일 배열 정의
    $korean_days = array('일', '월', '화', '수', '목', '금', '토');

    foreach ($results as $row) {
        $week_start = strtotime($row->week_start);
        $day_of_week = $korean_days[date('w', $week_start)]; // 한글 요일
        $date_string = date('n/j', $week_start);
        $labels[] = "$date_string ($day_of_week)"; // 날짜와 한글 요일 결합
        $data[] = round($row->total_cnt); // 소수점 제거
        if (empty($product_name)) {
            $product_name = $row->product_name;
        }
    }

    // 평균 계산
    $average = array_sum($data) / count($data);

    // 색상 배열 생성
    $backgroundColors = array_map(function ($value) use ($average) {
        return $value <= $average ? 'rgba(255, 0, 0, 0.8)' : 'rgba(0, 0, 0, 0.8)'; // 빨간색 또는 파란색
    }, $data);

    $borderColors = array_map(function ($value) use ($average) {
        return $value <= $average ? 'rgba(255, 0, 0, 1)' : 'rgba(0, 0, 0, 0.8)'; // 빨간색 또는 파란색
    }, $data);

    $chart_data = array(
        'labels' => $labels,
        'datasets' => array(
            array(
                'data' => $data,
                'backgroundColor' => $backgroundColors, // 조건에 따른 배경색
                'borderColor' => $borderColors, // 조건에 따른 테두리색
                'borderWidth' => 1,
                'barThickness' => 'flex',
                'barPercentage' => 0.5,
            )
        )
    );

    $chart_json = json_encode($chart_data);
    $chart_id = 'myChart_' . uniqid();

    $output = "<form method='post'>";
    $output .= "<select name='product_select_ordcnt' onchange='this.form.submit()'>";
    foreach ($products as $product) {
        $selected = ($product->product_code == $selected_product) ? 'selected' : '';
        $output .= "<option value='{$product->product_code}' {$selected}>{$product->product_name}</option>";
    }
    $output .= "</select>";
    $output .= "</form>";

    $output .= "<div style='height: 270px;'><canvas id='$chart_id'></canvas></div>";
    $output .= "<script>
        document.addEventListener('DOMContentLoaded', function() {
            var ctx = document.getElementById('$chart_id').getContext('2d');
            var chartData = $chart_json;
            new Chart(ctx, {
                type: 'bar',
                data: chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,

                            text: '" . esc_js($product_name) . " ★단위(" . esc_js($selected_unit) . ")★',
                            font: {
                                size: 16,
                                weight: 'bold'
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return new Intl.NumberFormat('ko-KR').format(context.parsed.y);
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value, index, values) {
                                    return new Intl.NumberFormat('ko-KR').format(value);
                                }
                            },
                            grid: {
                                display: true
                            },
                            suggestedMin: 0,
                            suggestedMax: Math.ceil(Math.max(...chartData.datasets[0].data) * 1.1)
                        }
                    }
                }
            });
        });
    </script>";

    return $output;
}
add_shortcode('jofMain_ordcntchart', 'jofMainOrdCntChartShortCode');
