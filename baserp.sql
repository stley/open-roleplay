-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-08-2025 a las 09:25:59
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
  `Fecha_Reg` tinytext NOT NULL,
  `Ultima_Conexion` tinytext NOT NULL,
  `Premium` int(11) NOT NULL,
  `dPremium` int(11) NOT NULL,
  `mPremium` int(11) NOT NULL,
  `aPremium` int(11) NOT NULL,
  `CharacterLimit` int(11) NOT NULL DEFAULT 3,
  `online` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
--
-- Volcado de datos para la tabla `accounts`
--

INSERT INTO `accounts` (`SQLID`, `Nombre`, `Administrador`, `FacMan`, `StaffMan`, `PropMan`, `Creditos`, `Clave`, `Email`, `IP`, `Fecha_Reg`, `Ultima_Conexion`, `Premium`, `dPremium`, `mPremium`, `aPremium`, `CharacterLimit`, `online`) VALUES
(1, 'varky', 1337, 0, 0, 0, 0, '644D5F272C31098436B96386B7CC62F363E058C9CC478C032D617EC1FB622ACCD1C1732793D3088599485CCA56850721A8F1A434615785FE8E321DBDA349447A', 'email@dominio.com', '127.0.0.1', 'Domingo 29 de Octubre de 2023 [04:13 AM]', 'Domingo 17 de Noviembre de 2024 [12:07 AM]', 0, 0, 0, 0, 3, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `characters`
--

CREATE TABLE `characters` (
  `SQLIDPJ` int(11) NOT NULL,
  `Usuario` int(11) DEFAULT NULL,
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
-- Ýndices para tablas volcadas
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
  MODIFY `SQLID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `characters`
--
ALTER TABLE `characters`
  MODIFY `SQLIDPJ` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT de la tabla `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `SQLID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
