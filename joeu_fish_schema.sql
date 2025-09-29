/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: joeu_fish
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `logdb`
--

DROP TABLE IF EXISTS `logdb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `logdb` (
  `idx` int(11) NOT NULL AUTO_INCREMENT,
  `dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '시간',
  `pg` varchar(1024) NOT NULL COMMENT '접속페이지',
  `id` varchar(50) NOT NULL,
  `ip` varchar(16) NOT NULL COMMENT 'ip addr',
  `rmrk` varchar(2000) NOT NULL,
  `pgDtlCD` varchar(2) DEFAULT NULL COMMENT '01:용역, 02:공사:,  03:물품, 04:사전용역, 05:사공, 06:사물',
  `keyDtlCD` varchar(2) DEFAULT NULL COMMENT '01:공고명, 02:수요기관, 03:공고+수요기관, 04:기업검색, 05:차트보기, 06:공 고상세, 07:수요기관재검색, 08:낙찰결과, 09:기업응찰기록, 10:업체정보, 98info_Fill:,99:일일자료수집',
  `modifydt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`idx`),
  KEY `id` (`id`),
  KEY `dt_idx` (`dt`)
) ENGINE=InnoDB AUTO_INCREMENT=5746 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tascinvt`
--

DROP TABLE IF EXISTS `tascinvt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tascinvt` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '입력일자(선택)',
  `prod_code` varchar(20) NOT NULL COMMENT '상품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '상품명',
  `asc_nm` varchar(20) NOT NULL COMMENT 'ASC명(ex.11미)',
  `init_stock` smallint(6) DEFAULT NULL COMMENT '기초재고',
  `in_luxury` smallint(6) DEFAULT NULL COMMENT '입고(명품)',
  `in_cheong` smallint(6) DEFAULT NULL COMMENT '입고(청해진)',
  `unit_cost` smallint(6) DEFAULT NULL COMMENT '원가',
  `sell_price` smallint(6) DEFAULT NULL COMMENT '판매가',
  `out_qty` smallint(6) DEFAULT NULL COMMENT '출고량',
  `raw_stock` smallint(6) DEFAULT NULL COMMENT '원료재고',
  `realuse_qty` smallint(6) DEFAULT NULL COMMENT '실사용',
  `remain_qty` smallint(6) DEFAULT NULL COMMENT '여량',
  `raw_cost` int(11) DEFAULT NULL COMMENT '원료원가',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`,`increate_dt`,`prod_code`,`asc_nm`),
  KEY `increate_dt_idx` (`increate_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=2551 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ASC수불관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `calculate_tascinvt_qty_insert` 
BEFORE INSERT ON `tascinvt` 
FOR EACH ROW 
BEGIN
    
    SET NEW.realuse_qty = IFNULL(NEW.init_stock, 0) + 
                         IFNULL(NEW.in_luxury, 0) + 
                         IFNULL(NEW.in_cheong, 0) - 
                         IFNULL(NEW.raw_stock, 0);
    
    
    SET NEW.remain_qty = IFNULL(NEW.out_qty, 0) - 
                        NEW.realuse_qty;
                        
    
    SET NEW.raw_cost = IFNULL(NEW.unit_cost, 0) * 
                      NEW.realuse_qty;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `calculate_tascinvt_qty_update` 
BEFORE UPDATE ON `tascinvt` 
FOR EACH ROW 
BEGIN
    
    SET NEW.realuse_qty = IFNULL(NEW.init_stock, 0) + 
                         IFNULL(NEW.in_luxury, 0) + 
                         IFNULL(NEW.in_cheong, 0) - 
                         IFNULL(NEW.raw_stock, 0);
    
    
    SET NEW.remain_qty = IFNULL(NEW.out_qty, 0) - 
                        NEW.realuse_qty;
                        
    
    SET NEW.raw_cost = IFNULL(NEW.unit_cost, 0) * 
                      NEW.realuse_qty;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tascinvt3`
--

DROP TABLE IF EXISTS `tascinvt3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tascinvt3` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '입력일자(선택)',
  `prod_code` varchar(20) NOT NULL COMMENT '상품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '상품명',
  `asc_nm` varchar(20) NOT NULL COMMENT 'ASC명(ex.11미)',
  `init_stock` smallint(6) DEFAULT NULL COMMENT '기초재고',
  `in_luxury` smallint(6) DEFAULT NULL COMMENT '입고(명품)',
  `in_cheong` smallint(6) DEFAULT NULL COMMENT '입고(청해진)',
  `unit_cost` smallint(6) DEFAULT NULL COMMENT '원가',
  `sell_price` smallint(6) DEFAULT NULL COMMENT '판매가',
  `out_qty` smallint(6) DEFAULT NULL COMMENT '출고량',
  `raw_stock` smallint(6) DEFAULT NULL COMMENT '원료재고',
  `realuse_qty` smallint(6) DEFAULT NULL COMMENT '실사용',
  `remain_qty` smallint(6) DEFAULT NULL COMMENT '여량',
  `raw_cost` int(11) DEFAULT NULL COMMENT '원료원가',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`,`increate_dt`,`prod_code`,`asc_nm`),
  KEY `increate_dt_idx` (`increate_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=3307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ASC수불관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `calculate_tascinvt3_qty_insert` 
BEFORE INSERT ON `tascinvt3`
FOR EACH ROW 
BEGIN
    SET NEW.realuse_qty = IFNULL(NEW.init_stock, 0) + 
                         IFNULL(NEW.in_luxury, 0) + 
                         IFNULL(NEW.in_cheong, 0) - 
                         IFNULL(NEW.raw_stock, 0);
    
    SET NEW.remain_qty = IFNULL(NEW.out_qty, 0) - 
                        NEW.realuse_qty;
                        
    SET NEW.raw_cost = IFNULL(NEW.unit_cost, 0) * 
                      NEW.realuse_qty;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `calculate_tascinvt3_qty_update` 
BEFORE UPDATE ON `tascinvt3`
FOR EACH ROW 
BEGIN
    SET NEW.realuse_qty = IFNULL(NEW.init_stock, 0) + 
                         IFNULL(NEW.in_luxury, 0) + 
                         IFNULL(NEW.in_cheong, 0) - 
                         IFNULL(NEW.raw_stock, 0);
    
    SET NEW.remain_qty = IFNULL(NEW.out_qty, 0) - 
                        NEW.realuse_qty;
                        
    SET NEW.raw_cost = IFNULL(NEW.unit_cost, 0) * 
                      NEW.realuse_qty;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `title` varchar(100) NOT NULL COMMENT '제목',
  `content` varchar(500) DEFAULT NULL COMMENT '내용',
  `due_date` date DEFAULT NULL COMMENT '기한',
  `finish_yn` varchar(1) NOT NULL DEFAULT 'n' COMMENT '완료여부_yn',
  `delete_yn` varchar(1) NOT NULL DEFAULT 'n' COMMENT '삭제여부yn',
  `star_yn` varchar(1) NOT NULL DEFAULT 'n' COMMENT '중요표시yn',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `due_date_idx` (`due_date`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='할일 관리';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbarcodein`
--

DROP TABLE IF EXISTS `tbarcodein`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbarcodein` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NOT NULL COMMENT '입력일자_화면',
  `lc_no` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'LC번호',
  `barcode_one` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT '바코드1',
  `barcode_two` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT '바코드2',
  `weight` float(5,1) NOT NULL COMMENT '중량',
  `prod_date` timestamp NULL DEFAULT NULL COMMENT '제조일자',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `increate_dt_idx` (`increate_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=74894 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='입고 관리 항목';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbarcodeinv`
--

DROP TABLE IF EXISTS `tbarcodeinv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbarcodeinv` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NULL DEFAULT NULL COMMENT '기준일(생산일)',
  `store_code` varchar(20) NOT NULL COMMENT '점코드',
  `doc_no` varchar(50) NOT NULL COMMENT 'PO번호',
  `store_no` varchar(20) DEFAULT NULL COMMENT '점포명',
  `prod_code` varchar(20) NOT NULL COMMENT '상품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '상품명',
  `barcode_out` varchar(50) DEFAULT NULL COMMENT '바코드',
  `bl_no` varchar(20) DEFAULT NULL COMMENT 'bl_no(=lc_no)',
  `weight` float(6,1) DEFAULT NULL COMMENT '입점수량',
  `expi_date` date DEFAULT NULL COMMENT '유통기한',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일시=출고일시',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  UNIQUE KEY `barcode_out` (`barcode_out`),
  KEY `idx_tbarcodeinv_prod_code` (`prod_code`),
  KEY `idx_tbarcodeinv_doc_no` (`doc_no`)
) ENGINE=InnoDB AUTO_INCREMENT=316039 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT=' 출고 INVOICE 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbarcodeinv_m`
--

DROP TABLE IF EXISTS `tbarcodeinv_m`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbarcodeinv_m` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NULL DEFAULT NULL COMMENT '기준일(생산일)',
  `store_code` varchar(20) NOT NULL COMMENT '점코드',
  `doc_no` varchar(50) NOT NULL COMMENT 'PO번호',
  `store_no` varchar(20) NOT NULL COMMENT '점포명',
  `invoice_yn` varchar(1) NOT NULL DEFAULT 'n' COMMENT '출고완료여부',
  `total_box` int(11) DEFAULT NULL COMMENT '박스수',
  `total_weight` float(5,1) DEFAULT NULL COMMENT 'total-weight',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일시=출고일시',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `increate_dt_idx` (`increate_dt`,`store_no`)
) ENGINE=InnoDB AUTO_INCREMENT=8383 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT=' 출고 INVOICE 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbarcodeout`
--

DROP TABLE IF EXISTS `tbarcodeout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbarcodeout` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NOT NULL COMMENT '입력일자(선택)',
  `barcode_out` varchar(50) DEFAULT NULL COMMENT '출고바코드',
  `lc_no` varchar(20) NOT NULL COMMENT 'LC번호=>BL번호',
  `store_code` varchar(20) NOT NULL COMMENT '999=개인점',
  `doc_no` varchar(50) DEFAULT NULL COMMENT 'PO번호',
  `origin_store_code` varchar(20) NOT NULL COMMENT '생산시sotore_code(000=조은점)',
  `store_no` varchar(20) NOT NULL COMMENT '코스트코점명(개인점은 직접입력)',
  `pack_color` varchar(20) DEFAULT NULL COMMENT '흰갈초빨노파',
  `manu_date` date NOT NULL COMMENT '제조일자',
  `expi_date` date DEFAULT NULL COMMENT '소비기한',
  `weight` float(6,1) NOT NULL COMMENT '중량(kg)',
  `prod_code` varchar(20) NOT NULL COMMENT '상품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '상품명',
  `invoice_yn` varchar(1) NOT NULL DEFAULT 'n' COMMENT '출고여부yn',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  UNIQUE KEY `barcode_out` (`barcode_out`),
  KEY `store_no_idx` (`store_no`),
  KEY `increate_dt_idx` (`increate_dt`),
  KEY `idx_tbarcodeout_prod_store_date` (`prod_code`,`store_code`,`increate_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=330532 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출고 바코드 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbarcodeout_invt`
--

DROP TABLE IF EXISTS `tbarcodeout_invt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbarcodeout_invt` (
  `invt_date` date NOT NULL COMMENT '재고 기준일자',
  `cnt_fillets` int(11) NOT NULL DEFAULT 0 COMMENT '연어필렛 재고 수량',
  `cnt_fillets_map` int(11) NOT NULL DEFAULT 0 COMMENT 'Map연어필렛 재고 수량',
  `cnt_steaks` int(11) NOT NULL DEFAULT 0 COMMENT '연어(스테이크) 재고 수량',
  `cnt_steaks_bulk` int(11) NOT NULL DEFAULT 0 COMMENT '연어(스테이크용)벌크 재고 수량',
  `cnt_wanchul` int(11) NOT NULL DEFAULT 0 COMMENT '완출점 재고 수량',
  `stock_quantity` int(11) NOT NULL DEFAULT 0 COMMENT '통관재고 마감 수량',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '데이터 생성 시각',
  PRIMARY KEY (`invt_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='일자별 연어생산 재고';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcodebook`
--

DROP TABLE IF EXISTS `tcodebook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcodebook` (
  `serial_no` int(11) NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `major_code` varchar(20) NOT NULL COMMENT '대코드',
  `major_nm` varchar(100) NOT NULL COMMENT '대코드명',
  `code` varchar(20) NOT NULL COMMENT '코드',
  `code_nm` varchar(100) NOT NULL COMMENT '코드명',
  `code_desc` varchar(500) DEFAULT NULL COMMENT '코드 상세설명',
  `order_num` smallint(6) DEFAULT NULL COMMENT '정렬 순서',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부 (Y/N)',
  `remarks` varchar(200) DEFAULT NULL COMMENT '비고',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일시',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일시',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  UNIQUE KEY `unique_code` (`major_code`,`code`),
  KEY `idx_major_code` (`major_code`),
  KEY `idx_use_yn` (`use_yn`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='코드북 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcomcode`
--

DROP TABLE IF EXISTS `tcomcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcomcode` (
  `serial_no` int(11) NOT NULL AUTO_INCREMENT,
  `grp_code` char(1) NOT NULL COMMENT '그룹코드 (1:점코드, 2:상품코드)',
  `grp_nm` varchar(20) DEFAULT NULL COMMENT '그룹코드명',
  `store_code` varchar(20) DEFAULT NULL COMMENT '점코드 또는 상품코드',
  `code_exp` varchar(100) DEFAULT NULL COMMENT '코드 설명',
  `code_exp2` varchar(1000) DEFAULT NULL COMMENT '원재료및함량',
  `unit` varchar(10) DEFAULT NULL COMMENT '단위',
  `tax_rate` float DEFAULT NULL COMMENT '세율',
  `country_origin` varchar(20) DEFAULT NULL COMMENT '원산지',
  `order_num` smallint(6) DEFAULT NULL COMMENT '순서',
  `use_yn` char(1) NOT NULL COMMENT '사용여부 (Y, N)',
  `expi_day` smallint(6) DEFAULT NULL COMMENT '유통기한 (일수)',
  `store_no` varchar(20) DEFAULT NULL COMMENT '상품 또는 납품처코드',
  `temp_code` varchar(1) DEFAULT NULL COMMENT 'F(냉동), C(냉장), A(상온),E(빈란)',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성 시간',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp() COMMENT '데이터 변경 시간',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `idx_tcomcode_grp_use_order` (`grp_code`,`use_yn`,`order_num`),
  KEY `idx_tcomcode_grp_use_order2` (`grp_code`,`use_yn`,`order_num`),
  KEY `idx_tcomcode_product_store` (`store_code`,`code_exp`,`country_origin`),
  KEY `idx_tcomcode_store_unit` (`store_code`,`unit`,`order_num`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공통코드 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcomcodegs`
--

DROP TABLE IF EXISTS `tcomcodegs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcomcodegs` (
  `serial_no` int(11) NOT NULL AUTO_INCREMENT,
  `grp_code` char(1) NOT NULL COMMENT '그룹코드 (1:점코드, 2:상품코드)',
  `grp_nm` varchar(20) DEFAULT NULL COMMENT '그룹코드명',
  `store_code` varchar(20) DEFAULT NULL COMMENT '점코드 또는 상품코드',
  `code_exp` varchar(100) DEFAULT NULL COMMENT '코드 설명',
  `unit` varchar(10) DEFAULT NULL COMMENT '단위',
  `tax_rate` float DEFAULT NULL COMMENT '세율',
  `country_origin` varchar(20) DEFAULT NULL COMMENT '원산지',
  `order_num` smallint(6) DEFAULT NULL COMMENT '순서',
  `use_yn` char(1) NOT NULL COMMENT '사용여부 (Y, N)',
  `expi_day` smallint(6) DEFAULT NULL COMMENT '유통기한 (일수)',
  `store_no` varchar(20) DEFAULT NULL COMMENT '상품 또는 납품처코드',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성 시간',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp() COMMENT '데이터 변경 시간',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `store_code` (`store_code`) USING BTREE,
  KEY `idx_tcomcodegs_grp_code` (`grp_code`),
  KEY `idx_tcomcodegs_use_yn` (`use_yn`),
  KEY `idx_comcodegs` (`store_code`,`grp_code`,`use_yn`),
  KEY `idx_tcomcodegs_grp_use_store` (`grp_code`,`use_yn`,`store_code`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='GS공통코드 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdayprod`
--

DROP TABLE IF EXISTS `tdayprod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdayprod` (
  `serial_no` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `increate_dt` timestamp NOT NULL COMMENT '생산일시',
  `prod_cd` varchar(20) NOT NULL COMMENT '완제품코드',
  `mat_cd` varchar(20) NOT NULL COMMENT '재료코드',
  `qty_unit` decimal(6,1) DEFAULT NULL COMMENT '소모량,생산량_단위(EA,Box)별',
  `qty` decimal(6,1) DEFAULT NULL COMMENT '소모, 생산량(Kg)',
  `yield_rate` decimal(6,2) DEFAULT NULL COMMENT '생산수율',
  `prod_yn` varchar(1) DEFAULT 'n' COMMENT '일일생산확정 완료여부',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일시',
  `create_id` varchar(50) NOT NULL COMMENT '생성자',
  PRIMARY KEY (`serial_no`),
  UNIQUE KEY `unique_prod_mat_increate` (`prod_cd`,`mat_cd`,`increate_dt`),
  CONSTRAINT `tdayprod_ibfk_1` FOREIGN KEY (`prod_cd`) REFERENCES `tdayprod_mst` (`prod_cd`)
) ENGINE=InnoDB AUTO_INCREMENT=15741 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='일일생산실적';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdayprod_lot`
--

DROP TABLE IF EXISTS `tdayprod_lot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdayprod_lot` (
  `increate_dt` datetime NOT NULL,
  `prod_cd` varchar(20) NOT NULL,
  `mat_cd` varchar(20) NOT NULL,
  `serial_no` smallint(2) NOT NULL,
  `qty_use` decimal(6,1) NOT NULL COMMENT '사용량',
  `lotin_nm` varchar(100) DEFAULT NULL COMMENT '입력당시의 lotin_nm',
  `create_id` varchar(50) NOT NULL COMMENT '생성자 ID',
  `create_dt` datetime NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `tpurchase_in_lotin_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`increate_dt`,`prod_cd`,`mat_cd`,`serial_no`),
  KEY `fk_tdayprod_lot_tpurchase_in1_idx` (`tpurchase_in_lotin_id`),
  CONSTRAINT `fk_tdayprod_lot_tpurchase_in1` FOREIGN KEY (`tpurchase_in_lotin_id`) REFERENCES `tpurchase_in` (`lotin_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='자재입고::\n입고된 lot 중에서 선택하여 일일 생산에서 소모량을 추가함.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `after_insert_tdayprod_lot`
AFTER INSERT ON `tdayprod_lot`
FOR EACH ROW
BEGIN
    DECLARE current_qty DECIMAL(7,2);

    
    SELECT qty_incur INTO current_qty
    FROM tpurchase_in
    WHERE lotin_id = NEW.tpurchase_in_lotin_id;

    
    IF current_qty < NEW.qty_use THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '사용량이 재고량보다 큽니다.';
    ELSE
        UPDATE tpurchase_in
        SET qty_incur = qty_incur - NEW.qty_use
        WHERE lotin_id = NEW.tpurchase_in_lotin_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `after_delete_tdayprod_lot`
AFTER DELETE ON `tdayprod_lot`
FOR EACH ROW
BEGIN
    
    UPDATE tpurchase_in
    SET qty_incur = qty_incur + OLD.qty_use
    WHERE lotin_id = OLD.tpurchase_in_lotin_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tdayprod_mst`
--

DROP TABLE IF EXISTS `tdayprod_mst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdayprod_mst` (
  `prod_cd` varchar(20) NOT NULL COMMENT '완제품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '완제품명',
  `unit` varchar(20) NOT NULL COMMENT '단위',
  `order_num` smallint(6) NOT NULL COMMENT '조회순서',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부',
  `create_dt` timestamp NULL DEFAULT current_timestamp() COMMENT '생성일시',
  `create_id` varchar(50) NOT NULL COMMENT '생성자',
  `modify_dt` timestamp NULL DEFAULT NULL COMMENT '변경일시',
  `modify_id` varchar(50) DEFAULT NULL COMMENT '변경자',
  PRIMARY KEY (`prod_cd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='완제품마스터';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdayprodmat_mst`
--

DROP TABLE IF EXISTS `tdayprodmat_mst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdayprodmat_mst` (
  `prod_cd` varchar(20) NOT NULL COMMENT '완제품코드',
  `mat_cd` varchar(20) NOT NULL COMMENT '재료코드',
  `mat_nm` varchar(100) NOT NULL COMMENT '재료명',
  `unit` varchar(20) NOT NULL COMMENT '단위',
  `order_num` smallint(6) NOT NULL COMMENT '표시순서',
  `inv_yn` varchar(1) DEFAULT NULL COMMENT '사용량이 아닌 재고로 관리',
  `temp_code` varchar(1) DEFAULT NULL COMMENT '※보관방법: F(냉동), C(냉장), A(상온), E(빈란)',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부',
  `create_dt` timestamp NULL DEFAULT current_timestamp() COMMENT '생성일시',
  `create_id` varchar(50) NOT NULL COMMENT '생성자',
  `modify_dt` timestamp NULL DEFAULT NULL COMMENT '변경일시',
  `modify_id` varchar(50) DEFAULT NULL COMMENT '변경자',
  PRIMARY KEY (`prod_cd`,`mat_cd`),
  CONSTRAINT `tdayprodmat_mst_ibfk_1` FOREIGN KEY (`prod_cd`) REFERENCES `tdayprod_mst` (`prod_cd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='완제품별재료마스터';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tevent`
--

DROP TABLE IF EXISTS `tevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tevent` (
  `serial_no` int(11) NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `increate_dt` timestamp NULL DEFAULT NULL COMMENT '입력일자',
  `major_code` varchar(20) NOT NULL COMMENT '행사 대코드',
  `code` varchar(20) NOT NULL COMMENT '행사 코드',
  `event_name` varchar(200) NOT NULL COMMENT '행사명',
  `event_desc` text DEFAULT NULL COMMENT '행사 상세설명',
  `start_date` date NOT NULL COMMENT '시작일',
  `end_date` date NOT NULL COMMENT '종료일',
  `days` int(11) GENERATED ALWAYS AS (to_days(`end_date`) - to_days(`start_date`) + 1) STORED COMMENT '행사 기간(일)',
  `prod_code` varchar(20) DEFAULT NULL COMMENT '상품코드',
  `prod_name` varchar(100) DEFAULT NULL COMMENT '상품명',
  `unit_price` decimal(6,0) DEFAULT NULL COMMENT '단가',
  `target_qty` int(11) DEFAULT NULL COMMENT '목표 수량',
  `result_qty` int(11) DEFAULT NULL COMMENT '실적 수량',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부(Y/N)',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일시',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일시',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `idx_date` (`start_date`,`end_date`),
  KEY `idx_code` (`major_code`,`code`),
  KEY `idx_use_yn` (`use_yn`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='행사기획 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgscodeout`
--

DROP TABLE IF EXISTS `tgscodeout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgscodeout` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `increate_dt` timestamp NULL DEFAULT NULL COMMENT '입력일자(선택)',
  `store_code` varchar(20) DEFAULT NULL COMMENT '납품점코드',
  `store_no` varchar(20) DEFAULT NULL COMMENT '납품점명',
  `prod_code` varchar(20) NOT NULL COMMENT '상품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '상품명',
  `weight_in` decimal(6,1) DEFAULT NULL COMMENT '재료중량',
  `prod_quantity` smallint(6) DEFAULT NULL COMMENT '생산수량',
  `weight_out` decimal(6,1) DEFAULT NULL COMMENT '생산중량',
  `prod_yield` decimal(4,1) DEFAULT NULL COMMENT '생산수율',
  `invent_quantity` smallint(6) NOT NULL COMMENT '재고수량',
  `invent_note` varchar(200) DEFAULT NULL COMMENT '재고조정사유',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `store_no_idx` (`store_no`),
  KEY `increate_dt_idx` (`increate_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=763 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출고 바코드 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER before_insert_tgscodeout
BEFORE INSERT ON tgscodeout
FOR EACH ROW
BEGIN
    DECLARE weight DECIMAL(10,3) DEFAULT 0;
    DECLARE unit VARCHAR(2);
    DECLARE weight_str VARCHAR(10);
    DECLARE temp_str VARCHAR(50);
    
    IF NEW.prod_nm IS NOT NULL AND NEW.prod_nm LIKE '%-%' THEN
        SET temp_str = TRIM(SUBSTRING_INDEX(NEW.prod_nm, '-', -1));
        
        IF temp_str LIKE '%kg%' THEN
            SET unit = 'kg';
            SET weight_str = TRIM(SUBSTRING_INDEX(temp_str, 'kg', 1));
            SET weight_str = TRIM(SUBSTRING_INDEX(weight_str, '(', 1));
            IF weight_str REGEXP '^[0-9.]+$' THEN
                SET weight = CAST(weight_str AS DECIMAL(10,3));
                SET NEW.weight_out = ROUND(NEW.prod_quantity * weight, 1);
            END IF;
        ELSEIF temp_str LIKE '%g%' THEN
            SET unit = 'g';
            SET weight_str = TRIM(SUBSTRING_INDEX(temp_str, 'g', 1));
            SET weight_str = TRIM(SUBSTRING_INDEX(weight_str, '(', 1));
            IF weight_str REGEXP '^[0-9.]+$' THEN
                SET weight = CAST(weight_str AS DECIMAL(10,3));
                SET NEW.weight_out = ROUND(NEW.prod_quantity * weight / 1000, 1);
            END IF;
        END IF;
    END IF;
    
    IF NEW.weight_out IS NULL OR NEW.weight_out = 0 THEN
        SET NEW.weight_out = ROUND(NEW.prod_quantity * 200 / 1000, 1);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `calculate_prod_yield_insert` 
BEFORE INSERT ON `tgscodeout`
FOR EACH ROW 
BEGIN
    IF NEW.weight_in > 0 THEN
        SET NEW.prod_yield = ROUND((NEW.weight_out / NEW.weight_in) * 100, 1);
    ELSE
        SET NEW.prod_yield = NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER before_update_tgscodeout
BEFORE UPDATE ON tgscodeout
FOR EACH ROW
BEGIN
    DECLARE weight DECIMAL(6,1) DEFAULT 0.0;
    DECLARE temp_str VARCHAR(50);
    DECLARE num_str VARCHAR(10);
    
    IF NEW.prod_nm IS NOT NULL AND NEW.prod_nm LIKE '%-%' THEN
        
        SET temp_str = SUBSTRING_INDEX(NEW.prod_nm, '-', -1);
        
        
        SET num_str = REGEXP_REPLACE(temp_str, '[^0-9]', '');
        
        IF temp_str LIKE '%kg%' THEN
            
            SET NEW.weight_out = CAST(COALESCE(num_str, '0') AS DECIMAL(6,1)) * 
                                COALESCE(NEW.prod_quantity, 0);
        ELSEIF temp_str LIKE '%g%' THEN
            
            SET NEW.weight_out = (CAST(COALESCE(num_str, '0') AS DECIMAL(6,1)) * 
                                COALESCE(NEW.prod_quantity, 0)) / 1000;
        ELSE
            
            SET NEW.weight_out = COALESCE(NEW.prod_quantity, 0) * 0.2;
        END IF;
    ELSE
        
        SET NEW.weight_out = COALESCE(NEW.prod_quantity, 0) * 0.2;
    END IF;
    
    
    IF NEW.weight_out IS NULL THEN
        SET NEW.weight_out = 0.0;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `calculate_prod_yield_update` 
BEFORE UPDATE ON `tgscodeout`
FOR EACH ROW 
BEGIN
    IF NEW.weight_in > 0 THEN
        SET NEW.prod_yield = ROUND((NEW.weight_out / NEW.weight_in) * 100, 1);
    ELSE
        SET NEW.prod_yield = NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tgscodeout_invent`
--

DROP TABLE IF EXISTS `tgscodeout_invent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgscodeout_invent` (
  `store_code` varchar(20) NOT NULL COMMENT '납품점코드',
  `store_no` varchar(20) NOT NULL COMMENT '납품점명',
  `prod_code` varchar(20) NOT NULL COMMENT '상품코드',
  `prod_nm` varchar(100) NOT NULL COMMENT '상품명',
  `increate_dt` timestamp NULL DEFAULT NULL COMMENT '생산일자',
  `invent_quantity` smallint(6) NOT NULL DEFAULT 0 COMMENT '재고수량',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  UNIQUE KEY `unique_key` (`store_code`,`prod_code`,`increate_dt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출고 바코드 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `toctopus_invt`
--

DROP TABLE IF EXISTS `toctopus_invt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `toctopus_invt` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '고유 ID',
  `serial_no` int(10) NOT NULL COMMENT '구매 테이블 참조 번호 (tpurchase.serial_no)',
  `vendor_nm` varchar(100) NOT NULL COMMENT '매입처명',
  `input_dt` date NOT NULL COMMENT '재고일자',
  `stock_large` int(10) unsigned DEFAULT 0 COMMENT '대',
  `stock_4mi` int(10) unsigned DEFAULT 0 COMMENT '4미',
  `stock_5mi` int(10) unsigned DEFAULT 0 COMMENT '5미',
  `stock_6mi` int(10) unsigned DEFAULT 0 COMMENT '6미',
  `stock_7mi` int(10) unsigned DEFAULT 0 COMMENT '7미',
  `stock_8mi` int(10) unsigned DEFAULT 0 COMMENT '8미',
  `stock_9mi` int(10) unsigned DEFAULT 0 COMMENT '9미',
  `stock_10_15mi` int(10) unsigned DEFAULT 0 COMMENT '10-15미',
  `stock_16_20mi` int(10) unsigned DEFAULT 0 COMMENT '16-20미',
  `stock_21_25mi` int(10) unsigned DEFAULT 0 COMMENT '21-25미',
  `stock_26_30mi` int(10) unsigned DEFAULT 0 COMMENT '26-30미',
  `warehouse_nm` varchar(100) DEFAULT NULL COMMENT '창고명',
  `remark` varchar(255) DEFAULT NULL COMMENT '비고',
  PRIMARY KEY (`id`),
  KEY `idx_serial_no` (`serial_no`),
  KEY `idx_input_dt` (`input_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=429 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='일자별 문어재고 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `torder_predict`
--

DROP TABLE IF EXISTS `torder_predict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `torder_predict` (
  `predict_dt` date NOT NULL COMMENT '예측 대상 일자',
  `product_code` varchar(20) NOT NULL COMMENT '상품 코드',
  `predict_qty` int(11) NOT NULL COMMENT '예측 주문 수량',
  `base_dt` date NOT NULL COMMENT '예측 생성 기준 일자',
  PRIMARY KEY (`predict_dt`,`product_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='일자별 주문 예측';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `torderproducts`
--

DROP TABLE IF EXISTS `torderproducts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `torderproducts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_code` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` smallint(6) DEFAULT NULL,
  `unit_price` int(11) DEFAULT NULL,
  `total_price` bigint(20) DEFAULT NULL,
  `expi_date` date DEFAULT NULL COMMENT ' 유통기한',
  `quantity_new` float(6,1) DEFAULT NULL COMMENT '수정된 수량',
  `weights` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'weight 검품목록',
  `create_dt` timestamp NULL DEFAULT current_timestamp(),
  `create_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modify_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_doc_product` (`doc_no`,`product_code`),
  KEY `idx_product_doc` (`product_code`,`doc_no`,`quantity`),
  KEY `idx_torderproducts_doc_product_qty` (`doc_no`,`product_code`,`quantity`),
  KEY `idx_torderproducts_prod_doc` (`product_code`,`doc_no`),
  KEY `idx_torderproducts_doc_product` (`doc_no`,`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=22051129 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='코스트코주문상품상세';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `torderproducts_add`
--

DROP TABLE IF EXISTS `torderproducts_add`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `torderproducts_add` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msgfrom` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `doc_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'PO번호',
  `supply_dt` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dest_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_code` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity_new` smallint(6) DEFAULT NULL COMMENT '입고수량추가',
  `create_dt` timestamp NULL DEFAULT current_timestamp(),
  `create_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modify_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_order_product` (`supply_dt`,`dest_code`,`product_code`),
  KEY `idx_torderproducts_add_product_code` (`product_code`),
  KEY `idx_torderproducts_add_doc_no` (`doc_no`),
  KEY `idx_torderproducts_add_supply_dt` (`supply_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='코스트코주문상품-수량추가';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `torders`
--

DROP TABLE IF EXISTS `torders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `torders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msgtype` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `msgfrom` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '송신자ID',
  `doc_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_dt` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supply_dt` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dest_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dest_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_count` smallint(6) DEFAULT NULL,
  `create_dt` timestamp NULL DEFAULT current_timestamp(),
  `create_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modify_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `doc_no` (`doc_no`),
  KEY `idx_supply_dest` (`supply_dt`,`dest_code`),
  KEY `idx_supply_region` (`supply_dt`,`region`,`doc_no`),
  KEY `idx_torders_doc_supply_region` (`doc_no`,`supply_dt`,`region`),
  KEY `idx_torders_doc_supplydt` (`doc_no`,`supply_dt`),
  KEY `idx_torders_doc_dest_supply` (`doc_no`,`dest_code`,`supply_dt`,`region`)
) ENGINE=InnoDB AUTO_INCREMENT=13222143 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='코스트코주문번호-마스터';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tprodinvt`
--

DROP TABLE IF EXISTS `tprodinvt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tprodinvt` (
  `serial_no` int(11) NOT NULL AUTO_INCREMENT,
  `invt_dt` timestamp NULL DEFAULT NULL COMMENT '재고일자',
  `store_code` varchar(20) DEFAULT NULL COMMENT '상품코드',
  `code_exp` varchar(100) DEFAULT NULL COMMENT '코드설명(제품명)',
  `invt_cnt` int(11) DEFAULT NULL COMMENT '재고량',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '레코드 생성 시간',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '데이터 변경 시간',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `idx_tprodinvt_store_dt` (`store_code`,`invt_dt` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=3121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상품재고 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tpurchase`
--

DROP TABLE IF EXISTS `tpurchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tpurchase` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '번호',
  `input_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '입력일자',
  `vendor_nm` varchar(50) NOT NULL COMMENT '업체명',
  `box` int(10) DEFAULT NULL COMMENT '박스수',
  `weight` decimal(11,2) DEFAULT NULL COMMENT '중량',
  `qty_cur` decimal(11,2) DEFAULT NULL COMMENT '자재현재고',
  `lot_nm` varchar(50) DEFAULT NULL COMMENT 'lot명',
  `mat_cd` varchar(20) NOT NULL COMMENT '자재코드',
  `mat_type` varchar(20) DEFAULT NULL COMMENT '자재종류(ex.10-15미)',
  `unitPrice` decimal(9,0) DEFAULT NULL COMMENT '자재단가',
  `remarks` varchar(200) DEFAULT NULL COMMENT '비고',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  PRIMARY KEY (`serial_no`),
  KEY `input_dt_idx` (`input_dt`),
  KEY `idx_tpurchase_mat_cd` (`mat_cd`)
) ENGINE=InnoDB AUTO_INCREMENT=342 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='입고 관리 항목';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `update_lot_nm` BEFORE INSERT ON `tpurchase` FOR EACH ROW BEGIN
    SET NEW.lot_nm = CONCAT(
        DATE_FORMAT(NEW.input_dt, '%Y%m%d'),
        '|',
        NEW.vendor_nm,
        -- IF 함수를 사용한 조건부 문자열 추가
        IF(NEW.mat_type IS NOT NULL AND NEW.mat_type != '', 
           CONCAT('(', NEW.mat_type, ')'), 
           ''),
        '|',
        IFNULL(CAST(NEW.box AS CHAR), 'N/A')
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `tpurchase_before_update` BEFORE UPDATE ON `tpurchase` FOR EACH ROW BEGIN
    SET NEW.lot_nm = CONCAT(
        DATE_FORMAT(NEW.input_dt, '%Y%m%d'),
        '|',
        NEW.vendor_nm,
        -- IF 함수를 사용한 조건부 문자열 추가
        IF(NEW.mat_type IS NOT NULL AND NEW.mat_type != '', 
           CONCAT('(', NEW.mat_type, ')'), 
           ''),
        '|',
        IFNULL(CAST(NEW.box AS CHAR), 'N/A')
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tpurchase_imp`
--

DROP TABLE IF EXISTS `tpurchase_imp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tpurchase_imp` (
  `serial_no` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `import_dt` date NOT NULL COMMENT '통관일',
  `spec` varchar(100) NOT NULL COMMENT '제품명',
  `vol` int(10) DEFAULT NULL COMMENT '수량(박스)',
  `weight` decimal(11,2) DEFAULT NULL COMMENT '중량(kg)',
  `airline` varchar(10) DEFAULT NULL COMMENT '항공사',
  `awb` varchar(50) DEFAULT NULL COMMENT '항공운송(Air Waybill)뒷4자리B/L번호',
  `arrival_dt` datetime DEFAULT NULL COMMENT '도착일시',
  `prod_date` datetime DEFAULT NULL COMMENT '생산일',
  `remarks` varchar(200) DEFAULT NULL COMMENT '비고',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(20) DEFAULT NULL COMMENT '생성자ID',
  `modify_dt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '변경일자',
  `modify_id` varchar(20) DEFAULT NULL COMMENT '변경자ID',
  `awb_suffix` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`serial_no`),
  KEY `import_dt_idx` (`import_dt`),
  KEY `idx_awb_suffix` (`awb_suffix`)
) ENGINE=InnoDB AUTO_INCREMENT=895 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='연어수입 통관내역';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_imp_before_insert`
BEFORE INSERT ON `tpurchase_imp`
FOR EACH ROW
BEGIN
  SET NEW.awb_suffix = RIGHT(NEW.awb, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_imp_before_update`
BEFORE UPDATE ON `tpurchase_imp`
FOR EACH ROW
BEGIN
  SET NEW.awb_suffix = RIGHT(NEW.awb, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tpurchase_in`
--

DROP TABLE IF EXISTS `tpurchase_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tpurchase_in` (
  `lotin_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '자동 증가 시리얼 번호',
  `tpurchase_serial_no` int(10) unsigned NOT NULL,
  `increate_dt` timestamp NOT NULL,
  `qty_in` decimal(7,2) NOT NULL COMMENT '입고량',
  `qty_incur` decimal(7,2) NOT NULL COMMENT '입고잔량',
  `lotin_nm` varchar(100) DEFAULT NULL COMMENT 'ex) 11/8-바다사람들-문어-50-30',
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '생성일',
  `create_id` varchar(50) NOT NULL COMMENT '생성자 ID',
  PRIMARY KEY (`lotin_id`),
  KEY `fk_tdayprod_lotin_tpurchase1_idx` (`tpurchase_serial_no`),
  CONSTRAINT `fk_tdayprod_lotin_tpurchase1` FOREIGN KEY (`tpurchase_serial_no`) REFERENCES `tpurchase` (`serial_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=727 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='자재입고::\n입고된 lot 중에서 선택하여 일일 생산에서 소모량을 추가함.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_in_before_insert` BEFORE INSERT ON `tpurchase_in`
FOR EACH ROW BEGIN
    DECLARE current_qty_cur DECIMAL(10,2);
    
    SELECT qty_cur INTO current_qty_cur
    FROM tpurchase
    WHERE serial_no = NEW.tpurchase_serial_no
    LIMIT 1;
    
    IF NEW.qty_in > current_qty_cur THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: qty_in 값이 현재고(qty_cur)보다 클 수 없습니다.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_in_bi` BEFORE INSERT ON `tpurchase_in` FOR EACH ROW BEGIN
    DECLARE v_vendor_nm VARCHAR(50);
    DECLARE v_mat_cd    VARCHAR(50);
    DECLARE v_mat_nm    VARCHAR(50);
    DECLARE v_mat_type  VARCHAR(20); -- `mat_type` 값을 담을 변수
    DECLARE v_in_date   VARCHAR(10);
    DECLARE v_qty_in    VARCHAR(10);
    DECLARE v_qty_incur VARCHAR(10);

    -- 1. tpurchase 테이블에서 vendor_nm, mat_cd, mat_type를 한 번에 조회
    SELECT vendor_nm, mat_cd, mat_type
      INTO v_vendor_nm, v_mat_cd, v_mat_type
      FROM tpurchase
     WHERE serial_no = NEW.tpurchase_serial_no;

    -- 2. 위에서 얻은 v_mat_cd로 mat_nm을 조회
    SELECT mat_nm
      INTO v_mat_nm
      FROM tdayprodmat_mst
     WHERE mat_cd = v_mat_cd
     LIMIT 1;

    SET v_in_date   = DATE_FORMAT(NEW.increate_dt, '%m/%d');
    SET v_qty_in    = IF(NEW.qty_in    = FLOOR(NEW.qty_in),    CAST(NEW.qty_in    AS UNSIGNED), NEW.qty_in);
    SET v_qty_incur = IF(NEW.qty_incur = FLOOR(NEW.qty_incur), CAST(NEW.qty_incur AS UNSIGNED), NEW.qty_incur);

    -- 3. CONCAT 함수에 조건부 (v_mat_type) 추가
    SET NEW.lotin_nm = CONCAT(v_in_date, '-', v_vendor_nm, '-', v_mat_nm, 
                             IF(v_mat_type IS NOT NULL AND v_mat_type != '', CONCAT('(', v_mat_type, ')'), ''),
                             '-', v_qty_in, '-', v_qty_incur);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_in_after_insert` AFTER INSERT ON `tpurchase_in`
FOR EACH ROW BEGIN
    
    UPDATE tpurchase
    SET qty_cur = qty_cur - NEW.qty_in
    WHERE serial_no = NEW.tpurchase_serial_no;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_in_before_update` BEFORE UPDATE ON `tpurchase_in`
FOR EACH ROW BEGIN
    DECLARE current_qty_cur DECIMAL(10,2);
    
    SELECT qty_cur INTO current_qty_cur
    FROM tpurchase
    WHERE serial_no = NEW.tpurchase_serial_no
    LIMIT 1;
    
    IF (NEW.qty_in - OLD.qty_in) > current_qty_cur THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: 수정된 qty_in 값이 현재고(qty_cur)보다 클 수 없습니다.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `update_lotin_nm` BEFORE UPDATE ON `tpurchase_in` FOR EACH ROW BEGIN
    DECLARE v_vendor_nm VARCHAR(50);
    DECLARE v_mat_cd    VARCHAR(50);
    DECLARE v_mat_nm    VARCHAR(50);
    DECLARE v_mat_type  VARCHAR(20); -- `mat_type` 값을 담을 변수
    DECLARE v_in_date   VARCHAR(10);
    DECLARE v_qty_in    VARCHAR(10);
    DECLARE v_qty_incur VARCHAR(10);

    -- 1. tpurchase 테이블에서 vendor_nm, mat_cd, mat_type를 한 번에 조회
    SELECT vendor_nm, mat_cd, mat_type
      INTO v_vendor_nm, v_mat_cd, v_mat_type
      FROM tpurchase
     WHERE serial_no = NEW.tpurchase_serial_no;

    -- 2. 위에서 얻은 v_mat_cd로 mat_nm을 조회
    SELECT mat_nm
      INTO v_mat_nm
      FROM tdayprodmat_mst
     WHERE mat_cd = v_mat_cd
     LIMIT 1;

    SET v_in_date   = DATE_FORMAT(NEW.increate_dt, '%m/%d');
    SET v_qty_in    = IF(NEW.qty_in    = FLOOR(NEW.qty_in),    CAST(NEW.qty_in    AS UNSIGNED), NEW.qty_in);
    SET v_qty_incur = IF(NEW.qty_incur = FLOOR(NEW.qty_incur), CAST(NEW.qty_incur AS UNSIGNED), NEW.qty_incur);

    -- 3. CONCAT 함수에 조건부 (v_mat_type) 추가
    SET NEW.lotin_nm = CONCAT(v_in_date, '-', v_vendor_nm, '-', v_mat_nm, 
                             IF(v_mat_type IS NOT NULL AND v_mat_type != '', CONCAT('(', v_mat_type, ')'), ''),
                             '-', v_qty_in, '-', v_qty_incur);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_in_after_update` AFTER UPDATE ON `tpurchase_in`
FOR EACH ROW BEGIN
    
    UPDATE tpurchase
    SET qty_cur = qty_cur + OLD.qty_in - NEW.qty_in
    WHERE serial_no = NEW.tpurchase_serial_no;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u753849441_cASrk`@`localhost`*/ /*!50003 TRIGGER `trg_tpurchase_in_after_delete` AFTER DELETE ON `tpurchase_in`
FOR EACH ROW BEGIN
    
    UPDATE tpurchase
    SET qty_cur = qty_cur + OLD.qty_in
    WHERE serial_no = OLD.tpurchase_serial_no;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `wp_commentmeta`
--

DROP TABLE IF EXISTS `wp_commentmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_commentmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `comment_id` (`comment_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_comments`
--

DROP TABLE IF EXISTS `wp_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT 0,
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT 'comment',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_ID`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`),
  KEY `comment_author_email` (`comment_author_email`(10))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_cosmosfarm_members_activity_history`
--

DROP TABLE IF EXISTS `wp_cosmosfarm_members_activity_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_cosmosfarm_members_activity_history` (
  `activity_history_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `related_user_id` bigint(20) unsigned NOT NULL,
  `activity_datetime` datetime NOT NULL,
  `ip_address` varchar(20) NOT NULL,
  `comment` varchar(127) NOT NULL,
  PRIMARY KEY (`activity_history_id`),
  KEY `user_id` (`user_id`),
  KEY `related_user_id` (`related_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_cosmosfarm_members_login_history`
--

DROP TABLE IF EXISTS `wp_cosmosfarm_members_login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_cosmosfarm_members_login_history` (
  `login_history_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `login_datetime` datetime NOT NULL,
  `ip_address` varchar(20) NOT NULL,
  `browser` varchar(127) NOT NULL,
  `operating_system` varchar(127) NOT NULL,
  `country_name` varchar(127) NOT NULL,
  `country_code` varchar(127) NOT NULL,
  `login_result` varchar(20) NOT NULL,
  `user_agent` text NOT NULL,
  PRIMARY KEY (`login_history_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=778489 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_e_events`
--

DROP TABLE IF EXISTS `wp_e_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_e_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_data` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_e_notes`
--

DROP TABLE IF EXISTS `wp_e_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_e_notes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `route_url` text DEFAULT NULL COMMENT 'Clean url where the note was created.',
  `route_title` varchar(255) DEFAULT NULL,
  `route_post_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The post id of the route that the note was created on.',
  `post_id` bigint(20) unsigned DEFAULT NULL,
  `element_id` varchar(60) DEFAULT NULL COMMENT 'The Elementor element ID the note is attached to.',
  `parent_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `author_id` bigint(20) unsigned DEFAULT NULL,
  `author_display_name` varchar(250) DEFAULT NULL COMMENT 'Save the author name when the author was deleted.',
  `status` varchar(20) NOT NULL DEFAULT 'publish',
  `position` text DEFAULT NULL COMMENT 'A JSON string that represents the position of the note inside the element in percentages. e.g. {x:10, y:15}',
  `content` longtext DEFAULT NULL,
  `is_resolved` tinyint(1) NOT NULL DEFAULT 0,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `last_activity_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `route_url_index` (`route_url`(191)),
  KEY `post_id_index` (`post_id`),
  KEY `element_id_index` (`element_id`),
  KEY `parent_id_index` (`parent_id`),
  KEY `author_id_index` (`author_id`),
  KEY `status_index` (`status`),
  KEY `is_resolved_index` (`is_resolved`),
  KEY `is_public_index` (`is_public`),
  KEY `created_at_index` (`created_at`),
  KEY `updated_at_index` (`updated_at`),
  KEY `last_activity_at_index` (`last_activity_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_e_notes_users_relations`
--

DROP TABLE IF EXISTS `wp_e_notes_users_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_e_notes_users_relations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(60) NOT NULL COMMENT 'The relation type between user and note (e.g mention, watch, read).',
  `note_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_index` (`type`),
  KEY `note_id_index` (`note_id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_e_submissions`
--

DROP TABLE IF EXISTS `wp_e_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_e_submissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(60) DEFAULT NULL,
  `hash_id` varchar(60) NOT NULL,
  `main_meta_id` bigint(20) unsigned NOT NULL COMMENT 'Id of main field. to represent the main meta field',
  `post_id` bigint(20) unsigned NOT NULL,
  `referer` varchar(500) NOT NULL,
  `referer_title` varchar(300) DEFAULT NULL,
  `element_id` varchar(20) NOT NULL,
  `form_name` varchar(60) NOT NULL,
  `campaign_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `user_ip` varchar(46) NOT NULL,
  `user_agent` text NOT NULL,
  `actions_count` int(11) DEFAULT 0,
  `actions_succeeded_count` int(11) DEFAULT 0,
  `status` varchar(20) NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `meta` text DEFAULT NULL,
  `created_at_gmt` datetime NOT NULL,
  `updated_at_gmt` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash_id_unique_index` (`hash_id`),
  KEY `main_meta_id_index` (`main_meta_id`),
  KEY `hash_id_index` (`hash_id`),
  KEY `type_index` (`type`),
  KEY `post_id_index` (`post_id`),
  KEY `element_id_index` (`element_id`),
  KEY `campaign_id_index` (`campaign_id`),
  KEY `user_id_index` (`user_id`),
  KEY `user_ip_index` (`user_ip`),
  KEY `status_index` (`status`),
  KEY `is_read_index` (`is_read`),
  KEY `created_at_gmt_index` (`created_at_gmt`),
  KEY `updated_at_gmt_index` (`updated_at_gmt`),
  KEY `created_at_index` (`created_at`),
  KEY `updated_at_index` (`updated_at`),
  KEY `referer_index` (`referer`(191)),
  KEY `referer_title_index` (`referer_title`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_e_submissions_actions_log`
--

DROP TABLE IF EXISTS `wp_e_submissions_actions_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_e_submissions_actions_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) unsigned NOT NULL,
  `action_name` varchar(60) NOT NULL,
  `action_label` varchar(60) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `log` text DEFAULT NULL,
  `created_at_gmt` datetime NOT NULL,
  `updated_at_gmt` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `submission_id_index` (`submission_id`),
  KEY `action_name_index` (`action_name`),
  KEY `status_index` (`status`),
  KEY `created_at_gmt_index` (`created_at_gmt`),
  KEY `updated_at_gmt_index` (`updated_at_gmt`),
  KEY `created_at_index` (`created_at`),
  KEY `updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_e_submissions_values`
--

DROP TABLE IF EXISTS `wp_e_submissions_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_e_submissions_values` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `key` varchar(60) DEFAULT NULL,
  `value` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submission_id_index` (`submission_id`),
  KEY `key_index` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_links`
--

DROP TABLE IF EXISTS `wp_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_links` (
  `link_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` bigint(20) unsigned NOT NULL DEFAULT 1,
  `link_rating` int(11) NOT NULL DEFAULT 0,
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_litespeed_url`
--

DROP TABLE IF EXISTS `wp_litespeed_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_litespeed_url` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` varchar(500) NOT NULL,
  `cache_tags` varchar(1000) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `url` (`url`(191)),
  KEY `cache_tags` (`cache_tags`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_litespeed_url_file`
--

DROP TABLE IF EXISTS `wp_litespeed_url_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_litespeed_url_file` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url_id` bigint(20) NOT NULL,
  `vary` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'md5 of final vary',
  `filename` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'md5 of file content',
  `type` tinyint(4) NOT NULL COMMENT 'css=1,js=2,ccss=3,ucss=4',
  `mobile` tinyint(4) NOT NULL COMMENT 'mobile=1',
  `webp` tinyint(4) NOT NULL COMMENT 'webp=1',
  `expired` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `filename` (`filename`),
  KEY `type` (`type`),
  KEY `url_id_2` (`url_id`,`vary`,`type`),
  KEY `filename_2` (`filename`,`expired`),
  KEY `url_id` (`url_id`,`expired`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_options`
--

DROP TABLE IF EXISTS `wp_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(191) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`),
  KEY `autoload` (`autoload`)
) ENGINE=InnoDB AUTO_INCREMENT=105196 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_postmeta`
--

DROP TABLE IF EXISTS `wp_postmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=2494 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_posts`
--

DROP TABLE IF EXISTS `wp_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT 0,
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(255) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT 0,
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=1099 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_snippets`
--

DROP TABLE IF EXISTS `wp_snippets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_snippets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` tinytext NOT NULL,
  `description` text NOT NULL,
  `code` longtext NOT NULL,
  `tags` longtext NOT NULL,
  `scope` varchar(15) NOT NULL DEFAULT 'global',
  `priority` smallint(6) NOT NULL DEFAULT 10,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `modified` datetime NOT NULL DEFAULT current_timestamp(),
  `revision` bigint(20) NOT NULL DEFAULT 1,
  `cloud_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `scope` (`scope`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_term_relationships`
--

DROP TABLE IF EXISTS `wp_term_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_term_taxonomy`
--

DROP TABLE IF EXISTS `wp_term_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`),
  KEY `taxonomy` (`taxonomy`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_termmeta`
--

DROP TABLE IF EXISTS `wp_termmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_termmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `term_id` (`term_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_terms`
--

DROP TABLE IF EXISTS `wp_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_id`),
  KEY `slug` (`slug`(191)),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_userfeedback_survey_responses`
--

DROP TABLE IF EXISTS `wp_userfeedback_survey_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_userfeedback_survey_responses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(20) NOT NULL,
  `answers` longtext DEFAULT NULL,
  `page_submitted` text DEFAULT NULL,
  `user_ip` varchar(256) DEFAULT NULL,
  `user_browser` varchar(128) DEFAULT NULL,
  `user_os` varchar(128) DEFAULT NULL,
  `user_device` varchar(64) DEFAULT NULL,
  `status` enum('publish','draft','trash') DEFAULT 'publish',
  `submitted_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_id` (`survey_id`),
  CONSTRAINT `wp_userfeedback_survey_responses_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `wp_userfeedback_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_userfeedback_surveys`
--

DROP TABLE IF EXISTS `wp_userfeedback_surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_userfeedback_surveys` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) DEFAULT NULL,
  `status` enum('publish','draft','trash') DEFAULT 'draft',
  `questions` longtext DEFAULT NULL,
  `impressions` bigint(20) NOT NULL DEFAULT 0,
  `settings` text DEFAULT NULL,
  `notifications` text DEFAULT NULL,
  `publish_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_usermeta`
--

DROP TABLE IF EXISTS `wp_usermeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=59985 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_users`
--

DROP TABLE IF EXISTS `wp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(255) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT 0,
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=3497 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_wpc_accesslocks`
--

DROP TABLE IF EXISTS `wp_wpc_accesslocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wpc_accesslocks` (
  `accesslock_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `accesslock_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `release_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `accesslock_IP` varchar(100) NOT NULL DEFAULT '',
  `reason` varchar(200) DEFAULT NULL,
  `unlocked` smallint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`accesslock_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_wpc_login_fails`
--

DROP TABLE IF EXISTS `wp_wpc_login_fails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wpc_login_fails` (
  `login_attempt_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `login_attempt_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `login_attempt_IP` varchar(100) NOT NULL DEFAULT '',
  `failed_user` varchar(200) NOT NULL DEFAULT '',
  `failed_pass` varchar(200) NOT NULL DEFAULT '',
  `reason` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`login_attempt_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_wpmembers_user_search_crud`
--

DROP TABLE IF EXISTS `wp_wpmembers_user_search_crud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wpmembers_user_search_crud` (
  `meta_key` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_yoast_indexable`
--

DROP TABLE IF EXISTS `wp_yoast_indexable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_indexable` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `permalink` longtext DEFAULT NULL,
  `permalink_hash` varchar(40) DEFAULT NULL,
  `object_id` bigint(20) DEFAULT NULL,
  `object_type` varchar(32) NOT NULL,
  `object_sub_type` varchar(32) DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `post_parent` bigint(20) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `breadcrumb_title` text DEFAULT NULL,
  `post_status` varchar(20) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT NULL,
  `is_protected` tinyint(1) DEFAULT 0,
  `has_public_posts` tinyint(1) DEFAULT NULL,
  `number_of_pages` int(11) unsigned DEFAULT NULL,
  `canonical` longtext DEFAULT NULL,
  `primary_focus_keyword` varchar(191) DEFAULT NULL,
  `primary_focus_keyword_score` int(3) DEFAULT NULL,
  `readability_score` int(3) DEFAULT NULL,
  `is_cornerstone` tinyint(1) DEFAULT 0,
  `is_robots_noindex` tinyint(1) DEFAULT 0,
  `is_robots_nofollow` tinyint(1) DEFAULT 0,
  `is_robots_noarchive` tinyint(1) DEFAULT 0,
  `is_robots_noimageindex` tinyint(1) DEFAULT 0,
  `is_robots_nosnippet` tinyint(1) DEFAULT 0,
  `twitter_title` text DEFAULT NULL,
  `twitter_image` longtext DEFAULT NULL,
  `twitter_description` longtext DEFAULT NULL,
  `twitter_image_id` varchar(191) DEFAULT NULL,
  `twitter_image_source` text DEFAULT NULL,
  `open_graph_title` text DEFAULT NULL,
  `open_graph_description` longtext DEFAULT NULL,
  `open_graph_image` longtext DEFAULT NULL,
  `open_graph_image_id` varchar(191) DEFAULT NULL,
  `open_graph_image_source` text DEFAULT NULL,
  `open_graph_image_meta` mediumtext DEFAULT NULL,
  `link_count` int(11) DEFAULT NULL,
  `incoming_link_count` int(11) DEFAULT NULL,
  `prominent_words_version` int(11) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `blog_id` bigint(20) NOT NULL DEFAULT 1,
  `language` varchar(32) DEFAULT NULL,
  `region` varchar(32) DEFAULT NULL,
  `schema_page_type` varchar(64) DEFAULT NULL,
  `schema_article_type` varchar(64) DEFAULT NULL,
  `has_ancestors` tinyint(1) DEFAULT 0,
  `estimated_reading_time_minutes` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT 1,
  `object_last_modified` datetime DEFAULT NULL,
  `object_published_at` datetime DEFAULT NULL,
  `inclusive_language_score` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `object_type_and_sub_type` (`object_type`,`object_sub_type`),
  KEY `object_id_and_type` (`object_id`,`object_type`),
  KEY `permalink_hash_and_object_type` (`permalink_hash`,`object_type`),
  KEY `subpages` (`post_parent`,`object_type`,`post_status`,`object_id`),
  KEY `prominent_words` (`prominent_words_version`,`object_type`,`object_sub_type`,`post_status`),
  KEY `published_sitemap_index` (`object_published_at`,`is_robots_noindex`,`object_type`,`object_sub_type`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_yoast_indexable_hierarchy`
--

DROP TABLE IF EXISTS `wp_yoast_indexable_hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_indexable_hierarchy` (
  `indexable_id` int(11) unsigned NOT NULL,
  `ancestor_id` int(11) unsigned NOT NULL,
  `depth` int(11) unsigned DEFAULT NULL,
  `blog_id` bigint(20) NOT NULL DEFAULT 1,
  PRIMARY KEY (`indexable_id`,`ancestor_id`),
  KEY `indexable_id` (`indexable_id`),
  KEY `ancestor_id` (`ancestor_id`),
  KEY `depth` (`depth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_yoast_migrations`
--

DROP TABLE IF EXISTS `wp_yoast_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_migrations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wp_yoast_migrations_version` (`version`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_yoast_primary_term`
--

DROP TABLE IF EXISTS `wp_yoast_primary_term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_primary_term` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) DEFAULT NULL,
  `term_id` bigint(20) DEFAULT NULL,
  `taxonomy` varchar(32) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `blog_id` bigint(20) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `post_taxonomy` (`post_id`,`taxonomy`),
  KEY `post_term` (`post_id`,`term_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wp_yoast_seo_links`
--

DROP TABLE IF EXISTS `wp_yoast_seo_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_yoast_seo_links` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `post_id` bigint(20) unsigned DEFAULT NULL,
  `target_post_id` bigint(20) unsigned DEFAULT NULL,
  `type` varchar(8) DEFAULT NULL,
  `indexable_id` int(11) unsigned DEFAULT NULL,
  `target_indexable_id` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `width` int(11) unsigned DEFAULT NULL,
  `size` int(11) unsigned DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `region` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `link_direction` (`post_id`,`type`),
  KEY `indexable_link_direction` (`indexable_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-29 18:57:32
