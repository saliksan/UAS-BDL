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
-- Tabel
CREATE TABLE tb_customer (
    id_cust INT PRIMARY KEY AUTO_INCREMENT,
    nama_cust VARCHAR(255) NOT NULL,
    alamat_cust VARCHAR(255) UNIQUE NOT NULL,
    tlp_cust VARCHAR(15) NOT NULL
);

CREATE TABLE tb_jasa (
    id_jasa INT PRIMARY KEY AUTO_INCREMENT,
    nama_jasa VARCHAR(255) NOT NULL,
    deskripsi_jasa VARCHAR(255) NOT NULL,
    harga_jasa VARCHAR(15) NOT NULL
);

CREATE TABLE tb_transaksi (
    id_transaksi INT PRIMARY KEY AUTO_INCREMENT,
    id_cust INT NOT NULL,
    id_jasa INT NOT NULL,
    tgl_transaksi DATE NOT NULL,
    total_bayar INT NOT NULL,
    FOREIGN KEY (id_cust) REFERENCES tb_cust(id_cust),
    FOREIGN KEY (id_jasa) REFERENCES tb_jasa(id_jasa)
);

CREATE TABLE tb_admin (
    id_admin INT PRIMARY KEY AUTO_INCREMENT,
    username_admin VARCHAR(255) NOT NULL UNIQUE,
    password_admin VARCHAR(255) NOT NULL
);

-- Index
CREATE INDEX idx_reservation_customer_id ON reservation(customer_id);
CREATE INDEX idx_restaurant_id ON restaurant(restaurant_id);
CREATE INDEX idx_table_id ON restaurant_table(table_id);
CREATE INDEX idx_reservation_date ON reservation(reservation_date);
CREATE INDEX idx_reservation_time ON reservation(reservation_time);
CREATE INDEX idx_payment_reservation_id ON payment(reservation_id);
CREATE INDEX idx_customer_name ON customer(NAME);
CREATE INDEX idx_customer_id ON customer(customer_id);

-- Trigger
DELIMITER //
CREATE TRIGGER update_table_capacity_after_reservation
AFTER INSERT ON reservation
FOR EACH ROW
BEGIN
    UPDATE restaurant_table
    SET capacity = capacity - NEW.number_of_people
    WHERE table_id = NEW.table_id;
END;
//
DELIMITER ;

-- Trigger 2
DELIMITER //
CREATE TRIGGER update_total_payments_after_insert
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(amount) INTO total
    FROM payment
    WHERE reservation_id = NEW.reservation_id;
    
    UPDATE reservation
    SET total_payment = total
    WHERE reservation_id = NEW.reservation_id;
END;
//
DELIMITER ;

-- View
CREATE VIEW reservation_details AS
SELECT
    r.reservation_id,
    c.name AS customer_name,
    c.email AS customer_email,
    rest.name AS restaurant_name,
    rt.table_number,
    r.reservation_date,
    r.reservation_time,
    r.number_of_people
FROM
    reservation r
JOIN
    customer c ON r.customer_id = c.customer_id
JOIN
    restaurant rest ON r.restaurant_id = rest.restaurant_id
JOIN
    restaurant_table rt ON r.table_id = rt.table_id;

-- View 2
CREATE VIEW reservation_payment_details AS
SELECT
    r.reservation_id,
    c.name AS customer_name,
    rest.name AS restaurant_name,
    rt.table_number,
    r.reservation_date,
    r.reservation_time,
    r.number_of_people,
    p.total_payment
FROM
    reservation r
JOIN
    customer c ON r.customer_id = c.customer_id
JOIN
    restaurant rest ON r.restaurant_id = rest.restaurant_id
JOIN
    restaurant_table rt ON r.table_id = rt.table_id
LEFT JOIN
    (SELECT reservation_id, SUM(amount) AS total_payment
     FROM payment
     GROUP BY reservation_id) p ON r.reservation_id = p.reservation_id;

-- View 3
CREATE VIEW customers_with_multiple_reservations AS
SELECT
    c.customer_id,
    c.name AS customer_name,
    COUNT(r.reservation_id) AS total_reservations
FROM
    customer c
LEFT JOIN
    reservation r ON c.customer_id = r.customer_id
WHERE
    c.name LIKE '%John%'
GROUP BY
    c.customer_id, c.name
HAVING
    COUNT(r.reservation_id) > 1;
   ```

### Testing

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
CREATE INDEX idx_id_cust ON tb_customer(id_customer);
CREATE INDEX idx_id_jasa ON tb_jasa(id_jasa);
CREATE INDEX idx_id_transaksi ON tb_transaksi(id_transaksi);
CREATE INDEX idx_id_admin ON tb_admin(id_admin)

-- TRIGGER
// Buat trigger after_insert pada tabel tb_transaksi untuk menghitung total pendapatan harian dan menyimpannya di tabel tb_pendapatan_harian.
CREATE TRIGGER after_insert_transaksi
AFTER INSERT ON tb_transaksi
FOR EACH ROW
BEGIN
  INSERT INTO tb_pendapatan_harian (tgl_transaksi, total_pendapatan)
  VALUES (NEW.tgl_transaksi, NEW.total_bayar);
END;

-- VIEW
// Buat view v_transaksi_lengkap yang menggabungkan data dari tabel tb_transaksi, tb_customer, dan tb_jasa.
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
// menampilkan semua transaksi, termasuk yang belum diawasi oleh admin.
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

// hanya menampilkan transaksi yang diawasi oleh admin.
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
   
   
