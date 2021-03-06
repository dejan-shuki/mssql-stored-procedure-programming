create database Asset5
go

use Asset5
go


--IF NOT EXISTS (SELECT * FROM sys.triggers WHERE parent_class_desc = 'DATABASE' AND name = N'ctrd_DDL_PROCEDURE_EVENTS_vb')
--EXECUTE dbo.sp_executesql N'
--CREATE TRIGGER [ctrd_DDL_PROCEDURE_EVENTS_vb] ON DATABASE WITH EXECUTE AS CALLER
-- FOR CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION, CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE AS 
-- EXTERNAL NAME [VbTriggers].[VbTriggers.Triggers].[trigger_DDL_PROCEDURE_EVENTS]'
--
--GO
--ENABLE TRIGGER [ctrd_DDL_PROCEDURE_EVENTS_vb] ON DATABASE
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' , @level0type=N'TRIGGER', @level0name=N'ctrd_DDL_PROCEDURE_EVENTS_vb'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'Triggers.vb' , @level0type=N'TRIGGER', @level0name=N'ctrd_DDL_PROCEDURE_EVENTS_vb'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=17 , @level0type=N'TRIGGER', @level0name=N'ctrd_DDL_PROCEDURE_EVENTS_vb'

--GO
--IF NOT EXISTS (SELECT * FROM sys.triggers WHERE parent_class_desc = 'DATABASE' AND name = N'ctrd_DDL_TABLE_EVENTS ')
--EXECUTE dbo.sp_executesql N'
--CREATE TRIGGER [ctrd_DDL_TABLE_EVENTS ] ON DATABASE WITH EXECUTE AS CALLER
-- FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE AS 
-- EXTERNAL NAME [CSrpTrigger].[Triggers].[ddl_table]'
--
--GO
--ENABLE TRIGGER [ctrd_DDL_TABLE_EVENTS ] ON DATABASE
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' , @level0type=N'TRIGGER', @level0name=N'ctrd_DDL_TABLE_EVENTS '
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'Trigger1.cs' , @level0type=N'TRIGGER', @level0name=N'ctrd_DDL_TABLE_EVENTS '
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=92 , @level0type=N'TRIGGER', @level0name=N'ctrd_DDL_TABLE_EVENTS '
--
--GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'rolUser' AND type = 'R')
CREATE ROLE [rolUser] AUTHORIZATION [dbo]
GO



IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'util')
EXEC sys.sp_executesql N'CREATE SCHEMA [util] AUTHORIZATION dbo'

GO
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'Eq')
CREATE SYNONYM [dbo].[Eq] FOR [dbo].[Equipment]
GO
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'typPhone' AND ss.name = N'dbo')
CREATE TYPE [dbo].[typPhone] FROM [varchar](25) NOT NULL
GO
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'typEmail' AND ss.name = N'dbo')
CREATE TYPE [dbo].[typEmail] FROM [varchar](255) NOT NULL
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[fnQuarterString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [util].[fnQuarterString]
-- returns quarter in form of ''3Q2000''.
     (
     @dtmDate datetime
     )
Returns char(6) -- quarter like 3Q2000
As
Begin
     Return (DateName(q, @dtmDate) + ''Q'' + DateName(yyyy, @dtmDate))
End
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[fnThreeBusDays]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [util].[fnThreeBusDays]
-- returns date 3 business day after the specified date
     (@dtmDate datetime)
Returns datetime
As
Begin
Declare @inyDayOfWeek tinyint
Set @inyDayOfWeek = DatePart(dw, @dtmDate)
Set @dtmDate = Convert(datetime, Convert(varchar, @dtmDate, 101))

If @inyDayOfWeek = 1 -- Sunday
     Return DateAdd(d, 3, @dtmDate )
If @inyDayOfWeek = 7 -- Saturday
     Return DateAdd(d, 4, @dtmDate )
If @inyDayOfWeek = 6 -- Friday
     Return DateAdd(d, 5, @dtmDate )
If @inyDayOfWeek = 5 -- Thursday
     Return DateAdd(d, 5, @dtmDate )
If @inyDayOfWeek = 4 -- Wednesday
     Return DateAdd(d, 5, @dtmDate )

Return DateAdd(d, 3, @dtmDate )
End
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnDueDays]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[fnDueDays]
-- return list of due days for the leasing
(
    @dtsStartDate smalldatetime,
    @dtsEndDate smalldatetime,
    @chvLeaseFrequency varchar(20)
)
Returns @tblTerms table
    (
    TermID int,
    DueDate smalldatetime
    )

As
Begin

Declare @insTermsCount smallint -- number of intervals
Declare @insTerms smallint -- number of intervals

-- calculate number of terms
Select @insTermsCount =
  Case @chvLeaseFrequency
     When ''monthly''
                then DateDIFF(month, @dtsStartDate, @dtsEndDate)
     When ''semi-monthly''
                then 2 * DateDIFF(month, @dtsStartDate, @dtsEndDate)
     When ''bi-weekly''
                then DateDIFF(week, @dtsStartDate, @dtsEndDate)/2
     When ''weekly''
                then DateDIFF(week, @dtsStartDate, @dtsEndDate)
     When ''quarterly''
                then DateDIFF(qq, @dtsStartDate, @dtsEndDate)
     When ''yearly''
                then DateDIFF(y, @dtsStartDate, @dtsEndDate)
  End

-- generate list of due dates
Set @insTerms = 1
While @insTerms <= @insTermsCount
Begin
  Insert @tblTerms (TermID, DueDate)
  Values (@insTerms, Convert(smalldatetime, CASE
        When @chvLeaseFrequency = ''monthly''
             then DateADD(month,@insTerms, @dtsStartDate)
        When @chvLeaseFrequency = ''semi-monthly''
        and @insTerms/2 =  Cast(@insTerms as float)/2
             then DateADD(month, @insTerms/2, @dtsStartDate)
        When @chvLeaseFrequency = ''semi-monthly''
        and @insTerms/2 <> Cast(@insTerms as float)/2
             then DateADD(dd, 15,
                          DateADD(month, @insTerms/2, @dtsStartDate))
        When @chvLeaseFrequency = ''bi-weekly''
             then DateADD(week, @insTerms*2, @dtsStartDate)
        When @chvLeaseFrequency = ''weekly''
             then DateADD(week, @insTerms, @dtsStartDate)
        When @chvLeaseFrequency = ''quarterly''
             then DateADD(qq, @insTerms, @dtsStartDate)
        When @chvLeaseFrequency = ''yearly''
             then DateADD(y, @insTerms, @dtsStartDate)
        End , 105))

    Select @insTerms = @insTerms + 1
End

Return
End
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Terms_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_Terms_List]
-- return list of due days for the leasing
     @dtsStartDate smalldatetime,
     @dtsEndDate smalldatetime,
     @chvLeaseFrequency varchar(20)
As
set nocount on

declare @insDueDates smallint -- number of intervals

-- calculate number of DueDates
select @insDueDates =
    Case @chvLeaseFrequency
         When ''monthly''
              then DateDiff(month, @dtsStartDate, @dtsEndDate)
         When ''semi-monthly''
              then 2 * DateDiff(month, @dtsStartDate, @dtsEndDate)
         When ''bi-weekly''
              then DateDiff(week, @dtsStartDate, @dtsEndDate)/2
         When ''weekly''
              then DateDiff(week, @dtsStartDate, @dtsEndDate)
         When ''quarterly''
              then DateDiff(qq, @dtsStartDate, @dtsEndDate)
         When ''yearly''
              then DateDiff(y, @dtsStartDate, @dtsEndDate)
     END

-- generate list of due dates using temporary table
Create table #DueDates (ID int)

while @insDueDates >= 0
begin
     insert #DueDates (ID)
     values (@insDueDates)

     select @insDueDates = @insDueDates - 1
end

-- display list of Due dates
select ID+1, Convert(varchar,
     Case
         When @chvLeaseFrequency = ''monthly''
              then DateAdd(month,ID, @dtsStartDate)
         When @chvLeaseFrequency = ''semi-monthly''
         and ID/2 =  CAST(ID as float)/2
              then DateAdd(month, ID/2, @dtsStartDate)
         When @chvLeaseFrequency = ''semi-monthly''
         and ID/2 <> CAST(ID as float)/2
              then DateAdd(dd, 15,
                           DateAdd(month, ID/2, @dtsStartDate))
         When @chvLeaseFrequency = ''bi-weekly''
              then DateAdd(week, ID*2, @dtsStartDate)
         When @chvLeaseFrequency = ''weekly''
              then DateAdd(week, ID, @dtsStartDate)
         When @chvLeaseFrequency = ''quarterly''
              then DateAdd(qq, ID, @dtsStartDate)
         When @chvLeaseFrequency = ''yearly''
              then DateAdd(y, ID, @dtsStartDate)
     END , 105) [Due date]
from #DueDates
order by ID

-- wash the dishes
drop table #DueDates

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventorySum]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventorySum](
	[ID] [int] NULL,
	[InventoryId] [int] NULL,
	[Make] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[FirstName] [varchar](30) NULL,
	[LastName] [varchar](30) NULL,
	[AcquisitionType] [varchar](12) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[ProvinceId] [char](3) NULL,
	[Country] [varchar](50) NULL,
	[EqType] [varchar](50) NULL,
	[Phone] [varchar](20) NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](128) NULL,
	[UserName] [varchar](50) NULL,
	[MakeModelSIdx] [int] NULL,
	[LFNameSIdx] [int] NULL,
	[CountrySIdx] [int] NULL
) ON [PRIMARY]
END
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_upgraddiagrams]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'
--	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
--	AS
--	BEGIN
--		IF OBJECT_ID(N''dbo.sysdiagrams'') IS NOT NULL
--			return 0;
--	
--		CREATE TABLE dbo.sysdiagrams
--		(
--			name sysname NOT NULL,
--			principal_id int NOT NULL,	-- we may change it to varbinary(85)
--			diagram_id int PRIMARY KEY IDENTITY,
--			version int,
--	
--			definition varbinary(max)
--			CONSTRAINT UK_principal_name UNIQUE
--			(
--				principal_id,
--				name
--			)
--		);
--
--
--		/* Add this if we need to have some form of extended properties for diagrams */
--		/*
--		IF OBJECT_ID(N''dbo.sysdiagram_properties'') IS NULL
--		BEGIN
--			CREATE TABLE dbo.sysdiagram_properties
--			(
--				diagram_id int,
--				name sysname,
--				value varbinary(max) NOT NULL
--			)
--		END
--		*/
--
--		IF OBJECT_ID(N''dbo.dtproperties'') IS NOT NULL
--		begin
--			insert into dbo.sysdiagrams
--			(
--				[name],
--				[principal_id],
--				[version],
--				[definition]
--			)
--			select	 
--				convert(sysname, dgnm.[uvalue]),
--				DATABASE_PRINCIPAL_ID(N''dbo''),			-- will change to the sid of sa
--				0,							-- zero for old format, dgdef.[version],
--				dgdef.[lvalue]
--			from dbo.[dtproperties] dgnm
--				inner join dbo.[dtproperties] dggd on dggd.[property] = ''DtgSchemaGUID'' and dggd.[objectid] = dgnm.[objectid]	
--				inner join dbo.[dtproperties] dgdef on dgdef.[property] = ''DtgSchemaDATA'' and dgdef.[objectid] = dgnm.[objectid]
--				
--			where dgnm.[property] = ''DtgSchemaNAME'' and dggd.[uvalue] like N''_EA3E6268-D998-11CE-9454-00AA00A3F36E_'' 
--			return 2;
--		end
--		return 1;
--	END
--	' 
--END
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InvSum_Generate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_InvSum_Generate]
	@debug [int] = 0
WITH EXECUTE AS CALLER
AS
SET NOCOUNT ON
SET XACT_ABORT ON

declare @intTransactionCountOnEntry int

create table #Inv(ID int identity(1,1),
                  Inventoryid int,
                  Make varchar(50),
                  Model varchar(50),
                  Location varchar(50),
                  Status varchar(15),
                  FirstName varchar(30),
                  LastName varchar(30),
                  AcquisitionType varchar(12),
                  Address varchar(50),
                  City varchar(50),
                  ProvinceId char(3),
                  Country varchar(50),
                  EqType varchar(50),
                  Phone varchar(20),
                  Fax varchar(20),
                  Email varchar(128),
                  UserName varchar(50),
                  MakeModelSIdx int,
                  LFNameSIdx int,
                  CountrySIdx int)

-- get result set
insert into #Inv(InventoryId,   Make, Model,
                 Location, FirstName, LastName,
                 AcquisitionType, Address, 
                 City, ProvinceId, Country,
                 EqType,Phone, Fax, 
                 Email, UserName 
)
/*SELECT Inventory.Inventoryid, Equipment.Make, Equipment.Model, 
       Location.Location, Contact.FirstName, 
       Contact.LastName, AcquisitionType.AcquisitionType, Location.Address,
       Location.City, Location.ProvinceId, Location.Country, 
       EqType.EqType, Contact.Phone, Contact.Fax, 
       Contact.Email, Contact.UserName
FROM  dbo.EqType EqType 
RIGHT OUTER JOIN dbo.Equipment Equipment 
ON EqType.EqTypeId = Equipment.EqTypeId 
    RIGHT OUTER JOIN dbo.Inventory Inventory 
    ON Equipment.EqId = Inventory.EqId 
        LEFT OUTER JOIN dbo.AcquisitionType AcquisitionType 
        ON Inventory.AcquisitionTypeID = AcquisitionType.AcquisitionTypeId
          LEFT OUTER JOIN dbo.Location Location
          ON Inventory.LocationId = Location.LocationId
            LEFT OUTER JOIN dbo.Contact Contact 
            ON Inventory.OwnerId = Contact.ContactId
*/
select * from vEquipmentFull
order by Location, LastName, FirstName

-- now, let''s do record sorting

---- Make, Model -------------------
create table #tmp (SID int identity(1,1),
                     ID int)
insert into #tmp(ID)
select ID
from #inv
order by Make, Model

update #inv
set MakeModelSIdx = #tmp.SId
from #inv inner join #tmp
on #inv.ID = #tmp.id

drop table #tmp

----------------------------------------
---- CountrySIdx: Country, Province, City, Location -------------------
create table #tmp2 (SID int identity(1,1),
                    ID int)
insert into #tmp2(ID)
select ID
from #inv
order by Country, ProvinceId, City, Location 

update #inv
set CountrySIdx = #tmp2.SId
from #inv inner join #tmp2
on #inv.ID = #tmp2.id
  
drop table #tmp2
----------------------------------------
---- LFNameSIdx: LName, FName -------------------
create table #tmp3 (SID int identity(1,1),
                    ID int)    
insert into #tmp3(ID)
select ID
from #inv
order by LastName, FirstName

update #inv
set LFNameSIdx = #tmp3.SId
from #inv inner join #tmp3
on #inv.ID = #tmp3.id
  
drop table #tmp3
----------------------------------------

-- use transaction to hide operation from users
Select @intTransactionCountOnEntry = @@TranCount
BEGIN TRANSACTION

-- recreate table
if exists (select * from dbo.sysobjects 
           where id = object_id(N''[InventorySum]'') 
           and OBJECTPROPERTY(id, N''IsUserTable'') = 1)
   drop table dbo.[InventorySum]

create table dbo.InventorySum(ID int,
            InventoryId int,   
            Make varchar(50),   
            Model varchar(50), 
            Location varchar(50),     
            FirstName varchar(30), 
            LastName varchar(30), 
            AcquisitionType varchar(12), 
            Address varchar(50),     
            City varchar(50),
            ProvinceId char(3), 
            Country varchar(50),
            EqType varchar(50),
            Phone varchar(20), 
            Fax varchar(20), 
            Email varchar(128),
            UserName varchar(50),
            MakeModelSIdx  int,
            LFNameSIdx int,
            CountrySIdx int)

-- populate table
insert into dbo.InventorySum (ID,
            InventoryId, Make, Model, 
            Location, FirstName, LastName,
            AcquisitionType, Address, City,
            ProvinceId, Country, EqType,
            Phone, Fax, Email,
            UserName, MakeModelSIdx, LFNameSIdx,
            CountrySIdx)
select  ID, InventoryId, Make, Model, 
        Location, FirstName, LastName,
        AcquisitionType, Address, City,
        ProvinceId, Country, EqType,
        Phone, Fax, Email,
        UserName, MakeModelSIdx, LFNameSIdx,
        CountrySIdx
from #inv

-- create indexes
CREATE UNIQUE CLUSTERED INDEX [idx_InvSum_Id] 
ON [dbo].[InventorySum] ([ID])

CREATE INDEX [idx_InvSum_LFName] 
ON [dbo].[InventorySum] (LastName, FirstName)

CREATE INDEX [idx_InvSum_Location] 
ON [dbo].[InventorySum] (Location)

CREATE INDEX [idx_InvSum_ModelMakeEqType] 
ON [dbo].[InventorySum] (Model, Make, EqType)

-- complete transaction - give access to users
If @@TranCount > @intTransactionCountOnEntry
    COMMIT TRANSACTION

return

' 
END
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysdiagrams]') AND type in (N'U'))
--BEGIN
--CREATE TABLE [dbo].[sysdiagrams](
--	[name] [sysname] NOT NULL,
--	[principal_id] [int] NOT NULL,
--	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
--	[version] [int] NULL,
--	[definition] [varbinary](max) NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[diagram_id] ASC
--)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY],
-- CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
--(
--	[principal_id] ASC,
--	[name] ASC
--)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--END
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_OrdersByCountry_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_OrdersByCountry_List]
      @Country char(3)
With Recompile
as
      Select *
      from Orders
      where Country =  @Country
' 
END
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Proc1]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[ap_Proc1]
--as
--select * from T1
--' 
--END
--GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[test]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'-- VDT file name: C:\Documents and Settings\dsunderic.LG\My Documents\Visual Studio 2005\Projects\VbTriggers\VbTriggers\Test Scripts\Test.sql
--create proc [dbo].[test]
--as 
--exec sp_who;
--
--' 
--END
--GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_diagramobjects]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'
--	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
--	RETURNS int
--	WITH EXECUTE AS N''dbo''
--	AS
--	BEGIN
--		declare @id_upgraddiagrams		int
--		declare @id_sysdiagrams			int
--		declare @id_helpdiagrams		int
--		declare @id_helpdiagramdefinition	int
--		declare @id_creatediagram	int
--		declare @id_renamediagram	int
--		declare @id_alterdiagram 	int 
--		declare @id_dropdiagram		int
--		declare @InstalledObjects	int
--
--		select @InstalledObjects = 0
--
--		select 	@id_upgraddiagrams = object_id(N''dbo.sp_upgraddiagrams''),
--			@id_sysdiagrams = object_id(N''dbo.sysdiagrams''),
--			@id_helpdiagrams = object_id(N''dbo.sp_helpdiagrams''),
--			@id_helpdiagramdefinition = object_id(N''dbo.sp_helpdiagramdefinition''),
--			@id_creatediagram = object_id(N''dbo.sp_creatediagram''),
--			@id_renamediagram = object_id(N''dbo.sp_renamediagram''),
--			@id_alterdiagram = object_id(N''dbo.sp_alterdiagram''), 
--			@id_dropdiagram = object_id(N''dbo.sp_dropdiagram'')
--
--		if @id_upgraddiagrams is not null
--			select @InstalledObjects = @InstalledObjects + 1
--		if @id_sysdiagrams is not null
--			select @InstalledObjects = @InstalledObjects + 2
--		if @id_helpdiagrams is not null
--			select @InstalledObjects = @InstalledObjects + 4
--		if @id_helpdiagramdefinition is not null
--			select @InstalledObjects = @InstalledObjects + 8
--		if @id_creatediagram is not null
--			select @InstalledObjects = @InstalledObjects + 16
--		if @id_renamediagram is not null
--			select @InstalledObjects = @InstalledObjects + 32
--		if @id_alterdiagram  is not null
--			select @InstalledObjects = @InstalledObjects + 64
--		if @id_dropdiagram is not null
--			select @InstalledObjects = @InstalledObjects + 128
--		
--		return @InstalledObjects 
--	END
--	' 
--END
--
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[fnSafeDynamicString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [util].[fnSafeDynamicString] 
-- make string parameters safe for use in dynamic strings
   (@chvInput nvarchar(max),
    @bitLikeSafe bit = 0) -- set to 1 if string will be used in LIKE
RETURNS nvarchar(max)
AS
BEGIN
   declare @chvOutput nvarchar(max)
   set @chvOutput = Replace(@chvInput, char(39), char(39) + char(39))
   if @bitLikeSafe = 1
   begin
      -- convert square bracket
      set @chvOutput = Replace(@chvOutput, ''['', ''[[]'')
      -- convert wild cards
      set @chvOutput = Replace(@chvOutput, ''%'', ''[%]'')
      set @chvOutput = Replace(@chvOutput, ''_'', ''[_]'')
   end
   RETURN (@chvOutput)
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_DataGenerator]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [util].[ap_DataGenerator]
-- generate a set of Insert statements
-- that can reproduce content of the table.
-- It does not handle very very long columns.
   @table sysname = ''Inventory'',
   @debug int = 0
-- debug:  exec util.ap_DataGenerator @table  = ''Inventory'', @debug = 1
as

declare @chvVal varchar(max)
declare @chvSQL varchar(max)
declare @chvColList varchar(max)
declare @intColCount smallint
declare @i smallint

set @chvColList = ''''
set @chvVal = ''''

select @intColCount = Max([ORDINAL_POSITION]),
		@i = 1
FROM     [INFORMATION_SCHEMA].[COLUMNS]
where    [TABLE_NAME] = @table

while @i <= @intColCount
begin
	SELECT @chvVal = @chvVal  
	+ ''+'''',''''+case when '' + [COLUMN_NAME] 
--	+ '''''',''''case when '' + [COLUMN_NAME] 
	+ '' is null then ''''null'''' else ''
	+ case when DATA_TYPE in (''varchar'', ''nvarchar'', ''datetime'',
								''smalldatetime'', ''char'', ''nchar'')
						then ''''''''''''''''''+convert(varchar(max),''
			else ''+ convert(varchar(max),''
		end
	+ convert(varchar(max),[COLUMN_NAME])
	+ case when DATA_TYPE in (''varchar'', ''nvarchar'', ''datetime'',
								''smalldatetime'',''char'', ''nchar'')
						then '')+''''''''''''''''''
			else '')''
		end 
	+ '' end ''
	FROM     [INFORMATION_SCHEMA].[COLUMNS]
	where    [TABLE_NAME] = @table
	and [ORDINAL_POSITION] = @i


--	if @debug <> 0 select @chvVal [@chvVal]

	-- get column list
	SELECT   @chvColList = @chvColList  
						+ '','' + convert(varchar(max),[COLUMN_NAME])
	FROM     [INFORMATION_SCHEMA].[COLUMNS]
	where    [TABLE_NAME] = @table
	and [ORDINAL_POSITION] = @i

	set @i = @i + 1
end

if @debug <> 0 select @chvColList [@chvColList]
if @debug <> 0 select @chvVal [@chvVal]

-- remove first comma
set @chvColList = substring(@chvColList, 2, len(@chvColList))

set @chvVal = substring(@chvVal, 6, len(@chvVal))


-- assemble a command to query the table to assemble everything
set @chvSQL = ''select ''''Insert dbo.'' + @table 
      + ''('' + @chvColList +'') values (''''+''
      + @chvVal + '' + '''')''''from '' +@table

-- get result
if @debug <> 0 select @chvSQL chvSQL
exec(@chvSQL)

return' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeasePeriodDuration_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_LeasePeriodDuration_Get]
-- return approximate number of days associated with lease frequency
     @inyScheduleFrequencyId tinyint,
     @insDays smallint OUTPUT
As
Declare @chvScheduleFrequency varchar(50)

Select @chvScheduleFrequency = ScheduleFrequency
From dbo.ScheduleFrequency
where ScheduleFrequencyId = @inyScheduleFrequencyId
select @insDays =
     Case @chvScheduleFrequency
          When ''monthly'' then 30
          When ''semi-monthly'' then 15
          When ''bi-weekly'' then 14
          When ''weekly'' then 7
          When ''quarterly'' then 92
          When ''yearly'' then 365
     END
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryProperties_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[ap_InventoryProperties_Get]
/************************************************************
Return comma-delimited list of properties that are describing asset.
i.e.: Property = Value Unit;Property = Value Unit;Property = Value
 Unit;Property = Value Unit;Property = Value Unit;...

test:
declare @p varchar(max)
exec ap_InventoryProperties_Get 5, @p OUTPUT, 1
select @p
*************************************************************/
     (
          @intInventoryId int,
          @chvProperties varchar(max) OUTPUT,
          @debug int = 0
     )

As

declare @intCountProperties int,
        @intCounter int,
        @chvProperty varchar(50),
        @chvValue varchar(50),
        @chvUnit varchar(50),
		@chvProcedure sysname

set @chvProcedure = ''ap_InventoryProperties_Get''

if @debug <> 0
     select ''**** ''+ @chvProcedure + ''START ****''


Create table #Properties(
          Id int identity(1,1),
          Property varchar(50),
          Value varchar(50),
          Unit varchar(50))

-- identify Properties associated with asset
insert into #Properties (Property, Value, Unit)
     select Property, Value, Unit
     from dbo.InventoryProperty InventoryProperty 
        inner join dbo.Property Property
        on InventoryProperty.PropertyId = Property.PropertyId
     where InventoryProperty.InventoryId = @intInventoryId

if @debug = 1
	select * from #Properties 

-- set loop
select @intCountProperties = Count(*),
       @intCounter = 1,
       @chvProperties = ''''
from #Properties

-- loop through list of properties
while @intCounter <= @intCountProperties
begin
     -- get one property
     select @chvProperty = Property,
          @chvValue = Value,
          @chvUnit = Unit
     from #Properties
     where Id = @intCounter

     if @debug <> 0
          select    @chvProperty Property,
                    @chvValue [Value],
                    @chvUnit [Unit]

     -- assemble list
     set @chvProperties = @chvProperties + ''; ''
                         + @chvProperty + ''=''
                         + @chvValue + '' '' +  ISNULL(@chvUnit, '''')

     -- let''s go another round and get another property
     set @intCounter = @intCounter + 1
end

if Substring(@chvProperties, 0, 2) = ''; ''
	set @chvProperties = Right(@chvProperties, Len(@chvProperties) - 2)

drop table #Properties

if @debug <> 0
     select ''**** ''+ @chvProcedure + ''END ****''

return 0

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_TempTbl2Varchar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [util].[ap_TempTbl2Varchar]
-- Convert information from #List temporary table to a single varchar
     @chvResult varchar(max) output
As
set nocount on

declare   @intCountItems int,
          @intCounter int,
          @chvItem varchar(255) 

-- set loop
select @intCountItems = Count(*),
       @intCounter = 1,
       @chvResult = ''''
from #List

-- loop through list of items
while @intCounter <= @intCountItems
begin
     -- get one property
     select @chvItem = Item
     from #List
     where Id = @intCounter

     -- assemble list
     set @chvResult = @chvResult + @chvItem

     -- let''s go another round and get another item
     set @intCounter = @intCounter + 1
end

return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_Cursor2Varchar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [util].[ap_Cursor2Varchar]
-- Process information from cursor initiated in calling sp.
-- Convert records into a single varchar.
     (
          @chvResult varchar(max) OUTPUT,
          @debug int = 0
     )

As


Declare   @chvItem varchar(255)

set @chvResult = ''''

Fetch Next From curItems
Into @chvItem

While (@@FETCH_STATUS = 0)
Begin

     If @debug <> 0
          Select @chvItem Item

     -- assemble list
     Set @chvResult = @chvResult + @chvItem

     If @debug <> 0
          Select @chvResult chvResult

     Fetch Next From curItems
     Into @chvItem

End

Return 0

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_Tables_BcpOut]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [util].[ap_Tables_BcpOut]
--loop through tables and export them to text files
     @debug int = 0
As

Declare   @chvTable varchar(128),
          @chvCommand varchar(255)

Declare @curTables Cursor

-- get all USER-DEFINED tables from current database
Set @curTables = Cursor FOR
    select name
     from sysobjects
     where xType = ''U''

Open @curTables

-- get first table
Fetch Next From @curTables
Into @chvTable

-- if we successfully read the current record
While (@@fetch_status = 0)
Begin

     -- assemble DOS command for exporting table
     Set @chvCommand = ''bcp "Asset5..['' + @chvTable
                     + '']" out D:\backup\'' + @chvTable
                     + ''.txt -c -q -Sdejan -Usa -Pdejan''
     -- during test just display command
     If @debug <> 0
          Select @chvCommand chvCommand

     -- in production execute DOS command and export table
     If @debug = 0
        Execute master.dbo.xp_cmdshell @chvCommand, NO_OUTPUT

     Fetch Next From @curTables
     Into @chvTable

End

Close @curTables
Deallocate @curTables

Return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_NonSelectedDBOption_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [util].[ap_NonSelectedDBOption_List]
-- return list of non-selected database options
-- test: exec util.ap_NonSelectedDBOption_List Asset5
(
     @chvDBName sysname
)
As

Set Nocount On

Create Table #setable (name nvarchar(35))
Create Table #current (name nvarchar(35))

-- collect all options
Insert Into #setable
     Exec sp_dboption

-- collect current options
Insert Into #current
     Exec sp_dboption @dbname = @chvDBName

-- return non-selected
Select name non_selected
From #setable
Where name not in (Select name From #current)

Drop Table #setable
Drop Table #current

Return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_LogSpacePercentUsed_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [util].[ap_LogSpacePercentUsed_Get]
/*
-- return percent of space used in transaction log for
-- specified database

--test: 
declare @fltUsed float
exec util.ap_LogSpacePercentUsed_Get ''Asset5'', @fltUsed OUTPUT
select @fltUsed Used
*/
     (
          @chvDbName sysname,
          @fltPercentUsed float OUTPUT
     )
As
Set Nocount On


     Create Table #DBLogSpace
          (    dbname sysname,
               LogSizeInMB float,
               LogPercentUsed float,
               Status int
          )

-- get log space info. for all databases
     Insert Into #DBLogSpace
          Exec (''DBCC SQLPERF (LogSpace)'')

-- get percent for specified database
     select @fltPercentUsed = LogPercentUsed
     from #DBLogSpace
     where dbname = @chvDbName


drop table #DBLogSpace

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ScrapOrder_Save]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_ScrapOrder_Save]
-- save order information.

     @dtsOrderDate smalldatetime,
     @intRequestedById int,
     @dtsTargetDate smalldatetime,
     @chvNote varchar(200),
     @insOrderTypeId smallint,
     @inyOrderStatusId tinyint
As
     Set nocount on

     Insert dbo.[Order](OrderDate,   RequestedById,
                        TargetDate,  Note,
                        OrderTypeId, OrderStatusId)
     Values (@dtsOrderDate,      @intRequestedById,
             @dtsTargetDate,     @chvNote,
             @insOrderTypeId,    @inyOrderStatusId)

Return @@identity
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_SpaceUsedByTables_4]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [util].[ap_SpaceUsedByTables_4]
-- loop through table names in current database
     -- display info about amount of space used by each table

-- demonstration of while loop

As
Set nocount on
Declare @TableName sysname

-- get first table name
Select @TableName = Min(name)
From sys.sysobjects
Where xtype = ''U''

While @TableName is not null
Begin

     -- display space used
     Exec sp_spaceused  @TableName

     -- get next table
     Select @TableName = Min(name)
     From sys.sysobjects
     Where xtype = ''U''
     And name > @TableName
End

Return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EqType2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EqType2](
	[EqTypeId] [smallint] NOT NULL,
	[EqType] [varchar](30) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EqType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EqType](
	[EqTypeId] [smallint] IDENTITY(1,1) NOT NULL,
	[EqType] [varchar](30) NOT NULL,
 CONSTRAINT [PK_EqType] PRIMARY KEY CLUSTERED 
(
	[EqTypeId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Trigger [itrEqType_D]
On [dbo].[EqType]
instead of Delete
As
If exists(select *
     from Equipment
     where EqTypeId in (select EqTypeId
                        from deleted)
     )
     raiserror('Some recs in EqType are in use in Equipment table!',
               16, 1)
else
     delete EqType
     where EqTypeId in (select EqTypeId from deleted)

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryCount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryCount](
	[LocationId] [int] NOT NULL,
	[InvCount] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AcquisitionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AcquisitionType](
	[AcquisitionTypeId] [tinyint] NOT NULL,
	[AcquisitionType] [varchar](20) NOT NULL,
 CONSTRAINT [PK_AcquisitionType] PRIMARY KEY CLUSTERED 
(
	[AcquisitionTypeId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Action]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Action](
	[ActionId] [smallint] NOT NULL,
	[Action] [varchar](20) NOT NULL,
	[Cost] [smallmoney] NULL,
 CONSTRAINT [PK_Action] PRIMARY KEY CLUSTERED 
(
	[ActionId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Contact](
	[ContactId] [int] NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
	[LastName] [varchar](30) NOT NULL,
	[Phone] [varchar](20) NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](128) NULL,
	[OrgUnitId] [smallint] NOT NULL,
	[UserName] [varchar](50) NULL,
	[ts] [binary](16) NULL
) ON [PRIMARY]
END
GO

--IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo.ctr_Contact_iu]'))
--EXECUTE dbo.sp_executesql N'
--CREATE TRIGGER [dbo.ctr_Contact_iu] ON [dbo].[Contact]  AFTER  INSERT, UPDATE AS 
--EXTERNAL NAME [CSrpTrigger].[Triggers].[ctr_Contact_iu]
--'
--GO

--IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo.ctr_Contact_iu_Email]'))
--EXECUTE dbo.sp_executesql N'
--CREATE TRIGGER [dbo.ctr_Contact_iu_Email] ON [dbo].[Contact]  AFTER  INSERT, UPDATE AS 
--EXTERNAL NAME [CSrpTrigger].[Triggers].[ctr_Contact_iu_Email]
--'
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'surrogate identifiers of contacts' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'COLUMN', @level2name=N'ContactId'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'persons that are in relationships in Asset' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'TRIGGER', @level2name=N'dbo.ctr_Contact_iu'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'Trigger1.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'TRIGGER', @level2name=N'dbo.ctr_Contact_iu'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=14 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'TRIGGER', @level2name=N'dbo.ctr_Contact_iu'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'TRIGGER', @level2name=N'dbo.ctr_Contact_iu_Email'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'TriggerValidateEmail.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'TRIGGER', @level2name=N'dbo.ctr_Contact_iu_Email'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=11 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'Contact', @level2type=N'TRIGGER', @level2name=N'dbo.ctr_Contact_iu_Email'
--
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact_with_BC]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Contact_with_BC](
	[ContactId] [int] NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
	[LastName] [varchar](30) NOT NULL,
	[Phone] [varchar](20) NULL,
	[Fax] [varchar](20) NULL,
	[Email] [varchar](128) NULL,
	[OrgUnitId] [smallint] NOT NULL,
	[UserName] [varchar](50) NULL,
	[ts] [binary](8) NULL,
	[BC] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[util].[vSpaceUsed]'))
EXEC dbo.sp_executesql @statement = N'
create view [util].[vSpaceUsed]
as
select  distinct TOP 100 PERCENT
       db_name()            as TABLE_CATALOG
    , user_name(obj.uid)    as TABLE_SCHEMA
    , obj.name                as TABLE_NAME
    , case obj.xtype
        when ''U'' then ''BASE TABLE''
        when ''V'' then ''VIEW''
    end                    as TABLE_TYPE
    , obj.ID                as TABLE_ID
    , Coalesce((select sum(reserved) 
                from sysindexes i1
                where i1.id = obj.id
                and i1.indid in (0, 1, 255)) 
            *    (select d.low from master.dbo.spt_values d
                where d.number = 1 and d.type = ''E'')
        , 0)            as RESERVED
    , Coalesce((select Sum (reserved) - sum(used) 
                from sysindexes i2
                where i2.indid in (0, 1, 255)
                and id = obj.id)  
            * (select d.low from master.dbo.spt_values d 
                where d.number = 1    and d.type = ''E'')
        , 0)            as UNUSED
    , case obj.xtype
        when ''U'' then Coalesce((select i3.rows
                                from sysindexes i3
                                where i3.indid < 2
                                and i3.id = obj.id), 0)
        when ''V'' then NULL
       end                as [ROWS]
,     Coalesce
    (    (    (select sum(dpages)    from sysindexes
                where indid < 2 and id = obj.id
            ) + (select isnull(sum(used), 0) from sysindexes 
                where indid = 255 and id = obj.id
                )
        ) * (select d.low from master.dbo.spt_values d 
                where d.number = 1 and d.type = ''E''
            ), 0)        as [DATA]
    , Coalesce(
        ((select sum(reserved) 
        from sysindexes i1
        where i1.id = obj.id
        and i1.indid in (0, 1, 255)
        ) - ( (select sum(dpages) from sysindexes
                where indid < 2 and id = obj.id
              ) + (select isnull(sum(used), 0) from sysindexes
                    where indid = 255 and id = obj.id)
            ) )
    * (select d.low from master.dbo.spt_values d 
        where d.number = 1 and d.type = ''E'')
        , 0)             as [INDEX]
from sysobjects obj
where obj.xtype in (''U'', ''V'') 
and    permissions(obj.id) != 0
order by db_name(), user_name(obj.uid), obj.name

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EquipmentBC]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EquipmentBC](
	[EqId] [int] NOT NULL,
	[EqBC] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Msg]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Msg](
	[service_instance_id] [uniqueidentifier] NULL,
	[handle] [uniqueidentifier] NULL,
	[message_sequence_number] [bigint] NULL,
	[service_name] [nvarchar](512) NULL,
	[service_contract_name] [nvarchar](256) NULL,
	[message_type_name] [nvarchar](256) NULL,
	[validation] [nchar](1) NULL,
	[message_body] [varbinary](max) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryProperty]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryProperty](
	[InventoryId] [int] NOT NULL,
	[PropertyId] [smallint] NOT NULL,
	[Value] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryPrim]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryPrim](
	[Inventoryid] [int] NOT NULL,
	[Make] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[FirstName] [varchar](30) NULL,
	[LastName] [varchar](30) NULL,
	[UserName] [varchar](50) NULL,
	[EqType] [varchar](50) NULL,
 CONSTRAINT [PK_InventoryPrim] PRIMARY KEY CLUSTERED 
(
	[Inventoryid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryXML]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryXML](
	[Inventoryid] [int] NOT NULL,
	[EquipmentId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[StatusId] [tinyint] NOT NULL,
	[LeaseId] [int] NULL,
	[LeaseScheduleId] [int] NULL,
	[OwnerId] [int] NOT NULL,
	[Rent] [smallmoney] NULL,
	[Lease] [smallmoney] NULL,
	[Cost] [smallmoney] NULL,
	[AcquisitionTypeID] [tinyint] NULL,
	[Properties] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lease]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Lease](
	[LeaseId] [int] NOT NULL,
	[LeaseVendor] [varchar](50) NOT NULL,
	[LeaseNumber] [varchar](50) NULL,
	[ContractDate] [smalldatetime] NOT NULL,
	[TotalValue] [money] NULL,
 CONSTRAINT [PK_Lease] PRIMARY KEY CLUSTERED 
(
	[LeaseId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LeaseFrequency]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LeaseFrequency](
	[LeaseFrequencyId] [tinyint] NOT NULL,
	[LeaseFrequency] [varchar](20) NOT NULL,
 CONSTRAINT [PK_LeaseFrequency] PRIMARY KEY CLUSTERED 
(
	[LeaseFrequencyId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderType](
	[OrderTypeId] [smallint] NOT NULL,
	[OrderType] [varchar](15) NULL,
 CONSTRAINT [PK_OrderType] PRIMARY KEY CLUSTERED 
(
	[OrderTypeId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrgUnit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrgUnit](
	[OrgUnitId] [smallint] NOT NULL,
	[OrgUnit] [varchar](50) NOT NULL,
	[ParentOrgUnitId] [smallint] NULL,
 CONSTRAINT [PK_OrgUnit] PRIMARY KEY CLUSTERED 
(
	[OrgUnitId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PriceList](
	[EqId] [int] NOT NULL,
	[Price] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[EqId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Part]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Part](
	[PartId] [int] NOT NULL,
	[Make] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[Type] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Property]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Property](
	[PropertyId] [smallint] NOT NULL,
	[Property] [varchar](50) NOT NULL,
	[Unit] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Sales](
	[OrderItemId] [int] IDENTITY(1,1) NOT NULL,
	[EqId] [int] NULL,
	[UnitPrice] [money] NULL,
	[Qty] [int] NULL,
	[ExtPrice] [money] NULL,
	[SalesDate] [smalldatetime] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Province]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Province](
	[ProvinceId] [char](3) NOT NULL,
	[Province] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Province] PRIMARY KEY CLUSTERED 
(
	[ProvinceId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Status]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Status](
	[StatusId] [tinyint] NOT NULL,
	[Status] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderStatus](
	[OrderStatusId] [tinyint] NOT NULL,
	[OrderStatus] [varchar](20) NOT NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[OrderStatusId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_BatchExec_OA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [util].[ap_BatchExec_OA]
-- Execute all sql files in the specified folder using the alphabetical order.
-- Demonstration of use of OLE Automation.
      @ServerName sysname = ''(local)\rc'',
      @UserId sysname = ''sa'',
      @PWD sysname = ''my,password'',
      @DirName varchar(400)=''C:\sql\test'',
      @File varchar(400) = ''list.txt'',
      @UseTransaction int = 0
as 

set nocount on

declare @FileSystemObject int,
        @objSQL int,
        @hr int,
        @property varchar(255),
        @return varchar(255),
        @TextStream int,
        @BatchText varchar(8000),
        @FilePath varchar(500),
        @ScriptId varchar(200),
        @Cmd varchar(1000)

--- Get list of files
create table #FileList (ScriptId int identity(1,1), 
                        FileName varchar(500))

select  @Cmd = ''cd '' + @DirName + '' & type '' + @File

insert #FileList (FileName)
exec master.sys.xp_cmdshell @Cmd

-- remove empty rows and comments
delete #FileList where FileName is null
delete #FileList where FileName like ''--%''

-- prepare COM to connect to SQL Server
EXEC @hr = sp_OACreate ''SQLDMO.SQLServer'', @objSQL OUTPUT
IF @hr < 0
BEGIN
   print ''error create SQLDMO.SQLServer''
   exec sys.sp_OAGetErrorInfo @objSQL, @hr
   RETURN
END

EXEC @hr = sp_OAMethod @objSQL, ''Connect'', NULL, @ServerName, @UserId, @PWD
IF @hr < 0
BEGIN
   print ''error Connecting''
   exec sys.sp_OAGetErrorInfo @objSQL, @hr
   RETURN
END
 
EXEC @hr = sp_OAMethod @objSQL, ''VerifyConnection'', @return OUTPUT
IF @hr < 0
BEGIN
   print ''error verifying connection''
   exec sys.sp_OAGetErrorInfo @objSQL, @hr
   RETURN
END

-- prepare file system object 
EXEC @hr = sp_OACreate ''Scripting.FileSystemObject'', @FileSystemObject OUTPUT
IF @hr < 0
BEGIN
   print ''error create FileSystemObject''
   exec sp_OAGetErrorInfo @FileSystemObject, @hr
   RETURN
END

-- begin transaction
if @UseTransaction <> 0
BEGIN 
   EXEC @hr = sp_OAMethod @objSQL, ''BeginTransaction ''
   IF @hr < 0
   BEGIN
      print ''error BeginTransaction''
      exec sp_OAGetErrorInfo @objSQL, @hr
      RETURN
   END
END

-- iterate through the temp table to get actual file names
select @ScriptId = Min (ScriptId) from #FileList

WHILE @ScriptId is not null
BEGIN
   select @FilePath = @DirName + ''\'' + FileName 
   from #FileList where ScriptId = @ScriptId
    if @FilePath <> ''''
    BEGIN
      print ''Executing '' + @FilePath
      
      EXEC @hr = sp_OAMethod @FileSystemObject, ''OpenTextFile'', 
                             @TextStream output, @FilePath
      IF @hr < 0
      BEGIN
         print ''Error opening TextFile '' + @FilePath
         exec sp_OAGetErrorInfo @FileSystemObject, @hr
         RETURN
      END
   
      EXEC @hr = sp_OAMethod @TextStream, ''ReadAll'', @BatchText output
      IF @hr < 0
      BEGIN
           print ''Error using ReadAll method.''
           exec sp_OAGetErrorInfo @TextStream, @hr
         RETURN
      END
   
      -- print @BatchText
      -- run it.   
      EXEC @hr = sp_OAMethod @objSQL, ''ExecuteImmediate'', Null , @BatchText
      IF @hr <> 0
      BEGIN
         if @UseTransaction <> 0
         BEGIN 
              EXEC @hr = sp_OAMethod @objSQL, ''RollbackTransaction ''
            IF @hr < 0
               BEGIN
                  print ''error RollbackTransaction''
                  exec sp_OAGetErrorInfo @objSQL, @hr
               RETURN
            END
         END
         print ''Error ExecuteImmediate.'' --Transaction will be rolled back.''
         exec sp_OAGetErrorInfo @objSQL, @hr
         RETURN
      END
   
      EXECUTE sp_OADestroy @TextStream
   END

   print ''Finished executing '' + @FilePath
   
   select @ScriptId = Min(ScriptId) from #FileList where ScriptId > @ScriptId
end

print ''Finished executing all files.''
drop table #FileList
EXECUTE sp_OADestroy @FileSystemObject

if @UseTransaction <> 0
BEGIN 
   EXEC @hr = sp_OAMethod @objSQL, ''CommitTransaction ''
   IF @hr < 0
   BEGIN
      print ''error CommitTransaction''
      exec sp_OAGetErrorInfo @objSQL, @hr
      RETURN
   END
END

RETURN 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_BatchExec5]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[ap_BatchExec5]
-- Execute all sql files in the specified folder using the order in the list file.
    @ServerName sysname = ''.\rc'',
    @UserId sysname = ''sa'',
    @PWD sysname = ''my,password'',
    @DirName varchar(400)=''C:\sql\test'',
    @File varchar(400) = ''list.txt'',
    @UseTransaction int = 0,
    @debug int = 0
as

set nocount on

declare @FileSystemObject int,
        @objSQL int,
        @hr int,
        @property varchar(255),
        @return varchar(255),
        @TextStream int,
        @Text nvarchar(max),
        @BatchText nvarchar(max),
        @FilePath varchar(500),
        @ScriptId varchar(200),
        @Cmd varchar(1000),
        @i int,
        @max int

--- Get list of files
create table #FileList (ScriptId int identity(1,1),
                        FileName varchar(500))

select  @Cmd = ''cd '' + @DirName + '' & type '' + @File

insert #FileList (FileName)
exec master.sys.xp_cmdshell @Cmd

-- remove empty rows and comments
delete #FileList where FileName is null
delete #FileList where FileName like ''--%''

if @debug <> 0
	select * from #FileList


create table #t (SQL varchar(max),ScriptId int )
create table #t2 (SQL varchar(max), ScriptId int identity)
select @ScriptId = Min (ScriptId) from #FileList

-- loop throguh files
WHILE @ScriptId is not null
BEGIN
	-- get name of the file to be processed
    select @FilePath = @DirName + ''\'' + FileName 
    from #FileList 
    where ScriptId = @ScriptId
    
    if @FilePath <> ''''
    BEGIN
      if @debug <> 0
		print ''Reading '' + @FilePath

        select  @Cmd = ''type "'' + @FilePath + ''"''

        insert into #t2 (SQL)
        exec master.sys.xp_cmdshell @Cmd
 
        delete #t2 
        where SQL is null


--        insert into #t2
--        Select a.* from (SELECT *
--        FROM OPENROWSET(BULK ''C:\SQL\test.dbs'', SINGLE_BLOB)as a)
        
--        SELECT *
--        FROM OPENROWSET(BULK ''C:\SQL\test\LIST.txt'', SINGLE_BLOB)AS a 
 
        select @ScriptId = Min(ScriptId) 
        from #FileList 
        where ScriptId > @ScriptId
    END
END

--if @debug <> 0
--	select * from #t

--if @debug <> 0
	select * from #t2 order by ScriptId

set @BatchText = ''''
select @i = Min(ScriptId), @Max = Max(ScriptId) from #t2

while @i <= @max
begin
    
    select @BatchText = @BatchText + SQL + ''    --''+ Char(13) + Char(10)
    from #t2
    WHERE ScriptId = @i


    select @Text = SQL
    from #t2
    WHERE ScriptId = @i

--if @debug = 0
    exec sp_executesql @Text
--else
    select @Text T


    select  @i = Min(ScriptId)
    from #t2
    where ScriptId > @i

    
end

drop table #t2


-- now, execute the whole thing:
--if @debug = 0
--    exec sp_executesql @BatchText
--else
--    select @BatchText BT

return


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDeleted]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderDeleted](
	[OrderId] [int] NOT NULL,
	[OrderDate] [smalldatetime] NOT NULL,
	[RequestedById] [int] NOT NULL,
	[TargetDate] [smalldatetime] NOT NULL,
	[CompletionDate] [smalldatetime] NULL,
	[DestinationLocationId] [int] NULL,
	[Note] [varchar](max) NULL,
	[OrderTypeId] [smallint] NOT NULL,
	[OrderStatusid] [tinyint] NOT NULL,
	[OrderItemXML] [xml] NULL,
	[UserName] [sysname] NOT NULL,
	[ChangeDT] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_BatchExec6]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[ap_BatchExec6]
-- Execute all sql files in the specified folder using the alphabetical order.
-- Demonstration of use of OLE Automation.
    @ServerName sysname = ''.\rc'',
    @UserId sysname = ''sa'',
    @PWD sysname = ''my,password'',
    @DirName varchar(400)=''C:\sql\test'',
    @File varchar(400) = ''list.txt'',
    @UseTransaction int = 0,
    @debug int = 1
as

set nocount on

declare @Text nvarchar(max),
        @BatchText nvarchar(max),
        @FilePath varchar(500),
        @FileId int,
        @OldFileId int,
        @Cmd varchar(1000),
        @i int,
        @max int

--- Get list of files
create table #FileList (FileId int identity(1,1),
                        FileName varchar(500))

select  @Cmd = ''cd '' + @DirName + '' & type '' + @File

insert #FileList (FileName)
exec master.sys.xp_cmdshell @Cmd

-- remove empty rows and comments
delete #FileList where FileName is null
delete #FileList where FileName like ''--%''

--if @debug <> 0
	select * from #FileList


--create table #t (SQL varchar(max),ScriptId int )
create table #t2 (SQL varchar(max), LineId int identity)
insert #t2(SQL)
values (N''GO --'')

select @FileId = Min (FileId) from #FileList

-- loop throguh files
WHILE @FileId is not null
BEGIN
	-- get name of the file to be processed
    select @FilePath = @DirName + ''\'' + FileName 
    from #FileList 
    where FileId = @FileId
    
    if @FilePath <> ''''
    BEGIN
      if @debug <> 0
		print ''Reading '' + @FilePath

        select  @Cmd = ''type "'' + @FilePath + ''"''

        select @cmd

        set @BatchText = N''UPDATE #t2 
        SET SQL = (
        SELECT *
        FROM OPENROWSET(BULK '''''' + @FilePath + '''''', SINGLE_BLOB)AS a )'';

        --exec sp_executesql @BatchText;
        exec (@BatchText);

--        select * from #t2
--
--        delete #t2 
--        where SQL is null
--        delete #t2 
--        where SQL = ''null''
--        delete #t2 
--        where Rtrim(LTrim(SQL)) = ''''

        select @Text = SQL
        from #t2
--        order by LineId

        --if @debug = 0
            exec sp_executesql @Text
        --else
            select @Text T
--      truncate table #t2

        set @OldFileId = @FileId
 
        select @FileId = Min(FileId) 
        from #FileList 
        where FileId > @OldFileId

    END
END

return


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_BatchExec8]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[ap_BatchExec8]
-- Execute all sql files in the specified folder using the alphabetical order.
-- Demonstration of use of OLE Automation.
    @ServerName sysname = ''.\rc'',
    @UserId sysname = ''sa'',
    @PWD sysname = ''my,password'',
    @DirName varchar(400)=''C:\sql\test'',
    @File varchar(400) = ''list.txt'',
    @UseTransaction int = 0,
    @debug int = 0
as

set nocount on

declare @FilePath varchar(500),
        @FileId int,
        @MaxFileID int,
        @OldFileId int,
        @Cmd varchar(1000),
        @i int,
        @iOld int,
        @max int,
        @s varchar(max),
        @line varchar(max)

--- Get list of files
create table #FileList (FileId int identity(1,1),
                        FileName varchar(500))

select  @Cmd = ''cd '' + @DirName + '' & type '' + @File

insert #FileList (FileName)
exec master.sys.xp_cmdshell @Cmd

-- remove empty rows and comments
delete #FileList where FileName is null
delete #FileList where FileName like ''--%''

if @debug <> 0
	select * from #FileList

create table #script (SQL    varchar(max), 
                      LineId int identity)

select @FileId = Min (FileId),
       @MaxFileID = Max(FileId) 
from #FileList

-- loop throguh files
WHILE @FileId <= @MaxFileID 
BEGIN
	-- get name of the file to be processed
    select @FilePath = @DirName + ''\'' + FileName 
    from #FileList 
    where FileId = @FileId
    
    if @FilePath <> ''''
    BEGIN
        if @debug <> 0
            print ''Reading '' + @FilePath

        set @cmd = ''Type "'' + @FilePath + ''"''

        insert #script (SQL)
        exec master.sys.xp_cmdshell @Cmd

        Select  @i = Min (LineId),
                @max = Max(LineId),
                @s = ''''
        from #script

        while @i <= @max
        begin

            Select @line = Coalesce(SQL, '' '')
            from #script
            where LineId = @i

            if @debug <> 0
                select ''read line ='', @i i, @line line

            if Left(@line, 2) <> ''GO''
            begin
                -- the the line and go another round               
                select @s = @s + char(13) + char(10) + @line
                if @debug <> 0
                    select @s [@s]
            end 
            else
            begin    
                begin try
                    if @debug = 0
                        exec sp_sqlexec @s
                    else
                        select @s
                end try
                begin catch
                    print Error_message()
                    print ''Process stopped.''
                    return
                end catch
                set @s = ''''
            end
            -- contunue line by line
            set @iOld = @i
            select @i = Min(LineId)
            from #script
            where LineId > @iOld
        end


    END
    -- get next file
    set @FileID = @FileId + 1
    select @fileID FileId
    
    truncate table #script
END
return' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Data]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Data](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[num] [float] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[util].[ap_BatchExec8]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [util].[ap_BatchExec8]
-- Execute listed sql files.
    @ServerName sysname = ''.\rc'',
    @UserId sysname = ''sa'',
    @PWD sysname = ''my,password'',
    @DirName varchar(400)=''C:\sql\test'',
    @File varchar(400) = ''list.txt'',
    @UseTransaction int = 0,
    @debug int = 0
as

set nocount on

declare @FilePath varchar(500),
        @FileId int,
        @MaxFileID int,
        @OldFileId int,
        @Cmd varchar(1000),
        @i int,
        @iOld int,
        @max int,
        @s varchar(max),
        @line varchar(max)

--- Get list of files
create table #FileList (FileId int identity(1,1),
                        FileName varchar(500))

select  @Cmd = ''cd '' + @DirName + '' & type '' + @File

insert #FileList (FileName)
exec master.sys.xp_cmdshell @Cmd

-- remove empty rows and comments
delete #FileList where FileName is null
delete #FileList where FileName like ''--%''

if @debug <> 0
	select * from #FileList

create table #script (SQL    varchar(max), 
                      LineId int identity)

select @FileId = Min (FileId),
       @MaxFileID = Max(FileId) 
from #FileList

-- loop throguh files
WHILE @FileId <= @MaxFileID 
BEGIN
	-- get name of the file to be processed
    select @FilePath = @DirName + ''\'' + FileName 
    from #FileList 
    where FileId = @FileId
    
    if @FilePath <> ''''
    BEGIN
        if @debug <> 0
            print ''Reading '' + @FilePath

        set @cmd = ''Type "'' + @FilePath + ''"''

        insert #script (SQL)
        exec master.sys.xp_cmdshell @Cmd

        Select  @i = Min (LineId),
                @max = Max(LineId),
                @s = ''''
        from #script

        while @i <= @max
        begin

            Select @line = Coalesce(SQL, '' '')
            from #script
            where LineId = @i

            if @debug <> 0
                select ''read line ='', @i i, @line line

            if Left(@line, 2) <> ''GO''
            begin
                -- the the line and go another round               
                select @s = @s + char(13) + char(10) + @line
                if @debug <> 0
                    select @s [@s]
            end 
            else
            begin    
                begin try
                    if @debug = 0
                        exec sp_sqlexec @s
                    else
                        select @s
                end try
                begin catch
                    print Error_message()
                    print ''Process stopped.''
                    return
                end catch
                set @s = ''''
            end
            -- contunue line by line
            set @iOld = @i
            select @i = Min(LineId)
            from #script
            where LineId > @iOld
        end


    END
    -- get next file
    set @FileID = @FileId + 1
    select @fileID FileId
    
    truncate table #script
END
return' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ErrorLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ErrorLog](
	[ErrorId] [int] IDENTITY(1,1) NOT NULL,
	[ErrorNum] [int] NULL,
	[ErrorType] [char](1) NULL,
	[ErrorMsg] [varchar](255) NULL,
	[ErrorSource] [varchar](255) NULL,
	[CreatedBy] [nvarchar](255) NULL CONSTRAINT [DF_ErrorLog_CreatedBy]  DEFAULT (suser_sname()),
	[CreateDT] [datetime] NULL CONSTRAINT [DF_ErrorLog_CreateDT]  DEFAULT (getdate()),
	[ErrorState] [int] NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeasedAsset_Insert8]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_LeasedAsset_Insert8]
-- Insert leased asset and update total in LeaseSchedule.
-- (demonstration of SET XACT_ABORT ON solution)
           (
           @intEqId int,
           @intLocationId int,
           @intStatusId int,
           @intLeaseId int,
           @intLeaseScheduleId int,
           @intOwnerId int,
           @mnyLease money,
           @intAcquisitionTypeID int
           )
As
set nocount on
SET XACT_ABORT ON
begin transaction

-- insert asset
insert Inventory(EqId,                LocationId,
                 StatusId,            LeaseId,
                 LeaseScheduleId,     OwnerId,
                 Lease,               AcquisitionTypeID)
values (         @intEqId,            @intLocationId,
                 @intStatusId,        @intLeaseId,
                 @intLeaseScheduleId, @intOwnerId,
                 @mnyLease,           @intAcquisitionTypeID)

-- update total
update dbo.LeaseSchedule_NON_EXISTING_TABLE
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId

commit transaction
return (0)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActivityLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActivityLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[Activity] [varchar](50) NULL,
	[LogDate] [smalldatetime] NOT NULL,
	[UserName] [varchar](128) NOT NULL,
	[Note] [varchar](max) NULL,
 CONSTRAINT [PK_ActivityLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryByMakeModel_Quick_TempTbl]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_InventoryByMakeModel_Quick_TempTbl]
-- Return a batch (of specified size) of records which satisfy the criteria
-- Demonstration of use of temporary table to perform record set splitting.
  @Make varchar(50) = ''%'',
  @Model varchar(50) = ''%'',
  @FirstRec int = 1,
  @LastRec int = 25,
  @RowCount int = null output
AS
/* test:
declare @rc int 
exec ap_InventoryByMakeModel_Quick_TempTbl @RowCount = @rc output
select @rc
exec ap_InventoryByMakeModel_Quick_TempTbl @FirstRec = 26, 
                                          @LastRec = 50,
                                          @RowCount = @rc output
*/
SET NOCOUNT ON

Create table #Inv(ID int identity,
                  Inventoryid int,
                  Make varchar(50),
                  Model varchar(50),
                  Location varchar(50),
                  FirstName varchar(30),
                  LastName varchar(30),
                  AcquisitionType varchar(12),
                  Address varchar(50),
                  City varchar(50),
                  ProvinceId char(3),
                  Country varchar(50),
                  EqType varchar(50),
                  Phone varchar(20),
                  Fax varchar(20),
                  Email varchar(128),
                  UserName varchar(50))

insert into #Inv(InventoryId,     Make,      Model,
                 Location,        FirstName, LastName,
                 AcquisitionType, Address,   City, 
                 ProvinceId,      Country,   EqType, 
                 Phone,           Fax,       Email, 
                 UserName)
SELECT 
  Inventory.Inventoryid, Equipment.Make, Equipment.Model, 
  Location.Location, Contact.FirstName,  Contact.LastName, 
  AcquisitionType.AcquisitionType, Location.Address, Location.City, 
  Location.ProvinceId, Location.Country, EqType.EqType, 
  Contact.Phone, Contact.Fax, Contact.Email, 
  Contact.UserName
 FROM  dbo.EqType EqType 
  RIGHT OUTER JOIN dbo.Equipment Equipment 
  ON EqType.EqTypeId = Equipment.EqTypeId 
    RIGHT OUTER JOIN dbo.Inventory Inventory
    ON Equipment.EqId = Inventory.EqId 
      INNER JOIN dbo.Status Status
      ON Inventory.StatusId = Status.StatusId 
        LEFT OUTER JOIN dbo.AcquisitionType AcquisitionType 
        ON Inventory.AcquisitionTypeID = AcquisitionType.AcquisitionTypeId
          LEFT OUTER JOIN dbo.Location Location
          ON Inventory.LocationId = Location.LocationId 
            LEFT OUTER JOIN dbo.Contact Contact
            ON Inventory.OwnerId = Contact.ContactId
where Make Like @Make 
and Model Like @Model  
order by Location, LastName, FirstName

select @RowCount = @@rowcount

SELECT * 
FROM #Inv
WHERE ID >= @FirstRec AND ID <= @LastRec
order by ID
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryPropertyXML]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryPropertyXML](
	[Inventoryid] [int] NOT NULL,
	[EqId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[StatusId] [tinyint] NOT NULL,
	[LeaseId] [int] NULL,
	[LeaseScheduleId] [int] NULL,
	[OwnerId] [int] NOT NULL,
	[Rent] [smallmoney] NULL,
	[Lease] [smallmoney] NULL,
	[Cost] [smallmoney] NULL,
	[AcquisitionTypeID] [tinyint] NULL,
	[PropertiesXML] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[Inventoryid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryByMakeModel_Quick1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[ap_InventoryByMakeModel_Quick1]
  @Make varchar(50) = null,  -- criteria
  @Model varchar(50) = null  -- criteria
/* test:      
exec ap_InventoryByMakeModel_Quick1 ''Compaq'', ''D%''
*/
as

select Inventoryid ,    Make ,        Model, 
        Location ,       FirstName ,   LastName ,
        AcquisitionType, Address ,     City ,
        ProvinceId ,     Country ,     EqType ,
        Phone ,          Fax ,         Email ,
        UserName
from dbo.InventorySum
where Make LIKE @Make
and Model LIKE @Model
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryByMakeModel_Quick2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[ap_InventoryByMakeModel_Quick2]
  @Make varchar(50) = null,  -- criteria
  @Model varchar(50) = null,  -- criteria
  @SortOrderId smallint = 0

/* test:      
exec ap_InventoryByMakeModel_Quick2 ''Compaq'', ''D%'', 1
*/
as

  select Id = Case @SortOrderId 
              when 1 then MakeModelSIdx
              when 2 then CountrySIdx
              when 3 then LFNameSIdx
            End,
        Inventoryid ,    Make ,      Model,
        Location ,       FirstName , LastName ,
        AcquisitionType, Address ,   City ,
        ProvinceId ,     Country ,   EqType ,
        Phone ,          Fax ,       Email ,
        UserName        
  from InventorySum
  where Make like @Make
  and Model like @Model
  order by case @SortOrderId 
        when 1 then MakeModelSIdx
        when 2 then CountrySIdx 
        when 3 then LFNameSIdx 
       end
  return

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryByMakeModel_Quick3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[ap_InventoryByMakeModel_Quick3]
  @Make varchar(50) = null,   -- criteria
  @Model varchar(50) = null,  -- criteria
  @PreviousID int = 0,        -- last record from the previous batch
  @SortOrderId smallint = 0

/* test:
exec ap_InventoryByMakeModel_Quick3 ''Compaq'', ''D%'', 444, 1
*/
as

  select   top 25 Id = Case @SortOrderId 
              when 1 then MakeModelSIdx
              when 2 then CountrySIdx
              when 3 then LFNameSIdx
            End,
        Inventoryid ,    Make ,       Model, 
        Location ,       FirstName ,  LastName ,
        AcquisitionType, Address ,    City ,
        ProvinceId ,     Country ,    EqType ,
        Phone ,          Fax ,        Email ,
        UserName
  from dbo.InventorySum
  where Case @SortOrderId 
      when 1 then MakeModelSIdx
      when 2 then CountrySIdx
      when 3 then LFNameSIdx
    End > @PreviousID 
  and Make like @Make
  and Model like @Model
  order by case @SortOrderId 
        when 1 then MakeModelSIdx
        when 2 then CountrySIdx 
        when 3 then LFNameSIdx 
       end
  return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MyEquipment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MyEquipment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](500) NULL
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Trigger [itrMyEquipment_D]
On [dbo].[MyEquipment]
instead of Delete
As
     -- deletion in this table is not allowed
     raiserror('Deletion of records in MyEquipment 
                table is not allowed', 16, 1)

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Trigger [trMyEquipment_D]
On [dbo].[MyEquipment]
After Delete     -- For Delete
As
     Select 'You have just deleted following '
          + Cast(@@rowcount as varchar)
          + ' record(s)!'

     Select * from deleted

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryByMakeModel_Quick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[ap_InventoryByMakeModel_Quick]
  @Make varchar(50) = null,  -- criteria
  @Model varchar(50) = null,  -- criteria
  @PreviousID int = 0,    -- last record from the previous batch
  @SortOrderId smallint = 0,
  @SearchTypeid tinyint = 0  -- 0: Begins With, 1: Match, 2: Contains
/* test:
exec ap_InventoryByMakeModel_Quick ''Compaq'', ''D'', 50, 2, 2
*/
as

if @SearchTypeId = 0
begin
  set @Make = @Make + ''%''
  set @Model = @Model + ''%''
end

if @SearchTypeid = 2
begin
  set @Make  = ''%'' + @Make  + ''%''
  set @Model = ''%'' + @Model + ''%''
end

select top 25 Id = Case @SortOrderId 
            when 1 then MakeModelSIdx
            when 2 then CountrySIdx
            when 3 then LFNameSIdx
          End,
      Inventoryid ,    Make ,      Model,
      Location ,       FirstName , LastName ,
      AcquisitionType, Address ,   City ,
      ProvinceId ,     Country ,   EqType ,
      Phone ,          Fax ,       Email ,
      UserName
from dbo.InventorySum
where Case @SortOrderId
    when 1 then MakeModelSIdx
    when 2 then CountrySIdx
    when 3 then LFNameSIdx
  End > @PreviousID
and Make like @Make
and Model like @Model
order by case @SortOrderId 
      when 1 then MakeModelSIdx
      when 2 then CountrySIdx 
      when 3 then LFNameSIdx 
     end
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryByMakeModel_Count]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[ap_InventoryByMakeModel_Count]
  @Make varchar(50) = null,  -- criteria
  @Model varchar(50) = null,  -- criteria
  @SearchTypeid tinyint = 0,  -- 0: Begins With, 1: Match, 2: Contains
  @Count int output
/* test:      
declare @count int
exec ap_InventoryByMakeModel_Count ''Compaq'', ''D'', 2, @count output
select @count count
*/
as

if @SearchTypeId = 0
begin
  set @Make = @Make + ''%''
  set @Model = @Model + ''%''
end

if @SearchTypeid = 2
begin
  set @Make  = ''%'' + @Make  + ''%''
  set @Model = ''%'' + @Model + ''%''
end

select @Count = count(*)  
from dbo.InventorySum
where Make like @Make
and Model like @Model

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventorySearchAdvFull_ListPage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ap_InventorySearchAdvFull_ListPage]
-- display a batch of 25 assets that specify the criteria

-- Example of use of dynamically assembled query 
-- and denormalized table with surrogate index fields
-- to return result in batches of 25 records.

   @Make varchar(50) = null,
   @Model varchar(50) = null,
   @Location varchar(50) = null,
   @FirstName varchar(30) = null,
   @LastName varchar(30) = null,
   @AcquisitionType varchar(20) = null,
   @ProvinceId char(3) = null,
   @Country varchar(50) = null,
   @EqType varchar(30) = null,
   @City varchar(50) = null,
   @UserName varchar(50) = null,
   @email varchar(50) = null,
   @SortOrderId smallint = 0,   -- 1: Make and model; 
                                -- 2: Country, Prov, City, Loc;
                                -- 4: LName; FName
   @PreviousID int = 0,      -- last record from the previous batch
   @BatchSize int = 25,
   @debug int = 0
/* test:      
exec ap_InventorySearchAdvFull_ListPage
   @Make = ''Compaq'',
   @Model= null,
   @Location = null,
   @FirstName = ''Michael'',
   @LastName = null,   
   @AcquisitionType = null,   
   @ProvinceId  = null,   
   @Country = null,   
   @EqType = null,   
   @City = null,   
   @UserName = null,   
   @email = null,   
   @SortOrderId = 2,   -- 2: Make and model
   @PreviousID = 25,   -- last record from the previous batch
   @BatchSize = 25,
   @debug = 1
*/
as
SET CONCAT_NULL_YIELDS_NULL OFF
SET NOCOUNT ON

declare @chvSelect varchar(max),
      @chvFrom varchar(max),
      @chvWhere varchar(max),
      @chvOrderby varchar(max),
      @chvSQL varchar(max)

-- order records
set @chvSelect = ''SELECT top '' + Convert(varchar, @BatchSize)
           + ''    Inventoryid ,       Make ,           Model,
                  Location ,          FirstName , 
                  LastName ,          AcquisitionType, Address ,
                  City ,              ProvinceId ,     Country ,
                  EqType ,            Phone ,          Fax ,
                  Email ,             UserName,  '' 
            + Case @SortOrderId 
                  when 1 then '' MakeModelSIdx '' 
                  when 2 then '' CountrySIdx '' 
                  when 3 then '' LFNameSIdx '' 
               End 
            + '' as ID ''

set @chvFrom = '' FROM  dbo.InventorySum ''

set @chvWhere = '' where ''
            + Case @SortOrderId 
               when 1 then '' MakeModelSIdx'' 
               when 2 then '' CountrySIdx '' 
               when 3 then '' LFNameSIdx '' 
              End + ''> '' 
            + Convert(varchar, @PreviousID)

if   @Make is not null
   set @chvWhere = @chvWhere + '' AND Make = '''''' + @Make + '''''' ''
if   @Model is not null
   set @chvWhere = @chvWhere + '' AND Model = '''''' + @Model + '''''' ''
if   @Location is not null
   set @chvWhere = @chvWhere + '' AND Location = '''''' + @Location + '''''' ''
if   @FirstName is not null
   set @chvWhere = @chvWhere + '' AND FirstName = '''''' + @FirstName + '''''' ''
if   @LastName is not null
   set @chvWhere = @chvWhere + '' AND lastName = '''''' + @lastName + '''''' ''
if   @AcquisitionType is not null
   set @chvWhere = @chvWhere + '' AND AcquisitionType = '''''' 
                 + @AcquisitionType + '''''' ''
if   @ProvinceId  is not null
   set @chvWhere = @chvWhere + '' AND ProvinceId = '''''' + @ProvinceId + '''''' ''
if   @Country is not null
   set @chvWhere = @chvWhere + '' AND Country = '''''' + @Country + '''''' ''
if   @EqType is not null
   set @chvWhere = @chvWhere + '' AND EqType = '''''' + @EqType + '''''' ''
if   @City is not null
   set @chvWhere = @chvWhere + '' AND City = '''''' + @City + '''''' ''
if   @UserName is not null
   set @chvWhere = @chvWhere + '' AND UserName = '''''' + @UserName + '''''' ''
if   @email is not null
   set @chvWhere = @chvWhere + '' AND email = '''''' + @email + '''''' ''

set @chvOrderBy = '' order by '' 
            + Case @SortOrderId 
               when 1 then '' MakeModelSIdx'' 
               when 2 then '' CountrySIdx '' 
               when 3 then '' LFNameSIdx '' 
              End

set @chvSQL = @chvSelect + @chvFrom + @chvWhere + @chvOrderby

if @debug = 0
   exec (@chvSQL)
else
   select @chvSQL
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EquipmentN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EquipmentN](
	[EqId] [int] IDENTITY(1,1) NOT NULL,
	[Make] [varchar](50) NOT NULL,
	[Model] [varchar](50) NOT NULL,
	[EqTypeId] [smallint] NULL,
	[ModelSDX] [char](4) NULL,
	[MakeSDX] [char](4) NULL,
	[EqDesc] [nvarchar](max) NULL,
	[EqImage] [varbinary](max) NULL
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Trigger [trEquipmentN_IU_2]
-- list all columns that were changed
On [dbo].[EquipmentN]
after Insert, Update 
As

     Set Nocount Off
     declare @intCountColumn int,
             @intColumn int

     -- count columns in the table
     Select @intCountColumn = Count(Ordinal_position)
     From Information_Schema.Columns
     Where Table_Name = 'EquipmentN'

     Select Columns_Updated() "COLUMNS UPDATED"
     Select @intColumn = 1

     -- loop through columns
     while @intColumn <= @intCountColumn
     begin
          if Columns_Updated() & @intColumn = @intColumn
               Print 'Column ('
                    +  Cast(@intColumn as varchar)
                    + ') '
                    + Col_Name(Object_ID('EquipmentN'), @intColumn)
                    + ' has been changed!'
          set @intColumn = @intColumn + 1
     End

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Equipment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Equipment](
	[EqId] [int] IDENTITY(1,1) NOT NULL,
	[Make] [varchar](50) NOT NULL,
	[Model] [varchar](50) NOT NULL,
	[EqTypeId] [smallint] NULL,
	[ModelSDX] [char](4) NULL,
	[MakeSDX] [char](4) NULL,
	[EqDesc] [nvarchar](max) NULL,
	[EqImage] [varbinary](max) NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[EqId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create Trigger [trEquipment_IU]
On [dbo].[Equipment]
After Insert, Update   -- For Insert, Update
As
     -- precalculate ModelSDX and MakeSDX field
     -- to speed up use of SOUNDEX function
     if Update(Model)
          update Equipment
          Set ModelSDX = SOUNDEX(Model)
          from dbo.Equipment Equipment
          where EqId IN (Select EqId from Inserted)

     if Update(Make)
          update Equipment
          Set MakeSDX = SOUNDEX(Make)
          from dbo.Equipment Equipment
          where EqId IN (Select EqId from Inserted)

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Equipment2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Equipment2](
	[EqId] [int] IDENTITY(1,1) NOT NULL,
	[Make] [varchar](50) NOT NULL,
	[Model] [varchar](50) NOT NULL,
	[EqTypeId] [smallint] NULL,
	[ModelSDX] [char](4) NULL,
	[MakeSDX] [char](4) NULL,
	[EqDesc] [nvarchar](max) NULL,
	[EqImage] [varbinary](max) NULL,
 CONSTRAINT [PK_Equipment2] PRIMARY KEY CLUSTERED 
(
	[EqId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Inventory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Inventory](
	[Inventoryid] [int] IDENTITY(1,1) NOT NULL,
	[EqId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[StatusId] [tinyint] NOT NULL,
	[LeaseId] [int] NULL,
	[LeaseScheduleId] [int] NULL,
	[OwnerId] [int] NOT NULL,
	[Rent] [smallmoney] NULL,
	[Lease] [smallmoney] NULL,
	[Cost] [smallmoney] NULL,
	[AcquisitionTypeID] [tinyint] NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[Inventoryid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChargeLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ChargeLog](
	[ItemId] [int] NOT NULL,
	[ActionId] [smallint] NOT NULL,
	[ChargeDate] [datetime] NOT NULL,
	[Cost] [money] NOT NULL CONSTRAINT [DF_ChargeLog_Cost]  DEFAULT ((0)),
	[Note] [varchar](1000) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LeaseSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LeaseSchedule](
	[ScheduleId] [int] NOT NULL,
	[LeaseId] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[LeaseFrequencyId] [tinyint] NOT NULL,
	[PeriodicTotalAmount] [money] NULL,
 CONSTRAINT [PK_LeaseSchedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderHeader]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderHeader](
	[OrderId] [int] NOT NULL,
	[OrderDate] [smalldatetime] NOT NULL,
	[RequestedById] [int] NOT NULL,
	[TargetDate] [smalldatetime] NOT NULL,
	[CompletionDate] [smalldatetime] NULL,
	[DestinationLocationId] [int] NULL,
	[Note] [varchar](max) NULL,
	[OrderTypeId] [smallint] NOT NULL,
	[OrderStatusid] [tinyint] NOT NULL,
 CONSTRAINT [PK_OrderHeader] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [itrOrder_D] ON [dbo].[OrderHeader]
INSTEAD OF DELETE
AS
BEGIN

SET NOCOUNT ON
-- collect OrderItems and Orders in OrderDeleted

INSERT INTO [dbo].[OrderDeleted]
           ([OrderId],[OrderDate],[RequestedById]
           ,[TargetDate],[CompletionDate],[DestinationLocationId]
           ,[Note],[OrderTypeId],[OrderStatusid]
           ,[UserName],[ChangeDT])
SELECT [OrderId],[OrderDate],[RequestedById]
,[TargetDate],[CompletionDate],[DestinationLocationId]
,[Note],[OrderTypeId],[OrderStatusid]
, SUSER_SNAME(), GETDATE()
FROM deleted 

delete dbo.[OrderHeader]
where OrderId in (select OrderId from deleted)

END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [trOrder_D] 
ON [dbo].[OrderHeader] AFTER DELETE
AS

BEGIN
SET NOCOUNT ON

-- collect OrderItems and Orders in OrderDeleted
INSERT INTO [dbo].[OrderDeleted]
    ([OrderId],[OrderDate],[RequestedById]
    ,[TargetDate],[CompletionDate],[DestinationLocationId]
    ,[Note],[OrderTypeId],[OrderStatusid]
    ,[UserName],[ChangeDT])
SELECT [OrderId],[OrderDate],[RequestedById]
	,[TargetDate],[CompletionDate],[DestinationLocationId]
	,[Note],[OrderTypeId],[OrderStatusid]
	, SUSER_SNAME(), GETDATE()
FROM deleted 

END

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [trOrderHeader_D] 
ON [dbo].[OrderHeader] 
AFTER DELETE
AS

BEGIN
SET NOCOUNT ON

-- collect OrderItems and Orders in OrderDeleted
INSERT INTO [dbo].[OrderDeleted]
    ([OrderId],[OrderDate],[RequestedById]
    ,[TargetDate],[CompletionDate],[DestinationLocationId]
    ,[Note],[OrderTypeId],[OrderStatusid]
    ,[UserName],[ChangeDT])
SELECT [OrderId],[OrderDate],[RequestedById]
	,[TargetDate],[CompletionDate],[DestinationLocationId]
	,[Note],[OrderTypeId],[OrderStatusid]
	, SUSER_SNAME(), GETDATE()
FROM deleted 

END

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Trigger [trOrderStatus_U]
On [dbo].[OrderHeader]
After Update -- For Update
As
     If Update (OrderStatusId)
     begin

          Insert into ActivityLog( Activity,
                                   LogDate,
                                   UserName,
                                   Note)
           Select   'Order.OrderStatusId',
                    GetDate(),
                    User_Name(),
                    'Value changed from '
                    + Cast( d.OrderStatusId as varchar)
                    + ' to '
                    + Cast( i.OrderStatusId as varchar)

          from deleted d inner join inserted i
          on d.OrderId = i.OrderId
     end

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Trigger [trOrderStatus_U_1]
On [dbo].[OrderHeader]
After Update    -- For Update
As
     declare @intOldOrderStatusId int,
             @intNewOrderStatusId int

     If Update (OrderStatusId)
     Begin

          select @intOldOrderStatusId = OrderStatusId from deleted
          select @intNewOrderStatusId = OrderStatusId from inserted
          Insert into dbo.ActivityLog( Activity,
                                       LogDate,
                                       UserName,
                                       Note)
           values ( 'OrderHeader.OrderStatusId',
                    GetDate(),
                    User_Name(),
                    'Value changed from '
                    + Cast( @intOldOrderStatusId as varchar)
                    + ' to '
                    + Cast((@intNewOrderStatusId) as varchar)
                   )
     End

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Location]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Location](
	[LocationId] [int] NOT NULL,
	[Location] [varchar](50) NOT NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[ProvinceId] [char](3) NULL,
	[Country] [varchar](50) NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderItem](
	[ItemId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[InventoryId] [int] NULL,
	[EqId] [int] NULL,
	[CompletionDate] [smalldatetime] NULL,
	[Note] [varchar](1000) NULL,
 CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

--IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[citr_OrderItem_D]'))
--EXECUTE dbo.sp_executesql N'
--CREATE TRIGGER [citr_OrderItem_D] ON [dbo].[OrderItem]  INSTEAD OF  DELETE AS 
--EXTERNAL NAME [CSrpTrigger].[Triggers].[TriggerDelete]
--'
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OrderItem', @level2type=N'TRIGGER', @level2name=N'citr_OrderItem_D'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'TriggerDelete.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OrderItem', @level2type=N'TRIGGER', @level2name=N'citr_OrderItem_D'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=11 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'OrderItem', @level2type=N'TRIGGER', @level2name=N'citr_OrderItem_D'
--
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventorySec]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventorySec](
	[Inventoryid] [int] NOT NULL,
	[AcquisitionType] [varchar](12) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[ProvinceId] [char](3) NULL,
	[Country] [varchar](50) NULL,
	[EqType] [varchar](50) NULL,
	[Phone] [dbo].[typPhone] NULL,
	[Fax] [dbo].[typPhone] NULL,
	[Email] [dbo].[typEmail] NULL,
 CONSTRAINT [PK_InventorySec] PRIMARY KEY CLUSTERED 
(
	[Inventoryid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Contact_Update2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_Contact_Update2]
-- update record from contact table
-- prevent user from overwriting changed record
     (
          @intContactId int,
          @chvFirstName varchar(30),
          @chvLastName varchar(30),
          @chvPhone typPhone,
          @chvFax typPhone,
          @chvEmail typEmail,
          @insOrgUnitId smallint,
          @chvUserName varchar(50),
          @tsOriginal timestamp
     )
As
Set nocount on

declare @recCount int
declare @CurrentTs varbinary(30)

Update dbo.Contact
Set FirstName = @chvFirstName,
    LastName = @chvLastName,
    Phone = @chvPhone,
    Fax = @chvFax,
    Email = @chvEmail,
    OrgUnitId = @insOrgUnitId,
    UserName = @chvUserName
Where ContactId = @intContactId
and ts = @tsOriginal

select @recCount = @@Rowcount
if @recCount =1
begin
	print ''One record was changed.''
	return
end
else
begin
	if exists (select ContactId 
				from dbo.Contact 
				where ContactId = @intContactId)
	begin
		print ''ContactID exists.''
		select @CurrentTs = Convert(varbinary(30), ts)
		from dbo.Contact 
		where ContactId = @intContactId

		print @CurrentTs

		raiserror (''Unable to update the record since timestamp has been changed.'', 16, 1, @CurrentTs)
		return 53200
	end
	else
	begin
		print ''ContactID does not exist.''
		raiserror (''The specified record does not exist in the table any more.'', 16, 1)
	end
end
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Contact_Update1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[ap_Contact_Update1]
-- update record from contact table
-- prevent user from overwriting changed record
     (
          @intContactId int,
          @chvFirstName varchar(30),
          @chvLastName varchar(30),
          @chvPhone typPhone,
          @chvFax typPhone,
          @chvEmail typEmail,
          @insOrgUnitId smallint,
          @chvUserName varchar(50),
          @tsOriginal timestamp
     )
As

Set nocount on

declare @recCount int
declare @CurrentTs varbinary(30)

Update dbo.Contact
Set FirstName = @chvFirstName,
    LastName = @chvLastName,
    Phone = @chvPhone,
    Fax = @chvFax,
    Email = @chvEmail,
    OrgUnitId = @insOrgUnitId,
    UserName = @chvUserName
Where ContactId = @intContactId
and ts = @tsOriginal

return @@RowCount' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_QBF_Contact_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_QBF_Contact_List]
-- Dynamically assemble a query based on specified parameters.
     (
          @chvFirstName    varchar(30)  = NULL,
          @chvLastName     varchar(30)  = NULL,
          @chvPhone        typPhone     = NULL,
          @chvFax          typPhone     = NULL,
          @chvEmail        typEmail     = NULL,
          @insOrgUnitId    smallint     = NULL,
          @chvUserName     varchar(50)  = NULL,
          @debug           int          = 0
     )
As
set nocount on

Declare @chvQuery nvarchar(max),
        @chvWhere nvarchar(max)
Select @chvQuery = ''SET QUOTED_IDENTIFIER OFF SELECT * FROM dbo.Contact'',
       @chvWhere = ''''

If @chvFirstName is not null
    Set @chvWhere = @chvWhere + '' FirstName = "''
                  + @chvFirstName + ''" AND''

If @chvLastName is not null
    Set @chvWhere = @chvWhere + '' LastName = "''
                  + @chvLastName + ''" AND''

If @chvPhone is not null
    set @chvWhere = @chvWhere + '' Phone = "'' 
                  + @chvPhone + ''" AND''

If @chvFax is not null
    set @chvWhere = @chvWhere + '' Fax = "'' 
                  + @chvFax + ''" AND''

If @chvEmail is not null
    set @chvWhere = @chvWhere + '' Email = "'' 
                  + @chvEmail + ''" AND''

If @insOrgUnitId is not null
    set @chvWhere = @chvWhere + '' OrgUnitId = ''
                  + @insOrgUnitId + '' AND''

If @chvUserName is not null
    set @chvWhere = @chvWhere + '' UserName = "'' 
                  + @chvUserName + ''"''

if @debug <> 0 
    select @chvWhere chvWhere

-- remove '' AND'' from the end of string
begin try 
	If Substring(@chvWhere, Len(@chvWhere) - 3, 4) = '' AND''
		set @chvWhere = Substring(@chvWhere, 1, Len(@chvWhere) - 3)
end try
begin Catch 
	Raiserror (''Unable to remove last AND operator.'', 16, 1)
	return
end catch

if @debug <> 0 
	select @chvWhere chvWhere

begin try 
	If Len(@chvWhere) > 0
		set  @chvQuery = @chvQuery + '' WHERE '' + @chvWhere

	if @debug <> 0
		select @chvQuery Query

	-- get contacts
		exec (@chvQuery)
end try
begin Catch 
	declare @s varchar(max)
	set @s = ''Unable to execute new query: '' + @chvQuery
	Raiserror (@s, 16, 2)
	return
end catch

return
' 
END
GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClrTvfFolderList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[ClrTvfFolderList](@folder [nvarchar](4000))
--RETURNS  TABLE (
--	[fileName] [nvarchar](max) NULL,
--	[size] [bigint] NULL
--) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [ClrTvfFolder].[UserDefinedFunctions].[ClrTvfFolderList]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'ClrTvfFolderList'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'ClrTvfFolder.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'ClrTvfFolderList'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=14 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'ClrTvfFolderList'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clrtvf_Split1]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[clrtvf_Split1](@str [nvarchar](4000), @splitChar [nvarchar](4000))
--RETURNS  TABLE (
--	[str] [nvarchar](max) NULL,
--	[ind] [int] NULL
--) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [clrtvf_Split1].[Samples.SqlServer.stringsplit].[clrtvf_Split1]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Split1'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'clrtvfSplit1.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Split1'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=28 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Split1'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clrtvf_Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[clrtvf_Split](@str [nvarchar](4000), @splitChar [nvarchar](4000))
--RETURNS  TABLE (
--	[segment] [nvarchar](max) NULL
--) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [clrtvf_Split2].[Samples.SqlServer.stringsplits].[clrtvf_Split]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Split'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'clrtvf_Split2.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Split'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=16 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Split'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_IsValidEmail]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cf_IsValidEmail](@email [nvarchar](4000))
--RETURNS [bit] WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cf_IsValidEmail]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_IsValidEmail'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_IsValidEmail'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=483 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_IsValidEmail'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_OrderCount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cf_OrderCount]()
--RETURNS [int] WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cf_OrderCount]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_OrderCount'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_OrderCount'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=470 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_OrderCount'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_DateConv]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cf_DateConv](@dt [datetime], @format [nvarchar](4000))
--RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cf_DateConv]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_DateConv'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_DateConv'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=454 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_DateConv'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cf_DateConv_DtFmtCult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[cf_DateConv_DtFmtCult](@dt [nvarchar](4000), @format [nvarchar](4000), @culture [nvarchar](4000))
--RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cf_DateConv_DtFmtCult]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_DateConv_DtFmtCult'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_DateConv_DtFmtCult'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=461 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'cf_DateConv_DtFmtCult'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_Lease_Calc2]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_Lease_Calc2]
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_Lease_Calc2]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Lease_Calc2'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Lease_Calc2'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=407 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Lease_Calc2'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_EqImage_Update]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_EqImage_Update]
--	@EqID [int],
--	@FileName [nvarchar](4000)
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_EqImage_Update]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqImage_Update'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqImage_Update'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=310 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqImage_Update'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_Lease_Calc]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_Lease_Calc]
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_Lease_Calc]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Lease_Calc'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Lease_Calc'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=366 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Lease_Calc'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_Eq_List]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_Eq_List]
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_Eq_List]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Eq_List'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Eq_List'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=57 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Eq_List'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_Eq_Insert]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_Eq_Insert]
--	@Make [nvarchar](4000),
--	@Model [nvarchar](4000),
--	@EqType [nvarchar](4000)
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_Eq_Insert]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Eq_Insert'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Eq_Insert'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=77 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_Eq_Insert'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_EqType_GetCommaDelimList]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_EqType_GetCommaDelimList]
--	@EqType [nvarchar](4000) OUTPUT
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_EqType_GetCommaDelimList]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_GetCommaDelimList'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_GetCommaDelimList'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=149 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_GetCommaDelimList'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_EqImage_Save]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_EqImage_Save]
--	@EqID [int],
--	@FileName [nvarchar](4000)
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_EqImage_Save]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqImage_Save'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqImage_Save'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=214 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqImage_Save'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_EqType_List2]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_EqType_List2]
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_EqType_List2]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_List2'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_List2'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=43 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_List2'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_EqType_List]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_EqType_List]
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[cp_EqType_List]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_List'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_List'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=22 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqType_List'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_First]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_First]
--AS
--EXTERNAL NAME [ClrSp].[CLRModules].[ap_First]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_First'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedures.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_First'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=15 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_First'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clrtvf_Matches]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[clrtvf_Matches](@sqlInput [nvarchar](4000), @sqlPattern [nvarchar](4000), @sqlRegexOptions [nvarchar](4000))
--RETURNS  TABLE (
--	[matchId] [int] NULL,
--	[matchValue] [nvarchar](max) NULL
--) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [RegExpr].[Samples.SqlServer.RegularExpression].[clrtvf_Matches]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Matches'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'clrtvf_RegExpr.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Matches'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=22 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_Matches'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_FirstVB]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_FirstVB]
--AS
--EXTERNAL NAME [VbSqlServerSp].[VbSqlServerSp.StoredProcedures].[ap_FirstVB]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_FirstVB'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'ap_First.vb' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_FirstVB'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=10 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_FirstVB'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_EqTypeListVB]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_EqTypeListVB]
--AS
--EXTERNAL NAME [VbSqlServerSp].[VbSqlServerSp.StoredProcedures].[cp_EqTypeListVB]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqTypeListVB'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'ap_First.vb' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqTypeListVB'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=18 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_EqTypeListVB'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_LeasedAsset_Insert]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_LeasedAsset_Insert]
--	@EqId [int],
--	@LocId [int],
--	@StatusId [int],
--	@LeaseId [int],
--	@LeaseScheduleId [int],
--	@OwnerId [int],
--	@LeaseAmount [numeric](18, 0),
--	@AcqTypeId [int]
--AS
--EXTERNAL NAME [VbTxSp].[VbTxSp.StoredProcedures].[cp_LeasedAsset_Insert]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_LeasedAsset_Insert'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'VbTxSp.vb' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_LeasedAsset_Insert'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=12 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_LeasedAsset_Insert'
--
--GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cp_DebugTest]') AND type in (N'P', N'PC'))
--BEGIN
--EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cp_DebugTest]
--AS
--EXTERNAL NAME [SqlServerProject3].[StoredProcedures].[cp_DebugTest]' 
--END
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_DebugTest'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'StoredProcedure1.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_DebugTest'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=10 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'cp_DebugTest'
--
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryProperties_Get_TempTblOuter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_InventoryProperties_Get_TempTblOuter]
/*
Return comma-delimited list of properties
that are describing asset.
i.e.: Property = Value unit;Property = Value unit;Property =
Value unit; Property = Value unit; Property = Value unit; Property =
Value unit;
*/
     @intInventoryId int
As
set nocount on

declare     @chvProperties varchar(max)

Create table #List(Id int identity(1,1),
                   Item varchar(255))

-- identify Properties associated with asset
insert into #List (Item)
     select Property + ''='' + Value + '' '' +  Coalesce(Unit, '''') + ''; ''
     from InventoryProperty inner join Property
     on InventoryProperty.PropertyId = Property.PropertyId
     where InventoryProperty.InventoryId = @intInventoryId

-- call sp that converts records to a single varchar
exec util.ap_TempTbl2Varchar @chvProperties OUTPUT

-- display result
select @chvProperties Properties

drop table #List

return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryProperties_Get_wNestedCursor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ap_InventoryProperties_Get_wNestedCursor] 
/*
Return comma-delimited list of properties
that are describing asset.
i.e.: Property = Value unit;Property = Value unit;Property =
Value unit; Property = Value unit; Property = Value unit; Property =
Value unit;

--test: 
declare @chvResult varchar(max)
exec dbo.ap_InventoryProperties_Get_wNestedCursor 5, @chvResult OUTPUT
select @chvResult
*/
     (
          @intInventoryId int,
          @chvProperties varchar(max) OUTPUT,
          @debug int = 0
     )
As

Select @chvProperties = ''''

Declare curItems Cursor For
     Select Property + ''='' + [Value] + '' ''
            + Coalesce([Unit], '''') + ''; '' Item
     From InventoryProperty Inner Join Property
     On InventoryProperty.PropertyId = Property.PropertyId
     Where InventoryProperty.InventoryId = @intInventoryId

Open curItems

Exec util.ap_Cursor2Varchar @chvProperties OUTPUT, @debug

Close curItems
Deallocate curItems

Return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vInventoryCost]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[vInventoryCost]
 
as
select ET.EqType, e.Make, e.Model, Sum(Cost) TotalCost, Count(*) [Count]
from dbo.Inventory I
inner join dbo.Equipment e
on i.EqId = e.EqId
     inner join dbo.EqType ET
     on e.EqTypeId = ET.EqTypeId
where Cost is not null
group by ET.EqType, e.Make, e.Model
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vInventory]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vInventory]
AS
SELECT     dbo.Inventory.Inventoryid, dbo.Equipment.Make, dbo.Equipment.Model, dbo.Location.Location, dbo.Status.Status, dbo.Contact.FirstName, 
                      dbo.Contact.LastName, dbo.Inventory.Cost, dbo.AcquisitionType.AcquisitionType, dbo.Location.Address, dbo.Location.City, dbo.Location.ProvinceId, 
                      dbo.Location.Country, dbo.EqType.EqType, dbo.Contact.Phone, dbo.Contact.Fax, dbo.Contact.Email, dbo.Contact.UserName, dbo.Inventory.Rent, 
                      dbo.Inventory.EqId, dbo.Inventory.LocationId, dbo.Inventory.StatusId, dbo.Inventory.OwnerId, dbo.Inventory.AcquisitionTypeID, 
                      dbo.Contact.OrgUnitId
FROM         dbo.EqType RIGHT OUTER JOIN
                      dbo.Equipment ON dbo.EqType.EqTypeId = dbo.Equipment.EqTypeId RIGHT OUTER JOIN
                      dbo.Inventory INNER JOIN
                      dbo.Status ON dbo.Inventory.StatusId = dbo.Status.StatusId LEFT OUTER JOIN
                      dbo.AcquisitionType ON dbo.Inventory.AcquisitionTypeID = dbo.AcquisitionType.AcquisitionTypeId ON 
                      dbo.Equipment.EqId = dbo.Inventory.EqId LEFT OUTER JOIN
                      dbo.Location ON dbo.Inventory.LocationId = dbo.Location.LocationId LEFT OUTER JOIN
                      dbo.Contact ON dbo.Inventory.OwnerId = dbo.Contact.ContactId
' 
GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
--Begin DesignProperties = 
--   Begin PaneConfigurations = 
--      Begin PaneConfiguration = 0
--         NumPanes = 4
--         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
--      End
--      Begin PaneConfiguration = 1
--         NumPanes = 3
--         Configuration = "(H (1 [50] 4 [25] 3))"
--      End
--      Begin PaneConfiguration = 2
--         NumPanes = 3
--         Configuration = "(H (1 [50] 2 [25] 3))"
--      End
--      Begin PaneConfiguration = 3
--         NumPanes = 3
--         Configuration = "(H (4 [30] 2 [40] 3))"
--      End
--      Begin PaneConfiguration = 4
--         NumPanes = 2
--         Configuration = "(H (1 [56] 3))"
--      End
--      Begin PaneConfiguration = 5
--         NumPanes = 2
--         Configuration = "(H (2 [66] 3))"
--      End
--      Begin PaneConfiguration = 6
--         NumPanes = 2
--         Configuration = "(H (4 [50] 3))"
--      End
--      Begin PaneConfiguration = 7
--         NumPanes = 1
--         Configuration = "(V (3))"
--      End
--      Begin PaneConfiguration = 8
--         NumPanes = 3
--         Configuration = "(H (1[56] 4[18] 2) )"
--      End
--      Begin PaneConfiguration = 9
--         NumPanes = 2
--         Configuration = "(H (1 [75] 4))"
--      End
--      Begin PaneConfiguration = 10
--         NumPanes = 2
--         Configuration = "(H (1[66] 2) )"
--      End
--      Begin PaneConfiguration = 11
--         NumPanes = 2
--         Configuration = "(H (4 [60] 2))"
--      End
--      Begin PaneConfiguration = 12
--         NumPanes = 1
--         Configuration = "(H (1) )"
--      End
--      Begin PaneConfiguration = 13
--         NumPanes = 1
--         Configuration = "(V (4))"
--      End
--      Begin PaneConfiguration = 14
--         NumPanes = 1
--         Configuration = "(V (2))"
--      End
--      ActivePaneConfig = 0
--   End
--   Begin DiagramPane = 
--      Begin Origin = 
--         Top = 0
--         Left = 0
--      End
--      Begin Tables = 
--         Begin Table = "EqType"
--            Begin Extent = 
--               Top = 6
--               Left = 38
--               Bottom = 91
--               Right = 190
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Equipment"
--            Begin Extent = 
--               Top = 0
--               Left = 383
--               Bottom = 115
--               Right = 535
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Inventory"
--            Begin Extent = 
--               Top = 96
--               Left = 38
--               Bottom = 211
--               Right = 205
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Status"
--            Begin Extent = 
--               Top = 122
--               Left = 392
--               Bottom = 207
--               Right = 544
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "AcquisitionType"
--            Begin Extent = 
--               Top = 216
--               Left = 38
--               Bottom = 301
--               Right = 204
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Location"
--            Begin Extent = 
--               Top = 216
--               Left = 242
--               Bottom = 331
--               Right = 394
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Contact"
--            Begin Extent = 
--               Top = 306
--               Left = 38
--               Bottom = 421
--               Right = 190
--            End
--            DisplayFlag' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vInventory'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N's = 280
--            TopColumn = 0
--         End
--      End
--   End
--   Begin SQLPane = 
--   End
--   Begin DataPane = 
--      Begin ParameterDefaults = ""
--      End
--   End
--   Begin CriteriaPane = 
--      Begin ColumnWidths = 11
--         Column = 1440
--         Alias = 900
--         Table = 1170
--         Output = 720
--         Append = 1400
--         NewValue = 1170
--         SortType = 1350
--         SortOrder = 1410
--         GroupBy = 1350
--         Filter = 1350
--         Or = 1350
--         Or = 1350
--         Or = 1350
--      End
--   End
--End
--' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vInventory'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vInventory'
--
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Equipment_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[ap_Equipment_Insert] 
-- insert equipment (and if necessary equipment type)
-- (demonstration of alternative method for error handling and transaction processing)
        @chvMake varchar(50),
        @chvModel varchar(50),
        @chvEqType varchar(50),
        @intEqId int OUTPUT
AS
set xact_abort on
set nocount on

declare @intTrancountOnEntry int,
        @intEqTypeId int

set @intTrancountOnEntry = @@tranCount

-- does such EqType already exist in the database
If  not exists (Select EqTypeId From dbo.EqType 
                Where EqType = @chvEqType)
--if it does not exist
Begin
    if @@tranCount = 0
        BEGIN TRAN

    -- insert new EqType in the database
    Insert dbo.EqType (EqType)
    Values (@chvEqType)

    -- get id of record that you''ve just inserted
    Select @intEqTypeId = @@identity
End
else
begin
    -- read Id of EqType
    Select @intEqTypeId
    From dbo.EqType
    Where EqType = @chvEqType
end

--insert equipment
Insert dbo.Equipment (Make, Model, EqTypeId)
Values (@chvMake, @chvModel, @intEqTypeId)

Select @intEqId = @@identity

if @@tranCount > @intTrancountOnEntry
    COMMIT TRAN

return

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vEquipment]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[vEquipment]
AS
Select Equipment.EqId,
       Equipment.Make,
       Equipment.Model,
       EqType.EqType
From Equipment Inner Join EqType
On Equipment.EqTypeId = EqType.EqTypeId
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Trigger [itr_vEquipment_I]
On [dbo].[vEquipment]
instead of Insert
As

-- If the EqType is new, insert it
If exists(select EqType
          from inserted
          where EqType not in (select EqType
                                 from EqType))
     -- we need to insert the new ones
     insert into EqType(EqType)
         select EqType
         from inserted
         where EqType not in (select EqType
                              from EqType)

-- now you can insert new equipment
Insert into Equipment(Make, Model, EqTypeId)
Select inserted.Make, inserted.Model, EqType.EqTypeId
From inserted Inner Join EqType
On inserted.EqType = EqType.EqType


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqTypeByEqTypeID_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[ap_EqTypeByEqTypeID_List] 
	@intEqTypeId [int]
WITH EXECUTE AS CALLER
AS
	Select *
    from dbo.EqType
    where EqTypeId = @intEqTypeId
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqType_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[ap_EqType_List]
WITH EXECUTE AS CALLER
AS
	Select *
    from dbo.EqType
    

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vEquipmentFull]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vEquipmentFull]
AS
SELECT     Inventory.Inventoryid, Equipment.Make, Equipment.Model, Location.Location, Contact.FirstName, Contact.LastName, AcquisitionType.AcquisitionType, 
                      Location.Address, Location.City, Location.ProvinceId, Location.Country, EqType.EqType, Contact.Phone, Contact.Fax, Contact.Email, 
                      Contact.UserName
FROM         dbo.EqType AS EqType RIGHT OUTER JOIN
                      dbo.Equipment AS Equipment ON EqType.EqTypeId = Equipment.EqTypeId RIGHT OUTER JOIN
                      dbo.Inventory AS Inventory ON Equipment.EqId = Inventory.EqId LEFT OUTER JOIN
                      dbo.AcquisitionType AS AcquisitionType ON Inventory.AcquisitionTypeID = AcquisitionType.AcquisitionTypeId LEFT OUTER JOIN
                      dbo.Location AS Location ON Inventory.LocationId = Location.LocationId LEFT OUTER JOIN
                      dbo.Contact AS Contact ON Inventory.OwnerId = Contact.ContactId
' 
GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
--Begin DesignProperties = 
--   Begin PaneConfigurations = 
--      Begin PaneConfiguration = 0
--         NumPanes = 4
--         Configuration = "(H (1[32] 4[19] 2[22] 3) )"
--      End
--      Begin PaneConfiguration = 1
--         NumPanes = 3
--         Configuration = "(H (1 [50] 4 [25] 3))"
--      End
--      Begin PaneConfiguration = 2
--         NumPanes = 3
--         Configuration = "(H (1 [50] 2 [25] 3))"
--      End
--      Begin PaneConfiguration = 3
--         NumPanes = 3
--         Configuration = "(H (4 [30] 2 [40] 3))"
--      End
--      Begin PaneConfiguration = 4
--         NumPanes = 2
--         Configuration = "(H (1 [56] 3))"
--      End
--      Begin PaneConfiguration = 5
--         NumPanes = 2
--         Configuration = "(H (2 [66] 3))"
--      End
--      Begin PaneConfiguration = 6
--         NumPanes = 2
--         Configuration = "(H (4 [50] 3))"
--      End
--      Begin PaneConfiguration = 7
--         NumPanes = 1
--         Configuration = "(V (3))"
--      End
--      Begin PaneConfiguration = 8
--         NumPanes = 3
--         Configuration = "(H (1[56] 4[18] 2) )"
--      End
--      Begin PaneConfiguration = 9
--         NumPanes = 2
--         Configuration = "(H (1 [75] 4))"
--      End
--      Begin PaneConfiguration = 10
--         NumPanes = 2
--         Configuration = "(H (1[66] 2) )"
--      End
--      Begin PaneConfiguration = 11
--         NumPanes = 2
--         Configuration = "(H (4 [60] 2))"
--      End
--      Begin PaneConfiguration = 12
--         NumPanes = 1
--         Configuration = "(H (1) )"
--      End
--      Begin PaneConfiguration = 13
--         NumPanes = 1
--         Configuration = "(V (4))"
--      End
--      Begin PaneConfiguration = 14
--         NumPanes = 1
--         Configuration = "(V (2))"
--      End
--      ActivePaneConfig = 0
--   End
--   Begin DiagramPane = 
--      Begin Origin = 
--         Top = 0
--         Left = 0
--      End
--      Begin Tables = 
--         Begin Table = "EqType"
--            Begin Extent = 
--               Top = 6
--               Left = 38
--               Bottom = 91
--               Right = 190
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Equipment"
--            Begin Extent = 
--               Top = 6
--               Left = 228
--               Bottom = 121
--               Right = 380
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Inventory"
--            Begin Extent = 
--               Top = 96
--               Left = 38
--               Bottom = 211
--               Right = 205
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "AcquisitionType"
--            Begin Extent = 
--               Top = 126
--               Left = 243
--               Bottom = 211
--               Right = 409
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Location"
--            Begin Extent = 
--               Top = 216
--               Left = 38
--               Bottom = 331
--               Right = 190
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--         Begin Table = "Contact"
--            Begin Extent = 
--               Top = 216
--               Left = 228
--               Bottom = 331
--               Right = 380
--            End
--            DisplayFlags = 280
--            TopColumn = 0
--         End
--      End
--   End
--   Begin SQLPane = 
--   End
--   Begin DataPane = 
--      Begin ParameterDefaults = ""
--      End
--      Begin ColumnWidths = 9
--         Width = 284
--         Width = 1500
--         Width = 15' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vEquipmentFull'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'00
--         Width = 1500
--         Width = 1500
--         Width = 1500
--         Width = 1500
--         Width = 1500
--         Width = 1500
--      End
--   End
--   Begin CriteriaPane = 
--      Begin ColumnWidths = 11
--         Column = 1440
--         Alias = 900
--         Table = 1170
--         Output = 720
--         Append = 1400
--         NewValue = 1170
--         SortType = 1350
--         SortOrder = 1410
--         GroupBy = 1350
--         Filter = 1350
--         Or = 1350
--         Or = 1350
--         Or = 1350
--      End
--   End
--End
--' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vEquipmentFull'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'vEquipmentFull'
--
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_DepartmentEquipment]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[fn_DepartmentEquipment]
     ( @chvUserName sysname )
Returns table
As
Return (
      Select InventoryId, Make + '' '' + model Model, Location
      From dbo.Inventory Inventory inner join dbo.Contact C
      On Inventory.OwnerId = C.ContactId
            Inner Join dbo.Contact Manager
            On C.OrgUnitId = Manager.OrgUnitId
                  Inner Join dbo.Equipment Equipment
                  On Inventory.EqId = Equipment.EqId
                        Inner Join dbo.Location Location
                        On Inventory.LocationId = Location.LocationId
      Where Manager.UserName = @chvUserName
     )
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Order_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[ap_Order_Add]
-- insert Order record
     @dtmOrderDate datetime = null,
     @dtmTargetDate datetime = null,
     @chvUserName varchar(128) = null,
     @intDestinationLocation int,
     @chvNote varchar(200),
     @intOrderid int OUTPUT

As

     declare     @intRequestedById int

     -- If user didn''t specify order date
     -- default is today.
     if @dtmOrderDate = null
          Set @dtmOrderDate = GetDate()

     -- If user didn''t specify target date
     -- default is 3 days after request date.
     if @dtmTargetDate = null
          Set @dtmTargetDate = DateAdd(day, 3, @dtmOrderDate)

     -- if user didn''t identify himself
     -- try to identify him using login name
     if @chvUserName = null
        Set @chvUserName = System_User

     -- get Id of the user
     select @intRequestedById = ContactId
     from dbo.Contact
     where UserName = @chvUserName

     -- if you cannot identify user report an error
     If @intRequestedById = null
     begin
          Raiserror(''Unable to identify user in Contact table!'', 1, 2)
          return -1
     end

     -- and finally create Order
     Insert into [Order](OrderDate, RequestedById, TargetDate,
                         DestinationLocationId)
     Values (@dtmOrderDate, @intRequestedById, @dtmTargetDate,
             @intDestinationLocation)

     set @intOrderid = scope_identity()

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Equipment_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_Equipment_Update]
-- Check if values were changed in the meanwhile
-- Update values in equipment table.
          @intEqId int,
          @chvMake varchar(50),
          @chvModel varchar(50),
          @intEqTypeId int,
          @debug int = 0
As
declare @intNewEqBC int

set @intNewEqBC = Binary_CheckSum(@chvMake,
                                  @chvModel,
                                  @intEqTypeId)
if @debug <> 0
      Select @intNewEqBC NewBC
if @debug <> 0
      select EqBC OldBC
      from EquipmentBC
      where EqId = @intEqId

if not exists (Select EqBC
               from EquipmentBC
               where EqId = @intEqId)
     insert EquipmentBC (EqId, EqBC)
         select @intEqId,
                Binary_CheckSum(Make, Model, EqTypeId)
         from Equipment
          where EqId = @intEqId

-- Check if values were changed in the meanwhile
if @intNewEqBC <> (Select EqBC
                         from EquipmentBC
                         where EqId = @intEqId)
begin
     if @debug <> 0
          select ''Information will be updated.''

     -- update information
     update Equipment
     Set  Make = @chvMake,
          Model = @chvModel,
          EqTypeId = @intEqTypeId
     where EqId = @intEqId

     if exists(select EqId
               from   EquipmentBC
               where  EqId = @intEqId)
          update EquipmentBC
          Set EqBC = @intNewEqBC
          where EqId = @intEqId
     else
          insert EquipmentBC (EqId, EqBC)
          values (@intEqId, @intNewEqBC)
end
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ServiceRequest_Process]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[ap_ServiceRequest_Process]
as

declare
     @conversation_group_id UNIQUEIDENTIFIER,
     @conversation_handle UNIQUEIDENTIFIER,
     @message_sequence_number BIGINT,
     @service_name NVARCHAR(512),
     @service_contract_name NVARCHAR(256),
     @message_type_name NVARCHAR(256),
     @validation NCHAR,
     @message_body VARBINARY(MAX);

INSERT INTO [dbo].[Msg]
           ([service_instance_id]
           ,[handle]
           ,[message_sequence_number]
           ,[service_name]
           ,[service_contract_name]
           ,[message_type_name]
           ,[validation]
           ,[message_body])
     VALUES
           (@conversation_group_id
           ,@conversation_handle
           ,@message_sequence_number
           ,@service_name
           ,@service_contract_name
           ,''Activated''
           ,@validation
           ,@message_body)

WAITFOR (
    RECEIVE TOP (1)
	@conversation_group_id = conversation_group_id,
    @conversation_handle = conversation_handle,
    @service_name = message_sequence_number,
    @service_name = service_name,
    @service_contract_name = service_contract_name,
    @message_type_name = message_type_name,
    @validation = validation,
    @message_body = message_body
FROM dbo.ServiceRequestQueue
),
TIMEOUT 60000 ;

INSERT INTO [dbo].[Msg]
           ([service_instance_id]
           ,[handle]
           ,[message_sequence_number]
           ,[service_name]
           ,[service_contract_name]
           ,[message_type_name]
           ,[validation]
           ,[message_body])
     VALUES
           (@conversation_group_id
           ,@conversation_handle
           ,@message_sequence_number
           ,@service_name
           ,@service_contract_name
           ,@message_type_name
           ,@validation
           ,@message_body)

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Confirmation_Process]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[ap_Confirmation_Process]
as
insert Msg([message_type_name])
values(''asdasd'')
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryProperties_Get_wCursor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_InventoryProperties_Get_wCursor]
-- Return Cursor that contains properties
-- that are describing selected asset.

   (
      @intInventoryId int,
      @curProperties Cursor Varying Output
   )

As

Set @curProperties = Cursor Forward_Only Static For
   Select Property, Value, Unit
   From InventoryProperty inner join Property
   On InventoryProperty.PropertyId = Property.PropertyId
   Where InventoryProperty.InventoryId = @intInventoryId

Open @curProperties

Return 
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryProperties_Get_Cursor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_InventoryProperties_Get_Cursor]
/********************************************************************
Return comma-delimited list of properties that are describing asset.
Property = Value unit;Property = Value unit;Property = Value unit;...

Output: @chvProperties
Return: n/a

             Name            Date        Description
Created by:  Dejan Sunderic  2005.04.18
Modified by: 

test:
declare @p varchar(max)
exec dbo.ap_InventoryProperties_Get_Cursor 5, @p OUTPUT, 1
select @p

********************************************************************/
     (
          @intInventoryId int,
          @chvProperties varchar(max) OUTPUT,
          @debug int = 0
     )

As

declare   @intCountProperties int,
          @intCounter int,
          @chvProperty varchar(50),
          @chvValue varchar(50),
          @chvUnit varchar(50)

Set @chvProperties = ''''

Declare @CrsrVar Cursor

Set @CrsrVar = Cursor For
     select Property, Value, Unit
     from dbo.InventoryProperty InventoryProperty 
          inner join dbo.Property Property
          on InventoryProperty.PropertyId = Property.PropertyId
     where InventoryProperty.InventoryId = @intInventoryId

Open @CrsrVar

Fetch Next From @CrsrVar
Into @chvProperty, @chvValue, @chvUnit

While (@@FETCH_STATUS = 0)
Begin

     Set @chvUnit = Coalesce(@chvUnit, '''')

     If @debug <> 0
          Select @chvProperty Property,
                 @chvValue [Value],
                 @chvUnit [Unit]


     -- assemble list
     Set @chvProperties = @chvProperties + @chvProperty + ''=''
                        + @chvValue + '' '' +  @chvUnit + ''; ''
     If @debug <> 0
          Select @chvProperties chvProperties

     Fetch Next From @CrsrVar
     Into @chvProperty, @chvValue, @chvUnit

End

Close @CrsrVar
Deallocate @CrsrVar

Return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeaseShedule_Clear_distributed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_LeaseShedule_Clear_distributed]
-- Set value of Lease of all equipment associated to 0
-- Set total amount of Lease Schedule to 0.
-- notify lease company that lease schedule is completed
     @intLeaseScheduleId int
As
     Declare @chvLeaseNumber varchar(50),
             @intError int

     -- Verify that lease has expired
     If GetDate() <  (Select EndDate
                      From dbo.LeaseSchedule
                      Where ScheduleId = @intLeaseScheduleId)
     	Raiserror (''Specified lease schedule has not expired yet!'', 16,1)

     If @@Error <> 0
     Begin
          Print ''Unable to eliminate lease amounts from the database!''
          Return 50000
     End

     -- get lease number
     Select @chvLeaseNumber = Lease.LeaseNumber
     From dbo.Lease Lease
     Inner Join dbo.LeaseSchedule  LeaseSchedule
     On Lease.LeaseId = LeaseSchedule.LeaseId
     Where (LeaseSchedule.ScheduleId = @intLeaseScheduleId)

     Begin Distributed Transaction

     -- Set value of Lease of all equipment associated to 0
     Update dbo.Inventory
     Set Lease = 0
     Where LeaseScheduleId = @intLeaseScheduleId
     If @@Error <> 0 Goto PROBLEM

     -- Set total amount of Lease Schedule to 0
     Update LeaseSchedule
     Set PeriodicTotalAmount = 0
     Where ScheduleId = @intLeaseScheduleId
     If @@Error <> 0 Goto PROBLEM

     -- notify lease vendor
Exec @intError = lease_srvr.LeaseShedules..prLeaseScheduleComplete
                     @chvLeaseNumber, @intLeaseScheduleId

     If @intError <> 0 GoTo PROBLEM

     Commit Transaction
     Return 0

PROBLEM:
     print ''Unable to complete lease schedule!''
     Rollback Transaction
Return 50000
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeaseContract_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_LeaseContract_Load]
-- insert lease contract information and return id of lease
          @chvLeaseVendor varchar(50),
          @chvLeaseNumber varchar(50),
          @chvLeaseDate varchar(50),
          @intLeaseId int OUTPUT
As
Declare @intError int

-- test validity of date
if IsDate(@chvLeaseDate) = 0
begin
     Raiserror (''Unable to Convert to date.'', 16, 1)
     return -1
end

insert into dbo.Lease(LeaseVendor, LeaseNumber, ContractDate)
values (@chvLeaseVendor, @chvLeaseNumber,
        Convert(smalldatetime, @chvLeaseDate))

select @intLeaseId = @@identity

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Schedule_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_Schedule_Insert]
     @intLeaseId int,
     @intLeaseFrequencyId int
As

     Insert dbo.LeaseSchedule(LeaseId, StartDate,
                              EndDate, LeaseFrequencyId)
     Values (@intLeaseId, GetDate(),
             DateAdd(Year, 3, GetDate()), @intLeaseFrequencyId)

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeaseShedule_Clear_distibuted_1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_LeaseShedule_Clear_distibuted_1]
-- Set value of Lease of all equipment associated
-- with expired Lease Schedule to 0
-- Set total amount of Lease Schedule to 0.

-- Designed to demontrate rollback without begin tran.

     @intLeaseScheduleId int
As

     -- Verify that lease has expired
     If GetDate() < (select EndDate
                     from dbo.LeaseSchedule
                     where ScheduleId = @intLeaseScheduleId)
          Raiserror (''Specified lease schedule has not expired yet!'', 16,1)

     -- If error occurs here,
     -- server will execute Rollback before transaction is started!
     if @@Error <> 0 goto PROBLEM

     Begin Transaction

     -- Set value of Lease of all equipment associated
     -- with expired Lease Schedule to 0
     update dbo.Inventory
     set Lease = 0
     where LeaseScheduleId = @intLeaseScheduleId
     if @@Error <> 0 goto PROBLEM

     -- Set total amount of Lease Schedule to 0
     update dbo.LeaseSchedule
     Set PeriodicTotalAmount = 0
     where ScheduleId = @intLeaseScheduleId
     if @@Error <> 0 goto PROBLEM

     commit transaction
     return 0

PROBLEM:

print ''Unable to eliminate lease amounts from the database!''
      rollback transaction
return 1
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeaseShedule_Clear]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_LeaseShedule_Clear]
-- Set value of Lease of all equipment
-- associated with expired Lease Schedule to 0.
-- Set total amount of Lease Schedule to 0.

     @intLeaseScheduleId int
As

Begin Transaction

-- Set value of Lease of all equipment
-- associated with expired Lease Schedule to 0
Update dbo.Inventory
Set Lease = 0
Where LeaseScheduleId = @intLeaseScheduleId

If @@Error <> 0 goto PROBLEM

-- Set total amount of Lease Schedule to 0
Update dbo.LeaseSchedule
Set PeriodicTotalAmount = 0
Where ScheduleId = @intLeaseScheduleId
If @@Error <> 0 goto PROBLEM

Commit Transaction
Return 0

PROBLEM:
Print '' Unable to eliminate lease amounts from the database!''
Rollback Transaction
Return 1
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeasedAsset_Insert1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_LeasedAsset_Insert1]
-- Insert leased asset and update total in LeaseSchedule.
-- (demonstration of imperfect solution)
(
           @intEquipmentId int,
           @intLocationId int,
           @intStatusId int,
           @intLeaseId int,
           @intLeaseScheduleId int,
           @intOwnerId int,
           @mnyLease money,
           @intAcquisitionTypeID int
)
As
set nocount on

begin transaction

-- insert asset
insert dbo.Inventory(EqId,            LocationId,
                     StatusId,        LeaseId,
                     LeaseScheduleId, OwnerId,
                     Lease,           AcquisitionTypeID)
values (@intEquipmentId,     @intLocationId,
        @intStatusId,        @intLeaseId,
        @intLeaseScheduleId, @intOwnerId,
        @mnyLease,           @intAcquisitionTypeID)
-- update total
update dbo.LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId

commit transaction

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_LeasedAsset_Insert7]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_LeasedAsset_Insert7]
-- Insert leased asset and update total in LeaseSchedule.
-- (demonstration of SET XACT_ABORT ON solution)
           (
           @intEqId int,
           @intLocationId int,
           @intStatusId int,
           @intLeaseId int,
           @intLeaseScheduleId int,
           @intOwnerId int,
           @mnyLease money,
           @intAcquisitionTypeID int
           )
As
set nocount on
SET XACT_ABORT ON
begin transaction

-- insert asset
insert Inventory(EqId,                LocationId,
                 StatusId,            LeaseId,
                 LeaseScheduleId,     OwnerId,
                 Lease,               AcquisitionTypeID)
values (         @intEqId,            @intLocationId,
                 @intStatusId,        @intLeaseId,
                 @intLeaseScheduleId, @intOwnerId,
                 @mnyLease,           @intAcquisitionTypeID)

-- update total
update LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId

commit transaction

return (0)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_OrderItem_Complete_1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_OrderItem_Complete_1]
-- Set CompletionDate of OrderItem to date
-- of last ChargeLog record associated with OrderItem.
     @intOrderItemId int
As
set nocount on
Declare @intErrorCode int
Select @intErrorCode = @@Error

If @intErrorCode = 0
     Begin Transaction

-- Set CompletionDate of OrderItem to date
-- of last ChargeLog record associated with OrderItem.
If @intErrorCode = 0
Begin
     update dbo.OrderItem
     Set CompletionDate = (Select Max(ChargeDate)
                           from dbo.ChargeLog
                           where ItemId = @intOrderItemId)
     Where ItemId = @intOrderItemId

     Select @intErrorCode = @@Error
End

If @intErrorCode = 0
Begin
     exec @intErrorCode = dbo.ap_NotifyAccounting @intOrderItemId
End

If @intErrorCode = 0 and @@trancount > 0
     Commit Transaction
Else
     Rollback Transaction
Return @intErrorCode
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ChargeLog_Insert_wTranState]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_ChargeLog_Insert_wTranState]
	@ItemId int,
	@ActionId smallint,
	@Cost money,
	@Note varchar(max),
	@Activity varchar(1000)
as
declare @Today smalldatetime
declare @User sysname
declare @ErrorCode int
declare @EqId int
declare @Price money

BEGIN TRY
	select @Today = GetDate()
	set @User = system_user

	BEGIN TRAN
	INSERT [dbo].[ChargeLog]([ItemId],[ActionId],[ChargeDate],
                             [Cost],[Note])
	VALUES (@ItemId, @ActionId, @Today, @Cost, @Note)

	select @EqId = EqId from dbo.OrderItem
	where ItemId = @ItemId

	select @EqId = EqId from dbo.OrderItem
	where ItemId = @ItemId

	select @Price = Price
	from dbo.PriceList
	where EqId = @EqId

	INSERT INTO dbo.Sales(EqId, [UnitPrice], [Qty], [ExtPrice] ,[SalesDate])
    VALUES (@EqId, @Price, 1, @Price, @today)
	
	INSERT INTO dbo.ActivityLog(Activity,LogDate,UserName,Note)
	VALUES	(@Activity, @Today , @User, @Note)

	COMMIT TRAN
END TRY
BEGIN CATCH
	set @ErrorCode = Error_Number()
	if xact_state() = -1
	begin
		-- transaction is uncommittable
		ROLLBACK TRAN
		INSERT dbo.ErrorLog(ErrorNum,ErrorType,ErrorMsg,ErrorSource, ErrorState)
		VALUES (@ErrorCode, ''E'', ''Unable to record transaction in ChargeLog.'',
			 ERROR_PROCEDURE(), -1)
	end
	else if xact_state() = 0
	begin
		--error occurred before tran started
		INSERT dbo.ErrorLog(ErrorNum,ErrorType,ErrorMsg,ErrorSource, ErrorState)
		VALUES (@ErrorCode,''E'', ''Unable to pre-process ChargeLog transaction.'',
			 ERROR_PROCEDURE(), 0)
	end
	else if xact_state() = 1
	begin
		--error could be committed or rolled back
		commit tran
		if exists(select * from dbo.ActivityLog
					where Activity = @Activity
					and LogDate = @Today
                    and UserName = @User)
		begin
			commit tran
			INSERT dbo.ErrorLog(ErrorNum,ErrorType,ErrorMsg,ErrorSource, ErrorState)
			VALUES (@ErrorCode,''E'', ''Unable to record transaction in ActivityLog.'',
				   ERROR_PROCEDURE(), 1)
		end

		if exists(select * from dbo.Sales
					where EqId = @Activity
					and [SalesDate] = @Today)
		begin
			commit tran
			INSERT dbo.ErrorLog(ErrorNum,ErrorType,ErrorMsg,ErrorSource, ErrorState)
			VALUES (@ErrorCode,''E'', ''Unable to record transaction in Sales.'',
				   ERROR_PROCEDURE(), 1)
		end

	end
END CATCH

return @ErrorCode
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ScrapOrderItem_Save]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[ap_ScrapOrderItem_Save]
-- Saves order item.
-- If error occurs, this item will be rolled back,
-- but other items will be saved.

-- demonstration of use of Save Transaction
-- must be called from sp or batch that initiates transaction
     @intOrderId int,
     @intInventoryId int,
     @intOrderItemId int OUTPUT
As
     Set nocount on
     Declare   @intErrorCode int,
               @chvInventoryId varchar(10)

     -- name the transaction savepoint
     Set @chvInventoryId = Convert(varchar, @intInventoryId)

     Save Transaction @chvInventoryId

     -- Set value of Lease of all equipment associated
     -- with expired Lease Schedule to 0
     Insert dbo.OrderItem (OrderId, InventoryId)
     Values (@intOrderId, @intInventoryId)

     Select @intOrderItemId = @@identity,
            @intErrorCode = @@Error

     If @intErrorCode <> 0
     Begin
          Rollback Transaction @chvInventoryId
          Return @intErrorCode
     End

Return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Sales_IncreasePrice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_Sales_IncreasePrice]
	@Factor real,
	@Date smalldatetime
as

set xact_abort on

begin tran
update dbo.Sales
set UnitPrice = UnitPrice * @Factor,
	ExtPrice = ExtPrice * @Factor
where  SalesDate = @Date

waitfor delay ''0:00:10''

update dbo.PriceList
set Price = Price * @Factor

commit tran' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_SalesByDate_IncreasePrice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_SalesByDate_IncreasePrice]
	@Factor real,
	@Date smalldatetime
as

set xact_abort on

begin tran
update dbo.Sales
set UnitPrice = UnitPrice * @Factor,
	ExtPrice = ExtPrice * @Factor
where  SalesDate = @Date

waitfor delay ''0:00:10''

update dbo.PriceList
set Price = Price * @Factor

commit tran' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_PriceByEqId_Set]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ap_PriceByEqId_Set]
	@EqId int,
	@Price money
as
-- exec ap_PriceByEqId_Set 1, $16.82
set xact_abort on
begin tran
update dbo.PriceList
set Price = @Price
where EqId = @EqId

waitfor delay ''0:00:10''

update dbo.Sales
set UnitPrice = @Price, 
	ExtPrice = @Price * Qty
where EqId = @EqId

commit tran

/*
declare @i int
set @i = 1
while @i <= 10
begin
	begin try
		set xact_abort on
		begin tran

		update dbo.PriceList
		set Price = @Price
		where EqId = @EqId

		waitfor delay ''0:00:10''

		update dbo.Sales
		set UnitPrice = @Price, 
			ExtPrice = @Price * Qty
		where EqId = @EqId

		commit tran

		------------
		print ''completed''
		break
	end try
	begin catch
		if ERROR_NUMBER() = 1205
		begin 
			rollback tran
			set @i = @i + 1
			print ''retry''
			INSERT INTO [dbo].[ErrorLog]([ErrorNum],[ErrorType],[ErrorMsg]
						,[ErrorSource],[CreatedBy],[CreateDT],[ErrorState])
			VALUES(Error_Number(), ''E'', Error_Message(), 
					Error_Procedure(), suser_sname(), GetDate(), Error_State())
			waitfor delay ''0:00:03''
		end
	end catch
end
print ''Completed''
*/' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_PriceByEqId_Set_wRetry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ap_PriceByEqId_Set_wRetry]
	@EqId int,
	@Price money
as
-- exec ap_PriceByEqId_Set_wRetry 1, $16.82
/*set xact_abort on
begin tran

update dbo.PriceList
set Price = @Price
where EqId = @EqId

waitfor delay ''0:00:10''

update dbo.Sales
set UnitPrice = @Price, 
	ExtPrice = @Price * Qty
where EqId = @EqId

commit tran
*/


declare @i int
set @i = 1
while @i <= 10
begin
	begin try
		set xact_abort on
		begin tran

		update dbo.PriceList
		set Price = @Price
		where EqId = @EqId

		waitfor delay ''0:00:10''

		update dbo.Sales
		set UnitPrice = @Price, 
			ExtPrice = @Price * Qty
		where EqId = @EqId

		commit tran

		------------
		print ''completed''
		break
	end try
	begin catch
		if ERROR_NUMBER() = 1205
		begin 
			rollback tran
			set @i = @i + 1
			print ''retry''
			INSERT INTO [dbo].[ErrorLog]([ErrorNum],[ErrorType],[ErrorMsg]
						,[ErrorSource],[CreatedBy],[CreateDT],[ErrorState])
			VALUES(Error_Number(), ''E'', Error_Message(), 
					Error_Procedure(), suser_sname(), GetDate(), Error_State())
			waitfor delay ''0:00:03''
		end
	end catch
end
print ''Completed''
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqImage_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ap_EqImage_Update]
	@EqId int,
	@EqImage varbinary(max)
AS
BEGIN
	SET NOCOUNT ON;
        
    update dbo.Eq
	set @EqImage = EqImage
    where EqId = @EqId

END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqImage_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_EqImage_List]
	-- Add the parameters for the stored procedure here
	@EqId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select EqImage
    from dbo.Eq
    where EqId = @EqId
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Eq_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_Eq_List]
WITH EXECUTE AS CALLER
AS
select *
from dbo.Eq' 
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List records in Eq table (synoni' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'PROCEDURE', @level1name=N'ap_Eq_List'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqImage_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ap_EqImage_Get]
	@EqId int,
	@EqImage varbinary(max) output
AS
BEGIN
	SET NOCOUNT ON;

	select @EqImage = EqImage
    from dbo.Eq
    where EqId = @EqId
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ChargeLog_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_ChargeLog_Insert]
	@ItemId int,
	@ActionId smallint,
	@Cost money,
	@Note varchar(max),
	@Activity varchar(1000)
as

BEGIN TRY
	INSERT [dbo].[ChargeLog]([ItemId],[ActionId],[ChargeDate],
                             [Cost],[Note])
	VALUES (@ItemId, @ActionId, GetDate(), @Cost, @Note)

	INSERT INTO [dbo].[ActivityLog]([Activity],[LogDate],[UserName],[Note])
	VALUES	(@Activity,GetDate(),system_user,@Note)
END TRY
BEGIN CATCH
	INSERT INTO [dbo].[ErrorLog]([ErrorNum],[ErrorType],[ErrorMsg],[ErrorSource])
	VALUES (50000,''E'', ''Unable to record transaction in ChargeLog.'',''ap_ChargeLog_Insert'')
END CATCH

return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ChargeLog_Insert_wTran]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_ChargeLog_Insert_wTran]
	@ItemId int,
	@ActionId smallint,
	@Cost money,
	@Note varchar(max),
	@Activity varchar(1000)
as

BEGIN TRY
	BEGIN TRAN
	INSERT [dbo].[ChargeLog]([ItemId],[ActionId],[ChargeDate],
                             [Cost],[Note])
	VALUES (@ItemId, @ActionId, GetDate(), @Cost, @Note)

	INSERT INTO [dbo].[ActivityLog]([Activity],[LogDate],[UserName],[Note])
	VALUES	(@Activity,GetDate(),system_user,@Note)
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	INSERT INTO [dbo].[ErrorLog]([ErrorNum],[ErrorType],[ErrorMsg],[ErrorSource])
	VALUES (50000,''E'', ''Unable to record transaction in ChargeLog.'',ERROR_PROCEDURE())
END CATCH

return
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_ChargeLog_Insert2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_ChargeLog_Insert2]
   @ItemId int,
   @ActionId smallint,
   @Cost money,
   @Note varchar(max),
   @Activity varchar(1000)
as

BEGIN TRY
   INSERT [dbo].[ChargeLog]([ItemId],[ActionId],[ChargeDate],
                             [Cost],[Note])
   VALUES (@ItemId, @ActionId, GetDate(), 
           @Cost, @Note)

   INSERT INTO [dbo].[ActivityLog]([Activity],[LogDate],
                                    [UserName],[Note])
   VALUES(@Activity, GetDate(),
          system_user, @Note)
END TRY
BEGIN CATCH
	declare @msg varchar(255)
	declare @severity int 
	set @severity = ERROR_SEVERITY()
	set @msg = ''Unable to record transaction in ChargeLog.'' 
             + ''Error('' + ERROR_NUMBER() + ''):'' + ERROR_MESSAGE()
             + '' Severity  = '' + ERROR_SEVERITY()
             + '' State     = '' + ERROR_STATE()
             + '' Procedure = '' + ERROR_PROCEDURE()
             + '' Line num. = '' + ERROR_LINE()

	INSERT INTO [dbo].[ErrorLog]([ErrorNum],[ErrorType],[ErrorMsg],[ErrorSource])
	VALUES (ERROR_NUMBER(), ''E'', @msg, ERROR_PROCEDURE())
	
    RAISERROR (@msg, @severity, 1)
END CATCH

Return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Inventory_InsertXA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[ap_Inventory_InsertXA]
-- insert inventory record , update inventory count and return Id
-- (demonstration of alternative method for error handling and transaction processing)

   @intEqId int, 
   @intLocationId int, 
   @inyStatusId tinyint, 
   @intLeaseId int, 
   @intLeaseScheduleId int, 
   @intOwnerId int, 
   @mnsRent smallmoney, 
   @mnsLease smallmoney, 
   @mnsCost smallmoney, 
   @inyAcquisitionTypeID int,
   @intInventoryId int output
   
As
declare @intTrancountOnEntry int
set nocount on
set xact_abort on
set @intTrancountOnEntry = @@tranCount

if @@tranCount = 0
   begin tran

Insert into dbo.Inventory (EqId, LocationId, StatusId, 
         LeaseId, LeaseScheduleId, OwnerId, 
         Rent, Lease, Cost, 
         AcquisitionTypeID)
values (@intEqId, @intLocationId, @inyStatusId, 
        @intLeaseId, @intLeaseScheduleId, @intOwnerId, 
        @mnsRent, @mnsLease, @mnsCost, 
        @inyAcquisitionTypeID)

select @intInventoryId = Scope_Identity()

update dbo.InventoryCount
Set InvCount = InvCount + 1
where LocationId = @intLocationId

if @@rowcount <> 1
begin
   -- business error
   Raiserror(50133, 16, 1)
   if @@tranCount > @intTrancountOnEntry
      rollback tran 
   return 50133
end

if @@tranCount > @intTrancountOnEntry
   commit tran

return 0

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EquipmentByEqTypeID_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ap_EquipmentByEqTypeID_Get]
	@intEqTypeId [int]
WITH EXECUTE AS CALLER
AS
	Select *
    from dbo.Equipment
    where EqTypeId = @intEqTypeId
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apEquipment_Insert_1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[apEquipment_Insert_1]
-- Store values in Equipment table.
-- Return identifier of the record to the caller.
/*
declare @rc int
begin tran
exec @rc = dbo.apEquipment_Insert_1 ''test'', ''test'', ''test''
select @rc id
rollback tran
*/
     (
          @chvMake varchar(50),
          @chvModel varchar(50),
          @chvEqType varchar(30)
     )
As
declare   @intEqTypeId int,
          @intEqId int

-- read Id of EqType
Select @intEqTypeId = EqTypeId
From dbo.EqType
Where EqType = @chvEqType
-- does such eqType already exists in the database
If  @intEqTypeId IS NOT NULL
     --insert equipment
     Insert dbo.Equipment (Make, Model, EqTypeId)
     Values (@chvMake, @chvModel, @intEqTypeId)
Else
     --if it does not exist
     Begin
          -- insert new EqType in the database
          Insert dbo.EqType (EqType)
          Values (@chvEqType)

          -- get id of record that you''ve just inserted
          Select @intEqTypeId = @@identity

          --insert equipment
          Insert dbo.Equipment (Make, Model, EqTypeId)
          Values (@chvMake, @chvModel, @intEqTypeId)
     End
Select @intEqId = @@identity

-- return id to the caller
return @intEqId

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Equipment_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[ap_Equipment_List]
as
     Select *
     from dbo.Equipment


' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqIdByMakeModel_List_5]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_EqIdByMakeModel_List_5]
     @chvMake varchar(50),
     @chvModel varchar(50),
     @intEqId int output
As
     select @intEqId = EqId
     from dbo.Equipment
     where Make = @chvMake
     and Model = @chvModel
Return @@error
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqIdByMakeModel_List_6]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_EqIdByMakeModel_List_6]
     @chvMake  varchar(50) = ''%'',
     @chvModel varchar(50) = ''%''
as
     Select *
     from dbo.Equipment
     where Make Like @chvMake
     and Model Like @chvModel' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vInventory_Ordered]'))
EXEC dbo.sp_executesql @statement = N'Create VIEW [dbo].[vInventory_Ordered]
AS
SELECT TOP 100 PERCENT 
dbo.Inventory.Inventoryid, dbo.Equipment.Make, dbo.Equipment.Model
FROM dbo.Equipment 
   RIGHT OUTER JOIN dbo.Inventory 
   ON dbo.Equipment.EqId = dbo.Inventory.EqId 
order by dbo.Equipment.Make, dbo.Equipment.Model
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vLaptopInventory]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[vLaptopInventory]
 
as
select i.Inventoryid, i.EqId, i.StatusId, e.Make, e.Model
from dbo.Inventory I
inner join dbo.Equipment e
on i.EqId = e.EqId
where EqTypeId = 1
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Equipment_Insert_1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_Equipment_Insert_1]
-- Store values in Equipment table.
-- Return identifier of the record to the caller.
/*
declare @rc int
begin tran
exec @rc = dbo.ap_Equipment_Insert_1 ''test'', ''test'', ''test''
select @rc id
rollback tran
*/
     (
          @chvMake varchar(50),
          @chvModel varchar(50),
          @chvEqType varchar(30)
     )
As
declare   @intEqTypeId int,
          @intEqId int

-- read Id of EqType
Select @intEqTypeId = EqTypeId
From dbo.EqType
Where EqType = @chvEqType
-- does such eqType already exists in the database
If  @intEqTypeId IS NOT NULL
     --insert equipment
     Insert dbo.Equipment (Make, Model, EqTypeId)
     Values (@chvMake, @chvModel, @intEqTypeId)
Else
     --if it does not exist
     Begin
          -- insert new EqType in the database
          Insert dbo.EqType (EqType)
          Values (@chvEqType)

          -- get id of record that you''ve just inserted
          Select @intEqTypeId = @@identity

          --insert equipment
          Insert dbo.Equipment (Make, Model, EqTypeId)
          Values (@chvMake, @chvModel, @intEqTypeId)
     End
Select @intEqId = @@identity

-- return id to the caller
return @intEqId

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Equipment_Insert_3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_Equipment_Insert_3]
-- Store values in equipment table.
-- Return identifier of the record to the caller.
     (
          @chvMake varchar(50),
          @chvModel varchar(50),
          @chvEqType varchar(30)
     )
As
/*
declare @rc int
begin tran
exec @rc = dbo.ap_Equipment_Insert_3 ''test'', ''test'', ''test''
select @rc id
rollback tran
*/
declare @intEqTypeId int,
        @ErrorCode int,
        @intEqId int

-- does such eqType already exists in the database
If  Not Exists (Select EqTypeId From dbo.EqType Where EqType = @chvEqType)
     --if it does not exist
     Begin
          -- insert new EqType in the database
          Insert dbo.EqType (EqType)
          Values (@chvEqType)

          -- get id of record that you''ve just inserted
          Select @intEqTypeId = @@identity,
                 @ErrorCode = @@Error
          If @ErrorCode <> 0
               begin
                    Select ''Unable to insert Equipment Type. Error: '',
                            @ErrorCode
                    Return -1
               End
     End
Else
     Begin
          -- read Id of EqType
          Select @intEqTypeId = EqTypeId
          From dbo.EqType
          Where EqType = @chvEqType

          Select @ErrorCode = @@Error

          If @ErrorCode <> 0
             begin

                Select ''Unable to get Id of Equipment Type. Error: '',
                       @ErrorCode
                    Return -2
             End
     End

--insert equipment
Insert dbo.Equipment (Make, Model, EqTypeId)
Values (@chvMake, @chvModel, @intEqTypeId)

-- return id to the caller
Select @intEqId = @@identity,
       @ErrorCode = @@Error

If @ErrorCode <> 0
     Begin
          Select ''Unable to insert Equipment. Error: '', @ErrorCode
          Return -3
     End


Return @intEqId
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Equipment_Insert_2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_Equipment_Insert_2]
-- Store values in equipment table.
-- Return identifier of the record to the caller.
     (
          @chvMake varchar(50),
          @chvModel varchar(50),
          @chvEqType varchar(30)
     )
As
/*
declare @rc int
begin tran
exec @rc = dbo.apEquipment_Insert_2 ''test'', ''test'', ''test''
select @rc id
rollback tran
*/
declare   @intEqTypeId int,
          @intEquipmentIdEqId int


-- does such eqType already exists in the database
If  Not Exists (Select EqTypeId From dbo.EqType Where EqType = @chvEqType)
     --if it does not exist
     Begin
          -- insert new EqType in the database
          Insert dbo.EqType (EqType)
          Values (@chvEqType)

          -- get id of record that you''ve just inserted
          Select @intEqTypeId = @@identity
     End
else
     -- read Id of EqType
     Select @intEqTypeId = EqTypeId
     From dbo.EqType
     Where EqType = @chvEqType

--insert equipment
Insert dbo.Equipment (Make, Model, EqTypeId)
Values (@chvMake, @chvModel, @intEqTypeId)

Select @intEquipmentIdEqId = @@identity

-- return id to the caller
Return @intEquipmentIdEqId
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EquipmentByMake_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_EquipmentByMake_List]
     @chvMake varchar(50)
as
     Select *
     from dbo.Equipment
     where Make = @chvMake
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqIdByMakeModel_List_3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ap_EqIdByMakeModel_List_3]
     @chvMake varchar(50),
     @chvModel varchar(50)
as
Declare @intEqId int

Select @intEqId  = EqId
from dbo.Equipment
where Make = @chvMake
and Model = @chvModel

Return @intEqId
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqIdByMakeModel_List_4]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_EqIdByMakeModel_List_4]
     @chvMake varchar(50),
     @chvModel varchar(50)
as
   Return (select EqId
           from dbo.Equipment
           where Make = @chvMake
           and Model = @chvModel)
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqIdByMakeModel_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create procedure [dbo].[ap_EqIdByMakeModel_List]
     @chvMake varchar(50),
     @chvModel varchar(50)
as
     select EqId
     from dbo.Equipment
     where Make = @chvMake
     and Model = @chvModel
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_EqIdByMakeModel_List_2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[ap_EqIdByMakeModel_List_2]
     @chvMake varchar(50),
     @chvModel varchar(50),
     @intEqId int output

as

select @intEqId = EqId
from dbo.Equipment
where Make = @chvMake
and Model = @chvModel
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderItem_wUDT]') AND type in (N'U'))
--BEGIN
--CREATE TABLE [dbo].[OrderItem_wUDT](
--	[OrderItemId] [int] NULL,
--	[OrderId] [int] NULL,
--	[PartId] [int] NULL,
--	[ExtPrice] [dbo].[ExtPriceUDT] NULL
--) ON [PRIMARY]
--END
--GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_Order_Complete_1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[ap_Order_Complete_1]
-- Complete all orderItems and then complete order
	@intOrderId int,
	@dtsCompletionDate smalldatetime
As
set nocount on

Declare @intErrorCode int,
        @i int,
        @intCountOrderItems int,
        @intOrderItemId int

Select @intErrorCode = @@Error

If @intErrorCode = 0
    Begin Transaction

-- complete order
If @intErrorCode = 0
Begin
     Update dbo.[Order]
     Set CompletionDate = @dtsCompletionDate,
         OrderStatusId = 4 -- completed
     Where OrderId = @intOrderId

     Select @intErrorCode = @@Error
End

-- loop through OrderItems and complete them
If @intErrorCode = 0
Begin
     Create Table #OrderItems(
          id int identity(1,1),
          OrderItemId int)

     Select @intErrorCode = @@Error
End

-- collect orderItemIds
If @intErrorCode = 0
Begin
     Insert Into #OrderItems(OrderItemId)
          Select ItemId
          From dbo.OrderItem
          Where OrderId = @intOrderId
          Select @intErrorCode = @@Error
End

If @intErrorCode = 0
Begin
     Select @intCountOrderItems = Max(Id),
            @i = 1
     From #OrderItems

     Select @intErrorCode = @@Error
End

while @intErrorCode = 0 and @i <= @intCountOrderItems
Begin
     If @intErrorCode = 0
     Begin
          Select @intOrderItemId = OrderItemId
          From #OrderItems
          Where id = @i
          Select @intErrorCode = @@Error
     End

     If @intErrorCode = 0
          Exec @intErrorCode = dbo.ap_OrderItem_Complete_1 @intOrderItemId

     If @intErrorCode = 0
          Set @i = @i + 1
End

If @intErrorCode = 0 and @@trancount > 0
      Commit Transaction
Else
      Rollback Transaction
return @intErrorCode
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryProperties_Get_UseNestedCursor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create Procedure [dbo].[ap_InventoryProperties_Get_UseNestedCursor]
-- return comma-delimited list of properties
-- that are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;
-- Property = Value unit;Property = Value unit;...

   (
      @intInventoryId int,
      @chvProperties varchar(max) OUTPUT,
      @debug int = 0
   )

As

Declare @intCountProperties int,
        @intCounter int,
        @chvProperty varchar(50),
        @chvValue varchar(50),
        @chvUnit varchar(50),
        @insLenProperty smallint,
        @insLenValue smallint,
        @insLenUnit smallint,
        @insLenProperties smallint

Set @chvProperties = ''''

Declare @CrsrVar Cursor

Exec dbo.ap_InventoryProperties_Get_wCursor @intInventoryId,
                                          @CrsrVar Output

Fetch Next From @CrsrVar
Into @chvProperty, @chvValue, @chvUnit

While (@@FETCH_STATUS = 0)
Begin

   Set @chvUnit = Coalesce(@chvUnit, '''')

   If @debug <> 0
      Select @chvProperty Property,
            @chvValue [Value],
            @chvUnit [Unit]

   -- assemble list
   Set @chvProperties = @chvProperties
                      + @chvProperty + ''=''
                      + @chvValue + '' ''
                      + @chvUnit + ''; ''
   If @debug <> 0
      Select @chvProperties chvProperties

   Fetch Next From @CrsrVar
   Into @chvProperty, @chvValue, @chvUnit

End

Close @CrsrVar
Deallocate @CrsrVar

Return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ap_InventoryEquipment_Insert_XA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[ap_InventoryEquipment_Insert_XA]
-- insert new inventory and new equipment
-- (demonstration of alternative method for error handling and transaction processing)
    @chvMake varchar(50),
    @chvModel varchar(50),
    @chvEqType varchar(30),
    @intLocationId int, 
    @inyStatusId tinyint, 
    @intLeaseId int, 
    @intLeaseScheduleId int, 
    @intOwnerId int, 
    @mnsRent smallmoney, 
    @mnsLease smallmoney, 
    @mnsCost smallmoney, 
    @inyAcquisitionTypeID int,
    @intInventoryId int output,
    @intEqId int output
as

Set nocount on
set xact_abort on

declare @intError int,
        @intTrancountOnEntry int
     
set @intError = 0
set @intTrancountOnEntry = @@tranCount

if @@tranCount = 0
    begin tran

-- is equipment already in the database
if not exists(select EqId 
              from Equipment 
              where Make = @chvMake 
              and Model = @chvModel)
EXEC @intError = dbo.ap_Equipment_Insert @chvMake, @chvModel,   @chvEqType,
                                        @intEqId OUTPUT

if @intError > 0
begin
    if @@tranCount > @intTrancountOnEntry
        rollback tran
    return @intError
end

exec @intError = dbo.ap_Inventory_InsertXA
      @intEqId,              @intLocationId,      @inyStatusId, 
      @intLeaseId,           @intLeaseScheduleId, @intOwnerId, 
      @mnsRent,              @mnsLease,           @mnsCost, 
      @inyAcquisitionTypeID, @intInventoryId output

if @intError > 0
begin
    if @@tranCount > @intTrancountOnEntry
        ROLLBACK TRAN 
    return @intError
end

if @@tranCount > @intTrancountOnEntry
    COMMIT TRAN

return 0
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnInventoryByLocationId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[fnInventoryByLocationId](
        @LocationId int)
Returns Table
AS 
Return (SELECT * 
        FROM dbo.vInventory
        WHERE LocationId = @LocationId)
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vInventoryTrigonTower]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vInventoryTrigonTower]
AS
SELECT * 
FROM dbo.vInventory
WHERE LocationId = 2
WITH CHECK OPTION
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vInventoryVertSplit]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vInventoryVertSplit]
as
select IP.Inventoryid, IP.Make,      IP.Model, 
       IP.Location,    IP.FirstName, IP.LastName, 
       IP.UserName,    IP.EqType,    ISec.AcquisitionType, 
       ISec.Address,   ISec.City,    ISec.ProvinceId, 
       ISec.Country,   ISec.Phone,   ISec.Fax, 
       ISec.Email
from dbo.InventoryPrim IP
full join dbo.InventorySec ISec
on IP.Inventoryid = ISec.Inventoryid
' 
GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clrtvf_GetLogicalDrives]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
--BEGIN
--execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[clrtvf_GetLogicalDrives]()
--RETURNS  TABLE (
--	[i] [int] NULL,
--	[DriveLogicalName] [nvarchar](255) NULL,
--	[DriveType] [nvarchar](255) NULL,
--	[DriveFreeSpace] [bigint] NULL
--) WITH EXECUTE AS CALLER
--AS
--EXTERNAL NAME [GetDrive].[GetDrives].[clrtvf_GetLogicalDrives]' 
--END
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_GetLogicalDrives'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'cf_getDrive.cs' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_GetLogicalDrives'
--
--GO
--EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=31 ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'FUNCTION', @level1name=N'clrtvf_GetLogicalDrives'
--
--GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrgUnit_OrgUnit]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrgUnit]'))
ALTER TABLE [dbo].[OrgUnit]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnit_OrgUnit] FOREIGN KEY([ParentOrgUnitId])
REFERENCES [dbo].[OrgUnit] ([OrgUnitId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Equipment_EqTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Equipment]'))
ALTER TABLE [dbo].[Equipment]  WITH NOCHECK ADD  CONSTRAINT [FK_Equipment_EqTypeId] FOREIGN KEY([EqTypeId])
REFERENCES [dbo].[EqType] ([EqTypeId])
GO
ALTER TABLE [dbo].[Equipment] CHECK CONSTRAINT [FK_Equipment_EqTypeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Equipment2_EqTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Equipment2]'))
ALTER TABLE [dbo].[Equipment2]  WITH NOCHECK ADD  CONSTRAINT [FK_Equipment2_EqTypeId] FOREIGN KEY([EqTypeId])
REFERENCES [dbo].[EqType] ([EqTypeId])
GO
ALTER TABLE [dbo].[Equipment2] CHECK CONSTRAINT [FK_Equipment2_EqTypeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inventory_AcquisitionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inventory]'))
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_AcquisitionType] FOREIGN KEY([AcquisitionTypeID])
REFERENCES [dbo].[AcquisitionType] ([AcquisitionTypeId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inventory_EquipmentID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inventory]'))
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_EquipmentID] FOREIGN KEY([EqId])
REFERENCES [dbo].[Equipment] ([EqId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inventory_Lease]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inventory]'))
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Lease] FOREIGN KEY([LeaseId])
REFERENCES [dbo].[Lease] ([LeaseId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inventory_LeaseSchedule]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inventory]'))
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_LeaseSchedule] FOREIGN KEY([LeaseScheduleId])
REFERENCES [dbo].[LeaseSchedule] ([ScheduleId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inventory_Location]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inventory]'))
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Inventory_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Inventory]'))
ALTER TABLE [dbo].[Inventory]  WITH CHECK ADD  CONSTRAINT [FK_Inventory_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChargeLog_Action]') AND parent_object_id = OBJECT_ID(N'[dbo].[ChargeLog]'))
ALTER TABLE [dbo].[ChargeLog]  WITH CHECK ADD  CONSTRAINT [FK_ChargeLog_Action] FOREIGN KEY([ActionId])
REFERENCES [dbo].[Action] ([ActionId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LeaseSchedule_Lease]') AND parent_object_id = OBJECT_ID(N'[dbo].[LeaseSchedule]'))
ALTER TABLE [dbo].[LeaseSchedule]  WITH CHECK ADD  CONSTRAINT [FK_LeaseSchedule_Lease] FOREIGN KEY([LeaseId])
REFERENCES [dbo].[Lease] ([LeaseId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LeaseSchedule_LeaseFrequency]') AND parent_object_id = OBJECT_ID(N'[dbo].[LeaseSchedule]'))
ALTER TABLE [dbo].[LeaseSchedule]  WITH CHECK ADD  CONSTRAINT [FK_LeaseSchedule_LeaseFrequency] FOREIGN KEY([LeaseFrequencyId])
REFERENCES [dbo].[LeaseFrequency] ([LeaseFrequencyId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderHeader_OrderStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderHeader]'))
ALTER TABLE [dbo].[OrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_OrderHeader_OrderStatus] FOREIGN KEY([OrderStatusid])
REFERENCES [dbo].[OrderStatus] ([OrderStatusId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderHeader_OrderType]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderHeader]'))
ALTER TABLE [dbo].[OrderHeader]  WITH CHECK ADD  CONSTRAINT [FK_OrderHeader_OrderType] FOREIGN KEY([OrderTypeId])
REFERENCES [dbo].[OrderType] ([OrderTypeId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Location_Province]') AND parent_object_id = OBJECT_ID(N'[dbo].[Location]'))
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_Location_Province] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([ProvinceId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderItem_OrderHeader]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderItem]'))
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_OrderHeader] FOREIGN KEY([OrderId])
REFERENCES [dbo].[OrderHeader] ([OrderId])
Go

/****** Object:  DdlTrigger [trdAuditTableChanges]    Script Date: 04/17/2005 19:41:27 ******/
CREATE TRIGGER [trdAuditTableChanges]
ON DATABASE 
AFTER DDL_TABLE_EVENTS
AS 
	

declare @event xml
set @event = EVENTDATA()
select @Event

/*select @event.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)')
select @event.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(100)')
select @event.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)')
*/

INSERT INTO [dbo].[ActivityLog]([Activity],[LogDate],[UserName],[Note])
VALUES 
(@event.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
 GETDATE(), 
 @event.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(100)'), 
 @event.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)') );

--ROLLBACK
 

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ENABLE TRIGGER [trdAuditTableChanges] ON DATABASE
GO
