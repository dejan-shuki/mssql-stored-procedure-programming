IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Asset')
	DROP DATABASE [Asset]
GO

CREATE DATABASE [Asset]  ON (NAME = N'Asset_Data', FILENAME = N'c:\program files\microsoft sql server\mssql$SQL2000\data\Asset_data.mdf' , SIZE = 3, FILEGROWTH = 10%) LOG ON (NAME = N'Asset_Log', FILENAME = N'c:\program files\microsoft sql server\mssql$SQL2000\data\Asset_log.ldf' , FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO

exec sp_dboption N'Asset', N'autoclose', N'false'
GO

exec sp_dboption N'Asset', N'bulkcopy', N'true'
GO

exec sp_dboption N'Asset', N'trunc. log', N'true'
GO

exec sp_dboption N'Asset', N'torn page detection', N'false'
GO

exec sp_dboption N'Asset', N'read only', N'false'
GO

exec sp_dboption N'Asset', N'dbo use', N'false'
GO

exec sp_dboption N'Asset', N'single', N'false'
GO

exec sp_dboption N'Asset', N'autoshrink', N'true'
GO

exec sp_dboption N'Asset', N'ANSI null default', N'false'
GO

exec sp_dboption N'Asset', N'recursive triggers', N'false'
GO

exec sp_dboption N'Asset', N'ANSI nulls', N'false'
GO

exec sp_dboption N'Asset', N'concat null yields null', N'false'
GO

exec sp_dboption N'Asset', N'cursor close on commit', N'false'
GO

exec sp_dboption N'Asset', N'default to local cursor', N'false'
GO

exec sp_dboption N'Asset', N'quoted identifier', N'false'
GO

exec sp_dboption N'Asset', N'ANSI warnings', N'false'
GO

exec sp_dboption N'Asset', N'auto create statistics', N'true'
GO

exec sp_dboption N'Asset', N'auto update statistics', N'true'
GO

use [Asset]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_AcquisitionType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_AcquisitionType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ChargeLog_Action]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ChargeLog] DROP CONSTRAINT FK_ChargeLog_Action
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_Contact]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_Contact
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Order_Contact]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Order] DROP CONSTRAINT FK_Order_Contact
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Equipment_EqType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Equipment] DROP CONSTRAINT FK_Equipment_EqType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_EquipmentBC_Equipment]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[EquipmentBC] DROP CONSTRAINT FK_EquipmentBC_Equipment
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_Equipment]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_Equipment
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_OrderItem_Equipment]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[OrderItem] DROP CONSTRAINT FK_OrderItem_Equipment
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_InventoryProperty_Inventory]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[InventoryProperty] DROP CONSTRAINT FK_InventoryProperty_Inventory
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_OrderItem_Inventory]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[OrderItem] DROP CONSTRAINT FK_OrderItem_Inventory
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_Lease]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_Lease
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_LeaseSchedule_Lease]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[LeaseSchedule] DROP CONSTRAINT FK_LeaseSchedule_Lease
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_LeaseSchedule_LeaseFrequency]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[LeaseSchedule] DROP CONSTRAINT FK_LeaseSchedule_LeaseFrequency
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_LeaseSchedule]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_LeaseSchedule
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_Location]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_Location
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_OrderItem_Order]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[OrderItem] DROP CONSTRAINT FK_OrderItem_Order
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ChargeLog_OrderItem]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ChargeLog] DROP CONSTRAINT FK_ChargeLog_OrderItem
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Order_OrderStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Order] DROP CONSTRAINT FK_Order_OrderStatus
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Order_OrderType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Order] DROP CONSTRAINT FK_Order_OrderType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Contact_OrgUnit]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Contact] DROP CONSTRAINT FK_Contact_OrgUnit
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_OrgUnit_OrgUnit]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[OrgUnit] DROP CONSTRAINT FK_OrgUnit_OrgUnit
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_InventoryProperty_Property]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[InventoryProperty] DROP CONSTRAINT FK_InventoryProperty_Property
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Location_Province]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Location] DROP CONSTRAINT FK_Location_Province
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Inventory_Status]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Inventory] DROP CONSTRAINT FK_Inventory_Status
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trContact_with_BC_IU]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trContact_with_BC_IU]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[itrEqType_D]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[itrEqType_D]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trEquipment_IU]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trEquipment_IU]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trEquipment_IU_2]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trEquipment_IU_2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Equipment_DeleteTrigger]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[Equipment_DeleteTrigger]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trInventory_Lease_U]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trInventory_Lease_U]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trInventory_Lease_D]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trInventory_Lease_D]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trInventory_Lease_I]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trInventory_Lease_I]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trMyEquipment_D]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trMyEquipment_D]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trOrderStatus_U]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trOrderStatus_U]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trOrderStatus_U_1]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trOrderStatus_U_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[itr_vEquipment_I]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[itr_vEquipment_I]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[itr_vInventory_I]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[itr_vInventory_I]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnDueDays]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnDueDays]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnLastDateOfMonth]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnLastDateOfMonth]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnListOfLastDatesMonth]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnListOfLastDatesMonth]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnQuarterString]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnQuarterString]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnThreeBusDays]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnThreeBusDays]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_DepartmentEquipment]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_DepartmentEquipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[A_Template]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[A_Template]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[A_Template_Loop_tempTbl]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[A_Template_Loop_tempTbl]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prAddOrder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prAddOrder]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prBackupIfLogAlmostFull]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prBackupIfLogAlmostFull]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prBcpOutTables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prBcpOutTables]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCalcFactoriel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCalcFactoriel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prClearLeaseShedule]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prClearLeaseShedule]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prClearLeaseShedule_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prClearLeaseShedule_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCloseLease]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCloseLease]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCnvDecade]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCnvDecade]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCnvDigit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCnvDigit]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCnvNumber]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCnvNumber]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCnvTeen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCnvTeen]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCnvThreeDigitNumber]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCnvThreeDigitNumber]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCnvTwoDigitNumber]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCnvTwoDigitNumber]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCompleteOrder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCompleteOrder]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCompleteOrderItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCompleteOrderItem]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCompleteOrderItem_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCompleteOrderItem_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prCompleteOrder_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prCompleteOrder_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prConvertTempTbl]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prConvertTempTbl]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prDeferredNameResolution]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prDeferredNameResolution]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prExtPropColumnList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prExtPropColumnList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prFTSearchActivityLog]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prFTSearchActivityLog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetContact]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetContact]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetEqId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetEqId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetEqId_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetEqId_2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetEqId_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetEqId_3]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetEqId_4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetEqId_4]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetEquipment_xml]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetEquipment_xml]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_3]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_Cursor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_Cursor]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_CursorGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_CursorGet]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_Cursor_Nested]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_Cursor_Nested]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_TempTbl_Outer]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_TempTbl_Outer]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetInventoryProperties_UseNestedCursor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetInventoryProperties_UseNestedCursor]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prGetShedulesAndLeases]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prGetShedulesAndLeases]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prHelloWorld_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prHelloWorld_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertEquipment_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertEquipment_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertEquipment_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertEquipment_2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertEquipment_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertEquipment_3]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertInventory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertInventory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_2]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_3]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_4]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_5]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_6]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_6]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertLeasedAsset_7]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertLeasedAsset_7]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prInsertNewSchedule]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prInsertNewSchedule]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prLeasePeriodDuration]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prLeasePeriodDuration]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListEquipment2_xml]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListEquipment2_xml]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListEquipment_HiddenCode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListEquipment_HiddenCode]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListEquipment_xml]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListEquipment_xml]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListInventoryEquipment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListInventoryEquipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListLeaseInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListLeaseInfo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListLeasedAssets]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListLeasedAssets]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prListTerms]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prListTerms]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prLoadLeaseContract]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prLoadLeaseContract]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prLogSpacePercentUsed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prLogSpacePercentUsed]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prLoopWithGoTo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prLoopWithGoTo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prNonSelectedDBOption]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prNonSelectedDBOption]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prOrderGetXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prOrderGetXML]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prOrderSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prOrderSave]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prPartList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prPartList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prProcess_Cursor_Nested]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prProcess_Cursor_Nested]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prQbfContact_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prQbfContact_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prScrapOrder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prScrapOrder]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prScrapOrderSaveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prScrapOrderSaveItem]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prSpellNumber]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prSpellNumber]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prSplitFullName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prSplitFullName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prTestXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prTestXML]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prUpdateContact]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prUpdateContact]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prUpdateContact_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prUpdateContact_1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[prUpdateEquipment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[prUpdateEquipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[setup_Contacts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[setup_Contacts]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[setup_Inventory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[setup_Inventory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[setup_Orders]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[setup_Orders]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vEquipment]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[vEquipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vInventory]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[vInventory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcquisitionType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AcquisitionType]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Action]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Action]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ActivityLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ActivityLog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ChargeLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ChargeLog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Contact]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Contact]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Contact_with_BC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Contact_with_BC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EqType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EqType]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Equipment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Equipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EquipmentBC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EquipmentBC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Inventory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Inventory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[InventoryProperty]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[InventoryProperty]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[InventoryXML]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[InventoryXML]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Lease]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Lease]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LeaseFrequency]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LeaseFrequency]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LeaseSchedule]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LeaseSchedule]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Location]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Location]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MyEquipment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MyEquipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OldEquipment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OldEquipment]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Order]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Order]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OrderItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OrderItem]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OrderStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OrderStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OrderType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OrderType]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OrgUnit]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OrgUnit]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Part]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Part]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Property]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Property]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Province]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Province]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Status]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Status]
GO

if exists (select * from dbo.systypes where name = N'typEmail')
exec sp_droptype N'typEmail'
GO

if exists (select * from dbo.systypes where name = N'typPhone')
exec sp_droptype N'typPhone'
GO

setuser
GO

EXEC sp_addtype N'typEmail', N'varchar (128)', N'null'
GO

setuser
GO

setuser
GO

EXEC sp_addtype N'typPhone', N'varchar (20)', N'null'
GO

setuser
GO

CREATE TABLE [dbo].[AcquisitionType] (
	[AcquisitionTypeId] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[AcquisitionType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Action] (
	[ActionId] [smallint] IDENTITY (1, 1) NOT NULL ,
	[Action] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Cost] [smallmoney] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ActivityLog] (
	[LogId] [int] IDENTITY (1, 1) NOT NULL ,
	[Activity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LogDate] [smalldatetime] NOT NULL ,
	[UserName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Note] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ChargeLog] (
	[ItemId] [int] NOT NULL ,
	[ActionId] [smallint] NOT NULL ,
	[ChargeDate] [datetime] NOT NULL ,
	[Cost] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Note] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Contact] (
	[ContactId] [int] IDENTITY (1, 1) NOT NULL ,
	[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Phone] [typPhone] NULL ,
	[Fax] [typPhone] NULL ,
	[Email] [typEmail] NULL ,
	[OrgUnitId] [smallint] NOT NULL ,
	[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ts] [timestamp] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Contact_with_BC] (
	[ContactId] [int] IDENTITY (1, 1) NOT NULL ,
	[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Phone] [typPhone] NULL ,
	[Fax] [typPhone] NULL ,
	[Email] [typEmail] NULL ,
	[OrgUnitId] [smallint] NOT NULL ,
	[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ts] [timestamp] NULL ,
	[BC] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EqType] (
	[EqTypeId] [smallint] IDENTITY (1, 1) NOT NULL ,
	[EqType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Equipment] (
	[EquipmentId] [int] IDENTITY (1, 1) NOT NULL ,
	[Make] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Model] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EqTypeId] [smallint] NULL ,
	[ModelSDX] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MakeSDX] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EquipmentBC] (
	[EquipmentId] [int] NOT NULL ,
	[EquipmentBC] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Inventory] (
	[Inventoryid] [int] IDENTITY (1, 1) NOT NULL ,
	[EquipmentId] [int] NOT NULL ,
	[LocationId] [int] NOT NULL ,
	[StatusId] [tinyint] NOT NULL ,
	[LeaseId] [int] NULL ,
	[LeaseScheduleId] [int] NULL ,
	[OwnerId] [int] NOT NULL ,
	[Rent] [smallmoney] NULL ,
	[Lease] [smallmoney] NULL ,
	[Cost] [smallmoney] NULL ,
	[AcquisitionTypeID] [tinyint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InventoryProperty] (
	[InventoryId] [int] NOT NULL ,
	[PropertyId] [smallint] NOT NULL ,
	[Value] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InventoryXML] (
	[Inventoryid] [int] IDENTITY (1, 1) NOT NULL ,
	[EquipmentId] [int] NOT NULL ,
	[LocationId] [int] NOT NULL ,
	[StatusId] [tinyint] NOT NULL ,
	[LeaseId] [int] NULL ,
	[LeaseScheduleId] [int] NULL ,
	[OwnerId] [int] NOT NULL ,
	[Rent] [smallmoney] NULL ,
	[Lease] [smallmoney] NULL ,
	[Cost] [smallmoney] NULL ,
	[AcquisitionTypeID] [tinyint] NULL ,
	[Properties] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Lease] (
	[LeaseId] [int] IDENTITY (1, 1) NOT NULL ,
	[LeaseVendor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LeaseNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContractDate] [smalldatetime] NOT NULL ,
	[TotalValue] [money] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LeaseFrequency] (
	[LeaseFrequencyId] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[LeaseFrequency] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LeaseSchedule] (
	[ScheduleId] [int] IDENTITY (1, 1) NOT NULL ,
	[LeaseId] [int] NOT NULL ,
	[StartDate] [smalldatetime] NOT NULL ,
	[EndDate] [smalldatetime] NOT NULL ,
	[LeaseFrequencyId] [tinyint] NOT NULL ,
	[PeriodicTotalAmount] [money] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Location] (
	[LocationId] [int] IDENTITY (1, 1) NOT NULL ,
	[Location] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ProvinceId] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MyEquipment] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OldEquipment] (
	[Make] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Model] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EqTypeid] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Order] (
	[OrderId] [int] IDENTITY (1, 1) NOT NULL ,
	[OrderDate] [smalldatetime] NOT NULL ,
	[RequestedById] [int] NOT NULL ,
	[TargetDate] [smalldatetime] NOT NULL ,
	[CompletionDate] [smalldatetime] NULL ,
	[DestinationLocationId] [int] NULL ,
	[Note] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OrderTypeId] [smallint] NOT NULL ,
	[OrderStatusid] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OrderItem] (
	[ItemId] [int] IDENTITY (1, 1) NOT NULL ,
	[OrderId] [int] NOT NULL ,
	[InventoryId] [int] NULL ,
	[EquipmentId] [int] NULL ,
	[CompletionDate] [smalldatetime] NULL ,
	[Note] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OrderStatus] (
	[OrderStatusId] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[OrderStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OrderType] (
	[OrderTypeId] [smallint] IDENTITY (1, 1) NOT NULL ,
	[OrderType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OrgUnit] (
	[OrgUnitId] [smallint] IDENTITY (1, 1) NOT NULL ,
	[OrgUnit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ParentOrgUnitId] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Part] (
	[PartId] [int] IDENTITY (1, 1) NOT NULL ,
	[Make] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Model] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Property] (
	[PropertyId] [smallint] IDENTITY (1, 1) NOT NULL ,
	[Property] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Unit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Province] (
	[ProvinceId] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Province] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Status] (
	[StatusId] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[Status] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ChargeLog] WITH NOCHECK ADD 
	CONSTRAINT [PK_ChargeLog] PRIMARY KEY  CLUSTERED 
	(
		[ItemId],
		[ActionId],
		[ChargeDate]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EquipmentBC] WITH NOCHECK ADD 
	CONSTRAINT [PK_EquipmentBC] PRIMARY KEY  CLUSTERED 
	(
		[EquipmentId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Part] WITH NOCHECK ADD 
	CONSTRAINT [PK_Part] PRIMARY KEY  CLUSTERED 
	(
		[PartId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AcquisitionType] WITH NOCHECK ADD 
	CONSTRAINT [PK_AcquisitionType] PRIMARY KEY  NONCLUSTERED 
	(
		[AcquisitionTypeId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Action] WITH NOCHECK ADD 
	CONSTRAINT [PK_Action] PRIMARY KEY  NONCLUSTERED 
	(
		[ActionId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ActivityLog] WITH NOCHECK ADD 
	CONSTRAINT [DF_ActivityLog_LogDate] DEFAULT (getdate()) FOR [LogDate],
	CONSTRAINT [DF_ActivityLog_UserName] DEFAULT (user_name()) FOR [UserName],
	CONSTRAINT [PK_ActivityLog] PRIMARY KEY  NONCLUSTERED 
	(
		[LogId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Contact] WITH NOCHECK ADD 
	CONSTRAINT [PK_Contact] PRIMARY KEY  NONCLUSTERED 
	(
		[ContactId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EqType] WITH NOCHECK ADD 
	CONSTRAINT [PK_EqType] PRIMARY KEY  NONCLUSTERED 
	(
		[EqTypeId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Equipment] WITH NOCHECK ADD 
	CONSTRAINT [PK_Equipment] PRIMARY KEY  NONCLUSTERED 
	(
		[EquipmentId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Inventory] WITH NOCHECK ADD 
	CONSTRAINT [PK_Inventory] PRIMARY KEY  NONCLUSTERED 
	(
		[Inventoryid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[InventoryProperty] WITH NOCHECK ADD 
	CONSTRAINT [PK_InventoryProperty] PRIMARY KEY  NONCLUSTERED 
	(
		[InventoryId],
		[PropertyId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Lease] WITH NOCHECK ADD 
	CONSTRAINT [DF_Lease_TotalValue] DEFAULT (0) FOR [TotalValue],
	CONSTRAINT [PK_Lease] PRIMARY KEY  NONCLUSTERED 
	(
		[LeaseId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LeaseFrequency] WITH NOCHECK ADD 
	CONSTRAINT [PK_LeaseFrequency] PRIMARY KEY  NONCLUSTERED 
	(
		[LeaseFrequencyId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LeaseSchedule] WITH NOCHECK ADD 
	CONSTRAINT [DF_LeaseSchedule_PeriodicTotalAmount] DEFAULT (0) FOR [PeriodicTotalAmount],
	CONSTRAINT [PK_LeaseSchedule] PRIMARY KEY  NONCLUSTERED 
	(
		[ScheduleId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Location] WITH NOCHECK ADD 
	CONSTRAINT [PK_Location] PRIMARY KEY  NONCLUSTERED 
	(
		[LocationId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Order] WITH NOCHECK ADD 
	CONSTRAINT [DF_Order_OrderDate] DEFAULT (getdate()) FOR [OrderDate],
	CONSTRAINT [PK_Order] PRIMARY KEY  NONCLUSTERED 
	(
		[OrderId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OrderItem] WITH NOCHECK ADD 
	CONSTRAINT [PK_OrderItem] PRIMARY KEY  NONCLUSTERED 
	(
		[ItemId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OrderStatus] WITH NOCHECK ADD 
	CONSTRAINT [PK_OrderStatus] PRIMARY KEY  NONCLUSTERED 
	(
		[OrderStatusId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OrderType] WITH NOCHECK ADD 
	CONSTRAINT [PK_OrderType] PRIMARY KEY  NONCLUSTERED 
	(
		[OrderTypeId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OrgUnit] WITH NOCHECK ADD 
	CONSTRAINT [PK_OrgUnit] PRIMARY KEY  NONCLUSTERED 
	(
		[OrgUnitId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Property] WITH NOCHECK ADD 
	CONSTRAINT [PK_Property] PRIMARY KEY  NONCLUSTERED 
	(
		[PropertyId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Province] WITH NOCHECK ADD 
	CONSTRAINT [PK_Province] PRIMARY KEY  NONCLUSTERED 
	(
		[ProvinceId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Status] WITH NOCHECK ADD 
	CONSTRAINT [PK_Status] PRIMARY KEY  NONCLUSTERED 
	(
		[StatusId]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_Equipment_modelSDX] ON [dbo].[Equipment]([ModelSDX]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ChargeLog] ADD 
	CONSTRAINT [FK_ChargeLog_Action] FOREIGN KEY 
	(
		[ActionId]
	) REFERENCES [dbo].[Action] (
		[ActionId]
	),
	CONSTRAINT [FK_ChargeLog_OrderItem] FOREIGN KEY 
	(
		[ItemId]
	) REFERENCES [dbo].[OrderItem] (
		[ItemId]
	)
GO

ALTER TABLE [dbo].[Contact] ADD 
	CONSTRAINT [FK_Contact_OrgUnit] FOREIGN KEY 
	(
		[OrgUnitId]
	) REFERENCES [dbo].[OrgUnit] (
		[OrgUnitId]
	)
GO

ALTER TABLE [dbo].[Equipment] ADD 
	CONSTRAINT [FK_Equipment_EqType] FOREIGN KEY 
	(
		[EqTypeId]
	) REFERENCES [dbo].[EqType] (
		[EqTypeId]
	)
GO

ALTER TABLE [dbo].[EquipmentBC] ADD 
	CONSTRAINT [FK_EquipmentBC_Equipment] FOREIGN KEY 
	(
		[EquipmentId]
	) REFERENCES [dbo].[Equipment] (
		[EquipmentId]
	)
GO

ALTER TABLE [dbo].[Inventory] ADD 
	CONSTRAINT [FK_Inventory_AcquisitionType] FOREIGN KEY 
	(
		[AcquisitionTypeID]
	) REFERENCES [dbo].[AcquisitionType] (
		[AcquisitionTypeId]
	),
	CONSTRAINT [FK_Inventory_Contact] FOREIGN KEY 
	(
		[OwnerId]
	) REFERENCES [dbo].[Contact] (
		[ContactId]
	),
	CONSTRAINT [FK_Inventory_Equipment] FOREIGN KEY 
	(
		[EquipmentId]
	) REFERENCES [dbo].[Equipment] (
		[EquipmentId]
	),
	CONSTRAINT [FK_Inventory_Lease] FOREIGN KEY 
	(
		[LeaseId]
	) REFERENCES [dbo].[Lease] (
		[LeaseId]
	),
	CONSTRAINT [FK_Inventory_LeaseSchedule] FOREIGN KEY 
	(
		[LeaseScheduleId]
	) REFERENCES [dbo].[LeaseSchedule] (
		[ScheduleId]
	),
	CONSTRAINT [FK_Inventory_Location] FOREIGN KEY 
	(
		[LocationId]
	) REFERENCES [dbo].[Location] (
		[LocationId]
	),
	CONSTRAINT [FK_Inventory_Status] FOREIGN KEY 
	(
		[StatusId]
	) REFERENCES [dbo].[Status] (
		[StatusId]
	)
GO

ALTER TABLE [dbo].[InventoryProperty] ADD 
	CONSTRAINT [FK_InventoryProperty_Inventory] FOREIGN KEY 
	(
		[InventoryId]
	) REFERENCES [dbo].[Inventory] (
		[Inventoryid]
	),
	CONSTRAINT [FK_InventoryProperty_Property] FOREIGN KEY 
	(
		[PropertyId]
	) REFERENCES [dbo].[Property] (
		[PropertyId]
	)
GO

ALTER TABLE [dbo].[LeaseSchedule] ADD 
	CONSTRAINT [FK_LeaseSchedule_Lease] FOREIGN KEY 
	(
		[LeaseId]
	) REFERENCES [dbo].[Lease] (
		[LeaseId]
	),
	CONSTRAINT [FK_LeaseSchedule_LeaseFrequency] FOREIGN KEY 
	(
		[LeaseFrequencyId]
	) REFERENCES [dbo].[LeaseFrequency] (
		[LeaseFrequencyId]
	)
GO

ALTER TABLE [dbo].[Location] ADD 
	CONSTRAINT [FK_Location_Province] FOREIGN KEY 
	(
		[ProvinceId]
	) REFERENCES [dbo].[Province] (
		[ProvinceId]
	)
GO

ALTER TABLE [dbo].[Order] ADD 
	CONSTRAINT [FK_Order_Contact] FOREIGN KEY 
	(
		[RequestedById]
	) REFERENCES [dbo].[Contact] (
		[ContactId]
	),
	CONSTRAINT [FK_Order_OrderStatus] FOREIGN KEY 
	(
		[OrderStatusid]
	) REFERENCES [dbo].[OrderStatus] (
		[OrderStatusId]
	),
	CONSTRAINT [FK_Order_OrderType] FOREIGN KEY 
	(
		[OrderTypeId]
	) REFERENCES [dbo].[OrderType] (
		[OrderTypeId]
	)
GO

ALTER TABLE [dbo].[OrderItem] ADD 
	CONSTRAINT [FK_OrderItem_Equipment] FOREIGN KEY 
	(
		[EquipmentId]
	) REFERENCES [dbo].[Equipment] (
		[EquipmentId]
	),
	CONSTRAINT [FK_OrderItem_Inventory] FOREIGN KEY 
	(
		[InventoryId]
	) REFERENCES [dbo].[Inventory] (
		[Inventoryid]
	),
	CONSTRAINT [FK_OrderItem_Order] FOREIGN KEY 
	(
		[OrderId]
	) REFERENCES [dbo].[Order] (
		[OrderId]
	)
GO

ALTER TABLE [dbo].[OrgUnit] ADD 
	CONSTRAINT [FK_OrgUnit_OrgUnit] FOREIGN KEY 
	(
		[ParentOrgUnitId]
	) REFERENCES [dbo].[OrgUnit] (
		[OrgUnitId]
	)
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.vEquipment
AS
SELECT Equipment.EquipmentId, Equipment.Make, 
    Equipment.Model, EqType.EqType
FROM Equipment INNER JOIN
    EqType ON Equipment.EqTypeId = EqType.EqTypeId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.vInventory
AS
SELECT     dbo.Inventory.Inventoryid, dbo.Equipment.Make, dbo.Equipment.Model, dbo.Location.Location, dbo.Status.Status, dbo.Contact.FirstName, 
                      dbo.Contact.LastName, dbo.Inventory.Cost, dbo.AcquisitionType.AcquisitionType, dbo.Location.Address, dbo.Location.City, dbo.Location.ProvinceId, 
                      dbo.Location.Country, dbo.EqType.EqType, dbo.Contact.Phone, dbo.Contact.Fax, dbo.Contact.Email, dbo.Contact.UserName, dbo.Inventory.Rent, 
                      dbo.Inventory.EquipmentId, dbo.Inventory.LocationId, dbo.Inventory.StatusId, dbo.Inventory.OwnerId, dbo.Inventory.AcquisitionTypeID, 
                      dbo.Contact.OrgUnitId
FROM         dbo.EqType RIGHT OUTER JOIN
                      dbo.Equipment ON dbo.EqType.EqTypeId = dbo.Equipment.EqTypeId RIGHT OUTER JOIN
                      dbo.Inventory INNER JOIN
                      dbo.Status ON dbo.Inventory.StatusId = dbo.Status.StatusId LEFT OUTER JOIN
                      dbo.AcquisitionType ON dbo.Inventory.AcquisitionTypeID = dbo.AcquisitionType.AcquisitionTypeId ON 
                      dbo.Equipment.EquipmentId = dbo.Inventory.EquipmentId LEFT OUTER JOIN
                      dbo.Location ON dbo.Inventory.LocationId = dbo.Location.LocationId LEFT OUTER JOIN
                      dbo.Contact ON dbo.Inventory.OwnerId = dbo.Contact.ContactId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure A_Template
-- 
	
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int

Select @intErrorCode = @@Error

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
End



If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
        COMMIT TRANSACTION
    Else
        ROLLBACK TRANSACTION
End

return @intErrorCode
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE   Procedure A_Template_Loop_tempTbl
-----------------------------------------------------------------------------------------
-- Description:
-- Roles:		
-- Resultset:	
-- Return val:	Error Code
-- Called by: 	

--				Name					Date		Change
-- Created by:	
-- Modified by:	
-----------------------------------------------------------------------------------------
	@debug int = 0
As
set nocount on
declare @intCountProperties int,
		@intCounter int,
		@chvProperty varchar(50),
		@chvValue varchar(50),
		@chvUnit varchar(50),
		@insLenProperty smallint,
		@insLenValue smallint,
		@insLenUnit smallint,
		@insLenProperties smallint,
		@chvProperties varchar(8000)

Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
        @intRowcount int,
		@chvProcedure sysname

set @chvProcedure = 'a_template_loop_tempTbl'
if @debug <> 0
	select '**** '+ @chvProcedure + ' START ****'
Select @intErrorCode = @@Error


If @intErrorCode = 0
Begin
	Create table #Properties(Id int identity(1,1),
							Property varchar(50), 
							Value varchar(50), 
							Unit varchar(50))
	Select @intErrorCode = @@Error
End

If @intErrorCode = 0
Begin
	-- identify Properties associated with asset
	insert into #Properties (Property, Value, Unit)
		select Property, Value, Unit
		from InventoryProperty inner join Property
		on InventoryProperty.PropertyId = Property.PropertyId 
	Select @intErrorCode = @@Error
End


If @intErrorCode = 0
Begin
	-- set loop
	select 	@intCountProperties = Count(*),
			@intCounter = 1,
			@chvProperties = ''
	from #Properties
	Select @intErrorCode = @@Error
End

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
End

-- loop through list of properties
while @intErrorCode = 0 and @intCounter <= @intCountProperties
begin
	-- get one property
	If @intErrorCode = 0
	Begin
		select @chvProperty = Property, 
			@chvValue = Value, 
			@chvUnit = Coalesce(Unit, '')
		from #Properties
		where Id = @intCounter 

	    Select @intErrorCode = @@Error
	End



	-- let's go another round and get another property
	If @intErrorCode = 0
	Begin
		set @intCounter = @intCounter + 1
	    Select @intErrorCode = @@Error
	End
end


If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
        COMMIT TRANSACTION
    Else
        ROLLBACK TRANSACTION
End

drop table #Properties

if @debug <> 0
	select '**** '+ @chvProcedure + ' END ****'
return @intErrorCode



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prAddOrder
-- insert Order record
	
		@dtmOrderDate datetime = null,
		@dtmTargetDate datetime = NULL,
		@chvUserName varchar(128) = NULL,
		@intDestinationLocation int,
		@chvNote varchar(200),
		@intOrderid int OUTPUT

As

	declare	@intRequestedById int
	
	
	-- if user didn't specify target date default is 3 days after the request is issued
	if @dtmOrderDate = NULL
		Set @dtmOrderDate = GetDate()

	-- if user didn't specify target date default is 3 days after the request is issued
	if @dtmTargetDate = NULL
		Set @dtmTargetDate = DateAdd(day, 3, @dtmOrderDate)
	
	-- if user didn't identify himself try to identify him using login name
	if @chvUserName = null
		Set @chvUserName = SYSTEM_USER
		
	-- get Id of the user
	select @intRequestedById = ContactId
	from Contact
	where UserName = @chvUserName

	-- if you can not identify user report an error
	If @intRequestedById = null
		begin
			RAISERROR('Unable to identify user in Contact table!', 16, 2) 
			return 1
		end
		
	-- and finally create Order
	Insert into [Order](OrderDate,				RequestedById,		TargetDate, 
						DestinationLocationId,	Note)
	values(				@dtmOrderDate,			@intRequestedById,	@dtmTargetDate,
						@intDestinationLocation,@chvNote)
	
	set @intOrderid = @@identity
	
return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

DENY  EXECUTE  ON [dbo].[prAddOrder]  TO [Servicer] CASCADE 
GO

GRANT  EXECUTE  ON [dbo].[prAddOrder]  TO [AssetOwner]
GO

GRANT  EXECUTE  ON [dbo].[prAddOrder]  TO [Management]
GO

GRANT  EXECUTE  ON [dbo].[prAddOrder]  TO [Accounting]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prBackupIfLogAlmostFull
-- Do backup of transaction log if percent of space used is bigger then @fltPercentLimit
	(
		@chvDbName sysname,
		@fltPercentLimit float,
		@debug int = 0
	)

As
set nocount on

declare @intErrorCode int,
		@fltPercentUsed float,
		@chvDeviceName sysname,
		@chvFileName sysname

set @intErrorCode = @@Error

-- how much of log space is used at the moment
if @intErrorCode = 0
	exec @intErrorCode = prLogSpacePercentUsed @chvDbName, @fltPercentUsed OUTPUT

-- if limit is not reached, just go out
if @intErrorCode = 0 and @fltPercentUsed < @fltPercentLimit 
	return 0

if @intErrorCode = 0
begin
	Set @chvDeviceName = @chvDbName + Convert(Varchar, GetDate(), 112)
	Set @chvFileName = 'c:\mssql7\backup\bkp'+ @chvDeviceName + '.dat'
	set @intErrorCode = @@Error		
end

if @debug <> 0 
	select @chvDeviceName chvDeviceName, @chvFileName chvFileName

if @intErrorCode = 0
begin
	EXEC sp_addumpdevice 'disk', @chvDeviceName, @chvFileName
	set @intErrorCode = @@Error		
end

-- 15061 it is OK if dump device already exists
if @intErrorCode = 0 or @intErrorCode = 15061
begin
	BACKUP LOG @chvDbName TO @chvDeviceName
	set @intErrorCode = @@Error		
end

return @intErrorCode


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prBcpOutTables
--loop through tables and export them to text fiels
		@debug int = 0
As

declare @chvTable varchar(128),
		@chvCommand varchar(255)

DECLARE @curTables CURSOR

-- get all tables from current database
SET @curTables = CURSOR FOR
	select name 
	from sysobjects 
	where xType = 'U'

OPEN @curTables

-- get first table
FETCH NEXT FROM @curTables
INTO @chvTable

-- if we succefully read the current record
WHILE (@@FETCH_STATUS = 0)
BEGIN

	-- assemble DOS command for exporting table
	Set @chvCommand = 'bcp "Asset..[' + @chvTable + ']" out C:\sql7\backup\' + @chvTable + '.txt -c -q -Sdejan -Usa -Pdejan'
	-- during test just display command
	if @debug <> 0
		select @chvCommand chvCommand
	
	-- in production execute DOS command and export table
	if @debug = 0
		execute xp_cmdshell @chvCommand, NO_OUTPUT
		
	FETCH NEXT FROM @curTables
	INTO @chvTable

END

CLOSE @curTables
DEALLOCATE @curTables

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCalcFactoriel
-- calcualte factoriel 
-- 0! = 1
-- 1! = 1
-- 3! = 3 * 2 * 1
-- 5! = 5 * 4 * 3 * 2 * 1
	(
		@N tinyint,
		@F int OUTPUT
	)

As
	
Set @F = 1
 
while @N > 1
begin
	set @F = @F * @N
	Set @N = @N - 1
end

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prClearLeaseShedule
-- Set value of Lease of all equipment associated with expired Lease Schedule to 0
-- Set total amount of Lease Schedule to 0.

	@intLeaseScheduleId int
As
	begin transaction

	-- Set value of Lease of all equipment associated with expired Lease Schedule to 0
	update Inventory
	set Lease = 0
	where LeaseScheduleId = @intLeaseScheduleId
	if @@Error <> 0 goto PROBLEM

	-- Set total amount of Lease Schedule to 0
	update LeaseSchedule
	Set PeriodicTotalAmount = 0
	where ScheduleId = @intLeaseScheduleId
	if @@Error <> 0 goto PROBLEM

	commit transaction
	return 0
	
PROBLEM:
	print 'Unable to eliminate lease amounts from the database!'
	rollback transaction
return 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prClearLeaseShedule_1
-- Set value of Lease of all equipment associated with expired Lease Schedule to 0
-- Set total amount of Lease Schedule to 0.

	@intLeaseScheduleId int
As

	-- Verify that lease has expired
	If GetDate() <	(select EndDate
					from LeaseSchedule
					where ScheduleId = @intLeaseScheduleId)
		raiserror ('Specified lease schedule has not expired yet!', 16,1)
	if @@Error <> 0 goto PROBLEM
	
	begin transaction

	-- Set value of Lease of all equipment associated with expired Lease Schedule to 0
	update Inventory
	set Lease = 0
	where LeaseScheduleId = @intLeaseScheduleId
	if @@Error <> 0 goto PROBLEM

	-- Set total amount of Lease Schedule to 0
	update LeaseSchedule
	Set PeriodicTotalAmount = 0
	where ScheduleId = @intLeaseScheduleId
	if @@Error <> 0 goto PROBLEM

	commit transaction
	return 0
	
PROBLEM:
	print 'Unable to eliminate lease amounts from the database!'
	rollback transaction
return 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prCloseLease
-- claer Rent, ScheduleId and LeaseId on all assets associated with specified lease.
	@intLeaseId int
As
	-- delete schedules
	update Inventory
	set Rent = 0,
		LeaseId = null,
		LeaseScheduleId = null
	where LeaseId = @intLeaseId
	if @@Error <> 0 goto PROBLEM

	-- delete schedules
	delete from LeaseSchedule
	where LeaseId = @intLeaseId
	if @@Error <> 0 goto PROBLEM

	-- delete lease
	delete from Lease
	where LeaseId = @intLeaseId
	if @@Error <> 0	goto PROBLEM
	return 0
	
PROBLEM:
	select 'Unable to remove lease from the database!'
return 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCnvDecade
-- convert 20, 30, 40...
	@chrDecade varchar(2),
	@chvWord varchar(500) OUTPUT
As
set nocount on

Select @chvWord = Case @chrDecade
					when '2' Then 'twenty'
					when '3' Then 'thirty'
					when '4' Then 'forty'
					when '5' Then 'fifty '
					when '6' Then 'sixty'
					when '7' Then 'seventy'
					when '8' Then 'eighty'
					when '9' Then 'ninety'
                  end

return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCnvDigit
-- convert digit to word
-- 8 -> eight
	@chrDigit char,
	@chvWord varchar(15) OUTPUT,
	@debug int = 0
As
set nocount on

Select @chvWord = Case @chrDigit
					when '1' Then 'one'
					when '2' Then 'two'
					when '3' Then 'three'
					when '4' Then 'four'
					when '5' Then 'five'
					when '6' Then 'six'
					when '7' Then 'seven'
					when '8' Then 'eight'
					when '9' Then 'nine'
					else ''
                  end

return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCnvNumber
-- convert monetary number to text
	@mnyNumber money,
	@chvResult varchar(500) OUTPUT,
	@debug int = 0
As
set nocount on
declare @chvNumber varchar(50),	-- 000,000,000,000.00
		@chvWord varchar(500),
		@chvDollars varchar(25),-- 000,000,000,000
		@chvCents varchar(2),	--                 00
		@intLenDollars int,		-- 12
		@intCountTriplets int,  -- 4
		@chrTriplet char(3),	-- 000
		@intCount int
		
-- get character representation
Set @chvNumber = Str(@mnyNumber, 22, 2)

-- get dollars
Set @chvDollars = LTrim(Str(@mnyNumber, 22, 0))
-- get cents
Set @chvCents = Substring(@chvNumber, Len(@chvNumber) - 1, 2)

if @debug <> 0 
	select @chvNumber, @chvDollars, @chvCents

Set @intLenDollars = Len(@chvDollars)

-- get number of triplets
Set @intCountTriplets = @intLenDollars/3
-- loop through triplets
if @debug <> 0
	Select @intCountTriplets CountTriplets, @chvDollars chvDollars
	
if @intLenDollars = @intCountTriplets * 3
	Set @chrTriplet = Left(@chvDollars, 3)
else
	Set @chrTriplet = Left(@chvDollars, @intLenDollars - @intCountTriplets * 3)
	
Set @intCount = @intCountTriplets
Set @chvResult = ''

while @intCount > 0
begin
	if @debug <> 0
		Select @intCount intCount, @chrTriplet Triplet
	exec prCnvThreeDigitNumber @chrTriplet, @chvWord output, @debug

	Set @chvResult = @chvResult + ' ' 
	               + @chvWord  + ' ' +  case @intCount
											when 1 then 'dollars'
											when 2 then 'thousand'
											when 3 then 'million'
											when 4 then 'billion'
											when 5 then 'trillion'
										end
	Set @intCount = @intCount - 1
	Set @chrTriplet = Convert(varchar, Convert(int, Substring(@chvDollars, @intLenDollars - @intCount * 3 + 1, 3)))
end
	
exec prCnvTwoDigitNumber @chvCents, @chvWord output, @debug
Set @chvWord = Ltrim(Rtrim(@chvWord))
if  @chvWord <> ''
	Set @chvResult = @chvResult + ' and ' + @chvWord  + ' cents'
return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCnvTeen
-- convert numbers between 10 and 19 to word
	@chvNumber varchar(2),
	@chvWord varchar(15) OUTPUT
As
set nocount on

Select @chvWord = Case @chvNumber
					when '10' Then 'ten'
					when '11' Then 'eleven'
					when '12' Then 'twelve'
					when '13' Then 'thirteen'
					when '14' Then 'fourteen'
					when '15' Then 'fifteen '
					when '16' Then 'sixteen'
					when '17' Then 'seventeen'
					when '18' Then 'eighteen'
					when '19' Then 'nineteen'
                  end

return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCnvThreeDigitNumber
-- convert numbers between 0 and 999
	@chvNumber varchar(3),
	@chvResult varchar(500) OUTPUT,
	@debug int = 0
As
set nocount on
declare @intNumber int,
		@chvLastTwoDigits varchar(2),
		@chvWord varchar(500),
		@chrDigit char

-- get numeric representation
Set @intNumber = Convert(int, @chvNumber)

If @intNumber > 99
begin
	-- get first digit
	Set @chrDigit = SubString(@chvNumber, 1,1)
	-- convert first digit to text
	execute prCnvDigit @chrDigit, @chvResult output, @debug
	-- add 'hundred'
	set @chvResult = @chvResult + ' hundred' 

	set @chvLastTwoDigits = Substring(@chvNumber, 2, 2)
end
else
begin
	set @chvLastTwoDigits = @chvNumber
	set @chvResult = ''
end
exec prCnvTwoDigitNumber @chvLastTwoDigits, @chvWord output, @debug

if @chvResult <> ''
	set @chvResult = @chvResult + ' ' + @chvWord
else
	set @chvResult = @chvWord

return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prCnvTwoDigitNumber
-- convert 2-digit numbers to words
	@inyNumber tinyint,
	@chvResult varchar(500) OUTPUT,
	@debug int = 0
As
set nocount on

declare @chvNumber varchar(2),
		@chrLastDigit char,
		@chrFirstDigit char,
		@chvWord varchar(500)
		
set @chvNumber = Convert(varchar(2), @inyNumber)

if @inyNumber = 0
begin
	Set @chvResult = ''
	return
end
else if @inyNumber < 10
begin
	exec prCnvDigit @chvNumber, @chvResult OUTPUT
	return
end
else if @inyNumber < 20
begin
	exec prCnvTeen @chvNumber, @chvResult OUTPUT
	return
end

Set @chrLastDigit = Substring(@chvNumber, 2, 1)
if @debug <> 0
	Select @chrLastDigit LastDigit

Set @chrFirstDigit = Substring(@chvNumber, 1, 1)
if @debug <> 0
	Select @chrFirstDigit FirstDigit

exec prCnvDecade @chrFirstDigit, @chvWord output
set @chvResult = @chvWord

exec prCnvDigit @chrLastDigit, @chvWord output
set @chvResult = @chvResult + ' ' + @chvWord

return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE Procedure prCompleteOrder
-- complete all orderItems and then complete order
	@intOrderId int,
	@dtsCompletionDate smalldatetime,
	@debug int = 0
	
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
		@i int,
		@intCountOrderItems int,
		@intOrderItemId int
		
declare @chvProc varchar(30)
Set @chvProc = '-- prCompleteOrder:   '

Select @intErrorCode = @@Error

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
    if @debug <> 0
		select @chvProc + 'BEGIN TRANSACTION'
End

-- complete order
If @intErrorCode = 0
Begin
	update [Order]
	Set CompletionDate = @dtsCompletionDate,
		OrderStatusId = 4 -- completed
		
	Where OrderId = @intOrderId
	
	Select @intErrorCode = @@Error
End

-- loop through OrderItems and complete them
If @intErrorCode = 0
Begin
	create table #OrderItems(
		id int identity(1,1),
		OrderItemId int)
	
	Select @intErrorCode = @@Error
End
	
-- collect orderItemIds
If @intErrorCode = 0
Begin
	insert into #OrderItems(OrderItemId)
		select ItemId 
		from OrderItem 
		where OrderId = @intOrderId
	Select @intErrorCode = @@Error
    if @debug <> 0
		select @chvProc + 'Loop through following', * from #OrderItems
End
	
If @intErrorCode = 0
Begin
	select	@intCountOrderItems = Max(Id),
			@i = 1
	from #OrderItems 
	
	Select @intErrorCode = @@Error
    if @debug <> 0
		select @chvProc, @intCountOrderItems MaxId, @i i
End

while @intErrorCode = 0 and @i <= @intCountOrderItems
Begin
	
	If @intErrorCode = 0
	Begin
		select	@intOrderItemId = OrderItemId
		from #OrderItems
		where id = @i
		
		Select @intErrorCode = @@Error
		if @debug <> 0
			select @chvProc, Convert(varchar, @i) i, Convert(varchar, @intOrderItemId) intOrderItemId
	End

	If @intErrorCode = 0
		exec @intErrorCode = prCompleteOrderItem	@intOrderItemId, @debug

	Set @i = @i + 1
End


If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
		begin
			COMMIT TRANSACTION
			if @debug <> 0
				select @chvProc, 'Commit Transaction'
		end
    Else
		begin
			ROLLBACK TRANSACTION
			if @debug <> 0
				select @chvProc, 'ROLLBACK TRANSACTION'
		end
End

return @intErrorCode

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


Create Procedure prCompleteOrderItem
-- Set CompletionDate of OrderItem to date 
-- of last ChargeLog record associated with OrderItem.
	@intOrderItemId int,
	@debug int = 0
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int

Select @intErrorCode = @@Error

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
    if @debug <> 0
		select '-- prCompleteOrderItem:   BEGIN TRANSACTION'
End

-- Set CompletionDate of OrderItem to date 
-- of last ChargeLog record associated with OrderItem.
If @intErrorCode = 0
Begin
	update OrderItem
	Set CompletionDate = (Select Max(ChargeDate) from ChargeLog where ItemId = @intOrderItemId)
	Where ItemId = @intOrderItemId
	
	Select @intErrorCode = @@Error
End

If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
		begin
			COMMIT TRANSACTION
			if @debug <> 0
					select '-- prCompleteOrderItem:   COMMIT TRANSACTION!'
		end
    Else
		begin
			ROLLBACK TRANSACTION
			if @debug <> 0
					select '-- prCompleteOrderItem:   ROLLBACK TRANSACTION!'
		end
End
if @debug <> 0
		select '-- prCompleteOrderItem:   Finished!'
return @intErrorCode

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE Procedure prCompleteOrderItem_1
-- Set CompletionDate of OrderItem to date 
-- of last ChargeLog record associated with OrderItem.
	@intOrderItemId int
As
set nocount on

Declare @intErrorCode int

Select @intErrorCode = @@Error

If @intErrorCode = 0
    BEGIN TRANSACTION

-- Set CompletionDate of OrderItem to date 
-- of last ChargeLog record associated with OrderItem.
If @intErrorCode = 0
Begin
	update OrderItem
	Set CompletionDate = (Select Max(ChargeDate) from ChargeLog where ItemId = @intOrderItemId)
	Where ItemId = @intOrderItemId
	
	Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @@trancount > 0
	COMMIT TRANSACTION
Else
	ROLLBACK TRANSACTION

return @intErrorCode

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE Procedure prCompleteOrder_1
-- complete all orderItems and then complete order
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
    BEGIN TRANSACTION

-- complete order
If @intErrorCode = 0
Begin
	update [Order]
	Set CompletionDate = @dtsCompletionDate,
		OrderStatusId = 4 -- completed
		
	Where OrderId = @intOrderId
	
	Select @intErrorCode = @@Error
End

-- loop through OrderItems and complete them
If @intErrorCode = 0
Begin
	create table #OrderItems(
		id int identity(1,1),
		OrderItemId int)
	
	Select @intErrorCode = @@Error
End
	
-- collect orderItemIds
If @intErrorCode = 0
Begin
	insert into #OrderItems(OrderItemId)
		select ItemId 
		from OrderItem 
		where OrderId = @intOrderId
	Select @intErrorCode = @@Error
End
	
If @intErrorCode = 0
Begin
	select	@intCountOrderItems = Max(Id),
			@i = 1
	from #OrderItems 
	
	Select @intErrorCode = @@Error
End

while @intErrorCode = 0 and @i <= @intCountOrderItems
Begin
	
	If @intErrorCode = 0
	Begin
		select	@intOrderItemId = OrderItemId
		from #OrderItems
		where id = @i
		
		Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0
		exec @intErrorCode = prCompleteOrderItem_1	@intOrderItemId

	Set @i = @i + 1
End


If @intErrorCode = 0 and @@trancount > 0
		COMMIT TRANSACTION
Else
		ROLLBACK TRANSACTION

return @intErrorCode

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prConvertTempTbl
-- Convert information from Temporary table to a single varchar
	@chvResult varchar(8000) output
As
set nocount on

declare @intCountItems int,
		@intCounter int,
		@chvItem varchar(255),
		@insLenItem smallint,
		@insLenResult smallint

-- set loop
select @intCountItems = Count(*),
       @intCounter = 1,
       @chvResult = ''
from #List

-- loop through list of items
while @intCounter <= @intCountItems
begin
	-- get one property
	select @chvItem = Item
	from #List
	where Id = @intCounter 

	-- check will new string fit
	select @insLenItem = DATALENGTH(@chvItem),
	       @insLenResult = DATALENGTH(@chvResult)

	if @insLenResult + @insLenItem > 8000
	begin
		print 'List is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	set @chvResult = @chvResult + @chvItem

	-- let's go another round and get another item
	set @intCounter = @intCounter + 1
end

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prDeferredNameResolution
As
	set nocount on

	select 'Start'
	select * from NonExistiongTable
	select 'Will execution be stopped?'

return 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prExtPropColumnList
-- list of extended properties assigned to a column

	@chvTable sysname,
	@chvColumn sysname
As
set nocount on

	SELECT  *
	FROM   ::fn_listextendedproperty(NULL, 
                   'user', 'dbo', 
                           'table', @chvTable, 
                                    'column', @chvColumn)
return @@Error




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prFTSearchActivityLog
-- full-text search of ActivityLog.Note
-- this will only work if you enable full-text search
	(
		@chvKeywords varchar(255),
		@inySearchType tinyint
	)
As
set nocount on
--------- Constants -----------
declare @c_Contains int,
		@c_FreeText int,
		@c_FormsOf int
Set		@c_Contains = 0
Set		@c_FreeText = 1
Set		@c_FormsOf = 2
--------- Constants -----------
		
if @inySearchType = @c_Contains
	exec ('select * from Activity Where Contains(Note, ' + @chvKeywords + ')')
else if @inySearchType = @c_FreeText
	exec ('select * from Activity Where FreeText(Note, ' + @chvKeywords + ')')
else if @inySearchType = @c_FormsOf
	exec ('select * from Activity Where FreeText(Note, FORMSOF(INFLECTIONAL, ' + @chvKeywords + ')')
	
return 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetContact
-- get Contact record with timestamp converted to datatime
	(
		@intContactId int
	)
As
	set nocount on

	SELECT ContactId, 
		FirstName, 
		LastName, 
		Phone, 
		Fax, 
		Email, 
		OrgUnitId, 
		UserName, 
		Convert(datetime, ts) dtmTimestamp
	FROM Contact
	where ContactId = @intContactId

return @@Error


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure prGetEqId
	@Make varchar(50),
	@Model varchar(50)
as
	select EquipmentId 
	from Equipment
	where Make = @Make
	and Model = @Model
 
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure prGetEqId_2
	@Make varchar(50),
	@Model varchar(50),
	@EqId int output
as
	select @EqId = EquipmentId 
	from Equipment
	where Make = @Make
	and Model = @Model
 
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure prGetEqId_3
	@Make varchar(50),
	@Model varchar(50)
as

declare @intEqId int

select @intEqId  = EquipmentId 
	from Equipment
	where Make = @Make
	and Model = @Model

return @intEqId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

Create procedure prGetEqId_4
	@Make varchar(50) = '%',
	@Model varchar(50) = '%'
as
	select *
	from Equipment
	where Make Like @Make
	and Model Like @Model

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE prGetEquipment_xml 
	@EquipmentId int
AS

select '<Root>'
select * from Equipment
where EquipmentID= @EquipmentId 
for XML AUTO, elements
Select '</Root>'

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;

	(
		@intInventoryId int,
		@chvProperties varchar(8000) OUTPUT,
		@debug int = 0
	)

As

declare 	@intCountProperties int,
	@intCounter int,
	@chvProperty varchar(50),
	@chvValue varchar(50),
	@chvUnit varchar(50),
	@insLenProperty smallint,
	@insLenValue smallint,
	@insLenUnit smallint,
	@insLenProperties smallint

Create table #Properties(Id int identity(1,1),
		Property varchar(50), 
		Value varchar(50), 
		Unit varchar(50))

-- identify Properties associated with asset
insert into #Properties (Property, Value, Unit)
	select Property, Value, Unit
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

if @debug <> 0
	select * from #Properties
	
-- set loop
select 	@intCountProperties = Count(*),
	@intCounter = 1,
	@chvProperties = ''
from #Properties

-- loop through list of properties
while @intCounter <= @intCountProperties
begin
	-- get one property
	select @chvProperty = Property, 
		@chvValue = Value, 
		@chvUnit = Coalesce(Unit, '')
	from #Properties
	where Id = @intCounter 

	if @debug <> 0
		select @chvProperty Property, 
				@chvValue [Value], 
				@chvUnit [Unit]
	
	-- check will new string fit
	select @insLenProperty = DATALENGTH(@chvProperty),
			@insLenValue = DATALENGTH(@chvValue),
			@insLenUnit = DATALENGTH(@chvUnit),
			@insLenProperties = DATALENGTH(@chvProperties)

	if @insLenProperties + 2 + @insLenProperty + 1 + @insLenValue + 1 + @insLenUnit > 8000
	begin
		select 'List of properties is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	set @chvProperties = @chvProperties + @chvProperty + '=' + @chvValue + ' ' +  @chvUnit + '; '
	if @debug <> 0
		select @chvProperties chvProperties

	-- let's go another round and get another property
	set @intCounter = @intCounter + 1
end

drop table #Properties
return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties_2
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;

	(
		@intInventoryId int,
		@chvProperties varchar(8000) OUTPUT,
		@debug int = 0
	)

As
set nocount on

declare @intCountProperties int,
		@intCounter int,
		@chvProperty varchar(50),
		@chvValue varchar(50),
		@chvUnit varchar(50),
		@insLenProperty smallint,
		@insLenValue smallint,
		@insLenUnit smallint,
		@insLenProperties smallint

declare @chvProcedure sysname
set @chvProcedure = 'prGetInventoryProperties_2'

if @debug <> 0
	select '**** '+ @chvProcedure + 'START ****'

Create table #Properties(Id int identity(1,1),
						Property varchar(50), 
						Value varchar(50), 
						Unit varchar(50))

-- identify Properties associated with asset
insert into #Properties (Property, Value, Unit)
	select Property, Value, Unit
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

if @debug <> 0
	select * from #Properties
	
-- set loop
select 	@intCountProperties = Count(*),
	@intCounter = 1,
	@chvProperties = ''
from #Properties

-- loop through list of properties
while @intCounter <= @intCountProperties
begin
	-- get one property
	select @chvProperty = Property, 
		@chvValue = Value, 
		@chvUnit = Coalesce(Unit, '')
	from #Properties
	where Id = @intCounter 

	if @debug <> 0
		select @chvProperty Property, 
				@chvValue [Value], 
				@chvUnit [Unit]
	
	-- check will new string fit
	select @insLenProperty = DATALENGTH(@chvProperty),
			@insLenValue = DATALENGTH(@chvValue),
			@insLenUnit = DATALENGTH(@chvUnit),
			@insLenProperties = DATALENGTH(@chvProperties)

	if @insLenProperties + 2 
       + @insLenProperty + 1 
       + @insLenValue + 1 
       + @insLenUnit > 8000
	begin
		select 'List of properties is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	set @chvProperties = @chvProperties + @chvProperty + '=' + 
                         @chvValue + ' ' +  @chvUnit + '; '
	if @debug <> 0
		select @chvProperties chvProperties

	-- let's go another round and get another property
	set @intCounter = @intCounter + 1
end

drop table #Properties

if @debug <> 0
	select '**** '+ @chvProcedure + 'END ****'

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prGetInventoryProperties_3
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;
	@intInventoryId int
As
set nocount on

declare @intCountProperties int,
		@intCounter int,
		@chvProperty varchar(50),
		@chvValue varchar(50),
		@chvUnit varchar(50),
		@insLenProperty smallint,
		@insLenValue smallint,
		@insLenUnit smallint,
		@insLenProperties smallint,
		@chvProperties varchar(8000)

Create table #Properties(Id int identity(1,1),
						Property varchar(50), 
						Value varchar(50), 
						Unit varchar(50))

-- identify Properties associated with asset
insert into #Properties (Property, Value, Unit)
	select Property, Value, Unit
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

-- set loop
select 	@intCountProperties = Count(*),
	@intCounter = 1,
	@chvProperties = ''
from #Properties

-- loop through list of properties
while @intCounter <= @intCountProperties
begin
	-- get one property
	select @chvProperty = Property, 
		@chvValue = Value, 
		@chvUnit = Coalesce(Unit, '')
	from #Properties
	where Id = @intCounter 

	-- check will new string fit
	select @insLenProperty = DATALENGTH(@chvProperty),
			@insLenValue = DATALENGTH(@chvValue),
			@insLenUnit = DATALENGTH(@chvUnit),
			@insLenProperties = DATALENGTH(@chvProperties)

	if @insLenProperties + 2 
       + @insLenProperty + 1 
       + @insLenValue + 1 
       + @insLenUnit > 8000
	begin
		select 'List of properties is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	set @chvProperties = @chvProperties + @chvProperty + '=' + 
                         @chvValue + ' ' +  @chvUnit + '; '

	-- let's go another round and get another property
	set @intCounter = @intCounter + 1
end

-- display result
select @chvProperties Properties

drop table #Properties

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties_Cursor
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;

	(
		@intInventoryId int,
		@chvProperties varchar(8000) OUTPUT,
		@debug int = 0
	)

As

declare 	@intCountProperties int,
			@intCounter int,
			@chvProperty varchar(50),
			@chvValue varchar(50),
			@chvUnit varchar(50),
			@insLenProperty smallint,
			@insLenValue smallint,
			@insLenUnit smallint,
			@insLenProperties smallint

Set @chvProperties = ''

DECLARE @CrsrVar CURSOR

SET @CrsrVar = CURSOR FOR
	select Property, Value, Unit
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

OPEN @CrsrVar

FETCH NEXT FROM @CrsrVar
INTO @chvProperty, @chvValue, @chvUnit

WHILE (@@FETCH_STATUS = 0)
BEGIN

	set @chvUnit = Coalesce(@chvUnit, '')

	if @debug <> 0
		select @chvProperty Property, 
				@chvValue [Value], 
				@chvUnit [Unit]
	
	-- check will new string fit
	select @insLenProperty = DATALENGTH(@chvProperty),
			@insLenValue = DATALENGTH(@chvValue),
			@insLenUnit = DATALENGTH(@chvUnit),
			@insLenProperties = DATALENGTH(@chvProperties)

	if @insLenProperties + 2 + @insLenProperty + 1 + @insLenValue + 1 + @insLenUnit > 8000
	begin
		select 'List of properties is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	set @chvProperties = @chvProperties + @chvProperty + '=' + @chvValue + ' ' +  @chvUnit + '; '
	if @debug <> 0
		select @chvProperties chvProperties

	FETCH NEXT FROM @CrsrVar
	INTO @chvProperty, @chvValue, @chvUnit

END

CLOSE @CrsrVar
DEALLOCATE @CrsrVar

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties_CursorGet
-- Return Cursor that contains properties which are describing selected asset.

	(
		@intInventoryId int,
		@curProperties CURSOR VARYING OUTPUT
	)

As

SET @curProperties = CURSOR FORWARD_ONLY STATIC FOR
	select Property, Value, Unit
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

OPEN @curProperties

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties_Cursor_Nested
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;

	(
		@intInventoryId int,
		@chvProperties varchar(8000) OUTPUT,
		@debug int = 0
	)

As

Select @chvProperties = ''

DECLARE curItems CURSOR FOR
	select Property + '=' + [Value] + ' ' + Coalesce([Unit], '') + '; ' Item
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

OPEN curItems

exec prProcess_Cursor_Nested @chvProperties OUTPUT, @debug

CLOSE curItems
DEALLOCATE curItems

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties_TempTbl_Outer
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;
	@intInventoryId int
As
set nocount on

declare	@chvProperties varchar(8000)

Create table #List(Id int identity(1,1),
                   Item varchar(255))

-- identify Properties associated with asset
insert into #List (Item)
	select Property + '=' + Value + ' ' +  Coalesce(Unit, '') + '; '
	from InventoryProperty inner join Property
	on InventoryProperty.PropertyId = Property.PropertyId 
	where InventoryProperty.InventoryId = @intInventoryId

-- call sp which converts records to a single varchar
exec prConvertTempTbl @chvProperties OUTPUT

-- display result
select @chvProperties Properties

drop table #List

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prGetInventoryProperties_UseNestedCursor
-- return comma-delimited list of properties which are describing asset.
-- i.e.: Property = Value unit;Property = Value unit;Property = Value unit;Property = Value unit;

	(
		@intInventoryId int,
		@chvProperties varchar(8000) OUTPUT,
		@debug int = 0
	)

As

declare 	@intCountProperties int,
		@intCounter int,
		@chvProperty varchar(50),
		@chvValue varchar(50),
		@chvUnit varchar(50),
		@insLenProperty smallint,
		@insLenValue smallint,
		@insLenUnit smallint,
		@insLenProperties smallint

Set @chvProperties = ''

DECLARE @CrsrVar CURSOR

EXEC prGetInventoryProperties_CursorGet @intInventoryId, 
					@CrsrVar OUTPUT


FETCH NEXT FROM @CrsrVar
INTO @chvProperty, @chvValue, @chvUnit

WHILE (@@FETCH_STATUS = 0)
BEGIN

	set @chvUnit = Coalesce(@chvUnit, '')

	if @debug <> 0
		select @chvProperty Property, 
				@chvValue [Value], 
				@chvUnit [Unit]
	
	-- check will new string fit
	select	@insLenProperty = DATALENGTH(@chvProperty),
		@insLenValue = DATALENGTH(@chvValue),
		@insLenUnit = DATALENGTH(@chvUnit),
		@insLenProperties = DATALENGTH(@chvProperties)

	if @insLenProperties + 2 + @insLenProperty + 1 + @insLenValue + 1 + @insLenUnit > 8000
	begin
		select 'List of properties is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	set @chvProperties = @chvProperties + @chvProperty + '=' + @chvValue + ' ' +  @chvUnit + '; '
	if @debug <> 0
		select @chvProperties chvProperties

	FETCH NEXT FROM @CrsrVar
	INTO @chvProperty, @chvValue, @chvUnit

END

CLOSE @CrsrVar
DEALLOCATE @CrsrVar

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure prGetShedulesAndLeases
	-- return two resultset:
	-- 1. list of all lease schedules
	-- 2. list of all leases
as
	-- list schedules
	select *
	from LeaseSchedule

	-- list leases
	select *
	from Lease




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure prHelloWorld_1
As
   Select 'Hello World again!'
   Select * from Inventory
Return 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertEquipment_1
-- store values in equipment table.
-- return identifier of the record to the caller.
	(
		@chvMake varchar(50),
		@chvModel varchar(50),
		@chvEqType varchar(30)
	)
As
declare 	@intEqTypeId int,
	@intEqupmentId int

-- read Id of EqType
Select @intEqTypeId
From EqType
Where EqType = @chvEqType

-- does such eqType alreadt exists in the database
If  @intEqTypeId IS NOT NULL
	--insert equipment
	Insert Equipment (Make, Model, EqTypeId)
	Values (@chvMake, @chvModel, @intEqTypeId)
Else
	--if it does not exist
	Begin
		-- insert new EqType in the database
		Insert EqType (EqType)
		Values (@chvEqType)

		-- get id of record that you've just inserted
		Select @intEqTypeId = @@identity

		--insert equipment
		Insert Equipment (Make, Model, EqTypeId)
		Values (@chvMake, @chvModel, @intEqTypeId)
	End
Select @intEqupmentId = @@identity

-- return id to the caller
return @intEqupmentId 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prInsertEquipment_2
-- store values in equipment table.
-- return identifier of the record to the caller.
	(
		@chvMake varchar(50),
		@chvModel varchar(50),
		@chvEqType varchar(30)
	)
As
declare 	@intEqTypeId int,
	@intEqupmentId int


-- does such eqType alreadt exists in the database
If  not exists (Select EqTypeId From EqType Where EqType = @chvEqType)
	--if it does not exist
	Begin
		-- insert new EqType in the database
		Insert EqType (EqType)
		Values (@chvEqType)

		-- get id of record that you've just inserted
		Select @intEqTypeId = @@identity
	End
else
	-- read Id of EqType
	Select @intEqTypeId
	From EqType
	Where EqType = @chvEqType
	
--insert equipment
Insert Equipment (Make, Model, EqTypeId)
Values (@chvMake, @chvModel, @intEqTypeId)

Select @intEqupmentId = @@identity

-- return id to the caller
return @intEqupmentId 
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertEquipment_3
/* Store values in equipment table.
   Return identifier of the record to the caller. 
*/
	(
		@chvMake varchar(50),
		@chvModel varchar(50),
		@chvEqType varchar(30),
		@intEqupmentId int
	)
As
declare 	@intEqTypeId int,
	@ErrorCode int

-- does such eqType alreadt exists in the database
If  not exists (Select EqTypeId From EqType Where EqType = @chvEqType)
	--if it does not exist
	Begin
		-- insert new EqType in the database
		Insert EqType (EqType)
		Values (@chvEqType)

		-- get id of record that you've just inserted
		Select 	@intEqTypeId = @@identity,
			@ErrorCode = @@Error
		If @ErrorCode <> 0
			begin
				Select 'Unable to insert Equpment Type. Error: ', @ErrorCode
				return 1
			end
	End
else
	begin
		-- read Id of EqType
		Select @intEqTypeId
		From EqType
		Where EqType = @chvEqType
		Select @ErrorCode = @@Error

		If @ErrorCode <> 0
			begin
				Select 'Unable to get Id of Equipment Type. Error: ', @ErrorCode
				return 2
			end
	end

--insert equipment
Insert Equipment (Make, Model, EqTypeId)
Values (@chvMake, @chvModel, @intEqTypeId)

Select @ErrorCode = @@Error
If @ErrorCode <> 0
	begin
		Select 'Unable to insert Equipment. Error: ', @ErrorCode
		return 3
	end

-- return id to the caller
Select @intEqupmentId = @@identity

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertInventory
-- insert inventory record and return Id
	@intEquipmentId int, 
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
set nocount on

Declare @intErrorCode int
Select @intErrorCode = @@Error

If @intErrorCode = 0
Begin
    Insert into Inventory (EquipmentId, LocationId, StatusId, 
				LeaseId, LeaseScheduleId, OwnerId, 
				Rent, Lease, Cost, 
				AcquisitionTypeID)
	values (	@intEquipmentId, @intLocationId, @inyStatusId, 
				@intLeaseId, @intLeaseScheduleId, @intOwnerId, 
				@mnsRent, @mnsLease, @mnsCost, 
				@inyAcquisitionTypeID)
    
	select	@intErrorCode = @@Error,
			@intInventoryId = @@identity
End

return @intErrorCode
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertLeasedAsset_1
-- Insert leased asset and update total in LeaseSchedule.
-- (demontration of imperfect solution)
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
insert Inventory(EquipmentId,     LocationId,              StatusId, 
                 LeaseId,         LeaseScheduleId,         OwnerId, 
                 Lease,           AcquisitionTypeID)
values (         @intEquipmentId, @intLocationId,          @intStatusId,
                 @intLeaseId,	  @intLeaseScheduleId,     @intOwnerId, 
                 @mnyLease,       @intAcquisitionTypeID)

-- update total
update LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId

commit transaction

return 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertLeasedAsset_2
-- Insert leased asset and update total in LeaseSchedule.
-- (demontration of not exactly perfect solution)
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
insert Inventory(EquipmentId,     LocationId,              StatusId, 
                 LeaseId,         LeaseScheduleId,         OwnerId, 
                 Lease,           AcquisitionTypeID)
values (         @intEquipmentId, @intLocationId,          @intStatusId,
                 @intLeaseId,     @intLeaseScheduleId,     @intOwnerId, 
                 @mnyLease,       @intAcquisitionTypeID)
If @@error <> 0 
Begin
    Print 'Unexpected error occurred!'
    Rollback transaction
    Return 1
End

-- update total
update LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId

If @@error <> 0 
Begin
    Print 'Unexpected error occurred!'
    Rollback transaction
    Return 1
End

commit transaction

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prInsertLeasedAsset_3
-- Insert leased asset and update total in LeaseSchedule.
-- (demontration of not exactly perfect solution)
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
insert Inventory(EquipmentId,     LocationId,              StatusId, 
                 LeaseId,         LeaseScheduleId,         OwnerId, 
                 Lease,           AcquisitionTypeID)
values (         @intEquipmentId, @intLocationId,          @intStatusId,
                 @intLeaseId,     @intLeaseScheduleId,     @intOwnerId, 
                 @mnyLease,       @intAcquisitionTypeID)
If @@error <> 0 GOTO ERR_HANDLER

-- update total
update LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId
If @@error <> 0 GOTO ERR_HANDLER

commit transaction

return 0


ERR_HANDLER:
    Print 'Unexpected error occurred!'
    Rollback transaction
    Return 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertLeasedAsset_4
-- Insert leased asset and update total in LeaseSchedule.
-- (demontration of not exactly perfect solution)
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
insert Inventory(EquipmentId,     LocationId,              StatusId, 
                 LeaseId,         LeaseScheduleId,         OwnerId, 
                 Lease,           AcquisitionTypeID)
values (         @intEquipmentId, @intLocationId,          @intStatusId,
                 @intLeaseId,     @intLeaseScheduleId,     @intOwnerId, 
                 @mnyLease,       @intAcquisitionTypeID)
If @@error <> 0 GOTO ERR_HANDLER

-- update total
update LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId
If @@error <> 0 GOTO ERR_HANDLER

commit transaction

return 0

ERR_HANDLER:
    Print 'Unexpected error occurred: ' + Convert(varchar, @@Error)
    Rollback transaction
    Return @@Error

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertLeasedAsset_5
-- Insert leased asset and update total in LeaseSchedule.
-- (demontration of almost perfect solution)
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

Declare @intErrorCode int
Select @intErrorCode = @@Error

begin transaction

If @intErrorCode = 0
begin
	-- insert asset
	insert Inventory(EquipmentId,     LocationId,              StatusId, 
	                 LeaseId,         LeaseScheduleId,         OwnerId, 
	                 Lease,           AcquisitionTypeID)
	values (         @intEquipmentId, @intLocationId,          @intStatusId,
	                 @intLeaseId,     @intLeaseScheduleId,     @intOwnerId, 
	                 @mnyLease,       @intAcquisitionTypeID)
	Select @intErrorCode = @@Error
end

If @intErrorCode = 0
begin
	-- update total
	update LeaseSchedule
	Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
	where LeaseId = @intLeaseId
	Select @intErrorCode = @@Error
end

If @intErrorCode = 0
	COMMIT TRANSACTION
Else
	ROLLBACK TRANSACTION

return @intErrorCode
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prInsertLeasedAsset_6
-- Insert leased asset and update total in LeaseSchedule.
	(
		@intEquipmentId int,
		@intLocationId int,
		@intStatusId int,
		@intLeaseId int,
		@intLeaseScheduleId int,    
		@intOwnerId int, 
		@mnyLease money,        
		@intAcquisitionTypeID int,
		@intInventoryId int OUTPUT
	)
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int

Select @intErrorCode = @@Error

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
End

If @intErrorCode = 0
begin
	-- insert asset
	insert Inventory(EquipmentId,     LocationId,              StatusId, 
	                 LeaseId,         LeaseScheduleId,         OwnerId, 
	                 Lease,           AcquisitionTypeID)
	values (         @intEquipmentId, @intLocationId,          @intStatusId,
	                 @intLeaseId,     @intLeaseScheduleId,     @intOwnerId, 
	                 @mnyLease,       @intAcquisitionTypeID)
	Select @intErrorCode = @@Error,
	       @intInventoryId = @@identity
end

If @intErrorCode = 0
begin
	-- update total
	update LeaseSchedule
	Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
	where LeaseId = @intLeaseId
	Select @intErrorCode = @@Error
end

If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
        COMMIT TRANSACTION
    Else
        ROLLBACK TRANSACTION
End

return @intErrorCode
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create Procedure prInsertLeasedAsset_7
-- Insert leased asset and update total in LeaseSchedule.
-- (demontration of imperfect solution)
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
SET XACT_ABORT ON
begin transaction

-- insert asset
insert Inventory(EquipmentId,     LocationId,              StatusId, 
                 LeaseId,         LeaseScheduleId,         OwnerId, 
                 Lease,           AcquisitionTypeID)
values (         @intEquipmentId, @intLocationId,          @intStatusId,
                 @intLeaseId,	  @intLeaseScheduleId,     @intOwnerId, 
                 @mnyLease,       @intAcquisitionTypeID)

-- update total
update LeaseSchedule
Set PeriodicTotalAmount = PeriodicTotalAmount + @mnyLease
where LeaseId = @intLeaseId

commit transaction

return (0)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prInsertNewSchedule
	@intLeaseId int,
	@intLeaseFrequencyId int
As

	Insert LeaseSchedule(LeaseId, StartDate, EndDate, LeaseFrequencyId)
	Values (@intLeaseId, GetDate(), DateAdd(Year, 3, GetDate()), @intLeaseFrequencyId)

return @@Error

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prLeasePeriodDuration
-- return approximate number of days associated with lease frequiency
	@inyScheduleFrequencyId tinyint,
	 @insDays smallint OUTPUT
As
Declare @chvScheduleFrequency varchar(50)

Select @chvScheduleFrequency = ScheduleFrequency
From ScheduleFrequency
where ScheduleFrequencyId = @inyScheduleFrequencyId

select @insDays =
	CASE @chvScheduleFrequency
		When 'monthly' then 30
		When 'semi-monthly' then 15
		When 'bi-weekly' then 14
		When 'weekly' then 17
		When 'quarterly' then 92
		When 'yearly' then 365
	END
return 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE prListEquipment2_xml AS
select EquipmentId, Make, Model, EqType from Equipment inner join EqType
on Equipment.EqTypeId = EqType.EqTypeId
for xml auto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/****** Encrypted object is not transferable, and script can not be generated. ******/

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE prListEquipment_xml 
AS
select * 
from Equipment
for xml auto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE prListInventoryEquipment AS
select InventoryId, vEquipment.* from Inventory inner join vEquipment
on Inventory.EquipmentId = vEquipment.EquipmentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prListLeaseInfo
-- list all lease contract information
As

Select 	LeaseVendor [Lease Vendor], 
	LeaseNumber [Lease Number], 
	Case -- some vendors have id of sales person incorporated in lease numbers
		When LeaseVendor = 'Trigon Financial Services' THEN SUBSTRING( LeaseNumber, 5, 12)
		When LeaseVendor Like 'EB%' THEN SUBSTRING( LeaseNumber, 9, 8)
		When LeaseVendor Like 'MMEX%' THEN SUBSTRING( LeaseNumber, 7, 6)
		When LeaseVendor = 'DAFS' THEN SUBSTRING( LeaseNumber, 8, 11)
		ELSE 'UNKNOWN'
	end [Lease Agent],
	ContractDate [Contract Date]
from Lease
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prListLeasedAssets
-- list all assets which were leased
As
	SELECT Inventory.Inventoryid, Equipment.Make, Equipment.Model, 
    EqType.EqType, Inventory.LeaseId, Lease.LeaseVendor, 
    Lease.ContractDate
FROM Inventory INNER JOIN
    Equipment ON 
    Inventory.EquipmentId = Equipment.EquipmentId INNER JOIN
    EqType ON 
    Equipment.EqTypeId = EqType.EqTypeId INNER JOIN
    Lease ON Inventory.LeaseId = Lease.LeaseId
WHERE (Inventory.LeaseId <> NULL)

return @@Error

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prListTerms
-- return list of due days for the leasing
	@dtsStartDate smalldatetime,
	@dtsEndDate smalldatetime,
	@chvLeaseFrequency varchar(20)
As
set nocount on

declare @insTerms smallint -- number of intervals

-- calculate number of terms
select @insTerms =
	CASE @chvLeaseFrequency
		When 'monthly' then DateDIFF(month, @dtsStartDate, @dtsEndDate)
		When 'semi-monthly' then 2 * DateDIFF(month, @dtsStartDate, @dtsEndDate)
		When 'bi-weekly' then DateDIFF(week, @dtsStartDate, @dtsEndDate)/2
		When 'weekly' then DateDIFF(week, @dtsStartDate, @dtsEndDate)
		When 'quarterly' then DateDIFF(qq, @dtsStartDate, @dtsEndDate)
		When 'yearly' then DateDIFF(y, @dtsStartDate, @dtsEndDate)
	END
	
-- generate list of due dates using temporary table
Create table #Terms (ID int)

while @insTerms >= 0
begin
	insert #Terms (ID)
	values (@insTerms)
	
	select @insTerms = @insTerms - 1
end

-- display list of Due dates
select ID+1, Convert(varchar, 
	CASE 
		When @chvLeaseFrequency = 'monthly' 
			then DateADD(month,ID, @dtsStartDate)
		When @chvLeaseFrequency = 'semi-monthly' and ID/2 =  Cast(ID as float)/2 
			then DateADD(month, ID/2, @dtsStartDate)
		When @chvLeaseFrequency = 'semi-monthly' and ID/2 <> Cast(ID as float)/2 
			then DateADD(dd, 15, DateADD(month, ID/2, @dtsStartDate))
		When @chvLeaseFrequency = 'bi-weekly' 
			then DateADD(week, ID*2, @dtsStartDate)
		When @chvLeaseFrequency = 'weekly' 
			then DateADD(week, ID, @dtsStartDate)
		When @chvLeaseFrequency = 'quarterly' 
			then DateADD(qq, ID, @dtsStartDate)
		When @chvLeaseFrequency = 'yearly' 
			then DateADD(y, ID, @dtsStartDate)
	END , 105) [Due date]
from #Terms
order by ID

-- wash the dishes
drop table #Terms

return 0
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prLoadLeaseContract
-- insert lease contract information and return id of lease

		@chvLeaseVendor varchar(50),
		@chvLeaseNumber varchar(50),
		@chvLeaseDate varchar(50),
		@intLeaseId int OUTPUT
As
Declare @intError int

-- test validity of date
if ISDATE(@chvLeaseDate) = 0
begin
	return 1
end

insert into Lease(LeaseVendor, LeaseNumber, ContractDate)
values (@chvLeaseVendor, @chvLeaseNumber, Convert(smalldatetime, @chvLeaseDate))

select	@intError = @@Error,
		@intLeaseId = @@identity

return @intError
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prLogSpacePercentUsed
-- return percent of space used in transcation log for specified database
	(
		@chvDbName sysname,
		@fltPercentUsed float OUTPUT
	)

As
set nocount on

declare @intErrorCode int

set @intErrorCode = @@Error

if @intErrorCode = 0
begin
	create table #DBLogSpace
		(	dbname sysname, 
			LogSizeInMB float, 
			LogPercentUsed float, 
			Status int
		)
	set @intErrorCode = @@Error		
end

-- get log space info. for all databases
if @intErrorCode = 0
begin
	insert into #DBLogSpace
		exec ('DBCC SQLPERF (LogSpace)') -- it will not work without exec
	set @intErrorCode = @@Error		
end

-- get percent for specified database
if @intErrorCode = 0
begin
	select @fltPercentUsed = LogPercentUsed
	from #DBLogSpace
	where dbname = @chvDbName

	set @intErrorCode = @@Error		
end

drop table #DBLogSpace

return @intErrorCode

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prLoopWithGoTo
-- just an example how to implement loop using If and Goto
As
declare @MaxCounter int,
	@Counter int

Select 	@MaxCounter = Max(EquipmentId),
	@Counter = 1
from Equipment

Loop:
if @Counter < @MaxCounter
begin
	-- some work
	Select @Counter -- this line is meaningless

	set @Counter = @Counter + 1
	Goto Loop
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prNonSelectedDBOption
-- return list of non-selected database options

	@chvDBName sysname

As

set nocount on
	
create table #setable 
	(
		name nvarchar(35)
	)
create table #current 
	(
		name nvarchar(35)
	)

-- collect all options
insert into #setable
	exec sp_dboption

-- collect current options
insert into #current
	exec sp_dboption @dbname = @chvDBName

-- return non-selected
select name non_selected 
from #setable
where name not in	(	Select name 
				from #current
			)

drop table #setable 
drop table #current

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Procedure prOrderGetXML
   @intOrderId int
as

SELECT *
FROM dbo.Contact INNER JOIN
   dbo.[Order] ON dbo.Contact.ContactId = dbo.[Order].RequestedById INNER JOIN
   dbo.OrderItem ON dbo.[Order].OrderId = dbo.OrderItem.OrderId INNER JOIN
   dbo.OrderStatus ON dbo.[Order].OrderStatusid = dbo.OrderStatus.OrderStatusId INNER JOIN
   dbo.OrderType ON dbo.[Order].OrderTypeId = dbo.OrderType.OrderTypeId
where dbo.[Order].OrderId = @intOrderId
for XML Auto, elements, xmlData

return @@error

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE   Procedure prOrderSave
-- Extract Order (and Order Items) info. from an XML document.
    @chvXMLDoc text,
    @debug int = 0
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
	@intRowCount int,
	@intDoc int,
	@intOrderId int

Select @intErrorCode = @@Error
If @debug <> 0
	select 'Load XML document.'
--Create an internal representation of the XML document.
If @intErrorCode = 0
    EXEC @intErrorCode = sp_xml_preparedocument @intDoc OUTPUT, @chvXMLDoc

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
    If @debug <> 0
       select 'Transaction started.'
End

-- extract order info
If @intErrorCode = 0
Begin
	Insert into [Order](OrderDate, RequestedById, 
			TargetDate, CompletionDate, DestinationLocationId, 
			Note, OrderTypeId, OrderStatusid)
	SELECT   	OrderDate, RequestedById, 
			TargetDate, CompletionDate, DestinationLocationId, 
			Note, OrderTypeId, OrderStatusid
	FROM     OPENXML  (@intDoc, '/Order', 1)
	         WITH     (OrderDate smalldatetime '@OrderDate', 
	                   RequestedById int '@RequestedById', 
	                   TargetDate smalldatetime '@TargetDate', 
	                   CompletionDate smalldatetime '@CompletionDate', 
	                   DestinationLocationId int '@DestinationLocationId', 
	                   Note text '@Note', 
	                   OrderTypeID int '@OrderTypeId', 
	                   OrderStatusId int '@OrderStatusid')
	Select @intErrorCode = @@Error,
		@intOrderId = @@identity
    If @debug <> 0
	Select 'OrderInserted:', @intErrorCode [Error], @intOrderId [identity]
End

-- extract OrderItem info
If @intErrorCode = 0
Begin
	Insert into OrderItem(OrderID, InventoryId, ActionId, EquipmentId)
	SELECT   @intOrderId, *
	FROM     OPENXML  (@intDoc, '/Order/OrderItem', 1)
	         WITH     (InventoryId int '@InventoryId', 
	                   ActionId    int '@ActionId', 
	                   EquipmentId int '@EquipmentId')
	Select @intErrorCode = @@Error,
		@intRowCount = @@RowCount
    If @debug <> 0
	Select 'Order Item info inserted.', @intErrorCode Error, @intRowCount [RowCount]
end

If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
    begin
        COMMIT TRANSACTION
        If @debug <> 0
	   Select 'Transaction commited.'
    end
    Else
    begin
        ROLLBACK TRANSACTION
        If @debug <> 0
	   Select 'Transaction rolled back.'
    end
End

If @intErrorCode = 0
	EXEC sp_xml_removedocument @intDoc

return @intErrorCode



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE prPartList  
AS

	select * from Part

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prProcess_Cursor_Nested
-- Process information from cursor initiated in calling sp. 
-- Convert records into a single varchar.
	(
		@chvResult varchar(8000) OUTPUT,
		@debug int = 0
	)

As

declare 	@intCountProperties int,
			@intCounter int,
			@chvItem varchar(255),
			@insLenItem smallint,
			@insLenResult smallint

FETCH NEXT FROM curItems
INTO @chvItem

WHILE (@@FETCH_STATUS = 0)
BEGIN

	if @debug <> 0
		select @chvItem Item
	
	-- check will new string fit
	select @insLenItem   = DATALENGTH(@chvItem),
	       @insLenResult = DATALENGTH(@chvResult)

	if @insLenResult + @insLenItem > 8000
	begin
		select 'List is too long (over 8000 characters)!'
		return 1
	end
	
	-- assemble list
	if @insLenItem > 0
		set @chvResult = @chvResult + @chvItem
		
	if @debug <> 0
		select @chvResult chvResult

	FETCH NEXT FROM curItems
	INTO @chvItem

END

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prQbfContact_1
-- Dynamicaly assemble a query based on specified parameters.
	(
		@chvFirstName	varchar(30)	= NULL, 
		@chvLastName	varchar(30)	= NULL, 
		@chvPhone		typPhone	= NULL, 
		@chvFax			typPhone	= NULL, 
		@chvEmail		typEmail	= NULL, 
		@insOrgUnitId	smallint	= NULL, 
		@chvUserName	varchar(50)	= NULL,
		@debug			int			= 0
	)	
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
        @chvQuery varchar(8000),
        @chvWhere varchar(8000)

Select	@intErrorCode = @@Error,
		@chvQuery = 'SET QUOTED_IDENTIFIER OFF SELECT * FROM Contact ',
		@chvWhere = ''

If @intErrorCode = 0 and @chvFirstName is not null
Begin
    set @chvWhere = @chvWhere + ' FirstName = "' + @chvFirstName + '" AND'
    Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @chvLastName is not null
Begin
    set @chvWhere = @chvWhere + ' LastName = "' + @chvLastName + '" AND'
    Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @chvPhone is not null
Begin
    set @chvWhere = @chvWhere + ' Phone = "' + @chvPhone + '" AND'
    Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @chvFax is not null
Begin
    set @chvWhere = @chvWhere + ' Fax = "' + @chvFax + '" AND'
    Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @chvEmail is not null
Begin
    set @chvWhere = @chvWhere + ' Email = "' + @chvEmail + '" AND'
    Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @insOrgUnitId is not null
Begin
    set @chvWhere = @chvWhere + ' OrgUnitId = ' + @insOrgUnitId + ' AND'
    Select @intErrorCode = @@Error
End

If @intErrorCode = 0 and @chvUserName is not null
Begin
    set @chvWhere = @chvWhere + ' UserName = "' + @chvUserName + '"'
    Select @intErrorCode = @@Error
End

if @debug <> 0 select @chvWhere chvWhere

-- remove ' AND' from the end of string
If @intErrorCode = 0  and Substring(@chvWhere, Len(@chvWhere) - 3, 4) = ' AND'
Begin
    set @chvWhere = Substring(@chvWhere, 1, Len(@chvWhere) - 3)
    Select @intErrorCode = @@Error
	if @debug <> 0 select @chvWhere chvWhere
End

If @intErrorCode = 0 and Len(@chvWhere) > 0
Begin
    set  @chvQuery = @chvQuery + ' WHERE ' + @chvWhere
    Select @intErrorCode = @@Error
End

if @debug <> 0
	select @chvQuery Query
	
-- get contacts
If @intErrorCode = 0
Begin
    exec (@chvQuery)
    Select @intErrorCode = @@Error
End

return @intErrorCode
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prScrapOrder
-- save order information.

	@dtsOrderDate smalldatetime, 
	@intRequestedById int, 
	@dtsTargetDate smalldatetime,
	@chvNote varchar(200), 
	@insOrderTypeId smallint, 
	@inyOrderStatusId tinyint
As
	set nocount on

	insert [Order](OrderDate, RequestedById, TargetDate,
				 Note, OrderTypeId, OrderStatusId)
	values (@dtsOrderDate, @intRequestedById, @dtsTargetDate,
			@chvNote, @insOrderTypeId, @inyOrderStatusId)

return @@identity

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prScrapOrderSaveItem
-- Saves order item.
-- If error occures, this item will be rolled back, 
-- but other items will be saved.

-- demonstration of use of SAVE TRANSACTION
-- must be called from sp or batch which initiates transaction
	@intOrderId int, 
	@intInventoryId int,
	@intOrderItemId int OUTPUT
As
	set nocount on
	declare @intErrorCode int,
			@chvInventoryId varchar(10)
	
	-- name the transaction savepoint		
	Set @chvInventoryId = Convert(varchar, @intInventoryId)
	
	Save Transaction @chvInventoryId

	-- Set value of Lease of all equipment associated with expired Lease Schedule to 0
	insert OrderItem (OrderId, InventoryId)
	values (@intOrderId, @intInventoryId)
	
	select @intOrderItemId = @@identity,
	       @intErrorCode = @@Error
	       
	if @intErrorCode <> 0
	begin
		rollback transaction @chvInventoryId
		return @intErrorCode
	end

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prSpellNumber
-- demo of use of Automation objects
	@mnsAmount money,
	@chvAmount varchar(500) output,
	@debug int = 0
	
As
set nocount on

Declare	@intErrorCode int,
	@intObject int,  -- hold object token
	@bitObjectCreated bit,
	@chvSource varchar(255), 
	@chvDesc varchar(255)

Select @intErrorCode = @@Error

If @intErrorCode = 0
	exec @intErrorCode = sp_OACreate 'DjnToolkit.DjnTools', @intObject OUTPUT

If @intErrorCode = 0
	Set @bitObjectCreated = 1
else
	Set @bitObjectCreated = 0

If @intErrorCode = 0
	exec @intErrorCode = sp_OAMethod @intObject, 'SpellNumber', @chvAmount OUT,  @mnsAmount

If @intErrorCode <> 0
begin
	Raiserror ('Unable to obtain spelling of number', 16, 1)
	exec sp_OAGetErrorInfo @intObject, @chvSource OUTPUT, @chvDesc OUTPUT
	Set @chvDesc = 'Error (' + Convert(varchar, @intErrorCode) + ', ' + @chvSource  + ') : ' + @chvDesc
	Raiserror (@chvDesc, 16, 1)
end

if @bitObjectCreated = 1
	exec  sp_OADestroy @intObject 

return @intErrorCode


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prSplitFullName
-- split full name received in format 'Sunderic, Dejan' into last and first name
-- default delimiter is comma and space ', ', but caller can specify other
	@chvFullName varchar(50),
	@chvDelimiter varchar(3) = ', ',
	@chvFirstName varchar(50) OUTPUT,
	@chvLastName varchar(50) OUTPUT
As
set nocount on

declare @intPosition int

Set @intPosition = CharIndex(@chvDelimiter, @chvFullName)

If @intPosition > 0
begin
	Set @chvLastName = Left(@chvFullName, @intPosition - 1)
	Set @chvFirstName = Right(@chvFullName, Len(@chvFullName) - @intPosition - Len(@chvDelimiter) )
end
else
	return 1

return 0

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE Procedure prTestXML
-- Extract Inventory info. from long XML document.
-- Demonstration of usage of text input parameters 
-- to parse long XML document.
    @chvXMLDoc text
	
As
set nocount on

Declare @intErrorCode int,
        @intTransactionCountOnEntry int
Declare @intDoc int

Select @intErrorCode = @@Error

--Create an internal representation of the XML document.
EXEC sp_xml_preparedocument @intDoc OUTPUT, @chvXMLDoc

-- SELECT statement using OPENXML rowset provider
SELECT   *
FROM     OPENXML  (@intDoc, '/root/Equipment/Inventory', 8)
         WITH     (InventoryID int '@InventoryID', 
                   StatusID int '@StatusID', 
                   Make varchar(25) '../@Make', 
                   Model varchar(25) '../@Model', 
                   comment ntext '@mp:xmltext')
EXEC sp_xml_removedocument @intDoc


return @intErrorCode


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prUpdateContact
-- update conrecord from contact table
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
		@dtmOriginalTS datetime
	)
As
set nocount on
declare @tsOriginalTS timestamp,
		@intErrorCode int

set @intErrorCode = @@Error

if @intErrorCode = 0
begin
	Set @tsOriginalTS = Convert(timestamp, @dtmOriginalTS)
	set @intErrorCode = @@Error
end


if @intErrorCode = 0
begin
	Update Contact
	Set FirstName = @chvFirstName, 
		LastName = @chvLastName, 
		Phone = @chvPhone, 
		Fax = @chvFax, 
		Email = @chvEmail, 
	    OrgUnitId = @insOrgUnitId, 
	    UserName = @chvUserName
	where ContactId = @intContactId
	and TSEqual(ts, @tsOriginalTS)
	
	set @intErrorCode = @@Error
end

return @intErrorCode
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prUpdateContact_1
-- update conrecord from contact table
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
set nocount on

Update Contact
Set FirstName = @chvFirstName, 
	LastName = @chvLastName, 
	Phone = @chvPhone, 
	Fax = @chvFax, 
	Email = @chvEmail, 
    OrgUnitId = @insOrgUnitId, 
    UserName = @chvUserName
where ContactId = @intContactId
and TSEqual(ts, @tsOriginal)

return @@Error
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure prUpdateEquipment
-- Check if values were changed in the meanwhile
-- Update values in equipment table.
		@intEquipmentId int,
		@chvMake varchar(50),
		@chvModel varchar(50),
		@intEqTypeId int,
		@debug int = 0	
As
declare 	@intNewEquipmentBC int

set @intNewEquipmentBC = binary_checksum(@chvMake, @chvModel, @intEqTypeId)
if @debug <> 0 	Select @intNewEquipmentBC NewBC 
if @debug <> 0 	select EquipmentBC OldBC from EquipmentBC where EquipmentId = @intEquipmentId

if not exists (Select EquipmentBC from EquipmentBC where EquipmentId = @intEquipmentId)
	insert EquipmentBC (EquipmentId, EquipmentBC)
		select @intEquipmentId, binary_checksum(Make, Model, EqTypeId)
		from Equipment
		where EquipmentId = @intEquipmentId

-- Check if values were changed in the meanwhile
if @intNewEquipmentBC <> (Select EquipmentBC from EquipmentBC where EquipmentId = @intEquipmentId)
begin
	if @debug <> 0 
		select 'Information will be updated.'

	-- update information
	update Equipment 
	Set 	Make = @chvMake,
		Model = @chvModel,
		EqTypeId = @intEqTypeId
	where EquipmentId = @intEquipmentId

	if exists(select EquipmentId from EquipmentBC where EquipmentId = @intEquipmentId)
		update EquipmentBC
		Set EquipmentBC = @intNewEquipmentBC
		where EquipmentId = @intEquipmentId
	else
		insert EquipmentBC (EquipmentId, EquipmentBC)
		values (@intEquipmentId, @intNewEquipmentBC)
end
return
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure setup_Contacts
-----------------------------------------------------------------------------------------
-- Description: insert demo data in Contacts table
-- Roles:		
-- Resultset:	
-- Return val:	Error Code
-- Called by: 	QA

--				Name					Date		Change
-- Created by:	Dejan Sunderic
-- Modified by:	
-----------------------------------------------------------------------------------------
	@debug int = 0
As
set nocount on
declare @intCountContacts int,
		@intCounter int,
		@chvContact varchar(50),
		@chvValue varchar(50),
		@chvUnit varchar(50),
		@insLenContact smallint,
		@insLenValue smallint,
		@insLenUnit smallint,
		@insLenContacts smallint,
		@chvFirstName varchar(50),
		@chvLastName varchar(50),
		@chvPhone varchar(50),
		@chvFax varchar(50),
		@chvEmail varchar(50),
		@chvUserName varchar(50),
		@intContactId int,
		@intOrgUnitId int

		

Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
        @intRowcount int,
		@chvProcedure sysname

set @chvProcedure = 'setup_Contacts'
if @debug <> 0
	select '**** '+ @chvProcedure + ' START ****'
Select @intErrorCode = @@Error


If @intErrorCode = 0
Begin
	insert into Contact(FirstName, LastName, OrgUnitId)
		select Top 440 FirstName, LastName, 10
		from Contact
		order by Phone
	Select @intErrorCode = @@Error
End

If @intErrorCode = 0
Begin
	Create table #Contacts(Id int identity(1,1),
							ContactId int)
	Select @intErrorCode = @@Error
End

If @intErrorCode = 0
Begin
	-- identify Contacts associated with asset
	insert into #Contacts (ContactId)
		select ContactId
		from Contact
		where Phone is null
	Select @intErrorCode = @@Error
End


If @intErrorCode = 0
Begin
	-- set loop
	select 	@intCountContacts = Count(*),
			@intCounter = 1
	from #Contacts
	Select @intErrorCode = @@Error
	if @debug <> 0
		select 	@intCountContacts [Count]
End



If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
End

-- loop through list of Contacts
while @intErrorCode = 0 and @intCounter <= @intCountContacts
begin
	-- get one Contact
	If @intErrorCode = 0
	Begin
		select @intContactId = ContactId
		from #Contacts
		where Id = @intCounter 

	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0
	Begin
		select @chvFirstName = FirstName,
				@chvLastName = LastName
		from Contact
		where @intContactId = ContactId

	    Select @intErrorCode = @@Error
	End


	If @intErrorCode = 0
	Begin
		select @chvPhone = '(416)' 	   + SubString(Convert(varchar, RAND( (DATEPART(mm, GETDATE()) )
							           + (DATEPART(ss, GETDATE()) * 1000 )
							           + DATEPART(ms, GETDATE()) * 100000 )), 3, 3) + '-' 
									   + SubString(Convert(varchar(30), RAND( (DATEPART(mm, GETDATE()) * 100000 )
							           + (DATEPART(ss, GETDATE()) * 1000 )
							           + DATEPART(ms, GETDATE()) * 100000 )), 5, 4),

				 @chvFax = '(416)'     + SubString(Convert(varchar, RAND( (DATEPART(mm, GETDATE()) )
							           + (DATEPART(ss, GETDATE()) * 1000 )
							           + DATEPART(ms, GETDATE()) * 100000 )), 3, 3) + '-' 
								       + SubString(Convert(varchar(30), RAND( (DATEPART(mm, GETDATE()) * 100000 )
							           + (DATEPART(ss, GETDATE()) * 1000 )
							           + DATEPART(ms, GETDATE()) * 100000 )), 5, 4),
				@chvEmail = Left(@chvFirstName, 1) + @chvLastName + '@TrigonBlue.com',
				@chvUserName = Left(@chvFirstName, 1) + @chvLastName,
				@intOrgUnitId = Convert(int, RAND(DATEPART(ms, GETDATE()) * 100000 ) * 10)

	    Select @intErrorCode = @@Error
	if @debug <> 0
		select	[Phone]=     @chvPhone,
			    [Fax]=       @chvFax, 
				[Email]=     @chvEmail, 
				[OrgUnitId]= @intOrgUnitId,
				[UserName]=  @chvUserName

	End

	If @intErrorCode = 0
	Begin
		UPDATE [Contact]
		SET  [Phone]=     @chvPhone,
		     [Fax]=       @chvFax, 
			 [Email]=     @chvEmail, 
			 [OrgUnitId]= @intOrgUnitId,
			 [UserName]=  @chvUserName
		WHERE [ContactId]=@intContactId
	    Select @intErrorCode = @@Error
	End


	-- let's go another round and get another Contact
	If @intErrorCode = 0
	Begin
		set @intCounter = @intCounter + 1
	    Select @intErrorCode = @@Error
	End
end


If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
        COMMIT TRANSACTION
    Else
        ROLLBACK TRANSACTION
End

drop table #Contacts

if @debug <> 0
	select '**** '+ @chvProcedure + ' END ****'
return @intErrorCode



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure setup_Inventory
-----------------------------------------------------------------------------------------
-- Description: insert demo data in Inventory table
-- Roles:		
-- Resultset:	
-- Return val:	Error Code
-- Called by: 	QA

--				Name					Date		Change
-- Created by:	Dejan Sunderic
-- Modified by:	
-----------------------------------------------------------------------------------------
	@debug int = 0
As
set nocount on
declare @intCountInventory int,
		@intCounter int,
		@intEquipmentId int, 
		@intLocationId int, 
		@intStatusId int, 
		@intLeaseId int, 
		@intLeaseScheduleId int, 
		@intOwnerId int, 
		@mnyrent money, 
		@mnyLease money, 
		@mnyCost money, 
		@intAcquisitionTypeId int

Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
        @intRowcount int,
		@chvProcedure sysname

set @chvProcedure = 'setup_Inventory'
if @debug <> 0
	select '**** '+ @chvProcedure + ' START ****'
Select @intErrorCode = @@Error


If @intErrorCode = 0
Begin
	-- set loop
	select 	@intCountInventory = 1000,
			@intCounter = 33
	Select @intErrorCode = @@Error
	if @debug <> 0
		select 	@intCountInventory [Count]
End



If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
End

-- loop through list of Inventory
while @intErrorCode = 0 and @intCounter <= @intCountInventory
begin
	-- get Owner ID
	If @intErrorCode = 0
	Begin
		select @intOwnerId  = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intCounter))), 3)))
	    Select @intErrorCode = @@Error
	End

	-- get equipment ID
	If @intErrorCode = 0
	Begin
		select @intEquipmentId = Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId ))), 3)) / 1000. * 400 + 26
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0 and not exists(select EquipmentId from Equipment where EquipmentId = @intEquipmentId)
	Begin
		select @intEquipmentId = 28
	    Select @intErrorCode = @@Error
	End

	-- get Location ID
	If @intErrorCode = 0
	Begin
		select @intLocationId = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 20) + 3

	    Select @intErrorCode = @@Error
	End

	-- get Status ID
	If @intErrorCode = 0
	Begin
		select @intStatusId  = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 6) + 1
	    Select @intErrorCode = @@Error
	End

	-- get Lease ID
	If @intErrorCode = 0
	Begin
		select @intLeaseId = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId))), 3))/1000. * 13) + 1
	    Select @intErrorCode = @@Error
	End

	-- get LeaseSchedule ID
	If @intErrorCode = 0
	Begin
		select @intLeaseScheduleId = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 300) + 20
	    Select @intErrorCode = @@Error
	End

	-- get AcquisitionType ID
	If @intErrorCode = 0
	Begin
		select @intAcquisitionTypeId = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 3) + 1
	    Select @intErrorCode = @@Error
	End

	-- money
	If @intErrorCode = 0 
	Begin
		if @intAcquisitionTypeId = 1
			select @mnyRent  = (Convert(real, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 200) + 1
		else
			Select @mnyRent = null
		
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0 
	Begin
		if @intAcquisitionTypeId = 2
			select @mnyLease  = (Convert(real, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 4000) + 1
		else
			Select @mnyLease = null
		
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0 
	Begin
		if @intAcquisitionTypeId = 3
			select @mnyCost = (Convert(real, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 12000) + 1
		else
			Select @mnyCost = null
		
	    Select @intErrorCode = @@Error
	End

	if @debug <> 0
		select @intEquipmentId, @intLocationId , @intStatusId , 
				@intLeaseId , @intLeaseScheduleId , @intOwnerId , 
				@mnyrent , @mnyLease , @mnyCost , 
				@intAcquisitionTypeId



	If @intErrorCode = 0
	Begin
		insert into Inventory (EquipmentId, LocationId, StatusId, 
								LeaseId, LeaseScheduleId, OwnerId, 
								rent , Lease, Cost, 
								AcquisitionTypeId)
		select @intEquipmentId, @intLocationId , @intStatusId , 
				@intLeaseId , @intLeaseScheduleId , @intOwnerId , 
				@mnyrent , @mnyLease , @mnyCost , 
				@intAcquisitionTypeId

	    Select @intErrorCode = @@Error
		
	End

	-- let's go another round and get another Inventory
	If @intErrorCode = 0
	Begin
		set @intCounter = @intCounter + 1
	    Select @intErrorCode = @@Error
		if @debug <> 0 
			select @intCounter intCounter
	End
end


If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
        COMMIT TRANSACTION
    Else
        ROLLBACK TRANSACTION
End


if @debug <> 0
	select '**** '+ @chvProcedure + ' END ****'
return @intErrorCode



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE procedure setup_Orders
-----------------------------------------------------------------------------------------
-- Description: insert demo data in Orders table
-- Roles:		
-- Resultset:	
-- Return val:	Error Code
-- Called by: 	QA

--				Name					Date		Change
-- Created by:	Dejan Sunderic
-- Modified by:	
-----------------------------------------------------------------------------------------
	@debug int = 0
As
set nocount on
declare @intCountOrders int,
		@intCounter int,
		@intOwnerId int,
		@dtmOrderDate datetime,
		@dtmTargetDate datetime,
		@dtmCompletionDate datetime,
		@chvNote varchar(1200),
		@intDestinationLocationId int,
		@intOrderStatusId int,
		@intOrderTypeId int,
		@intInventoryId int,
		@intEquipmentId int,
		@intActionId int,
		@mnyCost money,
		@intOrderId int,
		@intItemId int


Declare @intErrorCode int,
        @intTransactionCountOnEntry int,
        @intRowcount int,
		@chvProcedure sysname

set @chvProcedure = 'setup_Orders'
if @debug <> 0
	select '**** '+ @chvProcedure + ' START ****'
Select @intErrorCode = @@Error


If @intErrorCode = 0
Begin
	-- set loop
	select 	@intCountOrders = 100,
			@intCounter = 1
	Select @intErrorCode = @@Error
	if @debug <> 0
		select 	@intCountOrders [Count]
End

If @intErrorCode = 0
Begin
    Select @intTransactionCountOnEntry = @@TranCount
    BEGIN TRANSACTION
End

-- loop through list of Orders
while @intErrorCode = 0 and @intCounter <= @intCountOrders
begin
	-- get Owner ID
	If @intErrorCode = 0
	Begin
		select @intOwnerId  = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intCounter))), 3)))
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0
	Begin
		select @dtmOrderDate  = DateAdd(dd, @intOwnerId, '1/1/2000')
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0
	Begin
		select @dtmTargetDate  = DateAdd(dd, 7, @dtmOrderDate)
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0
	Begin
		select @dtmCompletionDate  = DateAdd(dd, 3, @dtmOrderDate)
	    Select @intErrorCode = @@Error
	End

/*
	-- get equipment ID
	If @intErrorCode = 0
	Begin
		select @intEquipmentId = Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId ))), 3)) / 1000. * 400 + 26
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0 and not exists(select EquipmentId from Equipment where EquipmentId = @intEquipmentId)
	Begin
		select @intEquipmentId = 28
	    Select @intErrorCode = @@Error
	End
*/
	-- get Location ID
	If @intErrorCode = 0
	Begin
		select @intDestinationLocationId = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 20) + 3
	    Select @intErrorCode = @@Error
	End


	-- NOTE
	If @intErrorCode = 0
	Begin
		select 	@chvNote = Substring ('lhsdour9dna  sdkjasdfijasdlf saldjf asdlkjf asldjf alsdf sdf88023rj kasd iu3o4i 34lt lsdfgj asut;ol4tj lrkj q;4lkt jqwlkj l4kj 3ql4kj 3l4k5j 3l45kj qw;l4k jawl4 jwl4j df;j otsujh4w0j tweon gmvsdf,mfndvlejrhtgernmvlsdkjfg;al awl qwrtj qwitejuqi wjwqoer89043l;krjgweourt58jgl skj glkdsjeh5h7t45hgnsjabnwseqwwethqwiretngs,mvn  sd,gn slgjhler g ewlrj qwlerjt lqwejrt lqwrjt lemrg.,smm.,wwemrgo eeroit owertj woerit owertu eortj lsdkfgn ,msdfnb,smdfng eowi5rt lekrgj wo35j elrkjg ewortj sdlfkgnj weilojwle;rgknm jelwrigj rel er gwlerjg e;wlrg jvnd ewlr  lerkjg ewlrkt wertlk jert lwertj sdofgu834wjtr 30 9sdflkgj lwrekj lekrjt ;wlerk j;weljg ;sdflg kjsd;lgk 4l5 twerljg ;welkrtj welrtjg ;wlerkjg welrjg werltj werlt jwerotgj 45j ewlrjg;elkrjg w;lkjw3etr ;lwerkjtg wel;rktgjrelkj lerkj lewrkj ;lwerkjt w;lerjtg 598ijt ;wlejrt sdnfg ,dnf wljpr ;wolerj lwe;rjt we;lrtj we;4t jg;lrej w;elrkjt ;welr e;lwrjhg lewrjt ;lerkjt lwert wej ;lekrjgl;wejr ;lerkjg welrjg elrjg ;lergj welrgj er;lgj e;wlrjg ;elrjg ewlrgj elr', @intOwnerId, 200)
	    Select @intErrorCode = @@Error
	End

	-- get Status ID
	If @intErrorCode = 0
	Begin
		select @intOrderStatusId  = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 6) + 1
	    Select @intErrorCode = @@Error
	End

	-- get OrderType ID
	If @intErrorCode = 0
	Begin
		select @intOrderTypeId = (Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId))), 3))/1000. * 5) + 1
	    Select @intErrorCode = @@Error
	End





--	if @debug <> 0
		select 		@intOwnerId ,
					@dtmOrderDate ,
					@dtmTargetDate,
					@dtmCompletionDate ,
					@chvNote ,
					@intDestinationLocationId ,
					@intOrderStatusId ,
					@intOrderTypeId 


	If @intErrorCode = 0
	Begin
		insert [Order](RequestedById , OrderDate ,	TargetDate,
					CompletionDate , Note , DestinationLocationId ,
					OrderStatusId , OrderTypeId)
		values 		(@intOwnerId , @dtmOrderDate ,	@dtmTargetDate,
					@dtmCompletionDate , @chvNote , @intDestinationLocationId ,
					@intOrderStatusId , @intOrderTypeId)	    
		Select @intErrorCode = @@Error,
				@intOrderId = @@identity

	End


-- ORDER ITEM
	-- get equipment ID
	If @intErrorCode = 0
	Begin
		select @intInventoryId = Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId ))), 3)) / 1000. * 900 + 75
	    Select @intErrorCode = @@Error
	End

	If @intErrorCode = 0 and not exists(select EquipmentId from Equipment where EquipmentId = @intEquipmentId)
	Begin
		select @intEquipmentId = EquipmentId
		from Inventory 
		where InventoryId = @intInventoryId
	    Select @intErrorCode = @@Error
	End

	-- actionID
	If @intErrorCode = 0
	Begin
		select @intActionID = Convert(int, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId ))), 3)) / 1000. * 15 + 1
	    Select @intErrorCode = @@Error
	End
	-- cost
	If @intErrorCode = 0
	Begin
		select @mnyCost  = (Convert(real, Right(Convert(varchar(20),Convert(decimal(38,17), RAND( @intOwnerId  ))), 3))/1000. * 200) + 1
	    Select @intErrorCode = @@Error
	End
	-- ORDER ITEM
	If @intErrorCode = 0
	Begin
		INSERT OrderItem (OrderId, InventoryId, EquipmentId, CompletionDate, Note)
			values(@intOrderId, @intInventoryId, @intEquipmentId, @dtmCompletionDate, @chvNote)
	    Select @intErrorCode = @@Error,
				@intItemId = @@identity
	End



	-- CHARGE LOG
	If @intErrorCode = 0
	Begin
		insert into ChargeLog(ItemId, ActionId, ChargeDate, Cost, Note)
			select @intItemId, @intActionId, @dtmCompletionDate, Convert(varchar(10), @mnyCost), @chvnote
	    Select @intErrorCode = @@Error
	End
	If @intErrorCode = 0
	Begin
		insert into ChargeLog(ItemId, ActionId, ChargeDate, Cost, Note)
			select @intItemId, @intActionId + 3, @dtmCompletionDate, @mnyCost * .57, ''
	    Select @intErrorCode = @@Error
	End
	If @intErrorCode = 0
	Begin
		insert into ChargeLog(ItemId, ActionId, ChargeDate, Cost, Note)
			select @intItemId, @intActionId + 5, @dtmCompletionDate, @mnyCost * .33, @chvNote
	    Select @intErrorCode = @@Error
	End






	-- let's go another round and get another Orders
	If @intErrorCode = 0
	Begin
		set @intCounter = @intCounter + 1
	    Select @intErrorCode = @@Error
		if @debug <> 0 
			select @intCounter intCounter
	End
end


If @@TranCount > @intTransactionCountOnEntry
Begin
    If @intErrorCode = 0
        COMMIT TRANSACTION
    Else
        ROLLBACK TRANSACTION
End


if @debug <> 0
	select '**** '+ @chvProcedure + ' END ****'
return @intErrorCode



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.fnDueDays 
-- return list of due days for the leasing
(
	@dtsStartDate smalldatetime,
	@dtsEndDate smalldatetime,
	@chvLeaseFrequency varchar(20)
)  
RETURNS @tblTerms table  
	(
	TermID int,
	DueDate smalldatetime
	)

AS  
BEGIN 

declare @insTermsCount smallint -- number of intervals
declare @insTerms smallint -- number of intervals

-- calculate number of terms
select @insTermsCount =
	CASE @chvLeaseFrequency
		When 'monthly' then DateDIFF(month, @dtsStartDate, @dtsEndDate)
		When 'semi-monthly' then 2 * DateDIFF(month, @dtsStartDate, @dtsEndDate)
		When 'bi-weekly' then DateDIFF(week, @dtsStartDate, @dtsEndDate)/2
		When 'weekly' then DateDIFF(week, @dtsStartDate, @dtsEndDate)
		When 'quarterly' then DateDIFF(qq, @dtsStartDate, @dtsEndDate)
		When 'yearly' then DateDIFF(y, @dtsStartDate, @dtsEndDate)
	END
	
-- generate list of due dates
set @insTerms = 1
while @insTerms <= @insTermsCount
begin
	insert @tblTerms (TermID, DueDate)
	values (@insTerms, Convert(smalldatetime, CASE 
						When @chvLeaseFrequency = 'monthly' 
							then DateADD(month,@insTerms, @dtsStartDate)
						When @chvLeaseFrequency = 'semi-monthly' and @insTerms/2 =  Cast(@insTerms as float)/2 
							then DateADD(month, @insTerms/2, @dtsStartDate)
						When @chvLeaseFrequency = 'semi-monthly' and @insTerms/2 <> Cast(@insTerms as float)/2 
							then DateADD(dd, 15, DateADD(month, @insTerms/2, @dtsStartDate))
						When @chvLeaseFrequency = 'bi-weekly' 
							then DateADD(week, @insTerms*2, @dtsStartDate)
						When @chvLeaseFrequency = 'weekly' 
							then DateADD(week, @insTerms, @dtsStartDate)
						When @chvLeaseFrequency = 'quarterly' 
							then DateADD(qq, @insTerms, @dtsStartDate)
						When @chvLeaseFrequency = 'yearly' 
							then DateADD(y, @insTerms, @dtsStartDate)
					END , 105))
	
	select @insTerms = @insTerms + 1
end

RETURN
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION fnLastDateOfMonth
-- returns last date of teh current month
	(
	@dtmDate datetime
	)
RETURNS datetime
AS
BEGIN
   declare @inyDay tinyint
   declare @dtmDateNew datetime

   set @inyDay = Day(@dtmDate)

   -- first day of the current month
   set @dtmDateNew = DateAdd( day, - @inyDay + 1, @dtmDate)
   -- first day of the next month
   set @dtmDateNew = DateAdd( month, 1, @dtmDateNew)
   -- last day of the current month
   set @dtmDateNew = DateAdd( day, - 1, @dtmDateNew)

   RETURN (@dtmDateNew)
END






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.fnListOfLastDatesMonth 
(	@dtmStartDate datetime,
	@inyCountYears tinyint
)
RETURNS @tblDates table  
	(
	LastDate datetime
	)
 AS  
BEGIN 

declare @dtmEndDate datetime
declare @dtmDate datetime

set @dtmEndDate = DATEADD(year, @inyCountYears, @dtmStartDate)
set @dtmDate = @dtmStartDate


while @dtmDate < @dtmEndDate
begin

	insert into @tblDates
	values(dbo.fnLastDateOfMonth(@dtmDate))

	set @dtmDate = DATEADD(month, 1, @dtmDate)

end
RETURN
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION fnQuarterString
-- returns quarter in form of '3Q2000' to which specified date belongs.
	(
	@dtmDate datetime
	)
RETURNS char(6) -- quater like 3Q2000
AS
BEGIN
   RETURN ( DateName(q, @dtmDate) + 'Q' + DateName(yyyy, @dtmDate))
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION fnThreeBusDays 
	(@dtmDate datetime)
RETURNS datetime
AS  
BEGIN 
declare @inyDayOfWeek tinyint
set @inyDayOfWeek = DatePart(dw, @dtmDate)
set @dtmDate = Convert(datetime, Convert(varchar, @dtmDate, 101))

if @inyDayOfWeek = 1 -- sunday
	return DateAdd(d, 3, @dtmDate )
if @inyDayOfWeek = 7 -- saturday
	return DateAdd(d, 4, @dtmDate )
if @inyDayOfWeek = 6 -- friday
	return DateAdd(d, 5, @dtmDate )
if @inyDayOfWeek = 5 -- thursday
	return DateAdd(d, 5, @dtmDate )
if @inyDayOfWeek = 4 -- wednesday
	return DateAdd(d, 5, @dtmDate )

return DateAdd(d, 3, @dtmDate )
END





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE FUNCTION fn_DepartmentEquipment 
                 ( @chvUserName sysname )
RETURNS table
AS
RETURN (
	select InventoryId, Make + ' ' + model Model, Location 
	from Inventory inner join Contact C
	on Inventory.OwnerId = C.ContactId
		inner join Contact Manager
		on C.OrgUnitId = Manager.OrgUnitId
			inner join Equipment
			on Inventory.EquipmentId = Equipment.EquipmentId
				inner join Location
				on Inventory.LocationId = Location.LocationId
	where Manager.UserName = @chvUserName
       )

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER trContact_with_BC_IU ON [dbo].[Contact_with_BC] 
FOR INSERT, UPDATE
AS

update Contact_with_BC
set BC = BINARY_CHECKSUM(FirstName, LastName, Phone, Fax, Email, OrgUnitId, UserName)
where ContactId in (select ContactId from inserted)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger itrEqType_D
On dbo.EqType
instead of Delete
As
If exists(select *
	from Equipment 
	where EqTypeId in (select EqTypeId 
			     from deleted)
	)
     raiserror('Some records from EEEEqType are in use in Equipment table!', 16, 1)
else
     delete EqType
     where EqTypeId in (select EqTypeId from deleted)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trEquipment_IU
On dbo.Equipment
For Insert, Update
As
	-- precalculate ModelSDX and MakeSDX field to speed up use of SOUNDEX function
	if Update(Model)
		update Equipment
		Set ModelSDX = SOUNDEX(Model)
		where EquipmentId IN (Select EquipmentId from Inserted)

	if Update(Make)
		update Equipment
		Set MakeSDX = SOUNDEX(Make)
		where EquipmentId IN (Select EquipmentId from Inserted)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


alter table [dbo].[Equipment] disable trigger [trEquipment_IU]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trEquipment_IU_2
-- list all columns that were changed
On dbo.Equipment
For Insert, Update
As

	SET NOCOUNT OFF
	declare @intCountColumn int,
			@intColumn int

	-- count columns in the table
	SELECT @intCountColumn = Count(Ordinal_position)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'Equipment'

	select COLUMNS_UPDATED() "COLUMNS UPDATED"
	
	Set @intColumn = 1
	
	-- loop through columns
	while @intColumn <= @intCountColumn
	begin
		if COLUMNS_UPDATED() & @intColumn = @intColumn 
			Print 'Column (' +  Cast(@intColumn as varchar) + ') ' + COL_NAME('Equipment', @intColumn) + ' has been changed!'
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


alter table [dbo].[Equipment] disable trigger [trEquipment_IU_2]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Trigger Equipment_DeleteTrigger
On dbo.Equipment
For Delete
As
Print 'One or more rows are deleted in Equipment table!'

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


alter table [dbo].[Equipment] disable trigger [Equipment_DeleteTrigger]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trInventory_Lease_U
On dbo.Inventory
For Update
As

if @@Rowcount = 0
	return

If Update (Lease) or Update(LeaseScheduleId)
begin
	-- sustruct deleted leases from total amount
	Update LeaseSchedule
	Set LeaseSchedule.PeriodicTotalAmount = LeaseSchedule.PeriodicTotalAmount - Coalesce(d.Lease, 0)
	from LeaseSchedule inner join deleted d
		on LeaseSchedule.ScheduleId = d.LeaseScheduleId
	
	-- add inserted leases to total amount	
	Update LeaseSchedule
	Set LeaseSchedule.PeriodicTotalAmount = LeaseSchedule.PeriodicTotalAmount + Coalesce(i.Lease, 0)
	from LeaseSchedule inner join inserted i
		on LeaseSchedule.ScheduleId = i.LeaseScheduleId
	
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trInventory_Lease_D
On dbo.Inventory
For delete
As

if @@Rowcount = 0
	return

-- sustruct deleted leases from total amount
Update LeaseSchedule
Set LeaseSchedule.PeriodicTotalAmount = LeaseSchedule.PeriodicTotalAmount - Coalesce(d.Lease, 0)
from LeaseSchedule inner join deleted d
	on LeaseSchedule.ScheduleId = d.LeaseScheduleId	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trInventory_Lease_I
On dbo.Inventory
For Insert
As

if @@Rowcount = 0
	return

-- add inserted leases to total
Update LeaseSchedule
Set LeaseSchedule.PeriodicTotalAmount = LeaseSchedule.PeriodicTotalAmount + Coalesce(i.Lease, 0)
from LeaseSchedule inner join inserted i
	on LeaseSchedule.ScheduleId = i.LeaseScheduleId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trMyEquipment_D
On dbo.MyEquipment
For Delete
As
	Select 'You have just deleted ' 
		+ Cast(@@rowcount as varchar) 
		+ ' record(s)!'

	Select * from deleted


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Trigger trOrderStatus_U
On dbo.[Order]
For Update
As
	If Update (OrderStatusId)
	begin
	
		Insert into ActivityLog(Activity, 
								LogDate, 
								UserName, 
								Note)
		 Select 	'Order.OrderStatusId',	
					GetDate(), 
					USER_NAME(),			
					'Value changed from ' 
					+ Cast( d.OrderStatusId as varchar)
					+ ' to '
					+ Cast( i.OrderStatusId as varchar)
				
		from deleted d inner join inserted i
		on d.OrderId = i.OrderId
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Trigger trOrderStatus_U_1
On dbo.[Order]
For Update
As
	declare @intOldOrderStatusId int,
			@intNewOrderStatusId int
	
	If Update (OrderStatusId)
	begin
	
		select @intOldOrderStatusId = OrderStatusId from deleted
		select @intNewOrderStatusId = OrderStatusId from inserted
		Insert into ActivityLog(Activity, LogDate, 
								UserName, Note)
		 values ('Order.OrderStatusId',	GetDate(), 
				USER_NAME(),			'Value changed from ' 
										+ Cast( @intOldOrderStatusId as varchar)
										+ ' to '
										+ Cast((@intNewOrderStatusId) as varchar)
				)
	end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

Create Trigger itr_vEquipment_I
On dbo.vEquipment
instead of Insert
As

-- If the EQType is new, insert it

--check are there any new inserted.EqTypes which do not exist in the EqType table
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
select inserted.Make, inserted.Model, EqType.EqTypeId
from inserted inner join EqType
on inserted.EqType = EqType.EqType


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER itr_vInventory_I 
ON vInventory
instead of INSERT
AS

-- If the EQType is new, insert it
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
If exists(select Make, Model, EqTypeId
          from inserted Inner Join EqType
          On inserted.EqType = EqType.EqType
          where Make + Model + Str(EqTypeId) not in (select Make + Model + Str(EqTypeId)
                                                     from Equipment))
     -- we need to insert the new ones
     Insert into Equipment(Make, Model, EqTypeId)
         select Make, Model, EqTypeId
          from inserted Inner Join EqType
          On inserted.EqType = EqType.EqType
          where Make + Model + Str(EqTypeId) not in (select Make + Model + Str(EqTypeId)
                                                     from Equipment)

-- if Location does not exist, insert it
If exists(select Location
          from inserted
          where Location not in (select Location 
                                 from Location))
     -- we need to insert the new ones
     insert into Location(Location, Address, City, ProvinceId, Country)
         select Location, Address, City, ProvinceId, Country
         from inserted
         where Location not in (select Location 
                                from Location)
-- Status
If exists(select Status
          from inserted
          where Status not in (select Status 
                               from Status))
     -- we need to insert the new ones
     insert into Status(Status)
         select Status
         from inserted
         where Status not in (select Status 
                              from Status)

-- AcquisitionType
If exists(select AcquisitionType
          from inserted
          where AcquisitionType not in (select AcquisitionType 
                                 from AcquisitionType))
     -- we need to insert the new ones
     insert into AcquisitionType(AcquisitionType)
         select AcquisitionType
         from inserted
         where AcquisitionType not in (select AcquisitionType 
                                       from AcquisitionType)

-- if Owner does not exist, insert it
If exists(select Email 
          from inserted
          where Email not in (select Email 
                              from Contact))
     -- we need to insert the new ones
     insert into Contact(FirstName, LastName,  Phone, Fax, Email, UserName, OrgUnitId)
         select FirstName, LastName,  Phone, Fax, Email, UserName, OrgUnitId
          from inserted
          where Email not in (select Email 
                              from Contact)

Insert into Inventory(EquipmentId, LocationId, StatusId,  OwnerId, AcquisitionTypeId, Cost, Rent)
Select  E.EquipmentId, L.LocationId, S.StatusId,  C.ContactId, A.AcquisitionTypeId, inserted.Cost, inserted.Rent
From inserted inner join EqType
on inserted.EqType =  EqType.EqType
   Inner Join Equipment E
   On inserted.Make = E.Make and inserted.Model = E.Model and EqType.EqTypeID = E.EqTypeID
      inner join Location L
      on inserted.Location = L.Location
         inner join Status S
         on inserted.Status = S.Status
              inner join Contact C
              on inserted.Email = C.Email
                 inner join AcquisitionType A
                 on inserted.AcquisitionType = A.AcquisitionType

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


exec sp_addextendedproperty N'Caption', 'Phone', N'user', N'dbo', N'table', N'Contact', N'column', N'Phone'
GO
exec sp_addextendedproperty N'Format', '(999)999-9999', N'user', N'dbo', N'table', N'Contact', N'column', N'Phone'
GO
exec sp_addextendedproperty N'Location', '4000x1200', N'user', N'dbo', N'table', N'Contact', N'column', N'Phone'


GO

