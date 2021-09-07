-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: hotel
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `camera`
--

DROP TABLE IF EXISTS `camera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `camera` (
  `Nome` varchar(10) NOT NULL,
  `NrLetti` int NOT NULL,
  `Tipo` varchar(10) NOT NULL,
  `Prezzo` varchar(45) NOT NULL,
  PRIMARY KEY (`Nome`),
  UNIQUE KEY `Nome_UNIQUE` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `camera`
--

LOCK TABLES `camera` WRITE;
/*!40000 ALTER TABLE `camera` DISABLE KEYS */;
INSERT INTO `camera` VALUES ('Bianca',1,'doppia','70'),('Blu',2,'doppia','70'),('Bordeaux',1,'doppia','70'),('Gialla',2,'quadrupla','90'),('Nera',1,'doppia','70'),('Rossa',2,'tripla','80'),('Verde',1,'singola','60');
/*!40000 ALTER TABLE `camera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(45) DEFAULT NULL,
  `Cognome` varchar(45) DEFAULT NULL,
  `Telefono` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `NrPassaporto` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `idCliente_UNIQUE` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fattura`
--

DROP TABLE IF EXISTS `fattura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fattura` (
  `idFattura` int NOT NULL AUTO_INCREMENT,
  `Data` date NOT NULL,
  `ImportoTotale` double NOT NULL,
  `prenotazione_idPrenotazione` int NOT NULL,
  `IntestatarioFattura_idIntestatarioFattura` int NOT NULL,
  PRIMARY KEY (`idFattura`),
  UNIQUE KEY `idFattura_UNIQUE` (`idFattura`),
  KEY `fk_Fattura_prenotazione1_idx` (`prenotazione_idPrenotazione`),
  KEY `fk_Fattura_IntestatarioFattura1_idx` (`IntestatarioFattura_idIntestatarioFattura`),
  CONSTRAINT `fk_Fattura_IntestatarioFattura1` FOREIGN KEY (`IntestatarioFattura_idIntestatarioFattura`) REFERENCES `intestatariofattura` (`idIntestatarioFattura`),
  CONSTRAINT `fk_Fattura_prenotazione1` FOREIGN KEY (`prenotazione_idPrenotazione`) REFERENCES `prenotazione` (`idPrenotazione`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fattura`
--

LOCK TABLES `fattura` WRITE;
/*!40000 ALTER TABLE `fattura` DISABLE KEYS */;
/*!40000 ALTER TABLE `fattura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intestatariofattura`
--

DROP TABLE IF EXISTS `intestatariofattura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intestatariofattura` (
  `idIntestatarioFattura` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(45) DEFAULT NULL,
  `Cognome` varchar(45) DEFAULT NULL,
  `Indirizzo` varchar(45) DEFAULT NULL,
  `Citta` varchar(45) DEFAULT NULL,
  `CAP` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idIntestatarioFattura`),
  UNIQUE KEY `idIntestatarioFattura_UNIQUE` (`idIntestatarioFattura`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intestatariofattura`
--

LOCK TABLES `intestatariofattura` WRITE;
/*!40000 ALTER TABLE `intestatariofattura` DISABLE KEYS */;
/*!40000 ALTER TABLE `intestatariofattura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prenotazione`
--

DROP TABLE IF EXISTS `prenotazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prenotazione` (
  `idPrenotazione` int NOT NULL AUTO_INCREMENT,
  `CheckIn` date DEFAULT NULL,
  `CheckOut` date DEFAULT NULL,
  `CodiceGenerato` int DEFAULT NULL,
  `cliente_idCliente` int DEFAULT NULL,
  `camera_Nome` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`idPrenotazione`),
  UNIQUE KEY `idPrenotazione_UNIQUE` (`idPrenotazione`),
  KEY `fk_prenotazione_cliente_idx` (`cliente_idCliente`),
  KEY `fk_prenotazione_camera1_idx` (`camera_Nome`),
  CONSTRAINT `fk_prenotazione_camera1` FOREIGN KEY (`camera_Nome`) REFERENCES `camera` (`Nome`),
  CONSTRAINT `fk_prenotazione_cliente` FOREIGN KEY (`cliente_idCliente`) REFERENCES `cliente` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prenotazione`
--

LOCK TABLES `prenotazione` WRITE;
/*!40000 ALTER TABLE `prenotazione` DISABLE KEYS */;
/*!40000 ALTER TABLE `prenotazione` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-17 21:20:29
