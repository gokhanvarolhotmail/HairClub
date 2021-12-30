/* CreateDate: 05/03/2010 12:26:27.687 , ModifyDate: 08/05/2019 11:20:37.823 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DimActivityDemographic_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivityDemographic_Extract_CDC] is used to retrieve a
-- list ActivityDemographic
--
--   exec [bi_mktg_stage].[spHC_DimActivityDemographic_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			03/29/2013  KMurdoch	 Added DiscStyleSSID
--			11/21/2017  KMurdoch     Added SFDC_Lead/Task_ID
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

	DECLARE		  @TableName			varchar(150)	-- Name of table
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'
 	SET @CDCTableName = N'dbo_cstd_activity_demographic'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HCM].[sys].[fn_cdc_increment_lsn]([HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HCM].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HCM].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


						INSERT INTO [bi_mktg_stage].[DimActivityDemographic]
								   ( [DataPkgKey]
								   , [ActivityDemographicKey]
								   , [ActivityDemographicSSID]
								   , [ActivitySSID]
								   , [ContactSSID]
								   , [GenderSSID]
								   , [GenderDescription]
								   , [EthnicitySSID]
								   , [EthnicityDescription]
								   , [OccupationSSID]
								   , [OccupationDescription]
								   , [MaritalStatusSSID]
								   , [MaritalStatusDescription]
								   , [Birthday]
								   , [Age]
								   , [AgeRangeSSID]
								   , [AgeRangeDescription]
								   , [HairLossTypeSSID]
								   , [HairLossTypeDescription]
								   , [NorwoodSSID]
								   , [LudwigSSID]
								   , [Performer]
								   , [PriceQuoted]
								   , [SolutionOffered]
								   , [NoSaleReason]
								   , [DateSaved]
								   , [ModifiedDate]
								   , [DiscStyleSSID]
								   , [SFDC_LeadID]
								   , [SFDC_TaskID]
								   , [IsNew]
								   , [IsType1]
								   , [IsType2]
								   , [IsException]
								   , [IsInferredMember]
								   , [SourceSystemKey]
									, [IsDelete]
									, [IsDuplicate]
								   , [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [ActivityDemographicKey]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[activity_demographic_id])),'') AS varchar(10)) AS [ActivityDemographicSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[activity_id])),'') AS varchar(10)) AS [ActivitySSID]
								, CAST(ISNULL(LTRIM(RTRIM(oncd_activity_contact.contact_id)),'') AS varchar(10)) AS [ContactSSID]
								, CASE WHEN chg.gender = 'M' THEN 'M'
										WHEN chg.gender = 'F' THEN 'F'
										WHEN chg.gender = '?' THEN 'U'
										WHEN chg.gender = 'U' THEN 'U'
										ELSE '-2'
										END AS [GenderSSID]
								, CASE WHEN chg.gender = 'M' THEN 'Male'
										WHEN chg.gender = 'F' THEN 'Female'
										WHEN chg.gender = '?' THEN 'Unknown'
										WHEN chg.gender = 'U' THEN 'Unknown'
										ELSE ''
										END AS [GenderDescription]
								, CASE WHEN chg.ethnicity_code = 0 THEN '-2'
										ELSE CAST(ISNULL(LTRIM(RTRIM(chg.ethnicity_code)),'-2') AS varchar(10))
										END AS [EthnicitySSID]
								, CASE WHEN chg.ethnicity_code = 0 THEN ''
										ELSE CAST(ISNULL(LTRIM(RTRIM(csta_contact_ethnicity.[description])),'') AS varchar(50))
										END AS [EthnicityDescription]
								, CASE WHEN chg.occupation_code = 0 THEN '-2'
										ELSE CAST(ISNULL(LTRIM(RTRIM(chg.occupation_code)),'-2') AS varchar(10))
										END AS [OccupationSSID]
								, CASE WHEN chg.occupation_code = 0 THEN ''
										ELSE CAST(ISNULL(LTRIM(RTRIM(csta_contact_occupation.[description])),'') AS varchar(50))
										END AS [OccupationDescription]
								, CASE WHEN chg.maritalstatus_code = 0 THEN '-2'
										ELSE  CAST(ISNULL(LTRIM(RTRIM(chg.maritalstatus_code)),'-2') AS varchar(10))
										END AS [MaritalStatusSSID]
								, CASE WHEN chg.maritalstatus_code = 0 THEN ''
										ELSE CAST(ISNULL(LTRIM(RTRIM(csta_contact_maritalstatus.[description])),'') AS varchar(50))
										END AS [MaritalStatusDescription]


								, CAST(CONVERT (VARCHAR(11), chg.[Birthday],120 )as date) AS [Birthday]
								, COALESCE(chg.age,0) AS [Age]
								, '' AS [AgeRangeSSID]
								, '' AS [AgeRangeDescription]
								, '' AS [HairLossTypeSSID]
								, '' AS [HairLossTypeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[norwood])),'') AS varchar(50)) AS [NorwoodSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[ludwig])),'') AS varchar(50)) AS [LudwigSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[performer])),'') AS varchar(50)) AS [Performer]
								, COALESCE(chg.price_quoted,0) AS [PriceQuoted]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[solution_offered])),'') AS varchar(100)) AS [SolutionOffered]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[no_sale_reason])),'') AS varchar(200)) AS [NoSaleReason]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[updated_date])),'') AS date) AS [DateSaved]

								, [HCM].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Disc_Style])),'u') AS nvarchar(20)) AS [DiscStyleSSID]
								, oncd_contact.[cst_sfdc_lead_id]
								, oncd_activity.[cst_sfdc_task_id]

								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[activity_demographic_id])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HCM].[cdc].[fn_cdc_get_net_changes_dbo_cstd_activity_demographic](@From_LSN, @To_LSN, @row_filter_option) chg
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
								ON chg.activity_id  = oncd_activity_contact.activity_id
								AND oncd_activity_contact.primary_flag = 'Y'
						LEFT OUTER JOIN hcm.dbo.oncd_contact oncd_contact WITH (NOLOCK)
								ON oncd_activity_contact.contact_id = oncd_contact.contact_id
						INNER JOIN hcm.dbo.oncd_activity oncd_activity WITH (NOLOCK)
								ON oncd_activity.activity_id = chg.activity_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_csta_contact_occupation] AS csta_contact_occupation WITH (NOLOCK)
								ON chg.occupation_code  = csta_contact_occupation.occupation_code
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_csta_contact_ethnicity] AS csta_contact_ethnicity WITH (NOLOCK)
								ON chg.ethnicity_code = csta_contact_ethnicity.ethnicity_code
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_csta_contact_maritalstatus] AS csta_contact_maritalstatus WITH (NOLOCK)
								ON chg.maritalstatus_code = csta_contact_maritalstatus.maritalstatus_code

						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
		END

		IF (@ExtractRowCnt IS NULL) SET @ExtractRowCnt = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt

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
