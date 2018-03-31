------ DEMO UDT ------------------
declare @a cudt_PriceDate

-- demo nullability
select @a.StockPrice, @a.BusinessDay

-- use parse
set @a = CONVERT(cudt_PriceDate, '911.799;2005-11-02')
select @a.StockPrice, @a.BusinessDay

-- use property set
set @a.StockPrice = 91.899

-- Convert/Cast
select CONVERT(float, @a.StockPrice)

-- demo insert
create table tmp(pd cudt_PriceDate)

insert into tmp (pd)
values(@a)

insert into tmp (pd)
values('912.35;2005-11-03')

-- get binary values
select * from tmp

--get string intepretations - invoke ToString()
select Cast(pd as varchar) pd from tmp

if object_id('dbo.tmp') is not null
	drop table dbo.tmp


-- invoke custom method
declare @b cudt_PriceDate
set @b = Cast ('912.35;2005-11-03' as cudt_PriceDate)
select cudt_PriceDate::DiffDate (@a, @b), cudt_PriceDate::DiffPrice(@a, @b)


------ DEMO AGG ---------------


if object_id('dbo.Stock') is not null
	drop table dbo.Stock

create table dbo.Stock(
	id int identity,
	stock varchar(100), 
	priceClose cudt_PriceDate)

INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('3.05;2-Dec-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('3.08;1-Dec-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('2.90;30-Nov-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('2.84;29-Nov-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('2.92;28-Nov-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('3.01;25-Nov-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('3.06;23-Nov-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('3.04;22-Nov-05' as cudt_PriceDate))
INSERT INTO  dbo.Stock(stock, priceClose)
values('NT', Cast('5.10;21-Nov-05' as cudt_PriceDate))

select stock, 
dbo.agg_MovingAvg(priceClose) MovingAvg
from Stock
group by stock

if object_id('dbo.Stock') is not null
	drop table dbo.Stock
		