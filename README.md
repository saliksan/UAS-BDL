# UAS-BDL / AFISAL AINUL IKSAN (2201010065)
## 1. ERD (Entity Relationship Diagram)
   
   ![ERD UAS](https://github.com/saliksan/UAS-BDL/assets/168659202/c8cc0551-b8f1-42bc-a100-5bcc6ec57e36)

## 2. Deskripsi Project
### Tujuan
Tujuan proyek ini adalah untuk merancang dan membangun basis data yang dapat digunakan untuk mengelola transaksi dan informasi pelanggan dalam bisnis jasa cuci sepatu. Basis data ini harus dapat menyimpan informasi tentang pelanggan, sepatu, layanan yang diminta, dan harga. Basis data ini juga harus dapat menghasilkan laporan dan statistik tentang bisnis.

### Desain Basis Data
Basis data dapat dirancang menggunakan model hubungan entitas (ER). Model ER akan terdiri dari entitas berikut:

Customer: Entitas ini akan menyimpan informasi tentang pelanggan, seperti nama, alamat, nomor telepon.
Admin: Entitas ini akan menyimpan informasi tentang username dan password.
Jasa: Entitas ini akan menyimpan informasi tentang layanan yang ditawarkan, seperti nama jasa, deskripsi jasa, dan harga jasa.
Transaksi: Entitas ini akan menyimpan informasi tentang transaksi, seperti tanggal transaksi, customer yang terlibat, jasa yang diminta, dan total biaya.

### Manfaat
Memiliki basis data untuk bisnis jasa cuci sepatu dapat memberikan beberapa manfaat, seperti:

Meningkatkan efisiensi: Basis data dapat membantu mengotomatisasi tugas-tugas seperti melacak transaksi, menghasilkan laporan, dan mengelola informasi pelanggan.
Meningkatkan layanan pelanggan: Basis data dapat digunakan untuk melacak riwayat pesanan pelanggan dan preferensi mereka, yang dapat membantu memberikan layanan yang lebih personal.
Membuat keputusan yang lebih baik: Basis data dapat digunakan untuk menghasilkan laporan dan statistik yang dapat membantu pemilik bisnis membuat keputusan yang lebih baik tentang operasi mereka.

## 3. Penjelasan skema basis data, relasi, trigger, serta view setiap potongan code dari source code (SQL file)

### -SKEMA BASIS DATA-

   Dalam ERD yang sudah saya buat terdapat 4 tabel.
  - Tabel tb_customer menyimpan informasi pelanggan, seperti nama, alamat, dan nomor telepon.
  - Tabel tb_jasa menyimpan informasi jasa yang ditawarkan, seperti nama, deskripsi, dan harga.
  - Tabel tb_transaksi menyimpan informasi transaksi, seperti ID pelanggan, ID jasa, tanggal transaksi, dan total pembayaran.
  - Tabel tb_admin menyimpan informasi admin, seperti username dan password.
   Dan relasi antar tabel didefinisikan menggunakan kolom kunci utama dan kunci asing.

#### Query Pembuatan tabel customer
```sql
CREATE TABLE tb_customer (
  id_cust INT PRIMARY KEY AUTO_INCREMENT,
  nama_cust VARCHAR(255) NOT NULL,
  alamat_cust TEXT NOT NULL,
  tlp_cust VARCHAR(255) NOT NULL
);
```

#### Query Pembuatan tabel jasa
```sql
CREATE TABLE tb_jasa (
  id_jasa INT PRIMARY KEY AUTO_INCREMENT,
  nama_jasa VARCHAR(255) NOT NULL,
  deskripsi_jasa TEXT NOT NULL,
  harga_jasa INT NOT NULL
);
```

#### Query Pembuatan tabel admin
```sql
CREATE TABLE tb_admin (
  id_admin INT PRIMARY KEY AUTO_INCREMENT,
  username_admin VARCHAR(255) NOT NULL UNIQUE,
  password_admin VARCHAR(255) NOT NULL
);
```

#### Query Pembuatan tabel transaksi
```sql
CREATE TABLE tb_transaksi (
  id_transaksi INT PRIMARY KEY AUTO_INCREMENT,
  id_cust INT NOT NULL,
  id_jasa INT NOT NULL,
  tgl_transaksi DATE NOT NULL,
  total_bayar INT NOT NULL,
  id_admin INT NOT NULL,
  FOREIGN KEY (id_cust) REFERENCES tb_customer(id_cust),
  FOREIGN KEY (id_jasa) REFERENCES tb_jasa(id_jasa),
  FOREIGN KEY (id_admin) REFERENCES tb_admin(id_admin)
);
```

### -RELASI-

   Relasi satu ke banyak (1:N) antara tb_customer dan tb_transaksi: Satu pelanggan dapat memiliki banyak transaksi. Setiap transaksi harus memiliki satu pelanggan.
    
   Relasi satu ke banyak (1:N) antara tb_jasa dan tb_transaksi: Satu jasa dapat memiliki banyak transaksi. Setiap transaksi harus memiliki satu jasa.'
    
   Relasi satu ke satu (1:1) antara tb_admin dan tb_transaksi: Setiap transaksi diawasi oleh satu admin. Setiap admin dapat mengawasi banyak transaksi.

###  -TRIGGER-

#### Buat trigger after_insert pada tabel tb_transaksi untuk menghitung total pendapatan harian dan menyimpannya di tabel tb_pendapatan_harian.
```sql
DELIMITER //
CREATE TRIGGER after_insert_transaksi
AFTER INSERT ON tb_transaksi
FOR EACH ROW
BEGIN
  INSERT INTO tb_pendapatan_harian (tgl_transaksi, total_pendapatan)
  VALUES (NEW.tgl_transaksi, NEW.total_bayar);
END;
//
DELIMITER;
```

### Index
```sql
CREATE INDEX idx_id_cust ON tb_customer(id_cust);
CREATE INDEX idx_id_jasa ON tb_jasa(id_jasa);
CREATE INDEX idx_id_transaksi ON tb_transaksi(id_transaksi);
CREATE INDEX idx_id_admin ON tb_admin(id_admin)
```

### Tabel View
Membuat view v_transaksi_lengkap yang menggabungkan data dari tabel tb_transaksi, tb_customer, dan tb_jasa.
```sql
CREATE VIEW v_transaksi_lengkap AS
SELECT
  t.id_transaksi,
  c.nama_cust,
  j.nama_jasa,
  t.tgl_transaksi,
  t.total_bayar
FROM tb_transaksi t
JOIN tb_customer c ON t.id_cust = c.id_cust
JOIN tb_jasa j ON t.id_jasa = j.id_jasa;
```

### Query Join
#### menampilkan semua transaksi, termasuk yang belum diawasi oleh admin.
```sql
SELECT
  t.id_transaksi,
  c.nama_cust,
  j.nama_jasa,
  t.tgl_transaksi,
  t.total_bayar,
  a.username_admin
FROM tb_transaksi t
LEFT JOIN tb_admin a ON t.id_admin = a.id_admin
JOIN tb_customer c ON t.id_cust = c.id_cust
JOIN tb_jasa j ON t.id_jasa = j.id_jasa;
```

#### hanya menampilkan transaksi yang diawasi oleh admin.
```sql
SELECT
  t.id_transaksi,
  c.nama_cust,
  j.nama_jasa,
  t.tgl_transaksi,
  t.total_bayar,
  a.username_admin
FROM tb_transaksi t
INNER JOIN tb_admin a ON t.id_admin = a.id_admin
JOIN tb_customer c ON t.id_cust = c.id_cust
JOIN tb_jasa j ON t.id_jasa = j.id_jasa;
```

### Full Code

```sql
-- Tabel tb_customer
CREATE TABLE tb_customer (
  id_cust INT PRIMARY KEY AUTO_INCREMENT,
  nama_cust VARCHAR(255) NOT NULL,
  alamat_cust TEXT NOT NULL,
  tlp_cust VARCHAR(255) NOT NULL
);

-- Tabel tb_jasa
CREATE TABLE tb_jasa (
  id_jasa INT PRIMARY KEY AUTO_INCREMENT,
  nama_jasa VARCHAR(255) NOT NULL,
  deskripsi_jasa TEXT NOT NULL,
  harga_jasa INT NOT NULL
);

-- Tabel tb_transaksi
CREATE TABLE tb_transaksi (
  id_transaksi INT PRIMARY KEY AUTO_INCREMENT,
  id_cust INT NOT NULL,
  id_jasa INT NOT NULL,
  tgl_transaksi DATE NOT NULL,
  total_bayar INT NOT NULL,
  id_admin INT NOT NULL,
  FOREIGN KEY (id_cust) REFERENCES tb_customer(id_cust),
  FOREIGN KEY (id_jasa) REFERENCES tb_jasa(id_jasa),
  FOREIGN KEY (id_admin) REFERENCES tb_admin(id_admin)
);

-- Tabel tb_admin
CREATE TABLE tb_admin (
  id_admin INT PRIMARY KEY AUTO_INCREMENT,
  username_admin VARCHAR(255) NOT NULL UNIQUE,
  password_admin VARCHAR(255) NOT NULL
);

-- Index
CREATE INDEX idx_id_cust ON tb_customer(id_cust);
CREATE INDEX idx_id_jasa ON tb_jasa(id_jasa);
CREATE INDEX idx_id_transaksi ON tb_transaksi(id_transaksi);
CREATE INDEX idx_id_admin ON tb_admin(id_admin)

-- TRIGGER
-- Buat trigger after_insert pada tabel tb_transaksi untuk menghitung total pendapatan harian dan menyimpannya di tabel tb_pendapatan_harian.
DELIMITER //
CREATE TRIGGER after_insert_transaksi
AFTER INSERT ON tb_transaksi
FOR EACH ROW
BEGIN
  INSERT INTO tb_pendapatan_harian (tgl_transaksi, total_pendapatan)
  VALUES (NEW.tgl_transaksi, NEW.total_bayar);
END;
//
DELIMITER;

-- VIEW
-- Buat view v_transaksi_lengkap yang menggabungkan data dari tabel tb_transaksi, tb_customer, dan tb_jasa.
CREATE VIEW v_transaksi_lengkap AS
SELECT
  t.id_transaksi,
  c.nama_cust,
  j.nama_jasa,
  t.tgl_transaksi,
  t.total_bayar
FROM tb_transaksi t
JOIN tb_customer c ON t.id_cust = c.id_cust
JOIN tb_jasa j ON t.id_jasa = j.id_jasa;

-- QUERY JOIN
-- menampilkan semua transaksi, termasuk yang belum diawasi oleh admin.
SELECT
  t.id_transaksi,
  c.nama_cust,
  j.nama_jasa,
  t.tgl_transaksi,
  t.total_bayar,
  a.username_admin
FROM tb_transaksi t
LEFT JOIN tb_admin a ON t.id_admin = a.id_admin
JOIN tb_customer c ON t.id_cust = c.id_cust
JOIN tb_jasa j ON t.id_jasa = j.id_jasa;

-- hanya menampilkan transaksi yang diawasi oleh admin.
SELECT
  t.id_transaksi,
  c.nama_cust,
  j.nama_jasa,
  t.tgl_transaksi,
  t.total_bayar,
  a.username_admin
FROM tb_transaksi t
INNER JOIN tb_admin a ON t.id_admin = a.id_admin
JOIN tb_customer c ON t.id_cust = c.id_cust
JOIN tb_jasa j ON t.id_jasa = j.id_jasa;



```
   
   
