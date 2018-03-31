if object_id('Data') is not null
    drop table dbo.Data

create table dbo.Data(id int identity, num float)
INSERT INTO dbo.Data (num) VALUES (-911.5);
INSERT INTO dbo.Data (num) VALUES (9.6);
INSERT INTO dbo.Data (num) VALUES (91.88);
INSERT INTO dbo.Data (num) VALUES (509.86);
INSERT INTO dbo.Data (num) VALUES (-911.5);
INSERT INTO dbo.Data (num) VALUES (90.6);
INSERT INTO dbo.Data (num) VALUES (-1.88);
INSERT INTO dbo.Data (num) VALUES (19.86);
INSERT INTO dbo.Data (num) VALUES (18888.86);

select * from Data order by num

select dbo.MedianDouble(num) MedianDouble
from Data

