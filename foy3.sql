CREATE DATABASE foy3;

USE foy3;


CREATE TABLE birinler (
    birim_id INT PRIMARY KEY,
    birim_ad CHAR(25) NOT NULL
);


CREATE TABLE calisamlar (
    calisan_id INT PRIMARY KEY,
    ad CHAR(25) NOT NULL,
    soyad CHAR(25) NOT NULL,
    maas INT NULL,
    katilmaTarihi DATETIME NULL,
    calisan_birim_id INT,
    FOREIGN KEY (calisan_birim_id) REFERENCES birimler(birim_id)
);


CREATE TABLE unvam (
    unvan_calisan_id INT NOT NULL,
    unvan CHAR(25) NOT NULL,
    unvan_tarih DATETIME NOT NULL,
    FOREIGN KEY (unvan_calisan_id) REFERENCES calisanlar(calisan_id)
);


CREATE TABLE ikraniye (
    ikramiye_calisan_id INT NOT NULL,
    ikramiye_ucret INT NULL,
    ikramiye_tarih DATETIME NOT NULL,
    FOREIGN KEY (ikramiye_calisan_id) REFERENCES calisanlar(calisan_id)
);


INSERT INTO birimler (birim_id, birim_ad) VALUES
(1, 'Yazýlým'),
(2, 'Donaným'),
(3, 'Güvenlik');


INSERT INTO calisanlar (calisan_id, ad, soyad, maas, katilmaTarihi, calisan_birim_id) VALUES
(1, 'Ýsmail', 'Ýçeri', 100000, '2014-02-20 00:00:00', 1),
(2, 'Hami', 'Þahmiþ', 80000, '2014-01-16 00:00:00', 1),
(3, 'Dumuþ', 'Þahin', 30000, '2014-02-20 00:00:00', 2),
(4, 'Kaðan', 'Yazar', 500000, '2014-02-20 00:00:00', 3),
(5, 'Meryem', 'Soyaslü', 500000, '2014-06-11 10:00:00', 3),
(6, 'Duygu', 'Akgöker', 200000, '2014-06-11 10:00:00', ),
(7, 'Kübra', 'Seyhan', 75000, '2014-01-20 00:00:00', 1),
(8, 'Gülcan', 'Yýldýz', 90000, '2014-01-11 00:00:00', 3);


INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarih) VALUES
(1, 5000, '2016-02-20 00:00:00'),
(2, 3000, '2016-06-11 00:00:00'),
(3, 4000, '2016-02-20 00:00:00'),
(4, 4500, '2016-02-20 00:00:00'),
(5, 3500, '2016-06-11 00:00:00');


INSERT INTO unvan (unvan_calisan_id, unvan, unvan_tarih) VALUES
(1, 'Yönetici', '2016-02-20 00:00:00'),
(2, 'Personel', '2016-06-11 00:00:00'),
(3, 'Personel', '2016-06-11 00:00:00'),
(4, 'Müdür', '2016-06-11 00:00:00'),
(5, 'Yönetici Yardýmcýsý', '2016-06-11 00:00:00'),
(6, 'Personel', '2016-06-11 00:00:00'),
(7, 'Takým Lideri', '2016-06-11 00:00:00'),
(8, 'Takým Lideri', '2016-06-11 00:00:00');

use foy3;

SELECT ad, soyad, maas
FROM calisanlar
WHERE calisan_birim_id IN (SELECT birim_id FROM birimler WHERE birim_ad IN ('Yazýlým', 'Donaným'));


SELECT ad, soyad, maas
FROM calisanlar
WHERE maas = (SELECT MAX(maas) FROM calisanlar);

SELECT b.birim_ad, COUNT(c.calisan_id) AS calisan_sayisi
FROM birimler b
LEFT JOIN calisanlar c ON b.birim_id = c.calisan_birim_id
GROUP BY b.birim_ad;


SELECT u.unvan, COUNT(u.unvan_calisan_id) AS calisan_sayisi
FROM unvan u
GROUP BY u.unvan
HAVING COUNT(u.unvan_calisan_id) > 1;


SELECT ad, soyad, maas
FROM calisanlar
WHERE maas BETWEEN 50000 AND 100000;

SELECT c.ad, c.soyad, b.birim_ad, u.unvan, i.ikramiye_ucret
FROM calisanlar c
JOIN birimler b ON c.calisan_birim_id = b.birim_id
JOIN unvan u ON c.calisan_id = u.unvan_calisan_id
JOIN ikramiye i ON c.calisan_id = i.ikramiye_calisan_id;


SELECT c.ad, c.soyad, u.unvan
FROM calisanlar c
JOIN unvan u ON c.calisan_id = u.unvan_calisan_id
WHERE u.unvan IN ('Yönetici', 'Müdür');


SELECT c.ad, c.soyad, c.maas, b.birim_ad
FROM calisanlar c
JOIN birimler b ON c.calisan_birim_id = b.birim_id
WHERE c.maas = (
    SELECT MAX(c2.maas)
    FROM calisanlar c2
    WHERE c2.calisan_birim_id = c.calisan_birim_id
);
