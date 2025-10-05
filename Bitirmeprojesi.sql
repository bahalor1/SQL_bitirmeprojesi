--------------------- TABLOLAR ---------------------

--Müþteri tablosu 
CREATE TABLE Musteri(
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(50) NOT NULL,
  soyad NVARCHAR(50) NOT NULL,
  email NVARCHAR(100) NOT NULL UNIQUE,
  sehir NVARCHAR(50),
  kayit_tarihi DATE DEFAULT GETDATE()
);

--Kategori tablosu 
CREATE TABLE Kategori(
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(50) NOT NULL
);

--Satýcý tablosu 
CREATE TABLE Satici(
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(100) NOT NULL,
  adres NVARCHAR(200)
);

--Ürün tablosu 
CREATE TABLE Urun(
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(100) NOT NULL,
  fiyat DECIMAL(10,2) NOT NULL,
  stok INT NOT NULL,
  kategori_id INT FOREIGN KEY REFERENCES Kategori(id),
  satici_id INT FOREIGN KEY REFERENCES Satici(id)
);

--Sipariþ tablosu 
CREATE TABLE Siparis(
  id INT IDENTITY(1,1) PRIMARY KEY,
  musteri_id INT FOREIGN KEY REFERENCES Musteri(id),
  tarih DATETIME DEFAULT GETDATE(),
  toplam_tutar DECIMAL(10,2),
  odeme_turu NVARCHAR(20)
);

--Sipariþ Detay tablosu
CREATE TABLE Siparis_Detay(
  id INT IDENTITY(1,1) PRIMARY KEY,
  siparis_id INT FOREIGN KEY REFERENCES Siparis(id),
  urun_id INT FOREIGN KEY REFERENCES Urun(id),
  adet INT NOT NULL,
  fiyat DECIMAL(10,2) NOT NULL
);
GO

CREATE TRIGGER trg_UpdateStock
ON Siparis_Detay
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @urunId INT, @adet INT, @stok INT, @urunAdi NVARCHAR(100);

    -- Yeni eklenen sipariþ detayýndaki ürün ve adet bilgilerini al
    SELECT @urunId = urun_id, @adet = adet FROM inserted;

    -- Ürünün mevcut stok miktarýný al
    SELECT @stok = stok, @urunAdi =ad FROM Urun WHERE id = @urunId;

    -- Eðer stok yetersizse iþlemi iptal et
    IF @stok < @adet
    BEGIN
        DECLARE @msg NVARCHAR(200);
        SET @msg = N'Yetersiz stok! "' + @urunAdi + N'" ürününden daha fazla satýn alýnamaz.';
        RAISERROR(@msg, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Stoktan düþ
    UPDATE Urun
    SET stok = stok - @adet
    WHERE id = @urunId;
END;
GO


--------------------- ÜRÜN,SATICI,MÜÞTERÝ BÝLGÝLERÝ BASTIRMA ---------------------



--Kategoriler 
INSERT INTO Kategori (ad) VALUES 
('Elektronik'),
('Giyim'),
('Kitap'),
('Spor & Outdoor'),
('Ev & Yaþam'),
('Ofis & Kýrtasiye'),
('Oyuncak'),
('Kozmetik'),
('Hobi & Sanat'),
('Mutfak');

--Satýcýlar 
INSERT INTO Satici (ad, adres) VALUES
('TeknoSat', 'Ýstanbul'),
('ModaCenter', 'Ankara'),
('KitapYurdu', 'Ýzmir'),
('SporMarket', 'Bursa'),
('EvTrend', 'Antalya'),
('OfisDepo', 'Eskiþehir'),
('OyuncakDünyasý', 'Gaziantep'),
('GüzellikShop', 'Adana'),
('HobiSanat', 'Konya'),
('MutfakMarket', 'Trabzon');

--Müþteriler 
INSERT INTO Musteri (ad, soyad, email, sehir) VALUES
('Deniz', 'Kaya', 'deniz.kaya@example.com', 'X'),
('Elif', 'Çelik', 'elif.celik@example.com', 'X'),
('Murat', 'Yýldýrým', 'murat.yildirim@example.com', 'X'),
('Zeynep', 'Demir', 'zeynep.demir@example.com', 'X'),
('Burak', 'Þahin', 'burak.sahin@example.com', 'X'),
('Selin', 'Kurt', 'selin.kurt@example.com', 'X'),
('Emre', 'Acar', 'emre.acar@example.com', 'X'),
('Gamze', 'Öztürk', 'gamze.ozturk@example.com', 'X'),
('Tolga', 'Kaplan', 'tolga.kaplan@example.com', 'X'),
('Derya', 'Polat', 'derya.polat@example.com', 'X'),
('Caner', 'Yýlmaz', 'caner.yilmaz@example.com', 'X'),
('Hülya', 'Yavuz', 'hulya.yavuz@example.com', 'X'),
('Kerem', 'Doðan', 'kerem.dogan@example.com', 'X'),
('Nazlý', 'Koç', 'nazli.koc@example.com', 'X'),
('Oðuz', 'Erdoðan', 'oguz.erdogan@example.com', 'X'),
('Seda', 'Aslan', 'seda.aslan@example.com', 'X'),
('Tuna', 'Çakýr', 'tuna.cakir@example.com', 'X'),
('Esra', 'Kurtuluþ', 'esra.kurtulus@example.com', 'X'),
('Hakan', 'Özdemir', 'hakan.ozdemir@example.com', 'X'),
('Pelin', 'Kara', 'pelin.kara@example.com', 'X'),
('Barýþ', 'Güneþ', 'baris.gunes@example.com', 'X'),
('Ýpek', 'Arslan', 'ipek.arslan@example.com', 'X'),
('Efe', 'Dinç', 'efe.dinc@example.com', 'X'),
('Serap', 'Taþ', 'serap.tas@example.com', 'X'),
('Cem', 'Þen', 'cem.sen@example.com', 'X'),
('Merve', 'Sezer', 'merve.sezer@example.com', 'X'),
('Kaan', 'Bulut', 'kaan.bulut@example.com', 'X'),
('Eda', 'Baþar', 'eda.basar@example.com', 'X'),
('Volkan', 'Koþar', 'volkan.kosar@example.com', 'X'),
('Nil', 'Çetin', 'nil.cetin@example.com', 'X'),
('Ufuk', 'Balcý', 'ufuk.balci@example.com', 'X'),
('Sibel', 'Aksoy', 'sibel.aksoy@example.com', 'X'),
('Alper', 'Yýldýz', 'alper.yildiz@example.com', 'X'),
('Deniz', 'Bozkurt', 'deniz.bozkurt@example.com', 'X'),
('Sevgi', 'Karaaslan', 'sevgi.karaaslan@example.com', 'X'),
('Onur', 'Köksal', 'onur.koksal@example.com', 'X'),
('Buse', 'Gül', 'buse.gul@example.com', 'X'),
('Harun', 'Sönmez', 'harun.sonmez@example.com', 'X'),
('Figen', 'Turan', 'figen.turan@example.com', 'X'),
('Tolunay', 'Kýlýç', 'tolunay.kilic@example.com', 'X'),
('Deniz', 'Arýkan', 'deniz.arikan@example.com', 'X'),
('Þule', 'Özkan', 'sule.ozkan@example.com', 'X'),
('Kadir', 'Toprak', 'kadir.toprak@example.com', 'X'),
('Necla', 'Ateþ', 'necla.ates@example.com', 'X'),
('Metin', 'Yurt', 'metin.yurt@example.com', 'X'),
('Sevil', 'Baþ', 'sevil.bas@example.com', 'X'),
('Aylin', 'Þeker', 'aylin.seker@example.com', 'X'),
('Ahmet', 'Tuna', 'ahmet.tuna@example.com', 'X'),
('Nihat', 'Çolak', 'nihat.colak@example.com', 'X'),
('Bora', 'Çetin', 'bora.cetin@example.com', 'X'),
('Ferhat', 'Özer', 'ferhat.ozer@example.com', 'X'),
('Hüseyin', 'Durmaz', 'huseyin.durmaz@example.com', 'X'),
('Ayça', 'Karaca', 'ayca.karaca@example.com', 'X'),
('Þirin', 'Duman', 'sirin.duman@example.com', 'X'),
('Ceyda', 'Tunç', 'ceyda.tunc@example.com', 'X'),
('Fatih', 'Eren', 'fatih.eren@example.com', 'X'),
('Berk', 'Önal', 'berk.onal@example.com', 'X'),
('Sevda', 'Kýlýç', 'sevda.kilic@example.com', 'X'),
('Tuðçe', 'Sarý', 'tugce.sari@example.com', 'X'),
('Ali', 'Kurt', 'ali.kurt@example.com', 'X'),
('Zehra', 'Taþçý', 'zehra.tasci@example.com', 'X'),
('Orhan', 'Korkmaz', 'orhan.korkmaz@example.com', 'X'),
('Binnaz', 'Güler', 'binnaz.guler@example.com', 'X'),
('Selçuk', 'Çalýþkan', 'selcuk.caliskan@example.com', 'X'),
('Aslý', 'Sevim', 'asli.sevim@example.com', 'X'),
('Gizem', 'Aydýn', 'gizem.aydin@example.com', 'X'),
('Okan', 'Karaman', 'okan.karaman@example.com', 'X'),
('Yusuf', 'Demirtaþ', 'yusuf.demirtas@example.com', 'X'),
('Arda', 'Ekinci', 'arda.ekinci@example.com', 'X'),
('Seçil', 'Bozkaya', 'secil.bozkaya@example.com', 'X'),
('Melis', 'Özer', 'melis.ozer@example.com', 'X'),
('Ýsmail', 'Türkmen', 'ismail.turkmen@example.com', 'X'),
('Þahin', 'Bayram', 'sahin.bayram@example.com', 'X'),
('Rabia', 'Altun', 'rabia.altun@example.com', 'X'),
('Aydýn', 'Tuna', 'aydin.tuna@example.com', 'X'),
('Gökhan', 'Ersoy', 'gokhan.ersoy@example.com', 'X'),
('Ebru', 'Sevimli', 'ebru.sevimli@example.com', 'X'),
('Ýrem', 'Koç', 'irem.koc@example.com', 'X'),
('Emir', 'Demir', 'emir.demir@example.com', 'X'),
('Selin', 'Aydýn', 'selin.aydin@example.com', 'X'),
('Bora', 'Korkmaz', 'bora.korkmaz@example.com', 'X'),
('Asya', 'Kaya', 'asya.kaya@example.com', 'X'),
('Efe', 'Þahin', 'efe.sahin@example.com', 'X'),
('Deniz', 'Arslan', 'deniz.arslan@example.com', 'X'),
('Ýpek', 'Koç', 'ipek.koc@example.com', 'X'),
('Kerem', 'Çelik', 'kerem.celik@example.com', 'X'),
('Mert', 'Polat', 'mert.polat@example.com', 'X'),
('Yasemin', 'Öztürk', 'yasemin.ozturk@example.com', 'X'),
('Arda', 'Güneþ', 'arda.gunes@example.com', 'X'),
('Gamze', 'Yýldýz', 'gamze.yildiz@example.com', 'X'),
('Tolga', 'Demirtaþ', 'tolga.demirtas@example.com', 'X'),
('Seda', 'Kara', 'seda.kara@example.com', 'X'),
('Kaan', 'Bayraktar', 'kaan.bayraktar@example.com', 'X'),
('Ayþe', 'Doðan', 'ayse.dogan@example.com', 'X'),
('Melis', 'Aksoy', 'melis.aksoy@example.com', 'X'),
('Burak', 'Özer', 'burak.ozer@example.com', 'X'),
('Ezgi', 'Çýnar', 'ezgi.cinar@example.com', 'X'),
('Can', 'Erdoðan', 'can.erdogan@example.com', 'X'),
('Zeynep', 'Çolak', 'zeynep.colak@example.com', 'X'),
('Onur', 'Sezer', 'onur.sezer@example.com', 'X');

--Ýlleri rastgele atama
DECLARE @Iller TABLE (sehir NVARCHAR(50));
INSERT INTO @Iller (sehir) VALUES
(N'Adana'),(N'Adýyaman'),(N'Afyonkarahisar'),(N'Aðrý'),(N'Amasya'),
(N'Ankara'),(N'Antalya'),(N'Artvin'),(N'Aydýn'),(N'Balýkesir'),
(N'Bilecik'),(N'Bingöl'),(N'Bitlis'),(N'Bolu'),(N'Burdur'),
(N'Bursa'),(N'Çanakkale'),(N'Çankýrý'),(N'Çorum'),(N'Denizli'),
(N'Diyarbakýr'),(N'Edirne'),(N'Elazýð'),(N'Erzincan'),(N'Erzurum'),
(N'Eskiþehir'),(N'Gaziantep'),(N'Giresun'),(N'Gümüþhane'),(N'Hakkari'),
(N'Hatay'),(N'Isparta'),(N'Mersin'),(N'Ýstanbul'),(N'Ýzmir'),
(N'Kars'),(N'Kastamonu'),(N'Kayseri'),(N'Kýrklareli'),(N'Kýrþehir'),
(N'Kocaeli'),(N'Konya'),(N'Kütahya'),(N'Malatya'),(N'Manisa'),
(N'Kahramanmaraþ'),(N'Mardin'),(N'Muðla'),(N'Muþ'),(N'Nevþehir'),
(N'Niðde'),(N'Ordu'),(N'Rize'),(N'Sakarya'),(N'Samsun'),
(N'Siirt'),(N'Sinop'),(N'Sivas'),(N'Tekirdað'),(N'Tokat'),
(N'Trabzon'),(N'Tunceli'),(N'Þanlýurfa'),(N'Uþak'),(N'Van'),
(N'Yozgat'),(N'Zonguldak'),(N'Aksaray'),(N'Bayburt'),(N'Karaman'),
(N'Kýrýkkale'),(N'Batman'),(N'Þýrnak'),(N'Bartýn'),(N'Ardahan'),
(N'Iðdýr'),(N'Yalova'),(N'Karabük'),(N'Kilis'),(N'Osmaniye'),
(N'Düzce');

-- Her müþteriye farklý random þehir ata
DECLARE @minId2 INT, @maxId2 INT, @id INT;
DECLARE @sehir NVARCHAR(50);

SET @minId2 = (SELECT MIN(id) FROM Musteri);
SET @maxId2 = (SELECT MAX(id) FROM Musteri);
SET @id = @minId2;

WHILE @id <= @maxId2
BEGIN
    -- Her müþteri için 1 random þehir çek
    SELECT TOP 1 @sehir = sehir
    FROM @Iller
    ORDER BY NEWID();

    -- O müþteriye þehir ata
    UPDATE Musteri
    SET sehir = @sehir
    WHERE id = @id;

    -- Sonraki müþteriye geç
    SET @id = @id + 1;
END;

--Kayýt tarihi rastgele atama
UPDATE Musteri
SET kayit_tarihi = DATEADD(
    DAY, 
    -1 * (ABS(CHECKSUM(NEWID())) % (365 * 3)), 
    GETDATE()
);

--Ürünler 
INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES
('Telefon', 15000, 4, 1, 1),
('Kulaklýk', 1200, 20, 1, 1),
('Tablet', 8000, 10, 1, 1),
('Televizyon', 25000, 4, 1, 1),
('Tiþört', 200, 12, 2, 2),
('Mont', 900, 10, 2, 2),
('Ayakkabý', 1200, 10, 2, 2),
('Kot Pantolon', 600, 10, 2, 2),
('Roman', 80, 20, 3, 3),
('Ansiklopedi', 300, 25, 3, 3),
('Bilim Kurgu Romaný', 150, 10, 3, 3),
('Þiir Kitabý', 90, 5, 3, 3),
('Futbol Topu', 400, 10, 4, 4),
('Kamp Çadýrý', 2500, 10, 4, 4),
('Dumbbell Seti', 1200, 10, 4, 4),
('Yoga Matý', 200, 10, 4, 4),
('Masa Lambasý', 350, 10, 5, 5),
('Defter', 20, 100, 5, 5),
('Dolma Kalem', 120, 20, 5, 5),
('Masa Sandalye Takýmý', 2000, 5, 5, 5),
('Oyuncak Araba', 150, 55, 6, 6),
('Puzzle Seti', 300, 15, 6, 6),
('LEGO Seti', 800, 10, 6, 6),
('Bebek Oyuncaðý', 100, 10, 6, 6),
('Parfüm', 700, 40, 7, 7),
('Ruj', 150, 40, 7, 7),
('Fondöten', 250, 40, 7, 7),
('Göz Farý Paleti', 300, 40, 7, 7),
('Sulu Boya Seti', 100, 40, 8, 8),
('Kanvas Tuvali', 80, 50, 8, 8),
('Yaðlý Boya Fýrçasý', 60, 10, 8, 8),
('Maket Býçaðý', 40, 50, 8, 8),
('Tencere Seti', 1200, 10, 9, 9),
('Býçak Takýmý', 600, 10, 9, 9),
('Tabak Seti', 800, 10, 9, 9),
('Çatal Kaþýk Seti', 400, 5, 9, 9);


-- Sipariþ oluþturma
DECLARE @musteriId INT, @maxMusteriId INT;
DECLARE @urunId INT, @stok INT, @adet INT, @fiyat DECIMAL(10,2);
DECLARE @toplam_tutar DECIMAL(10,2), @siparisId INT;
DECLARE @alinanUrunSayisi INT;

-- Rastgele ödeme türü seç
DECLARE @odeme NVARCHAR(20);
SET @odeme = CASE CAST(RAND(CHECKSUM(NEWID())) * 3 + 1 AS INT)
                WHEN 1 THEN N'Nakit'
                WHEN 2 THEN N'Kredi Kartý'
                WHEN 3 THEN N'Kapýda Ödeme'
             END;

SET @musteriId = (SELECT MIN(id) FROM Musteri);
SET @maxMusteriId = (SELECT MAX(id) FROM Musteri);

WHILE @musteriId <= @maxMusteriId
BEGIN
    -- Eðer stok bitmiþse çýk
    IF NOT EXISTS (SELECT 1 FROM Urun WHERE stok > 0 AND fiyat > 0)
        BREAK;

    -- Bu müþteri daha önce kaç ürün aldý?
    SET @alinanUrunSayisi = ISNULL(
        (SELECT SUM(adet)
         FROM Siparis_Detay sd
         JOIN Siparis s ON sd.siparis_id = s.id
         WHERE s.musteri_id = @musteriId),
        0
    );

    -- Eðer müþteri zaten 2 ürün aldýysa geç
    IF @alinanUrunSayisi >= 4
    BEGIN
        SET @musteriId += 1;
        CONTINUE;
    END

    -- Yeni sipariþ oluþtur
    INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu)
    VALUES (@musteriId, 0, @odeme);

    SET @siparisId = SCOPE_IDENTITY();
    SET @toplam_tutar = 0;

    -- Geçici tablo: bu sipariþte alýnan ürünler
    DECLARE @SecilenUrunler TABLE (urun_id INT PRIMARY KEY);

    WHILE @alinanUrunSayisi < 2
    BEGIN
        -- Rastgele stokta olan ürün seç (daha önce alýnmamýþ)
        SELECT TOP 1 @urunId = id, @stok = stok, @fiyat = fiyat
        FROM Urun
        WHERE stok > 0 AND fiyat > 0
          AND id NOT IN (SELECT urun_id FROM @SecilenUrunler)
        ORDER BY NEWID();

        IF @urunId IS NULL BREAK;

        -- Seçilen ürünü listeye ekle
        INSERT INTO @SecilenUrunler VALUES (@urunId);

        -- stok 1 ise sadece 1 adet alýnabilir
        IF @stok = 1
            SET @adet = 1;
        ELSE
            SET @adet = (SELECT CAST(RAND(CHECKSUM(NEWID())) * 2 + 1 AS INT)); -- 1-2

        -- stok yetmiyorsa bu ürünü atla
        IF @stok < @adet
            CONTINUE;

        -- Eðer toplam alým 2'yi geçerse dur
        IF @alinanUrunSayisi + @adet > 4
            SET @adet = 4 - @alinanUrunSayisi;

        -- Sipariþ detayýna ekle
        INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
        VALUES (@siparisId, @urunId, @adet, @fiyat);

        -- Stoktan düþ
        UPDATE Urun
        SET stok = stok - @adet
        WHERE id = @urunId;

        SET @toplam_tutar += @adet * @fiyat;
        SET @alinanUrunSayisi += @adet;

        -- Eðer müþteri 2 ürüne ulaþtýysa çýk
        IF @alinanUrunSayisi >= 2
            BREAK;
    END

    -- Sipariþ boþsa sil, doluysa güncelle
    IF @toplam_tutar = 0
        DELETE FROM Siparis WHERE id = @siparisId;
    ELSE
        UPDATE Siparis SET toplam_tutar = @toplam_tutar WHERE id = @siparisId;

    SET @musteriId += 1;
END;
GO


--Sipariþ tarihlerini müþterinin kayýt tarihinden sonraki rastgele günlere ata
UPDATE s
SET s.tarih = DATEADD(
    DAY,
    v.rnd,
    m.kayit_tarihi
)
FROM Siparis s
JOIN Musteri m ON s.musteri_id = m.id
CROSS APPLY (
    SELECT ABS(CHECKSUM(NEWID())) % 
           (DATEDIFF(DAY, m.kayit_tarihi, GETDATE()) + 1) AS rnd
) v;



--------------------- RAPORLAMA SORGULARI ---------------------


-- Örnek müþterileri listele
SELECT TOP 10 id, ad, soyad, email, sehir, kayit_tarihi
FROM Musteri;

-- Örnek ürünleri listele
SELECT TOP 10 id, ad, fiyat, stok, kategori_id, satici_id
FROM Urun;

-- Örnek sipariþleri listele
;WITH TekSiparis AS (
    SELECT 
        s.id AS SiparisID,
        m.id AS MusteriID,
        m.ad + ' ' + m.soyad AS Musteri,
        s.toplam_tutar,
        s.odeme_turu,
        s.tarih,
        ROW_NUMBER() OVER (PARTITION BY m.id ORDER BY NEWID()) AS rn
    FROM Siparis s
    JOIN Musteri m ON s.musteri_id = m.id
)
SELECT TOP 10
    t.SiparisID,
    t.Musteri,
    sd.adet,
    sd.fiyat,
    u.ad AS UrunAdi,
    t.odeme_turu,
    t.tarih
FROM TekSiparis t
JOIN Siparis_Detay sd ON t.SiparisID = sd.siparis_id
JOIN Urun u ON sd.urun_id = u.id
WHERE t.rn = 1
GROUP BY 
    t.SiparisID, t.Musteri, sd.adet, sd.fiyat, u.ad, t.odeme_turu, t.tarih
ORDER BY NEWID();

-- Hiç sipariþ vermemiþ müþteriler
SELECT m.id, m.ad, m.soyad, m.email, m.sehir
FROM Musteri m
LEFT JOIN Siparis s ON m.id = s.musteri_id
WHERE s.id IS NULL;

-- Hiç satýlmamýþ ürünler
SELECT u.id, u.ad, u.fiyat, u.stok
FROM Urun u
LEFT JOIN Siparis_Detay sd ON u.id = sd.urun_id
WHERE sd.id IS NULL;

-- En çok sipariþ veren 5 müþteri
SELECT TOP 5 
    m.id AS MusteriID,
    m.ad AS MusteriAdi, 
    SUM(sd.adet) AS ToplamUrun
FROM Musteri m
JOIN Siparis s ON m.id = s.musteri_id
JOIN Siparis_Detay sd ON s.id = sd.siparis_id
GROUP BY m.id, m.ad
ORDER BY ToplamUrun DESC;

-- En çok satýlan ürünler
SELECT u.ad AS Urun, SUM(sd.adet) AS ToplamSatis
FROM Siparis_Detay sd
JOIN Urun u ON u.id = sd.urun_id
GROUP BY u.ad
ORDER BY ToplamSatis DESC;

-- En yüksek ciroya sahip satýcýlar
SELECT s.ad AS Satici, SUM(sd.adet * sd.fiyat) AS Ciro
FROM Satici s
JOIN Urun u ON u.satici_id = s.id
JOIN Siparis_Detay sd ON sd.urun_id = u.id
GROUP BY s.ad
ORDER BY Ciro DESC;

-- Þehirlere göre müþteri sayýsý
SELECT sehir, COUNT(*) AS MusteriSayisi
FROM Musteri
GROUP BY sehir
ORDER BY MusteriSayisi DESC;

-- Kategori bazlý toplam satýþ
SELECT k.ad AS Kategori, SUM(sd.adet * sd.fiyat) AS ToplamSatis
FROM Kategori k
JOIN Urun u ON u.kategori_id = k.id
JOIN Siparis_Detay sd ON sd.urun_id = u.id
GROUP BY k.ad
ORDER BY ToplamSatis DESC;

-- Aylara göre sipariþ sayýsý
SELECT YEAR(tarih) AS Yil, FORMAT(tarih, 'MMMM', 'tr-TR') AS AyAdi, COUNT(*) AS SiparisSayisi
FROM Siparis
GROUP BY YEAR(tarih), FORMAT(tarih, 'MMMM', 'tr-TR')
ORDER BY Yil, MIN(MONTH(tarih));

-- Ortalama sipariþ tutarýný geçen sipariþler
SELECT s.id AS SiparisNo, m.ad + ' ' + m.soyad AS Musteri, s.toplam_tutar
FROM Siparis s
JOIN Musteri m ON m.id = s.musteri_id
WHERE s.toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis);

-- En az bir kere elektronik ürün alan müþteriler
SELECT DISTINCT m.ad + ' ' + m.soyad AS Musteri
FROM Musteri m
JOIN Siparis s ON m.id = s.musteri_id
JOIN Siparis_Detay sd ON s.id = sd.siparis_id
JOIN Urun u ON u.id = sd.urun_id
JOIN Kategori k ON k.id = u.kategori_id
WHERE k.ad = 'Elektronik';

--En çok kazanç saðlayan 3 kategori
SELECT TOP 3 k.ad AS Kategori, SUM(sd.adet * sd.fiyat) AS Kazanc
FROM Kategori k
JOIN Urun u ON u.kategori_id = k.id
JOIN Siparis_Detay sd ON sd.urun_id = u.id
GROUP BY k.ad
ORDER BY Kazanc DESC;





--------------------- ekleme,çýkarma,güncelleme ---------------------

UPDATE Urun SET stok = stok - 1 WHERE id = 1;
DELETE FROM Urun WHERE id = 2;
TRUNCATE TABLE Siparis_Detay;

--------------------- TÜM PROJEYÝ RESETLEME ---------------------



--Detaylardan sil
DELETE FROM Siparis_Detay;
DBCC CHECKIDENT ('Siparis_Detay', RESEED, 0);

-- Sipariþlerden sil
DELETE FROM Siparis;
DBCC CHECKIDENT ('Siparis', RESEED, 0);

-- Ürünlerden sil
DELETE FROM Urun;
DBCC CHECKIDENT ('Urun', RESEED, 0);

-- Müþterilerden sil
DELETE FROM Musteri;
DBCC CHECKIDENT ('Musteri', RESEED, 0);

-- Kategorilerden sil
DELETE FROM Kategori;
DBCC CHECKIDENT ('Kategori', RESEED, 0);

-- Satýcýlardan sil 
DELETE FROM Satici;
DBCC CHECKIDENT ('Satici', RESEED, 0);

