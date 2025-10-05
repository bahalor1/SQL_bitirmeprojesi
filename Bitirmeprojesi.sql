--------------------- TABLOLAR ---------------------

--M��teri tablosu 
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

--Sat�c� tablosu 
CREATE TABLE Satici(
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(100) NOT NULL,
  adres NVARCHAR(200)
);

--�r�n tablosu 
CREATE TABLE Urun(
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(100) NOT NULL,
  fiyat DECIMAL(10,2) NOT NULL,
  stok INT NOT NULL,
  kategori_id INT FOREIGN KEY REFERENCES Kategori(id),
  satici_id INT FOREIGN KEY REFERENCES Satici(id)
);

--Sipari� tablosu 
CREATE TABLE Siparis(
  id INT IDENTITY(1,1) PRIMARY KEY,
  musteri_id INT FOREIGN KEY REFERENCES Musteri(id),
  tarih DATETIME DEFAULT GETDATE(),
  toplam_tutar DECIMAL(10,2),
  odeme_turu NVARCHAR(20)
);

--Sipari� Detay tablosu
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

    -- Yeni eklenen sipari� detay�ndaki �r�n ve adet bilgilerini al
    SELECT @urunId = urun_id, @adet = adet FROM inserted;

    -- �r�n�n mevcut stok miktar�n� al
    SELECT @stok = stok, @urunAdi =ad FROM Urun WHERE id = @urunId;

    -- E�er stok yetersizse i�lemi iptal et
    IF @stok < @adet
    BEGIN
        DECLARE @msg NVARCHAR(200);
        SET @msg = N'Yetersiz stok! "' + @urunAdi + N'" �r�n�nden daha fazla sat�n al�namaz.';
        RAISERROR(@msg, 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Stoktan d��
    UPDATE Urun
    SET stok = stok - @adet
    WHERE id = @urunId;
END;
GO


--------------------- �R�N,SATICI,M��TER� B�LG�LER� BASTIRMA ---------------------



--Kategoriler 
INSERT INTO Kategori (ad) VALUES 
('Elektronik'),
('Giyim'),
('Kitap'),
('Spor & Outdoor'),
('Ev & Ya�am'),
('Ofis & K�rtasiye'),
('Oyuncak'),
('Kozmetik'),
('Hobi & Sanat'),
('Mutfak');

--Sat�c�lar 
INSERT INTO Satici (ad, adres) VALUES
('TeknoSat', '�stanbul'),
('ModaCenter', 'Ankara'),
('KitapYurdu', '�zmir'),
('SporMarket', 'Bursa'),
('EvTrend', 'Antalya'),
('OfisDepo', 'Eski�ehir'),
('OyuncakD�nyas�', 'Gaziantep'),
('G�zellikShop', 'Adana'),
('HobiSanat', 'Konya'),
('MutfakMarket', 'Trabzon');

--M��teriler 
INSERT INTO Musteri (ad, soyad, email, sehir) VALUES
('Deniz', 'Kaya', 'deniz.kaya@example.com', 'X'),
('Elif', '�elik', 'elif.celik@example.com', 'X'),
('Murat', 'Y�ld�r�m', 'murat.yildirim@example.com', 'X'),
('Zeynep', 'Demir', 'zeynep.demir@example.com', 'X'),
('Burak', '�ahin', 'burak.sahin@example.com', 'X'),
('Selin', 'Kurt', 'selin.kurt@example.com', 'X'),
('Emre', 'Acar', 'emre.acar@example.com', 'X'),
('Gamze', '�zt�rk', 'gamze.ozturk@example.com', 'X'),
('Tolga', 'Kaplan', 'tolga.kaplan@example.com', 'X'),
('Derya', 'Polat', 'derya.polat@example.com', 'X'),
('Caner', 'Y�lmaz', 'caner.yilmaz@example.com', 'X'),
('H�lya', 'Yavuz', 'hulya.yavuz@example.com', 'X'),
('Kerem', 'Do�an', 'kerem.dogan@example.com', 'X'),
('Nazl�', 'Ko�', 'nazli.koc@example.com', 'X'),
('O�uz', 'Erdo�an', 'oguz.erdogan@example.com', 'X'),
('Seda', 'Aslan', 'seda.aslan@example.com', 'X'),
('Tuna', '�ak�r', 'tuna.cakir@example.com', 'X'),
('Esra', 'Kurtulu�', 'esra.kurtulus@example.com', 'X'),
('Hakan', '�zdemir', 'hakan.ozdemir@example.com', 'X'),
('Pelin', 'Kara', 'pelin.kara@example.com', 'X'),
('Bar��', 'G�ne�', 'baris.gunes@example.com', 'X'),
('�pek', 'Arslan', 'ipek.arslan@example.com', 'X'),
('Efe', 'Din�', 'efe.dinc@example.com', 'X'),
('Serap', 'Ta�', 'serap.tas@example.com', 'X'),
('Cem', '�en', 'cem.sen@example.com', 'X'),
('Merve', 'Sezer', 'merve.sezer@example.com', 'X'),
('Kaan', 'Bulut', 'kaan.bulut@example.com', 'X'),
('Eda', 'Ba�ar', 'eda.basar@example.com', 'X'),
('Volkan', 'Ko�ar', 'volkan.kosar@example.com', 'X'),
('Nil', '�etin', 'nil.cetin@example.com', 'X'),
('Ufuk', 'Balc�', 'ufuk.balci@example.com', 'X'),
('Sibel', 'Aksoy', 'sibel.aksoy@example.com', 'X'),
('Alper', 'Y�ld�z', 'alper.yildiz@example.com', 'X'),
('Deniz', 'Bozkurt', 'deniz.bozkurt@example.com', 'X'),
('Sevgi', 'Karaaslan', 'sevgi.karaaslan@example.com', 'X'),
('Onur', 'K�ksal', 'onur.koksal@example.com', 'X'),
('Buse', 'G�l', 'buse.gul@example.com', 'X'),
('Harun', 'S�nmez', 'harun.sonmez@example.com', 'X'),
('Figen', 'Turan', 'figen.turan@example.com', 'X'),
('Tolunay', 'K�l��', 'tolunay.kilic@example.com', 'X'),
('Deniz', 'Ar�kan', 'deniz.arikan@example.com', 'X'),
('�ule', '�zkan', 'sule.ozkan@example.com', 'X'),
('Kadir', 'Toprak', 'kadir.toprak@example.com', 'X'),
('Necla', 'Ate�', 'necla.ates@example.com', 'X'),
('Metin', 'Yurt', 'metin.yurt@example.com', 'X'),
('Sevil', 'Ba�', 'sevil.bas@example.com', 'X'),
('Aylin', '�eker', 'aylin.seker@example.com', 'X'),
('Ahmet', 'Tuna', 'ahmet.tuna@example.com', 'X'),
('Nihat', '�olak', 'nihat.colak@example.com', 'X'),
('Bora', '�etin', 'bora.cetin@example.com', 'X'),
('Ferhat', '�zer', 'ferhat.ozer@example.com', 'X'),
('H�seyin', 'Durmaz', 'huseyin.durmaz@example.com', 'X'),
('Ay�a', 'Karaca', 'ayca.karaca@example.com', 'X'),
('�irin', 'Duman', 'sirin.duman@example.com', 'X'),
('Ceyda', 'Tun�', 'ceyda.tunc@example.com', 'X'),
('Fatih', 'Eren', 'fatih.eren@example.com', 'X'),
('Berk', '�nal', 'berk.onal@example.com', 'X'),
('Sevda', 'K�l��', 'sevda.kilic@example.com', 'X'),
('Tu��e', 'Sar�', 'tugce.sari@example.com', 'X'),
('Ali', 'Kurt', 'ali.kurt@example.com', 'X'),
('Zehra', 'Ta���', 'zehra.tasci@example.com', 'X'),
('Orhan', 'Korkmaz', 'orhan.korkmaz@example.com', 'X'),
('Binnaz', 'G�ler', 'binnaz.guler@example.com', 'X'),
('Sel�uk', '�al��kan', 'selcuk.caliskan@example.com', 'X'),
('Asl�', 'Sevim', 'asli.sevim@example.com', 'X'),
('Gizem', 'Ayd�n', 'gizem.aydin@example.com', 'X'),
('Okan', 'Karaman', 'okan.karaman@example.com', 'X'),
('Yusuf', 'Demirta�', 'yusuf.demirtas@example.com', 'X'),
('Arda', 'Ekinci', 'arda.ekinci@example.com', 'X'),
('Se�il', 'Bozkaya', 'secil.bozkaya@example.com', 'X'),
('Melis', '�zer', 'melis.ozer@example.com', 'X'),
('�smail', 'T�rkmen', 'ismail.turkmen@example.com', 'X'),
('�ahin', 'Bayram', 'sahin.bayram@example.com', 'X'),
('Rabia', 'Altun', 'rabia.altun@example.com', 'X'),
('Ayd�n', 'Tuna', 'aydin.tuna@example.com', 'X'),
('G�khan', 'Ersoy', 'gokhan.ersoy@example.com', 'X'),
('Ebru', 'Sevimli', 'ebru.sevimli@example.com', 'X'),
('�rem', 'Ko�', 'irem.koc@example.com', 'X'),
('Emir', 'Demir', 'emir.demir@example.com', 'X'),
('Selin', 'Ayd�n', 'selin.aydin@example.com', 'X'),
('Bora', 'Korkmaz', 'bora.korkmaz@example.com', 'X'),
('Asya', 'Kaya', 'asya.kaya@example.com', 'X'),
('Efe', '�ahin', 'efe.sahin@example.com', 'X'),
('Deniz', 'Arslan', 'deniz.arslan@example.com', 'X'),
('�pek', 'Ko�', 'ipek.koc@example.com', 'X'),
('Kerem', '�elik', 'kerem.celik@example.com', 'X'),
('Mert', 'Polat', 'mert.polat@example.com', 'X'),
('Yasemin', '�zt�rk', 'yasemin.ozturk@example.com', 'X'),
('Arda', 'G�ne�', 'arda.gunes@example.com', 'X'),
('Gamze', 'Y�ld�z', 'gamze.yildiz@example.com', 'X'),
('Tolga', 'Demirta�', 'tolga.demirtas@example.com', 'X'),
('Seda', 'Kara', 'seda.kara@example.com', 'X'),
('Kaan', 'Bayraktar', 'kaan.bayraktar@example.com', 'X'),
('Ay�e', 'Do�an', 'ayse.dogan@example.com', 'X'),
('Melis', 'Aksoy', 'melis.aksoy@example.com', 'X'),
('Burak', '�zer', 'burak.ozer@example.com', 'X'),
('Ezgi', '��nar', 'ezgi.cinar@example.com', 'X'),
('Can', 'Erdo�an', 'can.erdogan@example.com', 'X'),
('Zeynep', '�olak', 'zeynep.colak@example.com', 'X'),
('Onur', 'Sezer', 'onur.sezer@example.com', 'X');

--�lleri rastgele atama
DECLARE @Iller TABLE (sehir NVARCHAR(50));
INSERT INTO @Iller (sehir) VALUES
(N'Adana'),(N'Ad�yaman'),(N'Afyonkarahisar'),(N'A�r�'),(N'Amasya'),
(N'Ankara'),(N'Antalya'),(N'Artvin'),(N'Ayd�n'),(N'Bal�kesir'),
(N'Bilecik'),(N'Bing�l'),(N'Bitlis'),(N'Bolu'),(N'Burdur'),
(N'Bursa'),(N'�anakkale'),(N'�ank�r�'),(N'�orum'),(N'Denizli'),
(N'Diyarbak�r'),(N'Edirne'),(N'Elaz��'),(N'Erzincan'),(N'Erzurum'),
(N'Eski�ehir'),(N'Gaziantep'),(N'Giresun'),(N'G�m��hane'),(N'Hakkari'),
(N'Hatay'),(N'Isparta'),(N'Mersin'),(N'�stanbul'),(N'�zmir'),
(N'Kars'),(N'Kastamonu'),(N'Kayseri'),(N'K�rklareli'),(N'K�r�ehir'),
(N'Kocaeli'),(N'Konya'),(N'K�tahya'),(N'Malatya'),(N'Manisa'),
(N'Kahramanmara�'),(N'Mardin'),(N'Mu�la'),(N'Mu�'),(N'Nev�ehir'),
(N'Ni�de'),(N'Ordu'),(N'Rize'),(N'Sakarya'),(N'Samsun'),
(N'Siirt'),(N'Sinop'),(N'Sivas'),(N'Tekirda�'),(N'Tokat'),
(N'Trabzon'),(N'Tunceli'),(N'�anl�urfa'),(N'U�ak'),(N'Van'),
(N'Yozgat'),(N'Zonguldak'),(N'Aksaray'),(N'Bayburt'),(N'Karaman'),
(N'K�r�kkale'),(N'Batman'),(N'��rnak'),(N'Bart�n'),(N'Ardahan'),
(N'I�d�r'),(N'Yalova'),(N'Karab�k'),(N'Kilis'),(N'Osmaniye'),
(N'D�zce');

-- Her m��teriye farkl� random �ehir ata
DECLARE @minId2 INT, @maxId2 INT, @id INT;
DECLARE @sehir NVARCHAR(50);

SET @minId2 = (SELECT MIN(id) FROM Musteri);
SET @maxId2 = (SELECT MAX(id) FROM Musteri);
SET @id = @minId2;

WHILE @id <= @maxId2
BEGIN
    -- Her m��teri i�in 1 random �ehir �ek
    SELECT TOP 1 @sehir = sehir
    FROM @Iller
    ORDER BY NEWID();

    -- O m��teriye �ehir ata
    UPDATE Musteri
    SET sehir = @sehir
    WHERE id = @id;

    -- Sonraki m��teriye ge�
    SET @id = @id + 1;
END;

--Kay�t tarihi rastgele atama
UPDATE Musteri
SET kayit_tarihi = DATEADD(
    DAY, 
    -1 * (ABS(CHECKSUM(NEWID())) % (365 * 3)), 
    GETDATE()
);

--�r�nler 
INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES
('Telefon', 15000, 4, 1, 1),
('Kulakl�k', 1200, 20, 1, 1),
('Tablet', 8000, 10, 1, 1),
('Televizyon', 25000, 4, 1, 1),
('Ti��rt', 200, 12, 2, 2),
('Mont', 900, 10, 2, 2),
('Ayakkab�', 1200, 10, 2, 2),
('Kot Pantolon', 600, 10, 2, 2),
('Roman', 80, 20, 3, 3),
('Ansiklopedi', 300, 25, 3, 3),
('Bilim Kurgu Roman�', 150, 10, 3, 3),
('�iir Kitab�', 90, 5, 3, 3),
('Futbol Topu', 400, 10, 4, 4),
('Kamp �ad�r�', 2500, 10, 4, 4),
('Dumbbell Seti', 1200, 10, 4, 4),
('Yoga Mat�', 200, 10, 4, 4),
('Masa Lambas�', 350, 10, 5, 5),
('Defter', 20, 100, 5, 5),
('Dolma Kalem', 120, 20, 5, 5),
('Masa Sandalye Tak�m�', 2000, 5, 5, 5),
('Oyuncak Araba', 150, 55, 6, 6),
('Puzzle Seti', 300, 15, 6, 6),
('LEGO Seti', 800, 10, 6, 6),
('Bebek Oyunca��', 100, 10, 6, 6),
('Parf�m', 700, 40, 7, 7),
('Ruj', 150, 40, 7, 7),
('Fond�ten', 250, 40, 7, 7),
('G�z Far� Paleti', 300, 40, 7, 7),
('Sulu Boya Seti', 100, 40, 8, 8),
('Kanvas Tuvali', 80, 50, 8, 8),
('Ya�l� Boya F�r�as�', 60, 10, 8, 8),
('Maket B��a��', 40, 50, 8, 8),
('Tencere Seti', 1200, 10, 9, 9),
('B��ak Tak�m�', 600, 10, 9, 9),
('Tabak Seti', 800, 10, 9, 9),
('�atal Ka��k Seti', 400, 5, 9, 9);


-- Sipari� olu�turma
DECLARE @musteriId INT, @maxMusteriId INT;
DECLARE @urunId INT, @stok INT, @adet INT, @fiyat DECIMAL(10,2);
DECLARE @toplam_tutar DECIMAL(10,2), @siparisId INT;
DECLARE @alinanUrunSayisi INT;

-- Rastgele �deme t�r� se�
DECLARE @odeme NVARCHAR(20);
SET @odeme = CASE CAST(RAND(CHECKSUM(NEWID())) * 3 + 1 AS INT)
                WHEN 1 THEN N'Nakit'
                WHEN 2 THEN N'Kredi Kart�'
                WHEN 3 THEN N'Kap�da �deme'
             END;

SET @musteriId = (SELECT MIN(id) FROM Musteri);
SET @maxMusteriId = (SELECT MAX(id) FROM Musteri);

WHILE @musteriId <= @maxMusteriId
BEGIN
    -- E�er stok bitmi�se ��k
    IF NOT EXISTS (SELECT 1 FROM Urun WHERE stok > 0 AND fiyat > 0)
        BREAK;

    -- Bu m��teri daha �nce ka� �r�n ald�?
    SET @alinanUrunSayisi = ISNULL(
        (SELECT SUM(adet)
         FROM Siparis_Detay sd
         JOIN Siparis s ON sd.siparis_id = s.id
         WHERE s.musteri_id = @musteriId),
        0
    );

    -- E�er m��teri zaten 2 �r�n ald�ysa ge�
    IF @alinanUrunSayisi >= 4
    BEGIN
        SET @musteriId += 1;
        CONTINUE;
    END

    -- Yeni sipari� olu�tur
    INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu)
    VALUES (@musteriId, 0, @odeme);

    SET @siparisId = SCOPE_IDENTITY();
    SET @toplam_tutar = 0;

    -- Ge�ici tablo: bu sipari�te al�nan �r�nler
    DECLARE @SecilenUrunler TABLE (urun_id INT PRIMARY KEY);

    WHILE @alinanUrunSayisi < 2
    BEGIN
        -- Rastgele stokta olan �r�n se� (daha �nce al�nmam��)
        SELECT TOP 1 @urunId = id, @stok = stok, @fiyat = fiyat
        FROM Urun
        WHERE stok > 0 AND fiyat > 0
          AND id NOT IN (SELECT urun_id FROM @SecilenUrunler)
        ORDER BY NEWID();

        IF @urunId IS NULL BREAK;

        -- Se�ilen �r�n� listeye ekle
        INSERT INTO @SecilenUrunler VALUES (@urunId);

        -- stok 1 ise sadece 1 adet al�nabilir
        IF @stok = 1
            SET @adet = 1;
        ELSE
            SET @adet = (SELECT CAST(RAND(CHECKSUM(NEWID())) * 2 + 1 AS INT)); -- 1-2

        -- stok yetmiyorsa bu �r�n� atla
        IF @stok < @adet
            CONTINUE;

        -- E�er toplam al�m 2'yi ge�erse dur
        IF @alinanUrunSayisi + @adet > 4
            SET @adet = 4 - @alinanUrunSayisi;

        -- Sipari� detay�na ekle
        INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
        VALUES (@siparisId, @urunId, @adet, @fiyat);

        -- Stoktan d��
        UPDATE Urun
        SET stok = stok - @adet
        WHERE id = @urunId;

        SET @toplam_tutar += @adet * @fiyat;
        SET @alinanUrunSayisi += @adet;

        -- E�er m��teri 2 �r�ne ula�t�ysa ��k
        IF @alinanUrunSayisi >= 2
            BREAK;
    END

    -- Sipari� bo�sa sil, doluysa g�ncelle
    IF @toplam_tutar = 0
        DELETE FROM Siparis WHERE id = @siparisId;
    ELSE
        UPDATE Siparis SET toplam_tutar = @toplam_tutar WHERE id = @siparisId;

    SET @musteriId += 1;
END;
GO


--Sipari� tarihlerini m��terinin kay�t tarihinden sonraki rastgele g�nlere ata
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


-- �rnek m��terileri listele
SELECT TOP 10 id, ad, soyad, email, sehir, kayit_tarihi
FROM Musteri;

-- �rnek �r�nleri listele
SELECT TOP 10 id, ad, fiyat, stok, kategori_id, satici_id
FROM Urun;

-- �rnek sipari�leri listele
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

-- Hi� sipari� vermemi� m��teriler
SELECT m.id, m.ad, m.soyad, m.email, m.sehir
FROM Musteri m
LEFT JOIN Siparis s ON m.id = s.musteri_id
WHERE s.id IS NULL;

-- Hi� sat�lmam�� �r�nler
SELECT u.id, u.ad, u.fiyat, u.stok
FROM Urun u
LEFT JOIN Siparis_Detay sd ON u.id = sd.urun_id
WHERE sd.id IS NULL;

-- En �ok sipari� veren 5 m��teri
SELECT TOP 5 
    m.id AS MusteriID,
    m.ad AS MusteriAdi, 
    SUM(sd.adet) AS ToplamUrun
FROM Musteri m
JOIN Siparis s ON m.id = s.musteri_id
JOIN Siparis_Detay sd ON s.id = sd.siparis_id
GROUP BY m.id, m.ad
ORDER BY ToplamUrun DESC;

-- En �ok sat�lan �r�nler
SELECT u.ad AS Urun, SUM(sd.adet) AS ToplamSatis
FROM Siparis_Detay sd
JOIN Urun u ON u.id = sd.urun_id
GROUP BY u.ad
ORDER BY ToplamSatis DESC;

-- En y�ksek ciroya sahip sat�c�lar
SELECT s.ad AS Satici, SUM(sd.adet * sd.fiyat) AS Ciro
FROM Satici s
JOIN Urun u ON u.satici_id = s.id
JOIN Siparis_Detay sd ON sd.urun_id = u.id
GROUP BY s.ad
ORDER BY Ciro DESC;

-- �ehirlere g�re m��teri say�s�
SELECT sehir, COUNT(*) AS MusteriSayisi
FROM Musteri
GROUP BY sehir
ORDER BY MusteriSayisi DESC;

-- Kategori bazl� toplam sat��
SELECT k.ad AS Kategori, SUM(sd.adet * sd.fiyat) AS ToplamSatis
FROM Kategori k
JOIN Urun u ON u.kategori_id = k.id
JOIN Siparis_Detay sd ON sd.urun_id = u.id
GROUP BY k.ad
ORDER BY ToplamSatis DESC;

-- Aylara g�re sipari� say�s�
SELECT YEAR(tarih) AS Yil, FORMAT(tarih, 'MMMM', 'tr-TR') AS AyAdi, COUNT(*) AS SiparisSayisi
FROM Siparis
GROUP BY YEAR(tarih), FORMAT(tarih, 'MMMM', 'tr-TR')
ORDER BY Yil, MIN(MONTH(tarih));

-- Ortalama sipari� tutar�n� ge�en sipari�ler
SELECT s.id AS SiparisNo, m.ad + ' ' + m.soyad AS Musteri, s.toplam_tutar
FROM Siparis s
JOIN Musteri m ON m.id = s.musteri_id
WHERE s.toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis);

-- En az bir kere elektronik �r�n alan m��teriler
SELECT DISTINCT m.ad + ' ' + m.soyad AS Musteri
FROM Musteri m
JOIN Siparis s ON m.id = s.musteri_id
JOIN Siparis_Detay sd ON s.id = sd.siparis_id
JOIN Urun u ON u.id = sd.urun_id
JOIN Kategori k ON k.id = u.kategori_id
WHERE k.ad = 'Elektronik';

--En �ok kazan� sa�layan 3 kategori
SELECT TOP 3 k.ad AS Kategori, SUM(sd.adet * sd.fiyat) AS Kazanc
FROM Kategori k
JOIN Urun u ON u.kategori_id = k.id
JOIN Siparis_Detay sd ON sd.urun_id = u.id
GROUP BY k.ad
ORDER BY Kazanc DESC;





--------------------- ekleme,��karma,g�ncelleme ---------------------

UPDATE Urun SET stok = stok - 1 WHERE id = 1;
DELETE FROM Urun WHERE id = 2;
TRUNCATE TABLE Siparis_Detay;

--------------------- T�M PROJEY� RESETLEME ---------------------



--Detaylardan sil
DELETE FROM Siparis_Detay;
DBCC CHECKIDENT ('Siparis_Detay', RESEED, 0);

-- Sipari�lerden sil
DELETE FROM Siparis;
DBCC CHECKIDENT ('Siparis', RESEED, 0);

-- �r�nlerden sil
DELETE FROM Urun;
DBCC CHECKIDENT ('Urun', RESEED, 0);

-- M��terilerden sil
DELETE FROM Musteri;
DBCC CHECKIDENT ('Musteri', RESEED, 0);

-- Kategorilerden sil
DELETE FROM Kategori;
DBCC CHECKIDENT ('Kategori', RESEED, 0);

-- Sat�c�lardan sil 
DELETE FROM Satici;
DBCC CHECKIDENT ('Satici', RESEED, 0);

