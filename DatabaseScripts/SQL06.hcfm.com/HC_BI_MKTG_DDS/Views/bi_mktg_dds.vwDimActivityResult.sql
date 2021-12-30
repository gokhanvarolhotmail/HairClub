/* CreateDate: 09/03/2021 09:37:07.873 , ModifyDate: 09/03/2021 09:37:07.873 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimActivityResult]
AS
-------------------------------------------------------------------------
-- [vwDimActivityResult] is used to retrieve a
-- list of ActivityResult
--
--   SELECT * FROM [bi_mktg_dds].[vwDimActivityResult]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Added SFDC Lead/Task ID;Removed Activity/Contact SSID
--			07/10/2020  KMurdoch     Added Accomodation
--			08/05/2020  KMurdoch     Added Promo Code
--			12/16/2020  KMurdoch	 Added LeadSource aka CommunicationMethod
--			02/03/2021  KMurdoch     Added Lead GCLID to DimActivityResults
-------------------------------------------------------------------------

		SELECT [ActivityResultKey]
			  ,[ActivityResultSSID]
			  ,[CenterSSID]
			  --,[DimActivityResult].[ActivitySSID]
			  --,[DimActivityResult].[ContactSSID]
			  ,[SalesTypeSSID]
			  ,[SalesTypeDescription]
			  ,[ActionCodeSSID]
			  ,[ActionCodeDescription]
			  ,[ResultCodeSSID]
			  ,[ResultCodeDescription]
			  ,[SourceSSID]
			  ,[SourceDescription]
			  ,[IsShow]
			  ,[IsSale]
			  ,[ContractNumber]
			  ,[ContractAmount]
			  ,[ClientNumber]
			  ,[InitialPayment]
			  ,[NumberOfGraphs]
			  ,[OrigApptDate]
			  ,[DimActivityResult].[DateSaved]
			  ,[RescheduledFlag]
			  ,[RescheduledDate]
			  ,[SurgeryOffered]
			  ,[ReferredToDoctor]
			  ,COALESCE([SolutionOffered],'N/A') AS 'SolutionOffered'
			  ,COALESCE([NoSaleReason],'N/A') AS NoSaleReason
			  ,[DimActivityResult].SFDC_TaskID
			  ,[DimActivityResult].SFDC_LeadID
			  ,[DimActivityResult].Accomodation
			  ,CASE WHEN [DimActivityResult].Accomodation LIKE 'Video%' THEN 'Virtual' ELSE 'InPerson' END AS 'ConsultationType'
			  --,ISNULL(l.Promo_Code_Legacy__c,'Unknown') AS 'PromoCode'
			  ,	CASE	WHEN l.LeadSource IS NULL AND U.Username = 'bosleyintegration@hairclub.com' THEN 'Other-Bos'
					WHEN l.LeadSource IS NULL AND U.Username = 'conectintegration@hcfm.com' THEN 'Other-HC'
					WHEN l.LeadSource IS NULL AND U.Username = 'hanswiemannintegration@hcfm.com' THEN 'Other-HW'
					WHEN l.LeadSource IS NULL AND U.Username = 'sfintegration@hcfm.com' THEN 'Other-Web'
					ELSE ISNULL(l.LeadSource,'Unknown') END AS 'CommunicationMethod'
			  ,l.GCLID__c AS 'LeadGCLID'
			  ,[DimActivityResult].[RowIsCurrent]
			  ,[DimActivityResult].[RowStartDate]
			  ,[DimActivityResult].[RowEndDate]
	FROM [bi_mktg_dds].[DimActivityResult]
		LEFT OUTER JOIN bi_mktg_dds.DimActivityDemographic
			ON DimActivityResult.SFDC_TaskID = DimActivityDemographic.SFDC_TaskID
		LEFT OUTER JOIN HC_BI_SFDC.dbo.[Lead] l
			ON bi_mktg_dds.DimActivityResult.SFDC_LeadID = l.id
		LEFT OUTER JOIN HC_BI_SFDC.dbo.[User] u
			ON u.id = l.CreatedById
GO
