/* CreateDate: 05/03/2010 12:27:06.097 , ModifyDate: 03/22/2021 13:53:01.590 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_LASS]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_LASS] is used to determine
-- the LASS
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_LASS] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			06/04/2015  KMurdoch     Added logic to Exclude INVALID from Lead Count
--			10/19/2016  RHut		 Added logic to calculate SHOWDIFF and SALEDIFF; Moved WHERE filter for ('LEAD','CLIENT') to sub-select
--			11/29/2017	KMurdoch	 Added logic to change Leads count to 0 if status is not Lead, Client
--			08/06/2019  KMurdoch     Made SFDC Primary
--			09/08/2020  KMurdoch	 Addded , 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' as valid Lead Statuses
--			09/09/2020  KMurdoch     Added check on first name or last name
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
--			10/01/2020  kMurdoch     Added new validation logic
--			10/02/2020  KMurdoch     Added new function logic rather than
--			10/20/2020  KMurdoch     Removed validation logic from 9/8 - It is redundant
--			12/15/2020  KMurdoch     Added Lead Creation Date/Time Key; Source & Promo Key to FactActivityResults
--			03/20/2021  KMurdoch     Added logic to handle Lead Activity Status = Invalid
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

	DECLARE		@TableName			varchar(150)	-- Name of table
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		-------------------------------
		---------- Update Leads, Appointments, Shows, Sales BASED ON SFDC_LeadID
		-------------------------------
		--UPDATE STG SET
		--			[Leads] = COALESCE(DW.[Leads],1)
		--       ,	[Appointments] = COALESCE(DW.[Appointments],0)
		--       ,	[Shows] = COALESCE(DW.[Shows],0)
		--       ,	[Sales] = COALESCE(DW.[Sales],0)
		--       ,	[Activities] = COALESCE(DW.[Activities],0)
		--       ,	[NoShows] = COALESCE(DW.[NoShows],0)
		--       ,	[NoSales] = COALESCE(DW.[NoSales],0)
		--	   ,	[SHOWDIFF] = DATEDIFF(DAY,[LeadCreationDateSSID],DW.[MinShowDueDate])
		--	   ,	[SALEDIFF] = DATEDIFF(DAY,[LeadCreationDateSSID],DW.[MinSaleDueDate])

		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN
		--	(SELECT a.SFDC_LeadID
		--		 ,  1 AS [Leads]
		--		 ,	SUM(IsAppointment) AS [Appointments]
		--		 ,	SUM(IsShow) AS [Shows]
		--		 ,	SUM(IsSale) AS [Sales]
		--		 ,  COUNT(*) AS [Activities]
		--		 ,	SUM(IsNoShow) AS [NoShows]
		--		 ,	SUM(IsNoSale) AS [NoSales]
		--		 ,	MIN(CASE WHEN IsShow = 1 THEN ActivityDueDate ELSE NULL END) AS [MinShowDueDate]
		--		 ,	MIN(CASE WHEN IsSale = 1 THEN ActivityDueDate ELSE NULL END) AS [MinSaleDueDate]

		--	FROM [bi_mktg_stage].[synHC_DDS_DimActivity] a WITH(NOLOCK)
		--	INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] AS DC
		--		ON a.SFDC_LeadID = DC.SFDC_LeadID
		--	WHERE DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') --Only capture metrics for these statuses
		--	GROUP BY a.SFDC_LeadID
		--	 ) AS DW
		--		ON STG.SFDC_LeadID=DW.SFDC_LeadID
		--WHERE STG.[DataPkgKey] = @DataPkgKey


		/* Update FactLead based on SFDC_LeadID */
		UPDATE	stg
		SET		stg.[Leads] = COALESCE(dw.[Leads],1)
		,		stg.[Appointments] = COALESCE(dw.[Appointments],0)
		,		stg.[Shows] = COALESCE(dw.[Shows],0)
		,		stg.[Sales] = COALESCE(dw.[Sales],0)
		,		stg.[Activities] = COALESCE(dw.[Activities],0)
		,		stg.[NoShows] = COALESCE(dw.[NoShows],0)
		,		stg.[NoSales] = COALESCE(dw.[NoSales],0)
		,		stg.[SHOWDIFF] = DATEDIFF(DAY,stg.[LeadCreationDateSSID],dw.[MinShowDueDate])
		,		stg.[SALEDIFF] = DATEDIFF(DAY,stg.[LeadCreationDateSSID],dw.[MinSaleDueDate])
		FROM	bi_mktg_stage.FactLead stg
				OUTER APPLY (
					SELECT	c.ContactKey
					,		c.SFDC_LeadID
					,		c.SFDC_PersonAccountID
					,		1 AS 'Leads'
					,		SUM(a.IsAppointment) AS 'Appointments'
					,		SUM(a.IsShow) AS 'Shows'
					,		SUM(a.IsSale) AS 'Sales'
					,		COUNT(*) AS 'Activities'
					,		SUM(a.IsNoShow) AS 'NoShows'
					,		SUM(a.IsNoSale) AS 'NoSales'
					,		MIN(CASE WHEN a.IsShow = 1 THEN a.ActivityDueDate ELSE NULL END) AS 'MinShowDueDate'
					,		MIN(CASE WHEN a.IsSale = 1 THEN a.ActivityDueDate ELSE NULL END) AS 'MinSaleDueDate'
					FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity a
							INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
								ON c.SFDC_LeadID = a.SFDC_LeadID
					WHERE	c.ContactStatusSSID IN ( 'LEAD', 'CLIENT', 'HWLEAD', 'HWCLIENT', 'EVENT', 'PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
							AND c.[Lead_Activity_status__c] NOT IN ('INVALID')
							AND c.SFDC_LeadID IS NOT NULL
							AND c.SFDC_LeadID = stg.SFDC_LeadID
					GROUP BY c.ContactKey
					,		c.SFDC_LeadID
					,		c.SFDC_PersonAccountID
				) dw
		WHERE	stg.DataPkgKey = @DataPkgKey
		OPTION (RECOMPILE);


		-----------------------
		-- Validate the leads based on valid name, email & phone using new function
		-----------------------

		UPDATE fl
		SET Leads = 0,
			InvalidLead = 1
		FROM HC_BI_MKTG_STAGE.bi_mktg_stage.FactLead fl
			OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(Fl.SFDC_LeadID) fil
		WHERE isnull(fil.isinvalidlead,0) = 1


		-----------------------
		-- Update Lead Creation Date/Time, Source & Promo on Fact Activity Results
		-----------------------

		UPDATE far
		SET far.LeadCreationDateKey = fl.LeadCreationDateKey,
			far.LeadCreationTimeKey = fl.LeadCreationTimeKey,
			far.LeadSourceKey = fl.SourceKey,
			far.PromoCodeKey = fl.PromotionCodeKey
		FROM HC_BI_MKTG_STAGE.bi_mktg_stage.FactActivityResults far
		INNER JOIN HC_BI_MKTG_STAGE.bi_mktg_stage.FactLead fl
			ON far.ContactKey = fl.ContactKey
		WHERE fl.ContactKey IS NOT NULL AND fl.ContactKey <> -1



		-----------------------
		-- Exception if ContactStatusSSID not Lead,Client --ADD Lead_activity_Status__c
		-----------------------
		UPDATE STG SET
		     Leads = 0
		FROM [bi_mktg_stage].[FactLead] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] AS DC
				ON STG.SFDC_LeadID = DC.SFDC_LeadID
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (DC.ContactStatusSSID NOT IN ('LEAD', 'CLIENT', 'HWLEAD', 'HWCLIENT', 'EVENT', 'PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION')
			OR DC.[Lead_Activity_status__c] IN ('INVALID'))
		OPTION (RECOMPILE);

		----------------------
		-- Reset Invalid to 0 if lead is valid
		-----------------------

		UPDATE fl
		SET fl.InvalidLead = 0
		FROM HC_BI_MKTG_STAGE.bi_mktg_stage.FactLead fl
			OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(Fl.SFDC_LeadID) fil
		WHERE isnull(fil.isinvalidlead,0) = 0


		-----------------------
		-- Exception if [SalesTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[Leads] IS NULL
				OR STG.[Appointments] IS NULL
				OR STG.[Shows] IS NULL
				OR STG.[Sales] IS NULL
				)
		OPTION (RECOMPILE);


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
