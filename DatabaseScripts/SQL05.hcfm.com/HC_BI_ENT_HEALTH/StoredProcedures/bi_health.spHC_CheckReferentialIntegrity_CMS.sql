/* CreateDate: 05/08/2010 14:23:55.350 , ModifyDate: 04/10/2014 16:09:54.950 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckReferentialIntegrity_CMS]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckReferentialIntegrity_CMS]
--
-- EXEC [bi_health].[spHC_CheckReferentialIntegrity_CMS]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblRI TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, [TableName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [DimensionName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [FieldName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [FieldKey] bigint
			)

	------------------------------
	-- Check FactSales Referential Integrity
	------------------------------
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckReferentialIntegrity' AND AuditSystem='CMS'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimCenter_ClientHomeCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimClient]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimClientMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimSalesOrderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimSalesOrder]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSales_DimDate]()

	------------------------------
	-- Check FactSalesTransaction Referential Integrity
	------------------------------
	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimClient]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimClientMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee1]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee2]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee3]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee4]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimSalesOrderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimSalesCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimSalesOrder]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimSalesOrderDetail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimDate]()

	------------------------------
	-- Check FactSalesTransaction Referential Integrity
	------------------------------

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimClient]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimClientMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimTenderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrder]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderTender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransactionTender_DimDate]()

	------------------------------
	-- Check FactHairSystemOrder Referential Integrity
	------------------------------
	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimCenter]()
					--print cast(getdate() as varchar(20)) + ' fshsoDimCenter'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimClient]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimCenter'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimClientMembership]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimCLM'
	---THIS ONE IS SUSPECT
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimDates_DateKey]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimDateKey'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimEmployee_MeasuredBy]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimEmpMeasured'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemDensity]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSDensity'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemFrontalDensity]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSFrontalDensity'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemHairColor]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSColor'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemHairLength]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHairLength'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemMatrixColor]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimMatrixColor'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemOrder]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSO'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemOrderStatus]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSOStatus'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemRecession]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSRecession'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemStyle]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSStyle'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemTexture]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSTexture'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemType]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSType'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemVendorContract]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSVendorContract'
	------------------------------
	-- Check FactAppointment, AppointmentDetail, SurgeryCloseout Referential Integrity
	------------------------------
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactAppointmentDetail_DimAppointment]()
		--print cast(getdate() as varchar(20)) + ' fsadDimAppointment'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactAppointmentDetail_DimSalesCode]()
		--print cast(getdate() as varchar(20)) + ' fsadDimSalesCode'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactAppointmentEmployee_DimAppointment]()
		--print cast(getdate() as varchar(20)) + ' fsaeDimAppointment'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactAppointmentEmployee_DimEmployee]()
		--print cast(getdate() as varchar(20)) + ' fsaeDimEmployee'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimAppointment]()
		--print cast(getdate() as varchar(20)) + ' fsSCEDimAppointment'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimEmployee]()
		--print cast(getdate() as varchar(20)) + ' fsSCEDimEmployee'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemVendorContract]()
		--print cast(getdate() as varchar(20)) + ' fshsoDimHSVendorContract'
	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckRI_FactSalesTransaction_DimDate]()
		--print cast(getdate() as varchar(20)) + ' fsttDimdate2'
INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
           ([AuditProcessName]
           ,[TableName]
           ,[RI_DimensionName]
           ,[RI_FieldName]
           ,[RI_FieldKey]
		   ,[AuditSystem]	)
SELECT 'CheckReferentialIntegrity'
		, [TableName]
        , [DimensionName]
		, [FieldName]
		, [FieldKey]
		, 'CMS'
 FROM @tblRI


END
GO
