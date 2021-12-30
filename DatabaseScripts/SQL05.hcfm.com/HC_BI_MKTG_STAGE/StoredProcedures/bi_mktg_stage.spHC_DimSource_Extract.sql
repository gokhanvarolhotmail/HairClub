/* CreateDate: 05/03/2010 12:26:49.010 , ModifyDate: 08/30/2021 21:24:45.060 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimSource_Extract]
		@DataPkgKey	int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time

AS
-------------------------------------------------------------------------
-- [spHC_DimSource_Extract] is used to retrieve a
-- list Sources
--
-- exec [bi_mktg_stage].[spHC_DimSource_Extract]  '2009-01-01 01:00:00', '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			07/27/2020	KMurdoch	 Added Origin
--			12/08/2020  KMurdoch     Added Content
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
 				, @return_value		int


	DECLARE		  @TableName		varchar(150)	-- Name of table
				, @ExtractRowCnt	int


 	SET @TableName = N'[bi_mktg_dds].[DimSource]'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET


		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN
				-- Set the Current Extraction Time & Status
				UPDATE  bief_stage._DataFlow
				SET     CET = @CET
				,       Status = 'Extracting'
				WHERE   TableName = @TableName


				CREATE TABLE #Campaign (
					[SourceCodeID] NVARCHAR(18)
				,	[SourceCode] NVARCHAR(50)
				,	[Creative] NVARCHAR(50)
				)

				CREATE TABLE #SourceCode (
					RowID INT IDENTITY(1, 1)
				,	[SourceCodeID] NVARCHAR(18)
				,	[CampaignName] NVARCHAR(80)
				,	[CampaignType] NVARCHAR(50)
				,	[SourceCode] NVARCHAR(50)
				,	[DPNCode] NVARCHAR(50)
				,	[DWFCode] NVARCHAR(50)
				,	[DWCCode] NVARCHAR(50)
				,	[MPNCode] NVARCHAR(50)
				,	[MWFCode] NVARCHAR(50)
				,	[MWCCode] NVARCHAR(50)
				,	[Channel] NVARCHAR(50)
				,	[Type] NVARCHAR(50)
				,	[Gender] NVARCHAR(50)
				,	[Goal] NVARCHAR(50)
				,	[Media] NVARCHAR(50)
				,	[Location] NVARCHAR(50)
				,	[Language] NVARCHAR(50)
				,	[Format] NVARCHAR(50)
				,	[Creative] NVARCHAR(50)
				,	[Origin] NVARCHAR(50)
				,	[Number] NVARCHAR(50)
				,	[DNIS] NVARCHAR(50)
				,	[PromoCode] NVARCHAR(50)
				,	[PromoCodeDescription] NVARCHAR(500)
				,   [Content] NVARCHAR(100)
				,	[StartDate] DATETIME
				,	[EndDate] DATETIME
				,	[Status] NVARCHAR(50)
				,	[IsActive] BIT
				,	[CreatedDate] DATETIME
				,	[LastModifiedDate] DATETIME
				)

				CREATE TABLE #DuplicateSource (
					[SourceCode] NVARCHAR(50)
				)

				CREATE TABLE #CleanupSource (
					[RowID] INT
				,	[SourceCodeRowID] INT
				,	[SourceCodeID] NVARCHAR(18)
				,	[CampaignName] NVARCHAR(80)
				,	[CampaignType] NVARCHAR(50)
				,	[SourceCode] NVARCHAR(50)
				,	[DPNCode] NVARCHAR(50)
				,	[DWFCode] NVARCHAR(50)
				,	[DWCCode] NVARCHAR(50)
				,	[MPNCode] NVARCHAR(50)
				,	[MWFCode] NVARCHAR(50)
				,	[MWCCode] NVARCHAR(50)
				,	[Channel] NVARCHAR(50)
				,	[Type] NVARCHAR(50)
				,	[Gender] NVARCHAR(50)
				,	[Goal] NVARCHAR(50)
				,	[Media] NVARCHAR(50)
				,	[Location] NVARCHAR(50)
				,	[Language] NVARCHAR(50)
				,	[Format] NVARCHAR(50)
				,	[Creative] NVARCHAR(50)
				,	[Origin] NVARCHAR(50)
				,	[Number] NVARCHAR(50)
				,	[DNIS] NVARCHAR(50)
				,	[PromoCode] NVARCHAR(50)
				,	[PromoCodeDescription] NVARCHAR(500)
				,   [Content] NVARCHAR(100)
				,	[StartDate] DATETIME
				,	[EndDate] DATETIME
				,	[Status] NVARCHAR(50)
				,	[IsActive] BIT
				,	[CreatedDate] DATETIME
				,	[LastModifiedDate] DATETIME
				)


				INSERT  INTO #Campaign
						SELECT  c.Id
						,		c.SourceCode_L__c
						,		NULL AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	c.IsDeleted = 0

						UNION

						SELECT  c.Id
						,		c.DPNCode__c
						,		'Desktop Phone' AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	( c.DPNCode__c IS NOT NULL
									AND c.DPNCode__c <> c.SourceCode_L__c )
								AND c.IsDeleted = 0

						UNION

						SELECT  c.Id
						,		c.DWFCode__c
						,		'Desktop Form' AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	c.DWFCode__c IS NOT NULL
								AND c.IsDeleted = 0

						UNION

						SELECT  c.Id
						,		c.DWCCode__c
						,		'Desktop Chat' AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	c.DWCCode__c IS NOT NULL
								AND c.IsDeleted = 0

						UNION

						SELECT  c.Id
						,		c.MPNCode__c
						,		'Mobile Phone' AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	c.MPNCode__c IS NOT NULL
								AND c.IsDeleted = 0

						UNION

						SELECT  c.Id
						,		c.MWFCode__c
						,		'Mobile Form' AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	c.MWFCode__c IS NOT NULL
								AND c.IsDeleted = 0

						UNION

						SELECT  c.Id
						,		c.MWCCode__c
						,		'Mobile Chat' AS 'Creative'
						FROM    SQL06.HC_BI_SFDC.dbo.Campaign c
						WHERE	c.MWCCode__c IS NOT NULL
								AND c.IsDeleted = 0


				INSERT	INTO #SourceCode
						SELECT  c.SourceCodeID
						,		(SELECT Name FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignName'
						,		(SELECT CampaignType__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignType'
						,		c.SourceCode
						,		(SELECT DPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DPNCode'
						,		(SELECT DWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWFCode'
						,		(SELECT DWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWCCode'
						,		(SELECT MPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MPNCode'
						,		(SELECT MWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWFCode'
						,		(SELECT MWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWCCode'
						,		(SELECT Channel__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Channel'
						,		(SELECT Type FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Type'
						,		(SELECT Gender__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Gender'
						,		(SELECT Goal__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Goal'
						,		(SELECT Media__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Media'
						,		(SELECT Location__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Location'
						,		(SELECT Language__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Language'
						,		(SELECT Format__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Format'
						,		c.Creative
						,		(SELECT Source__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Origin'
						,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN '(' + LEFT(TollFreeMobileName__c, 3) + ') ' + SUBSTRING(TollFreeMobileName__c, 4, 3) + '-' + SUBSTRING(TollFreeMobileName__c, 7, 4) ELSE CASE WHEN c.SourceCode = DPNCode__c THEN '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) ELSE '' END END ELSE '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'Number'
						,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN DNISMobile__c ELSE CASE WHEN c.SourceCode = DPNCode__c THEN DNIS__c ELSE '' END END ELSE DNIS__c END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'DNIS'
						,		(SELECT PromoCodeName__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCode'
						,		(SELECT PromoCodeDisplay__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCodeDescription'
						,		(SELECT Level05Creative_L__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Content'
						,		(SELECT StartDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'StartDate'
						,		(SELECT EndDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'EndDate'
						,		(SELECT Status FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Status'
						,		(SELECT IsActive FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'IsActive'
						,		(SELECT CreatedDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CreatedDate'
						,		(SELECT LastModifiedDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'LastModifiedDate'
						FROM    #Campaign c
						ORDER BY c.SourceCodeID
						,		c.SourceCode


				-- Get Duplicate Source Codes
				INSERT	INTO #DuplicateSource
						SELECT  sc.SourceCode
						FROM    #SourceCode sc
						GROUP BY sc.SourceCode
						HAVING  COUNT(*) > 1


				-- Remove Inactive Duplicate Source Codes
				INSERT	INTO #CleanupSource
						SELECT  ROW_NUMBER() OVER ( PARTITION BY sc.SourceCode ORDER BY sc.IsActive DESC, sc.DPNCode DESC, sc.DWFCode DESC, sc.DWCCode DESC, sc.MPNCode DESC, sc.MWFCode DESC, sc.MWCCode DESC, sc.Number DESC, sc.StartDate DESC, sc.EndDate DESC, sc.CreatedDate ASC ) AS 'RowID'
						,		sc.RowID
						,		sc.SourceCodeID
						,		sc.CampaignName
						,		sc.CampaignType
						,		sc.SourceCode
						,		sc.DPNCode
						,		sc.DWFCode
						,		sc.DWCCode
						,		sc.MPNCode
						,		sc.MWFCode
						,		sc.MWCCode
						,		sc.Channel
						,		sc.Type
						,		sc.Gender
						,		sc.Goal
						,		sc.Media
						,		sc.Location
						,		sc.Language
						,		sc.Format
						,		sc.Creative
						,		sc.Origin
						,		sc.Number
						,		sc.DNIS
						,		sc.PromoCode
						,		sc.PromoCodeDescription
						,       sc.Content
						,		sc.StartDate
						,		sc.EndDate
						,		sc.Status
						,		sc.IsActive
						,		sc.CreatedDate
						,		sc.LastModifiedDate
						FROM    #SourceCode sc
								INNER JOIN #DuplicateSource ds
									ON ds.SourceCode = sc.SourceCode
						ORDER BY sc.SourceCode


				-- Cleanup Duplicates
				DELETE  sc
				FROM    #SourceCode sc
						CROSS APPLY ( SELECT    *
									  FROM      #CleanupSource cs
									  WHERE     cs.SourceCodeID = sc.SourceCodeID
												AND cs.SourceCode = sc.SourceCode
												AND cs.RowID <> 1
												AND cs.Status = 'Merged'
									) x_Cs


				DELETE  sc
				FROM    #SourceCode sc
						CROSS APPLY ( SELECT    *
									  FROM      #CleanupSource cs
									  WHERE     cs.SourceCodeID = sc.SourceCodeID
												AND cs.SourceCode = sc.SourceCode
												AND cs.RowID <> 1
												AND cs.Status = 'Completed'
									) x_Cs


				-- Insert Source Codes
				INSERT	INTO [bi_mktg_stage].[DimSource] (
						  [DataPkgKey]
						, [SourceKey]
						, [SourceSSID]
						, [SourceName]
						, [Media]
						, [Level02Location]
						, [Level03Language]
						, [Level04Format]
						, [Level05Creative]
						, [Origin]
						, [Number]
						, [NumberType]
						, [Channel]
						, [CampaignName]
						, [Gender]
						, [PromoCode]
						, [OwnerType]
						, [Content]
						, [ModifiedDate]
						, [IsNew]
						, [IsType1]
						, [IsType2]
						, [IsException]
						, [IsInferredMember]
						, [IsDelete]
						, [IsDuplicate]
						, [SourceSystemKey]
						)
						SELECT  @DataPkgKey
						,		NULL AS [SourceKey]
						,		sc.SourceCode
						,       sc.SourceCode
						,       ISNULL(sc.Media, '') AS 'Media'
						,       ISNULL(sc.Location, '') AS 'Location'
						,       ISNULL(sc.Language, '') AS 'Language'
						,       ISNULL(sc.Format, '') AS 'Format'
						,       ISNULL(sc.Creative, '') AS 'Creative'
						,		ISNULL(sc.Origin, '') AS 'Origin'
						,       ISNULL(sc.Number, '') AS 'Number'
						,       '' AS NumberType
						,       ISNULL(sc.Channel, '') AS 'Channel'
						,		ISNULL(sc.CampaignName, '') AS 'CampaignName'
						,       ISNULL(sc.Gender, '') AS 'Gender'
						,       ISNULL(sc.PromoCode, '') AS 'PromoCode'
						,		ISNULL(sc.Type, '') AS 'OwnerType'
						,       ISNULL(sc.Content,'') AS 'Content'
						,		GETDATE()
						,		0 AS [IsNew]
						,		0 AS [IsType1]
						,		0 AS [IsType2]
						,		0 AS [IsException]
						,		0 AS [IsInferredMember]
						,		0 AS [IsDelete]
						,		0 AS [IsDuplicate]
						,		sc.SourceCode AS [SourceSystemKey]
						FROM    #SourceCode sc


				SET @ExtractRowCnt = @@ROWCOUNT

				-- Set the Last Successful Extraction Time & Status
                UPDATE  bief_stage._DataFlow
                SET     LSET = @CET
                ,       Status = 'Extraction Completed'
                WHERE   TableName = @TableName
		END


		-- Data pkg auditing
		EXEC @return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt


		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF


		-- Cleanup temp tables


		-- Return success
		RETURN 0
	END TRY
    BEGIN CATCH
		-- Save original error number
		SET @intError = ERROR_NUMBER();


		-- Log the error
		EXECUTE [bief_stage].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;


		-- Re Raise the error
		EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList;


		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF


		-- Cleanup temp tables


		-- Return the error number
		RETURN @intError;
    END CATCH

END
GO
