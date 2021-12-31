USE AdventureWorks2019
GO 

SELECT * FROM Person.Contact WHERE ContactID >= 100 AND ContactID <= 200

SELECT * FROM Person.Contact WHERE ContactID BETWEEN 100 AND 200

SELECT * FROM Person.Contact WHERE LastName LIKE '%e'

SELECT * FROM Person.Contact WHERE LastName LIKE '[RA]%e'

SELECT * FROM Person.Contact WHERE LastName LIKE '[RA]__e'

SELECT Person.Contact.* FROM Person.Contact INNER JOIN HumanResources.Employee ON 
Person.Contact.ContactID=HumanResources.Employee.ContactID

SELECT Title, COUNT(*) [Title Number] FROM Person.Contact00 WHERE Title LIKE 'Mr%' GROUP BY ALL Title

SELECT Title, COUNT(*) [Title Number] FROM Person.Contact GROUP BY ALL Title HAVING Title LIKE 'Mr%'

GO

--Bài tập tự làm

CREATE DATABASE Lab6
GO

USE Lab6
GO

CREATE TABLE PhongBan(
  MaPB varchar(7) PRIMARY KEY,
  TenPB nvarchar(50)
)
GO

CREATE TABLE NhanVien(
   MaNV varchar(7) PRIMARY KEY,
   TenNV nvarchar(50),
   NgaySinh Datetime CHECK (NgaySinh < (GETDATE())),
   SoCMND char(9) CHECK ( ISNUMERIC(SoCMND) = 1),
   GioiTinh char(1) DEFAULT 'M',
   DiaChi nvarchar(100),
   NgayVaoLam Datetime ,
   MaPB varchar(7) FOREIGN KEY REFERENCES PhongBan(MaPB),
   CHECK (DATEDIFF(year, NgayVaoLam, NgaySinh) <= -20),
) 
GO

CREATE TABLE LuongDA(
   MaDA varchar(8) PRIMARY KEY,
   MaNV varchar(7) FOREIGN KEY REFERENCES NhanVien(MaNV),
   NgayNhan Datetime NOT NULL DEFAULT(GETDATE()),
   SoTien Money CHECK (SoTien > 0)
)
GO

--1.Chèn dữ liệu vào bảng 
INSERT INTO PhongBan(MaPB,TenPB) VALUES 
   ('01',N'Kế Toán'),
   ('02',N'Nhân Sự'), 
   ('03',N'Kinh Doanh'),
   ('04',N'Đầu Tư'),
   ('05',N'Dự Án')
GO

INSERT INTO NhanVien (MaNV, TenNV, NgaySinh,SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB) VALUES 
   ('001',N'Phùng Khánh Linh','2000-08-10','123456789','F',N'HÀ NỘI','2021-09-03','01'),
   ('002',N'Đỗ Nhật Hà','1998-09-03','123456788','F',N'HÀ NỘI','2021-02-01','02'),
   ('003',N'Nguyễn Đức Anh','1990-08-09','123456898','M',N'NINH BÌNH','2020-07-03','03'),
   ('004',N'Trần Minh Anh','1988-11-21','123468932','F',N'QUẢNG NINH','2019-11-03','04'),
   ('005',N'Hoàng Thùy Linh','2000-01-02','001122334','F',N'BÌNH DƯƠNG','2021-07-02','05'),
   ('006',N'Trần Quốc Bảo','1996-12-12','888831657','M',N'NHA TRANG','2019-12-03','01'),
   ('007',N'Vũ Quốc Huy','1990-12-3','234561267','M',N'HÀ NỘI','2019-03-07','03')
GO

INSERT INTO LuongDA (MaDA ,MaNV,SoTien) VALUES 
   ('da01','001',15000000),
   ('da02','002',10000000),
   ('da03','003',24000000),
   ('da04','004',9000000),
   ('da05','005',30000000),
   ('da06','006',21000000),
   ('da07','007',22000000);
GO

--2.Viết một query để hiển thị thông tin về các bảng LUONGDA, NHANVIEN, PHONGBAN.
SELECT * FROM PhongBan
GO

SELECT * FROM NhanVien
GO

SELECT * FROM LuongDA
GO

--3.Viết một query để hiển thị những nhân viên có giới tính là ‘F’.
SELECT * FROM NhanVien WHERE GioiTinh='F'
GO

--4.Hiển thị tất cả các dự án, mỗi dự án trên 1 dòng.
SELECT MaDA AS'Full DA' from luongDA
GO

--5.Hiển thị tổng lương của từng nhân viên (dùng mệnh đề GROUP BY)
SELECT MaNV, SUM(SoTien) FROM luongDA GROUP BY MaNV
GO

--6.Hiển thị tất cả các nhân viên trên một phòng ban cho trước (VD: ‘Hành chính’).
SELECT * FROM NhanVien WHERE MaPB='01'
GO

SELECT * FROM NhanVien WHERE MaPB='02'
GO

SELECT * FROM NhanVien WHERE MaPB='03'
GO

SELECT * FROM NhanVien WHERE MaPB='04'
GO

SELECT * FROM NhanVien WHERE MaPB='05'
GO

--7.Hiển thị mức lương của những nhân viên phòng hành chính.
CREATE VIEW NhanVienHanhChinh 
AS SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB FROM  NhanVien 
WHERE MaPB='05' WITH CHECK OPTION

SELECT * FROM NhanVienHanhChinh

CREATE VIEW LuongNhanVienHanhChinh AS
SELECT  TenNV, SoTien, GioiTinh
     FROM nhanvienhanhchinh
     INNER JOIN luongDA
     ON NhanVienHanhChinh.MaNV = luongDA.MaNV

SELECT * FROM LuongNhanVienHanhChinh

--8.Hiển thị số lượng nhân viên của từng phòng.
CREATE VIEW NhanVienKeToan AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
FROM  NhanVien
WHERE MaPB='01'
WITH CHECK OPTION

SELECT * FROM NhanVienKeToan

CREATE VIEW NhanVienNhanSu AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB FROM  NhanVien WHERE MaPB='02'
WITH CHECK OPTION

SELECT * FROM NhanVienNhanSu

CREATE VIEW NhanVienKinhDoanh AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB FROM  nhanvien
WHERE MaPB='03'
WITH CHECK OPTION

SELECT * FROM NhanVienKinhDoanh

CREATE VIEW NhanVienThietKe AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
FROM  nhanvien
WHERE MaPB='04'
WITH CHECK OPTION

SELECT * FROM NhanVienThietKe

CREATE VIEW NhanVienHanhChinh AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
FROM  nhanvien
WHERE MaPB='05'
WITH CHECK OPTION

SELECT * FROM NhanVienHanhChinh

SELECT COUNT(*) AS N'Nhân viên kế toán' FROM NhanVienKeToan 
SELECT COUNT(*) AS N'Nhân viên nhân sự' FROM NhanVienNhanSu 
SELECT COUNT(*) AS N'Nhân viên kinh doanh' FROM NhanVienKinhDoanh 
SELECT COUNT(*) AS N'Nhân viên thiết kế' FROM NhanVienThietKe
SELECT COUNT(*) AS N'Nhân viên hành chính' FROM NhanVienHanhChinh
GO

--9.Viết một query để hiển thị những nhân viên mà tham gia ít nhất vào một dự án.
SELECT * FROM luongDA WHERE MaDA!=''
GO

--10.Viết một query hiển thị phòng ban có số lượng nhân viên nhiều nhất.
SELECT MAX(MaPB) AS NVMAX FROM PhongBan
GO

--11.Tính tổng số lượng của các nhân viên trong phòng Hành chính.
SELECT COUNT(*) AS N' Tổng số nhân viên hành chính' FROM NhanVienHanhChinh
GO

--12.Hiển thị tống lương của các nhân viên có số CMND tận cùng bằng 9.
SELECT right(SoCMND, 1), SoCMND
FROM nhanvien
WHERE right(SoCMND, 1) = '9'
GO

SELECT * FROM NhanVien nv, luongDA lgda WHERE RIGHT(nv.SoCMND, 1) = '9'  and nv.MaNV = lgda.MaNV
GO

--13.Tìm nhân viên có số lương cao nhất.
SELECT MAX(SoTien) AS GTLonNhat FROM luongDA
GO

--14.Tìm nhân viên ở phòng Hành chính có giới tính bằng ‘F’ và có mức lương > 1200000.
SELECT * FROM LuongNhanVienHanhChinh WHERE (GioiTinh='F') AND (SoTien >1200000)
GO

--15.Tìm tổng lương trên từng phòng.
SELECT pb.MaPB, pb.TenPB, summoney FROM phongban pb,(
SELECT MaPB, SUM(SoTien) AS summoney FROM NhanVien AS nv, LuongDA AS luong WHERE nv.MaNV = luong.MaNV 
GROUP BY MaPB ) result WHERE pb.MaPB = result.MaPB
GO

--16.Liệt kê các dự án có ít nhất 2 người tham gia.
SELECT MaDA FROM LuongDA GROUP BY MaDA Having COUNT(MaNV) >= 2
GO

--17.Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’.
SELECT right(MaNV, 1), MaNV FROM NhanVien WHERE right(MaNV, 1)='N'

--18.Hiển thị thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2003.
SELECT * FROM luongDA WHERE NgayNhan= '2021-09-03'

--19.Hiển thị thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào.
SELECT * FROM luongDA WHERE MaDA=''

--20.Xoá dự án có mã dự án là DXD02.
DELETE FROM luongDA WHERE MaDA='DXD02'

--21.Xoá đi từ bảng LuongDA những nhân viên có mức lương 2000000.
DELETE FROM luongDA WHERE SoTien='2000000'

--22.Cập nhật lại lương cho những người tham gia dự án XDX01 thêm 10% lương cũ.
UPDATE luongDA
SET SoTien = '900000000' WHERE MaDA = 'da02'
SELECT * FROM luongDA

--23. Xoá các bản ghi tương ứng từ bảng NhanVien đối với những nhân viên không có mã nhân viên tồn tại trong bảng LuongDA.
DELETE FROM NhanVien WHERE MaNV NOT IN (SELECT MaNV FROM LuongDA )

--24.Viết một truy vấn đặt lại ngày vào làm của tất cả các nhân viên thuộc phòng hành chính là ngày 12/02/1999
UPDATE NhanVienHanhChinh SET NgayVaoLam = 12/02/1999
SELECT * FROM NhanVienHanhChinh