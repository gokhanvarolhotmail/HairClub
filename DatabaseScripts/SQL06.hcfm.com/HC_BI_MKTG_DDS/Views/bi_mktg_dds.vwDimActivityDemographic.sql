CREATE VIEW [bi_mktg_dds].[vwDimActivityDemographic]
AS
-------------------------------------------------------------------------
-- [vwDimActivityDemographic] is used to retrieve a
-- list of ActivityDemographic
--
--   SELECT * FROM [bi_mktg_dds].[vwDimActivityDemographic]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Removed Activity & Contact SSID
--			12/16/2020	KMurdoch	 Added LeadSource aka CommunicationMethod
-------------------------------------------------------------------------

		SELECT [ActivityDemographicKey]
			  ,[ActivityDemographicSSID]
			  --,[ActivitySSID]
			  --,[ContactSSID]
			  ,[GenderSSID]
			  ,[GenderDescription]
			  ,[EthnicitySSID]
			  ,[EthnicityDescription]
			  ,[OccupationSSID]
			  ,[OccupationDescription]
			  ,[MaritalStatusSSID]
			  ,[MaritalStatusDescription]
			  ,[Birthday]
			  ,[Age]
			  ,[AgeRangeSSID]
			  ,[AgeRangeDescription]
			  ,[HairLossTypeSSID]
			  ,[HairLossTypeDescription]
			  ,[NorwoodSSID]
			  ,[LudwigSSID]
			  ,[Performer]
			  ,RTRIM(STUFF(Performer,CHARINDEX('-',Performer,0),LEN(Performer),'')) AS 'PerformerInitials'
			  ,[PriceQuoted]
			  ,[SolutionOffered]
			  ,[NoSaleReason]
			  ,[DateSaved]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
			  ,[SFDC_TaskID]
			  ,[SFDC_LeadID]
			  ,l.LeadSource AS 'CommunicationMethod'
	FROM [bi_mktg_dds].[DimActivityDemographic] dad
	LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
	ON dad.SFDC_LeadID = l.Id
