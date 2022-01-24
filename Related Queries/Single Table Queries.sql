/* Odemelerin tarihlerine göre ortalamasını, tarihe göre azalan sırada listeleyen sorgu: */
select tarih odeme_tarihi, avg(odemeToplam) as Ort_Odeme
from Odemeler 
group by tarih 
order by tarih desc

/* Her bir tarihte kaç fatura basıldı? */
select tarih faturaTarihi, count(fatura_id) basilanFaturaAdedi
from Faturalar 
group by tarih 

/* Müşterilerin sistemde oluşturulma / sisteme ilk dahil edilme tarihlerine göre sayısını veren sorgu: */
select count(musteri_id) as musteri_sayisi, musteri_olusturulma_tarihi as [musteri olusturulma tarihi]
from Musteriler 
group by musteri_olusturulma_tarihi
order by count(*) desc

/* birim fiyatı 10 birim üstünde olan ürünlerin adedini, kendisinden temin edilen tedarikçi şirkete göre gruplandırıp adedi artan sırada listeleyen sorgu: */
select tedarikci_id [Tedarikçi Şirket], count(*) [ürün adedi]
from Urunler
where birimFiyat > 10
group by tedarikci_id
order by count(*)

/* Düşünün ki tedarikçi şirketlerden biri, size tedarik ettiği tüm mallarına %20 zam getiriyor. O halde sadece bu şirketten tedarik edilen malların zamdan önce ve sonraki durumlarını birim fiyatlarına göre azalan olarak gösteren sorgu: */
select urun_adi, birimFiyat, (birimFiyat + birimFiyat*20/100) as  zamliBirimFiyat 
from Urunler 
where tedarikci_id=5
order by birimFiyat desc

/* Verilen siparişlerin hangi müşteri (id olarak) tarafından ve toplam kaç paraya verdiğinin hepsini bir sütunda gösteren sorgu: */
select convert(nvarchar(10), musteri_id) + ': ' + convert(nvarchar(12), convert(int, toplamTutar)) as [Musteri ve toplam siparis tutarı]
from Siparisler

/* E-ticaret sitesinin pazara çıkardığı ürünlerin birim fiyatlarının ortalamasını veren sorgu: */
select avg(birimFiyat) [Ortalama fiyat] 
from Urunler

/* Üyeler tablosundaki üyelerin soyadlarının son iki harfini veren sorgu: */
select right(uye_soyad, 2) [son iki harf]
from Uyeler

/* Aynı cinsiyette olan Kontakları, kontak ünvanlarına göre sayılarını kontak ünvanlarına göre azalan sırada veren sorgu: */
select count(kontak_id) as [kontank sayısı], cinsiyet, kontak_unvan as [ünvan]
from Kontaklar
group by cinsiyet, kontak_unvan
order by kontak_unvan

/* her bir ürünün birim fiyatına %10 zam getirip tam sayı değer olacak şekilde getiren sorgu: */
select kategori_id, convert(int, birimFiyat+birimFiyat*10/100) as [%10 zam uygulanmış ve tam sayı olmuş birim fiyat]
from Urunler

/* Üyeler tablosundaki üyelerin herbirinin ne kadar süredir üye olduklarını veren sorgu: */
select uye_ad [Üyenin Adı], abs(datediff(year, getDate(), uye_kayit_tarih)) [Ne zamandır üye? (yıl)]
from Uyeler

/* Birden fazla tedarikçi tarafından temin edilen ürünlerin id'lerini ve ne kadar tedarikçi tarafından temin edildiklerini veren sorgu: */
select urun_id, count(*) as [tedarikçi adet]
from [Urun-TedarikciSirket]
group by urun_id having count(*) > 1

/* Veri tabanında; birden fazla şehire sahip olan ülkelerin id'lerini ve kaç şehre sahip olduklarını veren sorgu: */
select ulke_id, count(*) as [sahip olduğu şehir sayısı]
from Sehirler
group by ulke_id having count(*) > 1

/* Odeme türleri ve tarihlerine göre, ödememlerden toplam en fazla tutan ilk 2 ödemenin türü ve tarihini ve ne kadar tuttuğunu veren sorgu: */
select top 2 odeme_turu [ödeme türü], tarih, odemeToplam [Ne kadar tuttu?]
from Odemeler
group by odeme_turu, tarih, odemeToplam
order by odemeToplam desc

/* Aynı kargo şirketi ile taşınan ve durumları da halen 'beklemede' olan siparişlerin ödeme yöntemlerine göre en yüksek ve en düşük toplam tutarlarını ödeme yöntemine göre artan sırada getiren sorgu: */
select kargoSirketi_id, odeme_id, max(toplamTutar) as [maksimum toplam tutar], min(toplamTutar) as [minimum toplam tutar] 
from Siparisler 
where durum='beklemede'
group by kargoSirketi_id, odeme_id 
order by odeme_id

