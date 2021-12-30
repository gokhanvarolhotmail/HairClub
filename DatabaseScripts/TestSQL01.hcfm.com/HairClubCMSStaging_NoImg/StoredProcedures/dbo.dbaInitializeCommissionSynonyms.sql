/* CreateDate: 12/28/2021 09:21:12.163 , ModifyDate: 12/28/2021 09:21:12.163 */
GO
/*
==============================================================================
PROCEDURE:				dbaInitializeCommissionSynonyms

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		02/192013

LAST REVISION DATE: 	02/19/2013

==============================================================================
DESCRIPTION:	Initializes synonyms for the Commissions Database table references.
==============================================================================
NOTES:
		* 02/09/2013 MVT - Created
		* 03/13/2013 MVT - Added Parameter for Live/Staging
		* 06/14/2018 MVT - Added [HCTestCMS] prefix for dev/staging environments.

==============================================================================
SAMPLE EXECUTION:  [dbaInitializeCommissionSynonyms] 0, 1, 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaInitializeCommissionSynonyms]
		@IsLive bit,
		@IsStaging bit,
		@IsDev bit
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CommissionDB nvarchar(100)
	DECLARE @HC_BI_ENT_DDS_DB nvarchar(100)
	DECLARE @HC_BI_CMS_DDS_DB nvarchar(100)

	IF @IsDev = 1 OR @IsStaging = 1
	BEGIN
		SET @CommissionDB  = 'HC_Commission.dbo.'
		SET @HC_BI_ENT_DDS_DB = '[HC_BI_ENT_DDS].bi_ent_dds.'
		SET @HC_BI_CMS_DDS_DB = '[HC_BI_CMS_DDS].bi_cms_dds.'
	END
	ELSE IF @IsLive = 1
	BEGIN
		SET @CommissionDB = '[SQL06].HC_Commission.dbo.'
		SET @HC_BI_ENT_DDS_DB = '[SQL06].[HC_BI_ENT_DDS].bi_ent_dds.'
		SET @HC_BI_CMS_DDS_DB  = '[SQL06].[HC_BI_CMS_DDS].bi_cms_dds.'
	END

	--PRINT @CommissionDB
	--PRINT @HC_BI_ENT_DDS_DB
	--PRINT @HC_BI_CMS_DDS_DB

	DECLARE @sqlCommand nvarchar(1000)



	/********************************************************************************/
	/*																				*/
	/*	HC_Commission Database														*/
	/*																				*/
	/********************************************************************************/

	--
	-- Commission FactCommissionBatch table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_FactCommissionBatch_TABLE'))
		DROP SYNONYM Commission_FactCommissionBatch_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_FactCommissionBatch_TABLE FOR ' + @CommissionDB + 'FactCommissionBatch'
	EXEC (@sqlCommand)

	--
	-- Commission FactCommissionHeader table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_FactCommissionHeader_TABLE'))
		DROP SYNONYM Commission_FactCommissionHeader_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_FactCommissionHeader_TABLE FOR ' + @CommissionDB + 'FactCommissionHeader'
	EXEC (@sqlCommand)

	--
	-- Commission FactCommissionDetail table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_FactCommissionDetail_TABLE'))
		DROP SYNONYM Commission_FactCommissionDetail_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_FactCommissionDetail_TABLE FOR ' + @CommissionDB + 'FactCommissionDetail'
	EXEC (@sqlCommand)

	--
	-- Commission DimCommissionType table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_DimCommissionType_TABLE'))
		DROP SYNONYM Commission_DimCommissionType_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_DimCommissionType_TABLE FOR ' + @CommissionDB + 'DimCommissionType'
	EXEC (@sqlCommand)

	--
	-- Commission lkpPayPeriods table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_lkpPayPeriods_TABLE'))
		DROP SYNONYM Commission_lkpPayPeriods_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_lkpPayPeriods_TABLE FOR ' + @CommissionDB + 'lkpPayPeriods'
	EXEC (@sqlCommand)

	--
	-- Commission FactCommissionOverride table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_FactCommissionOverride_TABLE'))
		DROP SYNONYM Commission_FactCommissionOverride_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_FactCommissionOverride_TABLE FOR ' + @CommissionDB + 'FactCommissionOverride'
	EXEC (@sqlCommand)

	--
	-- Commission lkpCommissionBatchStatus table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_lkpCommissionBatchStatus_TABLE'))
		DROP SYNONYM Commission_lkpCommissionBatchStatus_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_lkpCommissionBatchStatus_TABLE FOR ' + @CommissionDB + 'lkpCommissionBatchStatus'
	EXEC (@sqlCommand)


	--
	-- Commission DimCommissionType table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_DimCommissionType_TABLE'))
		DROP SYNONYM Commission_DimCommissionType_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_DimCommissionType_TABLE FOR ' + @CommissionDB + 'DimCommissionType'
	EXEC (@sqlCommand)


	--
	-- Commission DimOvererrideReasons table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_DimOvererrideReasons_TABLE'))
		DROP SYNONYM Commission_DimOvererrideReasons_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_DimOvererrideReasons_TABLE FOR ' + @CommissionDB + 'DimOvererrideReasons'
	EXEC (@sqlCommand)


	--
	-- Commission DimPayrollExport table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_DimPayrollExport_TABLE'))
		DROP SYNONYM Commission_DimPayrollExport_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM Commission_DimPayrollExport_TABLE FOR ' + @CommissionDB + 'DimPayrollExport'
	EXEC (@sqlCommand)


	--
	-- Commission extHairClubCMSEarnedSummaryByEmployeeHR proc
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_extHairClubCMSEarnedSummaryByEmployeeHR_PROC'))
		DROP SYNONYM Commission_extHairClubCMSEarnedSummaryByEmployeeHR_PROC;

	SET @sqlCommand = 'CREATE SYNONYM Commission_extHairClubCMSEarnedSummaryByEmployeeHR_PROC FOR ' + @CommissionDB + 'extHairClubCMSEarnedSummaryByEmployeeHR'
	EXEC (@sqlCommand)


	--
	-- Commission extHairClubCMSEarnedSummaryByCountry
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_extHairClubCMSEarnedSummaryByCountry_PROC'))
		DROP SYNONYM Commission_extHairClubCMSEarnedSummaryByCountry_PROC;

	SET @sqlCommand = 'CREATE SYNONYM Commission_extHairClubCMSEarnedSummaryByCountry_PROC FOR ' + @CommissionDB + 'extHairClubCMSEarnedSummaryByCountry'
	EXEC (@sqlCommand)


	--
	-- Commission extHairClubCMSHRAuditByCountryAndPayPeriod proc
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('Commission_extHairClubCMSHRAuditByCountryAndPayPeriod_PROC'))
		DROP SYNONYM Commission_extHairClubCMSHRAuditByCountryAndPayPeriod_PROC;

	SET @sqlCommand = 'CREATE SYNONYM Commission_extHairClubCMSHRAuditByCountryAndPayPeriod_PROC FOR ' + @CommissionDB + 'extHairClubCMSHRAuditByCountryAndPayPeriod'
	EXEC (@sqlCommand)


	/********************************************************************************/
	/*																				*/
	/*	HC_BI_ENT_DDS Database														*/
	/*																				*/
	/********************************************************************************/

	--
	-- HC_BI_ENT_DDS DimCenter table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_ENT_DDS_DimCenter_TABLE'))
		DROP SYNONYM HC_BI_ENT_DDS_DimCenter_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_ENT_DDS_DimCenter_TABLE FOR ' + @HC_BI_ENT_DDS_DB + 'DimCenter'
	EXEC (@sqlCommand)


	--
	-- HC_BI_ENT_DDS DimCenter table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_ENT_DDS_DimCenter_TABLE'))
		DROP SYNONYM HC_BI_ENT_DDS_DimCenter_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_ENT_DDS_DimCenter_TABLE FOR ' + @HC_BI_ENT_DDS_DB + 'DimCenter'
	EXEC (@sqlCommand)



	/********************************************************************************/
	/*																				*/
	/*	HC_BI_CMS_DDS Database														*/
	/*																				*/
	/********************************************************************************/
	--
	-- HC_BI_CMS_DDS DimEmployee table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimEmployee_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimEmployee_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimEmployee_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimEmployee'
	EXEC (@sqlCommand)

	--
	-- HC_BI_CMS_DDS DimClient table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimClient_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimClient_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimClient_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimClient'
	EXEC (@sqlCommand)

	--
	-- HC_BI_CMS_DDS DimSalesCode table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimSalesCode_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimSalesCode_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimSalesCode_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimSalesCode'
	EXEC (@sqlCommand)


	--
	-- HC_BI_CMS_DDS DimSalesOrderDetail table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimSalesOrderDetail'
	EXEC (@sqlCommand)

	--
	-- HC_BI_CMS_DDS DimSalesOrder table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimSalesOrder_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimSalesOrder_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimSalesOrder_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimSalesOrder'
	EXEC (@sqlCommand)

	--
	-- HC_BI_CMS_DDS DimClientMembership table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimClientMembership_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimClientMembership_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimClientMembership_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimClientMembership'
	EXEC (@sqlCommand)

	--
	-- HC_BI_CMS_DDS DimMembership table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_CMS_DDS_DimMembership_TABLE'))
		DROP SYNONYM HC_BI_CMS_DDS_DimMembership_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM HC_BI_CMS_DDS_DimMembership_TABLE FOR ' + @HC_BI_CMS_DDS_DB + 'DimMembership'
	EXEC (@sqlCommand)

END
GO
