----------------------------------------------------------------
-- on World server
create database Asset51
GO
use Asset51
GO
CREATE TYPE [dbo].[typEmail] FROM [varchar](255) NOT NULL
CREATE TYPE [dbo].[typPhone] FROM [varchar](20) NOT NULL
GO

CREATE TABLE [dbo].[InventoryWorld] (
   [Inventoryid] [int] NOT NULL ,
   [Make] [varchar] (50) NULL ,
   [Model] [varchar] (50) NULL ,
   [Location] [varchar] (50) NULL ,
   [FirstName] [varchar] (30) NULL ,
   [LastName] [varchar] (30) NULL ,
   [AcquisitionType] [varchar] (12) NULL ,
   [Address] [varchar] (50) NULL ,
   [City] [varchar] (50) NULL ,
   [ProvinceId] [char] (3) NULL ,
   [Country] [varchar] (50) NOT NULL ,
   [EqType] [varchar] (50) NULL ,
   [Phone] [typPhone] NULL ,
   [Fax] [typPhone] NULL ,
   [Email] [typEmail] NULL ,
   [UserName] [varchar] (50) NULL ,
   CONSTRAINT [PK_InventoryWorld] PRIMARY KEY  CLUSTERED 
   (
      [Country],
      [Inventoryid]
   )  ON [PRIMARY] ,
   CONSTRAINT [chkInventoryWorld] CHECK ([Country] in ('UK', 
              'Ireland', 'Australia'))
) ON [PRIMARY]
GO

exec sp_addlinkedserver N'(local)\Canada', N'SQL Server'
GO
exec sp_addlinkedserver N'(local)\USA', N'SQL Server'
GO
USE master
EXEC sp_serveroption '(local)\Canada', 'lazy schema validation', 'true'
EXEC sp_serveroption '(local)\USA', 'lazy schema validation', 'true'
Go

-- After you create table on other two servers

use Asset51
GO

Create view dbo.vInventoryDist
as
select * from [(local)\Canada].Asset51.dbo.InventoryCanada
UNION ALL
select * from [(local)\USA].Asset51.dbo.InventoryUSA
UNION ALL
select * from Asset51.dbo.InventoryWorld
GO

create procedure ap_Inventory_ListDist
	@chvCountry varchar(50)
as 
select * 
from vInventoryDist
where Country = @chvCountry