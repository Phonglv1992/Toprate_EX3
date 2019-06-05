create database TOPRATE_EX3;
USE TOPRATE_EX3
go
create table KHACH_HANG(
MA_KH VARCHAR(10) NOT NULL,
TEN_CTY VARCHAR(100),
TEN_GIAO_DICH NVARCHAR(200),
DIA_CHI NVARCHAR(200),
EMAIL VARCHAR(100),
DIEN_THOAI INT,
FAX VARCHAR(100));

ALTER TABLE KHACH_HANG
ADD CONSTRAINT KHACH_HANG_PR PRIMARY KEY (MA_KH); 

CREATE TABLE DON_DAT_HANG(
SO_HOA_DON int not null,
MA_KH VARCHAR(10) not null,
MA_NV VARCHAR(10) NOT NULL,
NGAY_DAT_HANG DATETIME,
NGAY_GIAO_HANG DATETIME,
NGAY_CHUYEN_HANG DATETIME,
NOI_GIAO_HANG NVARCHAR(200));
ALTER TABLE DON_DAT_HANG
ADD CONSTRAINT DON_DAT_HANG_PR PRIMARY KEY (SO_HOA_DON); 

-------------------------------------------------------------
CREATE TABLE NHAN_VIEN(
MA_NV VARCHAR(10) NOT NULL,
HO NVARCHAR(20),
TEN NVARCHAR(30),
NGAY_SINH DATETIME,
NGAY_LAM_VIEC DATETIME,
DIA_CHI NVARCHAR(200),
DIEN_THOAI INT,
LUONG_CO_BAN money,
PHU_CAP MONEY);

ALTER TABLE NHAN_VIEN
ADD CONSTRAINT NHAN_VIEN_PR PRIMARY KEY (MA_NV);

CREATE TABLE NHA_CC(
MA_CTY VARCHAR(10) NOT NULL,
TEN_CTY NVARCHAR(100) NOT NULL,
TEN_GIAO_DICH NVARCHAR(200),
DIA_CHI NVARCHAR(100),
DIEN_THOAI INT,
FAX VARCHAR(100),
EMAIL VARCHAR(100));

ALTER TABLE NHA_CC
ADD CONSTRAINT NHA_CC_PR PRIMARY KEY (MA_CTY);

CREATE TABLE CHI_TIET_DAT_HANG(
SO_HOA_DON INT NOT NULL,
MA_HANG VARCHAR(10) NOT NULL,
GIA_BAN MONEY,
SO_LUONG INT,
MUC_GIAM_GIA INT);

ALTER TABLE CHI_TIET_DAT_HANG
ADD CONSTRAINT CHI_TIET_DAT_HANG_PR PRIMARY KEY (SO_HOA_DON,MA_HANG);


CREATE TABLE MAT_HANG(
MA_HANG VARCHAR(10) NOT NULL,
TEN_HANG NVARCHAR(100) NOT NULL,
MA_CTY VARCHAR(10) NOT NULL,
MA_LOAI_HANG VARCHAR(10) NOT NULL,
SO_LUONG INT,
DON_VI_TINH NVARCHAR(20),
GIA_HANG MONEY);

ALTER TABLE MAT_HANG
ADD CONSTRAINT MAT_HANG_PR PRIMARY KEY (MA_HANG);

CREATE TABLE LOAI_HANG(
MA_LOAI_HANG VARCHAR(10) NOT NULL,
TEN_LOAI_HANG NVARCHAR(100));

ALTER TABLE LOAI_HANG
ADD CONSTRAINT LOAI_HANG_PR PRIMARY KEY (MA_LOAI_HANG);

ALTER TABLE DON_DAT_HANG
ADD FOREIGN KEY (MA_KH) REFERENCES KHACH_HANG(MA_KH);
ALTER TABLE DON_DAT_HANG
ADD FOREIGN KEY (MA_NV) REFERENCES NHAN_VIEN(MA_NV);

ALTER TABLE CHI_TIET_DAT_HANG
ADD FOREIGN KEY (SO_HOA_DON) REFERENCES DON_DAT_HANG(SO_HOA_DON);
ALTER TABLE CHI_TIET_DAT_HANG
ADD FOREIGN KEY (MA_HANG) REFERENCES MAT_HANG(MA_HANG);

ALTER TABLE MAT_HANG
ADD FOREIGN KEY (MA_CTY) REFERENCES NHA_CC(MA_CTY);
ALTER TABLE MAT_HANG
ADD FOREIGN KEY (MA_LOAI_HANG) REFERENCES LOAI_HANG(MA_LOAI_HANG);