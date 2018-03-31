CREATE ASSEMBLY Management FROM 
'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\System.Management.dll'
WITH permission_set=unsafe;
go

--CREATE ASSEMBLY Aggregates FROM 

--'H:\Visual Studio 2005\Projects\StringUtilities\CS\StringUtilities\bin\debug\Aggregates.dll'

--WITH permission_set=unsafe;

GO

 

CREATE FUNCTION GetLogicalDrives()
RETURNS TABLE 
(id int, DriveLogicalName nvarchar(100), DriveType nvarchar(100), DriveFreeSpace int)
AS 
EXTERNAL NAME [Aggregates].[GetDrives].GetLogicalDrives
Go

select * from dbo.GetLogicalDrives()
