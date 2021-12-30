/* CreateDate: 05/08/2010 13:21:50.230 , ModifyDate: 12/14/2012 15:02:11.867 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckReferentialIntegrity_MKTG]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckReferentialIntegrity_MKTG]
--
-- EXEC [bi_health].[spHC_CheckReferentialIntegrity_MKTG]
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

    DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckReferentialIntegrity' AND AuditSystem='MKTG'
	------------------------------
	-- Check FactActivity Referential Integrity
	------------------------------

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimActionCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimActivityType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimAgeRange]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimContact]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityCompletedDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityDueDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimEmployee_CompletedByEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimEmployee_StartedByEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimEthnicity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimGender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimHairLossType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimMaritalStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimOccupation]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimResultCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimSource]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimTimeOfDay_ActivityCompletedTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimTimeOfDay_ActivityTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimTimeOfDay_ActivityStartTime]()


	------------------------------
	-- Check FactActivityReults Referential Integrity
	------------------------------

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimActionCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimActivityResult]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimAgeRange]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimContact]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivityDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivityDueDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivityResultDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivitySavedDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivityCompletedDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_OriginalAppointmentDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimEmployee_CompletedByEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimEthnicity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimGender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimHairLossType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimMaritalStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimOccupation]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimResultCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimSource]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimSalesType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityCompletedTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityResultTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivitySavedTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityStartTime]()


	------------------------------
	-- Check FactLead Referential Integrity
	------------------------------

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimAgeRange]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimContact]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimDate_LeadCreationDate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimTimeOfDay_LeadCreationTime]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimEthnicity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimGender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimHairLossType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimMaritalStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimOccupation]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimSource]()


	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
			   ([AuditProcessName]
			   ,[TableName]
			   ,[RI_DimensionName]
			   ,[RI_FieldName]
			   ,[RI_FieldKey]
			   ,[AuditSystem]
				)
	SELECT 'CheckReferentialIntegrity'
			, [TableName]
			, [DimensionName]
			, [FieldName]
			, [FieldKey]
			, 'MKTG'
	 FROM @tblRI


END
GO
