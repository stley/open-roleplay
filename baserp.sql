-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-11-2024 a las 19:28:21
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `baserp`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accounts`
--

CREATE TABLE `accounts` (
  `SQLID` int(11) NOT NULL,
  `Nombre` tinytext NOT NULL,
  `Administrador` smallint(6) NOT NULL DEFAULT 0,
  `FacMan` tinyint(1) NOT NULL DEFAULT 0,
  `StaffMan` tinyint(1) NOT NULL DEFAULT 0,
  `PropMan` tinyint(1) NOT NULL DEFAULT 0,
  `Creditos` int(11) NOT NULL DEFAULT 0,
  `Clave` tinytext NOT NULL,
  `Email` tinytext NOT NULL,
  `IP` tinytext NOT NULL,
  `Personaje_1` tinytext NOT NULL DEFAULT 'user_none',
  `Personaje_2` tinytext NOT NULL DEFAULT 'user_none',
  `Personaje_3` tinytext NOT NULL DEFAULT 'user_none',
  `Fecha_Reg` tinytext NOT NULL,
  `Ultima_Conexion` tinytext NOT NULL,
  `Premium` int(11) NOT NULL,
  `dPremium` int(11) NOT NULL,
  `mPremium` int(11) NOT NULL,
  `aPremium` int(11) NOT NULL,
  `online` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `accounts`
--

INSERT INTO `accounts` (`SQLID`, `Nombre`, `Administrador`, `FacMan`, `StaffMan`, `PropMan`, `Creditos`, `Clave`, `Email`, `IP`, `Personaje_1`, `Personaje_2`, `Personaje_3`, `Fecha_Reg`, `Ultima_Conexion`, `Premium`, `dPremium`, `mPremium`, `aPremium`, `online`) VALUES
(1, 'varky', 1337, 0, 0, 0, 0, '644D5F272C31098436B96386B7CC62F363E058C9CC478C032D617EC1FB622ACCD1C1732793D3088599485CCA56850721A8F1A434615785FE8E321DBDA349447A', 'email@dominio.com', '127.0.0.1', 'Gregory_Donovan', 'user_none', 'user_none', 'Domingo 29 de Octubre de 2023 [04:13 AM]', 'Domingo 17 de Noviembre de 2024 [12:07 AM]', 0, 0, 0, 0, 0),
(2, 'FRANZCTDS', 0, 0, 0, 0, 0, '46ADB2A778CB2AC98D19D7CEA3E6178CB6BF4CE393CDD592CE052B371A409DF6957D2CD3AC6D6E4D6BEE4C567F8D74ECBEE2C7FFE74B63F6761B1390D635DCCC', 'playboysx13@gmail.com', '-', 'franz_elmejor', 'user_none', 'user_none', 'Domingo 24 de Marzo de 2024 [07:33 PM]', '-', 0, 0, 0, 0, 0),
(3, 'Ahh', 0, 0, 0, 0, 0, 'EF991960798148ABAACB37ABCB126450A7D0F3FC2612BADD956A03C0E93F36C847341178A4018E5E668F992AFF924999C22BB648D5215B61A3BE396F96D700B2', 'melodyyeor@gmail.com\r\n', '186.138.80.39', 'Melody_Stern', 'user_none', 'user_none', 'Viernes 16 de Agosto de 2024 [01:19 AM]', 'Viernes 16 de Agosto de 2024 [01:28 AM]', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `characters`
--

CREATE TABLE `characters` (
  `SQLIDPJ` int(11) NOT NULL,
  `Usuario` varchar(25) DEFAULT NULL,
  `NombrePJ` varchar(25) DEFAULT NULL,
  `Fecha_Creacion` varchar(101) DEFAULT NULL,
  `Salud` float DEFAULT NULL,
  `Muerto` tinyint(4) NOT NULL DEFAULT 0,
  `Chaleco` float DEFAULT NULL,
  `PosX` float DEFAULT NULL,
  `PosY` float DEFAULT NULL,
  `PosZ` float DEFAULT NULL,
  `PosR` float DEFAULT NULL,
  `VirtualWorld` int(11) DEFAULT NULL,
  `Interior` int(11) DEFAULT NULL,
  `Nivel` int(11) NOT NULL,
  `Experiencia` int(11) NOT NULL,
  `Horas` int(11) NOT NULL,
  `PuntosRol` int(11) NOT NULL,
  `PuntosRolNeg` int(11) NOT NULL,
  `Edad` int(11) DEFAULT NULL,
  `Sexo` int(11) DEFAULT NULL,
  `Dinero` int(11) DEFAULT NULL,
  `Ropa` int(11) DEFAULT NULL,
  `ManoDer` int(11) DEFAULT NULL,
  `ManoDerCant` int(11) DEFAULT NULL,
  `ManoIzq` int(11) DEFAULT NULL,
  `ManoIzCant` int(11) DEFAULT NULL,
  `ManoDerData` int(11) DEFAULT NULL,
  `ManoIzData` int(11) DEFAULT NULL,
  `Bolsillo0` int(11) DEFAULT NULL,
  `BolsilloCant0` int(11) DEFAULT NULL,
  `BolsilloData0` int(11) DEFAULT NULL,
  `Bolsillo1` int(11) DEFAULT NULL,
  `BolsilloCant1` int(11) DEFAULT NULL,
  `BolsilloData1` int(11) DEFAULT NULL,
  `Bolsillo2` int(11) DEFAULT NULL,
  `BolsilloCant2` int(11) DEFAULT NULL,
  `BolsilloData2` int(11) DEFAULT NULL,
  `Bolsillo3` int(11) DEFAULT NULL,
  `BolsilloCant3` int(11) DEFAULT NULL,
  `BolsilloData3` int(11) DEFAULT NULL,
  `Bolsillo4` int(11) DEFAULT NULL,
  `BolsilloCant4` int(11) DEFAULT NULL,
  `BolsilloData4` int(11) DEFAULT NULL,
  `Pecho` int(11) DEFAULT NULL,
  `PechoCant` int(11) DEFAULT NULL,
  `Espalda` int(11) DEFAULT NULL,
  `EspaldaCant` int(11) DEFAULT NULL,
  `EspaldaData` int(11) DEFAULT NULL,
  `PechoData` int(11) DEFAULT NULL,
  `Faccion` int(11) DEFAULT NULL,
  `RangoFac` int(11) DEFAULT NULL,
  `DivFac` int(11) DEFAULT NULL,
  `Faccion2` int(11) DEFAULT NULL,
  `RangoFac2` int(11) DEFAULT NULL,
  `DivFac2` int(11) DEFAULT NULL,
  `Documento` int(11) DEFAULT NULL,
  `Licencia1` int(11) DEFAULT NULL,
  `Licencia2` int(11) DEFAULT NULL,
  `Coche1` int(11) DEFAULT NULL,
  `Coche2` int(11) DEFAULT NULL,
  `CocheLlaves1` int(11) DEFAULT NULL,
  `CocheLlaves2` int(11) NOT NULL DEFAULT 0,
  `Casa` int(11) DEFAULT NULL,
  `Casa2` int(11) DEFAULT NULL,
  `CasaLlaves` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `characters`
--

INSERT INTO `characters` (`SQLIDPJ`, `Usuario`, `NombrePJ`, `Fecha_Creacion`, `Salud`, `Muerto`, `Chaleco`, `PosX`, `PosY`, `PosZ`, `PosR`, `VirtualWorld`, `Interior`, `Nivel`, `Experiencia`, `Horas`, `PuntosRol`, `PuntosRolNeg`, `Edad`, `Sexo`, `Dinero`, `Ropa`, `ManoDer`, `ManoDerCant`, `ManoIzq`, `ManoIzCant`, `ManoDerData`, `ManoIzData`, `Bolsillo0`, `BolsilloCant0`, `BolsilloData0`, `Bolsillo1`, `BolsilloCant1`, `BolsilloData1`, `Bolsillo2`, `BolsilloCant2`, `BolsilloData2`, `Bolsillo3`, `BolsilloCant3`, `BolsilloData3`, `Bolsillo4`, `BolsilloCant4`, `BolsilloData4`, `Pecho`, `PechoCant`, `Espalda`, `EspaldaCant`, `EspaldaData`, `PechoData`, `Faccion`, `RangoFac`, `DivFac`, `Faccion2`, `RangoFac2`, `DivFac2`, `Documento`, `Licencia1`, `Licencia2`, `Coche1`, `Coche2`, `CocheLlaves1`, `CocheLlaves2`, `Casa`, `Casa2`, `CasaLlaves`) VALUES
(3, 'varky', 'Gregory_Donovan', 'Domingo 29 de Octubre de 2023 [05:58 PM]', 100, 0, 0, 1533.26, -1669.87, 13.383, 6.155, 0, 0, 0, 0, 0, 0, 0, 20, 1, 1500, 72, 0, 0, 0, 0, 0, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 8, 66, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0),
(4, 'FRANZCTDS', 'franz_elmejor', 'Domingo 24 de Marzo de 2024 [07:34 PM]', 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 1, 1500, 299, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 'Ahh', 'Melody_Stern', 'Viernes 16 de Agosto de 2024 [01:21 AM]', 100, 0, 100, 237.988, -192.365, 1.578, 316.669, 0, 0, 0, 0, 0, 0, 0, 20, 0, 1500, 20007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `char_toys`
--

CREATE TABLE `char_toys` (
  `character_id` int(11) NOT NULL,
  `Gorro` int(11) NOT NULL DEFAULT 0,
  `Gafas` int(11) NOT NULL DEFAULT 0,
  `Boca` int(11) NOT NULL DEFAULT 0,
  `Cuerpo` int(11) NOT NULL DEFAULT 0,
  `Pecho` int(11) NOT NULL DEFAULT 0,
  `GorroPosX` float NOT NULL DEFAULT 0,
  `GorroPosY` float NOT NULL DEFAULT 0,
  `GorroPosZ` float NOT NULL DEFAULT 0,
  `GorroRotX` float NOT NULL DEFAULT 0,
  `GorroRotY` float NOT NULL DEFAULT 0,
  `GorroRotZ` float NOT NULL DEFAULT 0,
  `GorroScaleX` float NOT NULL DEFAULT 0,
  `GorroScaleY` float NOT NULL DEFAULT 0,
  `GorroScaleZ` float NOT NULL DEFAULT 0,
  `GafasPosX` float NOT NULL DEFAULT 0,
  `GafasPosY` float NOT NULL DEFAULT 0,
  `GafasPosZ` float NOT NULL DEFAULT 0,
  `GafasRotX` float NOT NULL DEFAULT 0,
  `GafasRotY` float NOT NULL DEFAULT 0,
  `GafasRotZ` float NOT NULL DEFAULT 0,
  `GafasScaleX` float NOT NULL DEFAULT 0,
  `GafasScaleY` float NOT NULL DEFAULT 0,
  `GafasScaleZ` float NOT NULL DEFAULT 0,
  `BocaPosX` float NOT NULL DEFAULT 0,
  `BocaPosY` float NOT NULL DEFAULT 0,
  `BocaPosZ` float NOT NULL DEFAULT 0,
  `BocaRotX` float NOT NULL DEFAULT 0,
  `BocaRotY` float NOT NULL DEFAULT 0,
  `BocaRotZ` float NOT NULL DEFAULT 0,
  `BocaScaleX` float NOT NULL DEFAULT 0,
  `BocaScaleY` float NOT NULL DEFAULT 0,
  `BocaScaleZ` float NOT NULL DEFAULT 0,
  `CuerpoPosX` float NOT NULL DEFAULT 0,
  `CuerpoPosY` float NOT NULL DEFAULT 0,
  `CuerpoPosZ` float NOT NULL DEFAULT 0,
  `CuerpoRotX` float NOT NULL DEFAULT 0,
  `CuerpoRotY` float NOT NULL DEFAULT 0,
  `CuerpoRotZ` float NOT NULL DEFAULT 0,
  `CuerpoScaleX` float NOT NULL DEFAULT 0,
  `CuerpoScaleY` float NOT NULL DEFAULT 0,
  `CuerpoScaleZ` float NOT NULL DEFAULT 0,
  `PechoPosX` float NOT NULL DEFAULT 0,
  `PechoPosY` float NOT NULL DEFAULT 0,
  `PechoPosZ` float NOT NULL DEFAULT 0,
  `PechoRotX` float NOT NULL DEFAULT 0,
  `PechoRotY` float NOT NULL DEFAULT 0,
  `PechoRotZ` float NOT NULL DEFAULT 0,
  `PechoScaleX` float NOT NULL DEFAULT 0,
  `PechoScaleY` float NOT NULL DEFAULT 0,
  `PechoScaleZ` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `char_toys`
--

INSERT INTO `char_toys` (`character_id`, `Gorro`, `Gafas`, `Boca`, `Cuerpo`, `Pecho`, `GorroPosX`, `GorroPosY`, `GorroPosZ`, `GorroRotX`, `GorroRotY`, `GorroRotZ`, `GorroScaleX`, `GorroScaleY`, `GorroScaleZ`, `GafasPosX`, `GafasPosY`, `GafasPosZ`, `GafasRotX`, `GafasRotY`, `GafasRotZ`, `GafasScaleX`, `GafasScaleY`, `GafasScaleZ`, `BocaPosX`, `BocaPosY`, `BocaPosZ`, `BocaRotX`, `BocaRotY`, `BocaRotZ`, `BocaScaleX`, `BocaScaleY`, `BocaScaleZ`, `CuerpoPosX`, `CuerpoPosY`, `CuerpoPosZ`, `CuerpoRotX`, `CuerpoRotY`, `CuerpoRotZ`, `CuerpoScaleX`, `CuerpoScaleY`, `CuerpoScaleZ`, `PechoPosX`, `PechoPosY`, `PechoPosZ`, `PechoRotX`, `PechoRotY`, `PechoRotZ`, `PechoScaleX`, `PechoScaleY`, `PechoScaleZ`) VALUES
(3, 0, 0, 184, 0, 177, 0.117, 0.003, 0.006, -5.3, 0, -7.3, 1.029, 1.097, 1.066, 0.085, 0.03, 0, 0, 89.5, 90.2, 1, 1, 1, -0.00000003655, 0.151, -0.022, 172.1, 87.9, -92.1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.118, 0.123, -0.015, 0, -2.7, -6.5, 0.955, 0.835, 1.017);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehicles`
--

CREATE TABLE `vehicles` (
  `SQLID` int(11) NOT NULL,
  `Tipo` int(11) DEFAULT NULL,
  `Matricula` int(11) NOT NULL,
  `Modelo` int(11) DEFAULT NULL,
  `Color1` smallint(6) DEFAULT NULL,
  `Color2` smallint(6) DEFAULT NULL,
  `Dueno` varchar(25) DEFAULT NULL,
  `Gasolina` int(11) DEFAULT NULL,
  `Bloqueo` tinyint(1) DEFAULT NULL,
  `Vida` float DEFAULT NULL,
  `PosX` float DEFAULT NULL,
  `PosY` float DEFAULT NULL,
  `PosZ` float DEFAULT NULL,
  `PosR` float NOT NULL,
  `VW` int(11) DEFAULT NULL,
  `Interior` int(11) DEFAULT NULL,
  `Deposito` int(11) DEFAULT NULL,
  `DmgSuperficie` int(11) DEFAULT NULL,
  `DmgPuertas` int(11) DEFAULT NULL,
  `DmgLuces` int(11) DEFAULT NULL,
  `DmgRuedas` int(11) DEFAULT NULL,
  `mods0` int(11) DEFAULT NULL,
  `mods1` int(11) DEFAULT NULL,
  `mods2` int(11) DEFAULT NULL,
  `mods3` int(11) DEFAULT NULL,
  `mods4` int(11) DEFAULT NULL,
  `mods5` int(11) DEFAULT NULL,
  `mods6` int(11) DEFAULT NULL,
  `mods7` int(11) DEFAULT NULL,
  `mods8` int(11) DEFAULT NULL,
  `mods9` int(11) DEFAULT NULL,
  `mods10` int(11) DEFAULT NULL,
  `mods11` int(11) DEFAULT NULL,
  `mods12` int(11) DEFAULT NULL,
  `mods13` int(11) DEFAULT NULL,
  `mods14` int(11) DEFAULT NULL,
  `EspacioMal` int(11) DEFAULT NULL,
  `Maletero_0` int(11) DEFAULT NULL,
  `MaleteroCant_0` int(11) DEFAULT NULL,
  `MaleteroData_0` int(11) DEFAULT NULL,
  `Maletero_1` int(11) DEFAULT NULL,
  `MaleteroCant_1` int(11) DEFAULT NULL,
  `MaleteroData_1` int(11) DEFAULT NULL,
  `Maletero_2` int(11) DEFAULT NULL,
  `MaleteroCant_2` int(11) DEFAULT NULL,
  `MaleteroData_2` int(11) DEFAULT NULL,
  `Maletero_3` int(11) DEFAULT NULL,
  `MaleteroCant_3` int(11) DEFAULT NULL,
  `MaleteroData_3` int(11) DEFAULT NULL,
  `Maletero_4` int(11) DEFAULT NULL,
  `MaleteroCant_4` int(11) DEFAULT NULL,
  `MaleteroData_4` int(11) DEFAULT NULL,
  `Maletero_5` int(11) DEFAULT NULL,
  `MaleteroCant_5` int(11) DEFAULT NULL,
  `MaleteroData_5` int(11) DEFAULT NULL,
  `Maletero_6` int(11) DEFAULT NULL,
  `MaleteroCant_6` int(11) DEFAULT NULL,
  `MaleteroData_6` int(11) DEFAULT NULL,
  `Maletero_7` int(11) DEFAULT NULL,
  `MaleteroCant_7` int(11) DEFAULT NULL,
  `MaleteroData_7` int(11) DEFAULT NULL,
  `Maletero_8` int(11) DEFAULT NULL,
  `MaleteroCant_8` int(11) DEFAULT NULL,
  `MaleteroData_8` int(11) DEFAULT NULL,
  `Maletero_9` int(11) DEFAULT NULL,
  `MaleteroCant_9` int(11) DEFAULT NULL,
  `MaleteroData_9` int(11) DEFAULT NULL,
  `Maletero_10` int(11) DEFAULT NULL,
  `MaleteroCant_10` int(11) DEFAULT NULL,
  `MaleteroData_10` int(11) DEFAULT NULL,
  `Maletero_11` int(11) DEFAULT NULL,
  `MaleteroCant_11` int(11) DEFAULT NULL,
  `MaleteroData_11` int(11) DEFAULT NULL,
  `Maletero_12` int(11) DEFAULT NULL,
  `MaleteroCant_12` int(11) DEFAULT NULL,
  `MaleteroData_12` int(11) DEFAULT NULL,
  `Maletero_13` int(11) DEFAULT NULL,
  `MaleteroCant_13` int(11) DEFAULT NULL,
  `MaleteroData_13` int(11) DEFAULT NULL,
  `Maletero_14` int(11) DEFAULT NULL,
  `MaleteroCant_14` int(11) DEFAULT NULL,
  `MaleteroData_14` int(11) DEFAULT NULL,
  `Guantera` int(11) DEFAULT NULL,
  `GuanteraCant` int(11) DEFAULT NULL,
  `GuanteraData` int(11) DEFAULT NULL,
  `Gunrack` smallint(6) NOT NULL DEFAULT 0,
  `GunrackCant` smallint(6) NOT NULL DEFAULT 0,
  `GunrackData` smallint(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vehicles`
--

INSERT INTO `vehicles` (`SQLID`, `Tipo`, `Matricula`, `Modelo`, `Color1`, `Color2`, `Dueno`, `Gasolina`, `Bloqueo`, `Vida`, `PosX`, `PosY`, `PosZ`, `PosR`, `VW`, `Interior`, `Deposito`, `DmgSuperficie`, `DmgPuertas`, `DmgLuces`, `DmgRuedas`, `mods0`, `mods1`, `mods2`, `mods3`, `mods4`, `mods5`, `mods6`, `mods7`, `mods8`, `mods9`, `mods10`, `mods11`, `mods12`, `mods13`, `mods14`, `EspacioMal`, `Maletero_0`, `MaleteroCant_0`, `MaleteroData_0`, `Maletero_1`, `MaleteroCant_1`, `MaleteroData_1`, `Maletero_2`, `MaleteroCant_2`, `MaleteroData_2`, `Maletero_3`, `MaleteroCant_3`, `MaleteroData_3`, `Maletero_4`, `MaleteroCant_4`, `MaleteroData_4`, `Maletero_5`, `MaleteroCant_5`, `MaleteroData_5`, `Maletero_6`, `MaleteroCant_6`, `MaleteroData_6`, `Maletero_7`, `MaleteroCant_7`, `MaleteroData_7`, `Maletero_8`, `MaleteroCant_8`, `MaleteroData_8`, `Maletero_9`, `MaleteroCant_9`, `MaleteroData_9`, `Maletero_10`, `MaleteroCant_10`, `MaleteroData_10`, `Maletero_11`, `MaleteroCant_11`, `MaleteroData_11`, `Maletero_12`, `MaleteroCant_12`, `MaleteroData_12`, `Maletero_13`, `MaleteroCant_13`, `MaleteroData_13`, `Maletero_14`, `MaleteroCant_14`, `MaleteroData_14`, `Guantera`, `GuanteraCant`, `GuanteraData`, `Gunrack`, `GunrackCant`, `GunrackData`) VALUES
(2, 1, 937303, 560, 7, 0, 'Gregory_Donovan', 100, 0, 897.39, 1608.9, -1665.6, 13.252, 183.064, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 61, 9, 0, 86, 34, 0, 56, 9, 0, 177, 1, 0, 166, 1, 0, 68, 0, 0, 63, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 1, 574781, 426, 6, 0, 'Gregory_Donovan', 100, 1, 951.25, 1259.33, -1341.45, 12.778, 283.295, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 1, 870508, 560, 0, 0, 'Melody_Stern', 0, 0, 0, 196.326, -282.963, 1.431, 215.632, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`SQLID`);

--
-- Indices de la tabla `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`SQLIDPJ`);

--
-- Indices de la tabla `char_toys`
--
ALTER TABLE `char_toys`
  ADD PRIMARY KEY (`character_id`);

--
-- Indices de la tabla `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`SQLID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `accounts`
--
ALTER TABLE `accounts`
  MODIFY `SQLID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `characters`
--
ALTER TABLE `characters`
  MODIFY `SQLIDPJ` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `SQLID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
