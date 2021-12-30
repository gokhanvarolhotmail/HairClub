/* CreateDate: 05/03/2010 12:27:05.907 , ModifyDate: 08/06/2021 13:19:58.420 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Extract_CDC] is used to retrieve a
-- list FactLead
--
--   exec [bi_mktg_stage].[spHC_FactLead_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			02/04/2010				 Add SalesType and Promotion Code to extract
--			08/10/2011	KMurdoch	 Added AssignedEmployeKey
--          01/08/2012  EKnapp		 Do inner join to oncd_contact in derived FactLead extract from oncd_activity.
--			08/20/2014	KMurdoch	 Added index, changed synonym refs, changed some to inner join
--			08/20/2014  Kmurdoch	 Added CCF change related to contact completion
--			07/20/2020  KMurdocn     Fixed field length for SourceSSID
--			08/24/2020  KMurdoch     Added RecentSource Code to FactLead
--			09/24/2020  KMurdoch     Modified 2nd Extract Query to not insert duplicate leads
--			09/24/2020  KMurdoch     Changed selection for duplicate centers to move to new SSID
--			09/24/2020  KMurdoch     Removed the above logic
--			01/06/2021  KMurdoch     Modified Center extract to handle Bad Philadelphia data
--			02/17/2021  KMurdoch     Added to Center check; if still null assign to 100
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
				, @CDCTableName2			varchar(150)	-- Name of CDC table
				, @CDCTableName3			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int
				, @ExtractRowCnt1		int
				, @ExtractRowCnt2		int
				, @ExtractRowCnt3		int

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'
 	SET @CDCTableName = N'dbo_oncd_contact'
 	SET @CDCTableName2 = N'dbo_oncd_activity'
 	SET @CDCTableName3 = N'dbo_cstd_contact_completion'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Subtract 15 minutes to help ensure Dims have been loaded
		SET @CET = DATEADD(mi,-5,@CET)

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET


		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN
						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


				INSERT INTO [bi_mktg_stage].[FactLead]
						   (  [ContactSSID]
							, [SFDC_LeadID]
							, [ContactKey]
							, [LeadCreationDateKey]
							, [LeadCreationDateSSID]
							, [LeadCreationTimeKey]
							, [LeadCreationTimeSSID]
							, [CenterKey]
							, [CenterSSID]
							, [SourceKey]
							, [SourceSSID]
							, [DataPkgKey]

							,[PromotionCodeSSID]
							,[PromotionCodeKey]

							,[SalesTypeSSID]
							,[SalesTypeKey]

							, [GenderKey]
							, [GenderSSID]
							, [OccupationKey]
							, [OccupationSSID]
							, [EthnicityKey]
							, [EthnicitySSID]
							, [MaritalStatusKey]
							, [MaritalStatusSSID]
							, [HairLossTypeKey]
							, [HairLossTypeSSID]
							, [NorwoodSSID]
							, [LudwigSSID]
							, [AgeRangeKey]
							, [Age]
							, [AgeRangeSSID]
							, [EmployeeKey]
							, [EmployeeSSID]
							, [Leads]
							, [Appointments]
							, [Shows]
							, [Sales]
							, [Activities]
							, [NoShows]
							, [NoSales]
						    , [AssignedEmployeeKey]
							, [AssignedEmployeeSSID]
							, [RecentSourceSSID]
							, [RecentSourceKey]
							, [IsNew]
							, [IsUpdate]
							, [IsException]
							, [IsDelete]
							, [IsDuplicate]
							, [SourceSystemKey]
							)

					SELECT DISTINCT
								  CAST(ISNULL(LTRIM(RTRIM(l.ContactID__c)), '-2') AS VARCHAR(10)) AS 'ContactSSID'
					,			  l.Id AS 'SFDC_LeadID'
					,             0 AS 'ContactKey'
					,             d.DateKey AS 'LeadCreationDateKey'
					,             CAST(CONVERT(VARCHAR(11), ISNULL(l.ReportCreateDate__c,l.CreatedDate), 120) AS DATE) AS 'LeadCreationDateSSID'
					,             0 AS 'LeadCreationTimeKey'
					,             CAST(CONVERT(VARCHAR(5), ISNULL(l.ReportCreateDate__c,l.CreatedDate), 114) AS TIME) AS 'LeadCreationTimeSSID'
					,             0 AS 'CenterKey'
					,             CAST(ISNULL(CASE WHEN l.CenterNumber__c = '890' THEN '233' ELSE ISNULL(l.CenterNumber__c,100) END,
										CASE WHEN l.CenterID__c = '890' THEN '233' ELSE ISNULL(l.CenterID__c,100) END)	AS NVARCHAR(10)) AS 'CenterSSID'  --01/06/2021
					,             0 AS 'SourceKey'
					,             CAST(ISNULL(LTRIM(RTRIM(l.Source_Code_Legacy__c)), '-2') AS NVARCHAR(30)) AS 'SourceSSID'
					,             @DataPkgKey
					,             CAST(ISNULL(LTRIM(RTRIM(l.Promo_Code_Legacy__c)), '-2') AS NVARCHAR(10)) AS 'PromotionCodeSSID'
					,             0 AS 'PromotionCodeKey'
					,             '' AS 'SalesTypeSSID'
					,             0 AS 'SalesTypeKey'
					,             0 AS 'GenderKey'
					,             '' AS 'GenderSSID'
					,             0 AS 'OccupationKey'
					,             '' AS 'OccupationSSID'
					,             0 AS 'EthnicityKey'
					,             '' AS 'EthnicitySSID'
					,             0 AS 'MaritalStatusKey'
					,             '' AS 'MaritalStatusSSID'
					,             0 AS 'HairLossTypeKey'
					,             '-2' AS 'HairLossTypeSSID'
					,             '' AS 'NorwoodSSID'
					,             '' AS 'LudwigSSID'
					,             0 AS 'AgeRangeKey'
					,             NULL AS 'Age'
					,             '-2' AS 'AgeRangeSSID'
					,             0 AS 'EmployeeKey'
					,             CAST(ISNULL(LTRIM(RTRIM(u.UserCode__c)), '-2') AS VARCHAR(20)) AS 'EmployeeSSID' --LegacyField from OldCrm to SalesForce, field not being update.
					,             0 AS 'Leads'
					,             0 AS 'Appointments'
					,             0 AS 'Shows'
					,             0 AS 'Sales'
					,             0 AS 'Activities'
					,             0 AS 'NoShows'
					,             0 AS 'NoSales'
					,             0 AS 'AssignedEmployeeKey'
					,             CAST(ISNULL(LTRIM(RTRIM(u.UserCode__c)), '-2') AS VARCHAR(20)) AS 'AssignedEmployeeSSID' --LegacyField from OldCrm to SalesForce, field not being update.
					,			  ISNULL(l.RecentSourceCode__c,CAST(ISNULL(LTRIM(RTRIM(l.Source_Code_Legacy__c)), '-2') AS NVARCHAR(30))) AS 'RecentSourceSSID'
					,			  0 AS 'RecentSourceKey'
					,             0 AS 'IsNew'
					,             0 AS 'IsUpdate'
					,             0 AS 'IsException'
					,             0 AS 'IsDelete'
					,             0 AS 'IsDuplicate'
					,             CAST(ISNULL(LTRIM(RTRIM(l.id)), '') AS VARCHAR(18)) AS 'SourceSystemKey'
					FROM   SQL06.HC_BI_SFDC.dbo.Lead l WITH ( NOLOCK )
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
								ON d.FullDate = CAST(ISNULL(l.ReportCreateDate__c,l.CreatedDate) AS DATE)
								  LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u WITH ( NOLOCK )
										 ON u.Id = l.CreatedById
					WHERE  ( ISNULL(l.ReportCreateDate__c,l.CreatedDate) >= @LSET AND ISNULL(l.ReportCreateDate__c,l.CreatedDate) < @CET )
										 OR ( l.LastModifiedDate >= @LSET AND l.LastModifiedDate < @CET )
										 AND ISNULL(l.IsDeleted, 0) = 0


				SET @ExtractRowCnt1 = @@ROWCOUNT


					INSERT INTO [bi_mktg_stage].[FactLead]
					(
						[ContactSSID],
						[SFDC_LeadID],
						[ContactKey],
						[LeadCreationDateKey],
						[LeadCreationDateSSID],
						[LeadCreationTimeKey],
						[LeadCreationTimeSSID],
						[CenterKey],
						[CenterSSID],
						[SourceKey],
						[SourceSSID],
						[DataPkgKey],
						[PromotionCodeSSID],
						[PromotionCodeKey],
						[SalesTypeSSID],
						[SalesTypeKey],
						[GenderKey],
						[GenderSSID],
						[OccupationKey],
						[OccupationSSID],
						[EthnicityKey],
						[EthnicitySSID],
						[MaritalStatusKey],
						[MaritalStatusSSID],
						[HairLossTypeKey],
						[HairLossTypeSSID],
						[NorwoodSSID],
						[LudwigSSID],
						[AgeRangeKey],
						[Age],
						[AgeRangeSSID],
						[EmployeeKey],
						[EmployeeSSID],
						[Leads],
						[Appointments],
						[Shows],
						[Sales],
						[Activities],
						[NoShows],
						[NoSales],
						[AssignedEmployeeKey],
						[AssignedEmployeeSSID],
						[RecentSourceSSID],
						[RecentSourceKey],
						[IsNew],
						[IsUpdate],
						[IsDelete],
						[IsException],
						[SourceSystemKey]
					)
					SELECT DISTINCT
							CAST(ISNULL(LTRIM(RTRIM(l.ContactID__c)), '') AS VARCHAR(10)) AS 'ContactSSID',
							l.Id AS 'SFDC_LeadID',
							0 AS 'ContactKey',
							d.DateKey AS 'LeadCreationDateKey',
							CAST(CONVERT(VARCHAR(11), ISNULL(l.ReportCreateDate__c,l.CreatedDate), 120) AS DATE) AS 'LeadCreationDateSSID',
							0 AS 'LeadCreationTimeKey',
							CAST(CONVERT(VARCHAR(5), ISNULL(l.ReportCreateDate__c,l.CreatedDate), 114) AS TIME) AS 'LeadCreationTimeSSID',
							0 AS 'CenterKey',
				            CAST(ISNULL(CASE WHEN l.CenterNumber__c = '890' THEN '233' ELSE l.CenterNumber__c END,
										CASE WHEN l.CenterID__c = '890' THEN '233' ELSE l.CenterID__c END)	AS NVARCHAR(10)) AS 'CenterSSID',
							0 AS 'SourceKey',
							CAST(ISNULL(LTRIM(RTRIM(l.Source_Code_Legacy__c)), '-2') AS NVARCHAR(30)) AS 'SourceSSID',
							@datapkgkey,
							CAST(ISNULL(LTRIM(RTRIM(l.Promo_Code_Legacy__c)), '-2') AS NVARCHAR(10)) AS 'PromotionCodeSSID',
							0 AS 'PromotionCodeKey',
							'' AS 'SalesTypeSSID',
							0 AS 'SalesTypeKey',
							0 AS 'GenderKey',
							'' AS 'GenderSSID',
							0 AS 'OccupationKey',
							'' AS 'OccupationSSID',
							0 AS 'EthnicityKey',
							'' AS 'EthnicitySSID',
							0 AS 'MaritalStatusKey',
							'' AS 'MaritalStatusSSID',
							0 AS 'HairLossTypeKey',
							'-2' AS 'HairLossTypeSSID',
							'' AS 'NorwoodSSID',
							'' AS 'LudwigSSID',
							0 AS 'AgeRangeKey',
							NULL AS 'Age',
							'-2' AS 'AgeRangeSSID',
							0 AS 'EmployeeKey',
							CAST(ISNULL(LTRIM(RTRIM(u.UserCode__c)), '-2') AS VARCHAR(20)) AS 'EmployeeSSID',
							0 AS 'Leads',
							0 AS 'Appointments',
							0 AS 'Shows',
							0 AS 'Sales',
							0 AS 'Activities',
							0 AS 'NoShows',
							0 AS 'NoSales',
							0 AS 'AssignedEmployeeKey',
							CAST(ISNULL(LTRIM(RTRIM(u.UserCode__c)), '-2') AS VARCHAR(20)) AS 'AssignedEmployeeSSID',
							ISNULL(l.RecentSourceCode__c, CAST(ISNULL(LTRIM(RTRIM(l.Source_Code_Legacy__c)), '-2') AS NVARCHAR(30))) AS 'RecentSourceSSID',
							0 AS 'RecentSourceKey',
							0 AS 'IsNew',
							0 AS 'IsUpdate',
							0 AS 'IsDelete',
							0 AS 'IsException',
							CAST(ISNULL(LTRIM(RTRIM(l.Id)), '') AS VARCHAR(18)) AS 'SourceSystemKey'
					FROM SQL06.HC_BI_SFDC.dbo.Task t WITH (NOLOCK)
						INNER JOIN SQL06.HC_BI_SFDC.dbo.Lead l WITH (NOLOCK)
							ON l.Id = t.WhoId
						INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
							ON d.FullDate = CAST(ISNULL(l.ReportCreateDate__c,l.CreatedDate) AS DATE) --*
						LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u WITH (NOLOCK)
							ON u.Id = l.CreatedById
						LEFT OUTER JOIN HC_BI_MKTG_STAGE.bi_mktg_stage.FactLead fl
							ON (
									l.Id = fl.SFDC_LeadID
									AND fl.DataPkgKey = @datapkgkey
								)
					WHERE fl.SFDC_LeadID IS NULL
							AND
							(
								(
									t.ActivityDate >= @lset
									AND t.ActivityDate < @cet
								)
								OR
								(
									t.CreatedDate >= @lset
									AND t.CreatedDate < @cet
								)
								OR (
										t.LastModifiedDate >= @lset
										AND t.LastModifiedDate < @cet
									)
									AND
									(
										(
											(t.Action__c IN ( 'Appointment', 'In House', 'Be Back' ))
											AND
											(
												(t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'Void' )) --* NOT LOGIC KNOWLEDGE
												OR (t.Result__c IS NULL)
											)
										)
										OR
										(
											(t.Action__c IN ( 'Recovery' ))
											AND ((t.Result__c IS NOT NULL))
											AND (t.Result__c IN ( 'Show Sale', 'Show No Sale', 'No Show' )) --* Review Distict result in task to be sure of No_Show
										)
									)
							);

							--AND ISNULL(t.IsDeleted, 0) = 0


					SET @ExtractRowCnt2 = @@ROWCOUNT


					SET @ExtractRowCnt3 = 0


					SET @ExtractRowCnt = @ExtractRowCnt1 + @ExtractRowCnt2 + @ExtractRowCnt3


					-- Set the Last Successful Extraction Time & Status
					UPDATE [bief_stage].[_DataFlow]
						SET LSET = @CET
							, [Status] = 'Extraction Completed'
						WHERE [TableName] = @TableName
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
