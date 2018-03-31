set xact_abort on
insert into Asset511.dbo.vInventoryDist
select * from AssetXML.dbo.InventoryCanada


set xact_abort on
INSERT INTO [Asset51].[dbo].[vInventoryDist]
           ([Inventoryid],
			[Make]
           ,[Model]
           ,[Location]
           ,[FirstName]
           ,[LastName]
           ,[AcquisitionType]
           ,[Address]
           ,[City]
           ,[ProvinceId]
           ,[Country]
           ,[EqType]
           ,[Phone]
           ,[Fax]
           ,[Email]
           ,[UserName])
SELECT [Inventoryid] + 100000,
      [Make]
      ,[Model]
      ,[Location]
      ,[FirstName]
      ,[LastName]
      ,[AcquisitionType]
      ,[Address]
      ,'Pgh'
      ,'PA'
      ,'USA'
      ,[EqType]
      ,[Phone]
      ,[Fax]
      ,[Email]
      ,[UserName]
  FROM [AssetXML].[dbo].[InventoryCanada]
where ProvinceId = 'ON'

set xact_abort on
INSERT INTO [Asset51].[dbo].[vInventoryDist]
           ([Inventoryid],
			[Make]
           ,[Model]
           ,[Location]
           ,[FirstName]
           ,[LastName]
           ,[AcquisitionType]
           ,[Address]
           ,[City]
           ,[ProvinceId]
           ,[Country]
           ,[EqType]
           ,[Phone]
           ,[Fax]
           ,[Email]
           ,[UserName])
SELECT [Inventoryid] + 200000,
      [Make]
      ,[Model]
      ,[Location]
      ,[FirstName]
      ,[LastName]
      ,[AcquisitionType]
      ,[Address]
      ,'London'
      ,'EN'
      ,'UK'
      ,[EqType]
      ,[Phone]
      ,[Fax]
      ,[Email]
      ,[UserName]
  FROM [AssetXML].[dbo].[InventoryCanada]
where ProvinceId <> 'ON'



