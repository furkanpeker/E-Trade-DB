/* Kendisinden verilen toplam sipariş miktarı 5'ten fazla olan ürünlerin ürün kodu ve verilen toplam sipariş miktarını listeleyen sorgu: */
select U.urun_id as urun_kodu, sum(S.miktar) as toplam_Siparis_Miktari
from [Urun-SiparisDetay] US
join Urunler U on US.urun_id=U.urun_id
join SiparisDetay S on US.siparisDetay_id=S.siparisDetay_id
group by U.urun_id having sum(S.miktar) > 5


/* Ürün ID si 3 ve 4 olanları, aynı zamanda 5 ve 6 olanları azalan olarak sıralayıp ve birleştirip getiren sorgu:  */
select a.urun_id
from
(
    select top 10 urun_id 
    from Urunler
    where urun_id in(3, 4)
    order by urun_adi desc
) a
union
select b.urun_id
from
(
    select top 10 urun_id 
    from Urunler
    where urun_id in(5, 6)
    order by urun_adi desc
) b


/* 2021 yılında ya da her hangi bir yılın 12'nci ayında sipariş veren üyeleri ve bu üyelerin siparişlerinin toplam ne kadar tuttuğunu veren sorgu:  */
select U.uye_ad + ' ' + U.uye_soyad as [Üyenin Ad ve Soyadı], S.toplamTutar 
from Siparisler S, Uyeler U 
where U.uye_id = S.uye_id and (year(S.siparis_tarihi) = 2021 or MONTH(S.siparis_tarihi)=12)

/* 2021 yılında sipariş veren müşterilerin id lerini ve telefonlarını listeleyen sorgu:  */
select M.musteri_id [musteri_id], M.telefonNO telefon 
from Siparisler S inner join Musteri M
on S.musteri_id = M.musteri_id
where year(S.siparis_tarihi) = 2021

/* 2021 yılında id si 9 olan üyenin adının ilk harfini, verdiği siparişin id sini ve bu üyenin vermiş olduğu siparişin ödeme şeklini listeleyen sorgu: */
select left(U.uye_ad, 1) [Üye adı baş harfi], S.siparis_id [sipariş id], O.odeme_turu [Odeme şekli] 
from Siparisler S
full join Uyeler U on S.uye_id = U.uye_id
inner join Odemeler O on S.odeme_id = O.odeme_id
where U.uye_id = 9 and datepart(year, S.siparis_tarihi) = 2021

/* Siparişler tablosu ile müşteri tablosunun birleşimini veren sorgu: */
select * from Siparisler AS S JOIN Musteri AS M
ON S.musteri_id = M.musteri_id
ORDER BY S.siparis_tarihi DESC

/* Müşteri adına göre azalan sırada; müşteri adını ve o müşterinin verdiği siparişleri listeleyen sorgu: */
select M.sirket_ad [Müşteri şirkertin adı], S.siparis_id
from Musteri M left join Siparisler S
on S.musteri_id = M.musteri_id
order by M.sirket_ad

/* İsminde 't' geçen bir kargo şirketinin  siparişlerinin verildiği adresin metni ve müşterisinin adını veren sorgu: */
select A.adres_metni, M.sirket_ad [Müşteri Adı]
from Siparisler S
join KargoSirketi KS on KS.kargoSirketi_id = S.kargoSirketi_id
join Adresler as A on A.adres_id = S.adres_id
join Musteri M on M.musteri_id = S.musteri_id
where KS.sirketAd = '%t%'

/* 2021 yılında en pahalı siparişi veren üyenin adı ve soyadını ve verdiği siparişin toplam tutarını veren sorgu: */
select top 1 U.uye_ad, U.uye_soyad, S.toplamTutar                                                                                                                                      
from Siparisler S
join Uyeler U on U.uye_id = S.uye_id
order by S.toplamTutar desc

/* Bir siparişin; sipariş id, o siparişi veren müşterinin (şirket) adını ve verildiği yılı veren sorgu: */
select S.siparis_id, M.sirket_ad, year(S.siparis_tarihi) [Sipariş Yılı] from Siparisler as S, Musteri as M
where S.musteri_id = M.musteri_id 
order by S.siparis_tarihi desc

/* Hangi müşteriler ve hangi üyeler hangi yılda sipariş vermiş? bunu veren sorgu: */
select year(S.siparis_tarihi) [Sipariş Yılı], M.sirket_ad, U.uye_ad + ' ' + U.uye_soyad [uye ad-soyad]
from Siparisler S
Right Join Musteri M on S.musteri_id = M.musteri_id
Right Join Uyeler U on S.uye_id = U.uye_id

/* Ayın 1.gününde sipariş veren müşterilerin hangi şehirde yaşadığını gösteren sorgu: */
select S.musteri_id [Müşteri No], Sh.sehir_adi [Şehir]
from Adresler A
join Siparisler S on S.adres_id = A.adres_id
join Sehirler Sh on Sh.sehir_id = A.sehir_id
where datepart(day,S.siparis_tarihi) = 1

/* Ödeme şekli peşin olan kargo şirketinin kargo araçlarının sayısını veren sorgu: */
select count(K.kargoAraci) [Kargo Aracı Sayısı]
from KargoSirketi KS 
left join Kargolar K on KS.kargoSirketi_id = K.kargoSirketi_id
join Odemeler O on O.odeme_id = KS.odeme_id
where KS.odeme_id = 2

/* 0216 349 84 55 telefon numarasına sahip olan tedarikçi şirketin tedarik ettiği ürünlerin isim - birim fiyat listesi: */
select U.urun_adi [isim], U.birimFiyat [birim fiyat]
from [Urun-TedarikciSirket] UT 
join Urunler U on UT.urun_id = U.urun_id
join TedarikciSirket T on T.[t-sirket_id] = UT.[t-sirket_id]
where T.telefonNO = '0216 349 84 55'

/* Siparişler tablosu ile müşteri tablosunun kartezyen çarpımını veren sorgu: */
select M.musteri_id, S.siparis_id
from Musteri M cross join Siparisler S
order by M.musteri_id





