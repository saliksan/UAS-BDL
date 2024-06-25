-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2024 at 09:18 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_jasa_sepatu`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_admin`
--

CREATE TABLE `tb_admin` (
  `id_admin` int(11) NOT NULL,
  `username_admin` varchar(255) NOT NULL,
  `password_admin` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `tb_admin`:
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_customer`
--

CREATE TABLE `tb_customer` (
  `id_cust` int(11) NOT NULL,
  `nama_cust` varchar(255) NOT NULL,
  `alamat_cust` text NOT NULL,
  `tlp_cust` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `tb_customer`:
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_jasa`
--

CREATE TABLE `tb_jasa` (
  `id_jasa` int(11) NOT NULL,
  `nama_jasa` varchar(255) NOT NULL,
  `deskripsi_jasa` text NOT NULL,
  `harga_jasa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `tb_jasa`:
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_transaksi`
--

CREATE TABLE `tb_transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_cust` int(11) NOT NULL,
  `id_jasa` int(11) NOT NULL,
  `tgl_transaksi` date NOT NULL,
  `total_bayar` int(11) NOT NULL,
  `id_admin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `tb_transaksi`:
--   `id_cust`
--       `tb_customer` -> `id_cust`
--   `id_jasa`
--       `tb_jasa` -> `id_jasa`
--   `id_admin`
--       `tb_admin` -> `id_admin`
--

--
-- Triggers `tb_transaksi`
--
DELIMITER $$
CREATE TRIGGER `after_insert_transaksi` AFTER INSERT ON `tb_transaksi` FOR EACH ROW BEGIN
  INSERT INTO tb_pendapatan_harian (tgl_transaksi, total_pendapatan)
  VALUES (NEW.tgl_transaksi, NEW.total_bayar);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_transaksi_lengkap`
-- (See below for the actual view)
--
CREATE TABLE `v_transaksi_lengkap` (
`id_transaksi` int(11)
,`nama_cust` varchar(255)
,`nama_jasa` varchar(255)
,`tgl_transaksi` date
,`total_bayar` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `v_transaksi_lengkap`
--
DROP TABLE IF EXISTS `v_transaksi_lengkap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_transaksi_lengkap`  AS SELECT `t`.`id_transaksi` AS `id_transaksi`, `c`.`nama_cust` AS `nama_cust`, `j`.`nama_jasa` AS `nama_jasa`, `t`.`tgl_transaksi` AS `tgl_transaksi`, `t`.`total_bayar` AS `total_bayar` FROM ((`tb_transaksi` `t` join `tb_customer` `c` on(`t`.`id_cust` = `c`.`id_cust`)) join `tb_jasa` `j` on(`t`.`id_jasa` = `j`.`id_jasa`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_admin`
--
ALTER TABLE `tb_admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `username_admin` (`username_admin`),
  ADD KEY `idx_id_admin` (`id_admin`);

--
-- Indexes for table `tb_customer`
--
ALTER TABLE `tb_customer`
  ADD PRIMARY KEY (`id_cust`),
  ADD KEY `idx_id_cust` (`id_cust`);

--
-- Indexes for table `tb_jasa`
--
ALTER TABLE `tb_jasa`
  ADD PRIMARY KEY (`id_jasa`),
  ADD KEY `idx_id_jasa` (`id_jasa`);

--
-- Indexes for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_cust` (`id_cust`),
  ADD KEY `id_jasa` (`id_jasa`),
  ADD KEY `id_admin` (`id_admin`),
  ADD KEY `idx_id_transaksi` (`id_transaksi`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_admin`
--
ALTER TABLE `tb_admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_customer`
--
ALTER TABLE `tb_customer`
  MODIFY `id_cust` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_jasa`
--
ALTER TABLE `tb_jasa`
  MODIFY `id_jasa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD CONSTRAINT `tb_transaksi_ibfk_1` FOREIGN KEY (`id_cust`) REFERENCES `tb_customer` (`id_cust`),
  ADD CONSTRAINT `tb_transaksi_ibfk_2` FOREIGN KEY (`id_jasa`) REFERENCES `tb_jasa` (`id_jasa`),
  ADD CONSTRAINT `tb_transaksi_ibfk_3` FOREIGN KEY (`id_admin`) REFERENCES `tb_admin` (`id_admin`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
