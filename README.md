# UAS-BDL / AFISAL AINUL IKSAN (2201010065)
## 1. ERD (Entity Relationship Diagram)
   
   ![ERD UAS](https://github.com/saliksan/UAS-BDL/assets/168659202/c8cc0551-b8f1-42bc-a100-5bcc6ec57e36)

## 2. Deskripsi Project
  - 

## 3. Penjelasan skema basis data, relasi, trigger, serta view setiap potongan code dari source code (SQL file)

### -SKEMA BASIS DATA-

   Dalam ERD yang sudah saya buat terdapat 4 tabel.
  - Tabel tb_customer menyimpan informasi pelanggan, seperti nama, alamat, dan nomor telepon.
  - Tabel tb_jasa menyimpan informasi jasa yang ditawarkan, seperti nama, deskripsi, dan harga.
  - Tabel tb_transaksi menyimpan informasi transaksi, seperti ID pelanggan, ID jasa, tanggal transaksi, dan total pembayaran.
  - Tabel tb_admin menyimpan informasi admin, seperti username dan password.
   Dan relasi antar tabel didefinisikan menggunakan kolom kunci utama dan kunci asing.

### -RELASI-

   Relasi satu ke banyak (1:N) antara tb_customer dan tb_transaksi: Satu pelanggan dapat memiliki banyak transaksi. Setiap transaksi harus memiliki satu pelanggan.
    
   Relasi satu ke banyak (1:N) antara tb_jasa dan tb_transaksi: Satu jasa dapat memiliki banyak transaksi. Setiap transaksi harus memiliki satu jasa.'
    
   Relasi satu ke satu (1:1) antara tb_admin dan tb_transaksi: Setiap transaksi diawasi oleh satu admin. Setiap admin dapat mengawasi banyak transaksi.

###  -TRIGGER-


###   -VIEW SOURCE CODE-

   ```sql
   -- Buat tabel tb_cust
CREATE TABLE tb_cust (
  id_cust INT PRIMARY KEY AUTO_INCREMENT,
  nama_cust VARCHAR(255) NOT NULL,
  alamat_cust TEXT NOT NULL,
  tlp_cust VARCHAR(255) NOT NULL
);

-- Buat tabel tb_jasa
CREATE TABLE tb_jasa (
  id_jasa INT PRIMARY KEY AUTO_INCREMENT,
  nama_jasa VARCHAR(255) NOT NULL,
  deskripsi_jasa TEXT NOT NULL,
  harga_jasa INT NOT NULL
);

-- Buat tabel tb_transaksi
CREATE TABLE tb_transaksi (
  id_transaksi INT PRIMARY KEY AUTO_INCREMENT,
  id_cust INT NOT NULL,
  id_jasa INT NOT NULL,
  tgl_transaksi DATE NOT NULL,
  total_bayar INT NOT NULL,
  FOREIGN KEY (id_cust) REFERENCES tb_cust(id_cust),
  FOREIGN KEY (id_jasa) REFERENCES tb_jasa(id_jasa)
);

-- Buat tabel tb_admin
CREATE TABLE tb_admin (
  id_admin INT PRIMARY KEY AUTO_INCREMENT,
  username_admin VARCHAR(255) NOT NULL UNIQUE,
  password_admin VARCHAR(255) NOT NULL
);

   ```
   
   
