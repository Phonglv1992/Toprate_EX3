--1. Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty(tức là có cùng tên giao dịch).
select kh.MA_KH,kh.TEN_CTY,kh.TEN_GIAO_DICH from KHACH_HANG kh
join NHA_CC ncc on ncc.TEN_GIAO_DICH=kh.TEN_GIAO_DICH;
--2. Những đơn đặt hàng nào yêu cầu giao hàng ngay tại cty đặt hàng và những đơn đó là của công ty nào? 
select ddh.SO_HOA_DON,ddh.NOI_GIAO_HANG,kh.TEN_GIAO_DICH from DON_DAT_HANG ddh
join KHACH_HANG kh on kh.MA_KH=ddh.MA_KH where kh.DIA_CHI=ddh.NOI_GIAO_HANG;
--3.Những mặt hàng nào chưa từng được khách hàng đặt mua?
select MA_HANG,TEN_HANG from MAT_HANG
where not EXISTS (select MA_HANG from CHI_TIET_DAT_HANG where CHI_TIET_DAT_HANG.MA_HANG=MAT_HANG.MA_HANG); 
--4. Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
select * from NHAN_VIEN
where NHAN_VIEN.MA_NV NOT IN (select distinct(MA_NV) from DON_DAT_HANG);
--5. Trong năm 2003, những mặt hàng nào chỉ được đặt mua đúng một lần
SELECT count(MAT_HANG.MA_HANG) 'số lượng',TEN_HANG 'Tên mặt hàng' from (
MAT_HANG join CHI_TIET_DAT_HANG on MAT_HANG.MA_HANG=CHI_TIET_DAT_HANG.MA_HANG)
join DON_DAT_HANG on DON_DAT_HANG.SO_HOA_DON=CHI_TIET_DAT_HANG.SO_HOA_DON
where YEAR (DON_DAT_HANG.NGAY_DAT_HANG)=2003 
group by (MAT_HANG.TEN_HANG)
having count(MAT_HANG.MA_HANG)=2;

--select * from DON_DAT_HANG where YEAR(DON_DAT_HANG.NGAY_DAT_HANG)=2003;
--6. Hãy cho biết mỗi một khách hàng đã phải bỏ ra bao nhiêu tiền để đặt mua hàng củacông ty? 
select KHACH_HANG.MA_KH, sum(SO_LUONG*GIA_BAN - SO_LUONG*GIA_BAN*MUC_GIAM_GIA/100) from KHACH_HANG
join DON_DAT_HANG on DON_DAT_HANG.MA_KH=KHACH_HANG.MA_KH
join CHI_TIET_DAT_HANG on CHI_TIET_DAT_HANG.SO_HOA_DON=DON_DAT_HANG.SO_HOA_DON
group by (KHACH_HANG.MA_KH);
--7. Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng
-- (nếu nhân viên chưahề lập một hoá đơn nào thì cho kết quả là 0)


select NHAN_VIEN.HO,NHAN_VIEN.TEN,count(DON_DAT_HANG.MA_NV) 'số lượng' from NHAN_VIEN
left join DON_DAT_HANG on DON_DAT_HANG.MA_NV=NHAN_VIEN.MA_NV
group by NHAN_VIEN.HO, NHAN_VIEN.TEN;
--8. Cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2003
--(thời được gian tính theo ngày đặt hàng).
select Month(DON_DAT_HANG.NGAY_DAT_HANG) 'Tháng', 
sum(CHI_TIET_DAT_HANG.GIA_BAN*SO_LUONG-CHI_TIET_DAT_HANG.GIA_BAN*SO_LUONG*MUC_GIAM_GIA/100) 'Tổng số tiền bán' 
from (DON_DAT_HANG join CHI_TIET_DAT_HANG on CHI_TIET_DAT_HANG.SO_HOA_DON=DON_DAT_HANG.SO_HOA_DON)
where YEAR (NGAY_DAT_HANG)=2003
group by(Month(DON_DAT_HANG.NGAY_DAT_HANG));

--9. Hãy cho biết tổng số lượng hàng của mỗi mặt hàng mà cty đã có (tổng số lượng hàng hiện có và đã bán).
-- cách 1:
select MAT_HANG.MA_HANG ,MAT_HANG.SO_LUONG,CHI_TIET_DAT_HANG.SO_LUONG, MAT_HANG.SO_LUONG+
CASE
   WHEN SUM(CHI_TIET_DAT_HANG.SO_LUONG) IS NULL THEN 0
	ELSE
	SUM(CHI_TIET_DAT_HANG.SO_LUONG)
	 END AS TONG
from MAT_HANG
left join CHI_TIET_DAT_HANG on CHI_TIET_DAT_HANG.MA_HANG=MAT_HANG.MA_HANG
group by MAT_HANG.MA_HANG, MAT_HANG.SO_LUONG, CHI_TIET_DAT_HANG.SO_LUONG
--cách 2:

select MAT_HANG.MA_HANG,MAT_HANG.SO_LUONG,CHI_TIET_DAT_HANG.SO_LUONG ,SUM(MAT_HANG.SO_LUONG + isNull(CHI_TIET_DAT_HANG.SO_LUONG,0))
from MAT_HANG
left join CHI_TIET_DAT_HANG on CHI_TIET_DAT_HANG.MA_HANG=MAT_HANG.MA_HANG
group by MAT_HANG.MA_HANG, MAT_HANG.SO_LUONG, CHI_TIET_DAT_HANG.SO_LUONG
--10. Nhân viên nào của cty bán được số lượng hàng nhiều nhất và số lượng hàng bán được
--của nhân viên này là bao nhiêu?

select top(1) NHAN_VIEN.MA_NV,NHAN_VIEN.HO,NHAN_VIEN.TEN,sum(CHI_TIET_DAT_HANG.SO_LUONG) SL from NHAN_VIEN
join DON_DAT_HANG on DON_DAT_HANG.MA_NV=NHAN_VIEN.MA_NV
join CHI_TIET_DAT_HANG on CHI_TIET_DAT_HANG.SO_HOA_DON=DON_DAT_HANG.SO_HOA_DON
group by NHAN_VIEN.MA_NV,NHAN_VIEN.HO,NHAN_VIEN.TEN
order by SL desc
--11. Mỗi một đơn đặt hàng đặt mua những mặt hàng nào 
--và tổng số tiền mà mỗi đơn đặt hàng phải trả là bao nhiêu?
select DON_DAT_HANG.SO_HOA_DON,sum(CHI_TIET_DAT_HANG.SO_LUONG*GIA_BAN) from DON_DAT_HANG
join CHI_TIET_DAT_HANG on CHI_TIET_DAT_HANG.SO_HOA_DON=DON_DAT_HANG.SO_HOA_DON
join MAT_HANG on MAT_HANG.MA_HANG=CHI_TIET_DAT_HANG.MA_HANG
group by(DON_DAT_HANG.SO_HOA_DON)

--12. Hãy cho biết mỗi một loại hàng bao gồm những mặt hàng nào, tổng số lượng hàng của mỗi loại 
--và tổng số lượng của tất cả các mặt hàng hiện có trong công ty là bao nhiêu?


--ạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mớicho bảng MATHANG
-- (thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cần bổsung: 
--không trùng khoá chính và đảm bảo toàn vẹn tham chiếu)

ALTER PROCEDURE INSERT_MAT_HANG
	@MA_HANG varchar(10)  = NULL,
	@TEN_HANG NVARCHAR(100)  = NULL,
	@MA_CTY VARCHAR(10)  = NULL,
	@MA_LOAI_HANG NVARCHAR(10) = NULL,
	@SO_LUONG BIGINT = NULL,
	@DON_VI_TINH NVARCHAR(20) = NULL,
	@GIA_HANG MONEY  = NULL

AS

begin
	SET XACT_ABORT ON
	SET NOCOUNT ON;
	BEGIN TRAN
	BEGIN TRY
	INSERT INTO MAT_HANG (MA_HANG,TEN_HANG,MA_CTY,MA_LOAI_HANG,SO_LUONG,DON_VI_TINH,GIA_HANG)
	values(@MA_HANG,@TEN_HANG,@MA_CTY,@MA_LOAI_HANG,@SO_LUONG,@DON_VI_TINH,@GIA_HANG)
	
	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		DECLARE @ErrorMessage VARCHAR(2000)
		SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
	END CATCH
END
--Tạo thủ tục lưu trữ có chức năng thống kê tổng số lượng hàng bán được của một mặt hàng có mã bất kỳ 
--(mã mặt hàng cần thống kê là tham số của thủ tục).
alter procedure Search_Mat_Hang
@MA_HANG NVARCHAR(10)=NULL
AS
SET NOCOUNT ON
BEGIN
	
	--declare @STMT nvarchar(max) 
	--set @STMT='select CHI_TIET_DAT_HANG.MA_HANG,sum(CHI_TIET_DAT_HANG.SO_LUONG) [số lượng bán ra] from CHI_TIET_DAT_HANG	
	--	where CHI_TIET_DAT_HANG.MA_HANG='+@MA_HANG+
	--	'group by CHI_TIET_DAT_HANG.MA_HANG'
	select CHI_TIET_DAT_HANG.MA_HANG,sum(CHI_TIET_DAT_HANG.SO_LUONG) 'số lượng bán ra' from CHI_TIET_DAT_HANG	
	where CHI_TIET_DAT_HANG.MA_HANG=@MA_HANG
	group by CHI_TIET_DAT_HANG.MA_HANG

END	
--EXEC sp_executesql @STMT
SET NOCOUNT OFF




