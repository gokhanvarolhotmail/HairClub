/* CreateDate: 09/03/2021 09:37:08.300 , ModifyDate: 09/03/2021 09:37:08.300 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimSource]
AS
-------------------------------------------------------------------------
-- [vwDimSource] is used to retrieve a
-- list of Source
--
--   SELECT * FROM [bi_mktg_dds].[vwDimSource]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			04/18/2018  KMurdoch	 Changed derivation of Channel to be from SFDC - Added campaignName, Promo, Gender
--			10/01/2019  DLeiba		 Added OwnerType to view
--			11/05/2019  KMurdoch     Added new case logic for DeviceType
--			07/27/2020  KMurdoch	 Added Origin
--			01/29/2021  KMurdoch     Added Budget Name
-------------------------------------------------------------------------

SELECT	[SourceKey]
,		[SourceSSID]
,		CASE WHEN ISNULL(SourceName, '') = '' THEN 'Unknown' ELSE SourceName END AS 'SourceName'
,		CASE WHEN ISNULL(media, '') = '' THEN 'Unknown' ELSE Media END AS 'Media'
,		CASE WHEN ISNULL(Level02Location, '') = '' THEN 'Unknown' ELSE Level02Location END AS 'Level02Location'
,		CASE WHEN ISNULL(Level03Language, '') = '' THEN 'Unknown' ELSE Level03Language END AS 'Level03Language'
,		CASE WHEN ISNULL(Level04Format, '') = '' THEN 'Unknown' ELSE Level04Format END AS 'Level04Format'
,		CASE WHEN ISNULL(Level05Creative, '') = '' THEN 'Unknown' ELSE Level05Creative END AS 'Level05Creative'
,		[Number]
,		[NumberType]
,		CONVERT(NVARCHAR(50),ISNULL([Channel], 'Unknown')) AS 'Channel'
,		CASE WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Call%Center%' THEN 'Various'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Print%Billboard%' THEN 'Various'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Print%Brochure%' THEN 'Direct Mail'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Print%Direct%Mail%' THEN 'Direct Mail'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Radio%' THEN 'Radio'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Television%' THEN 'TV'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) = 'Web Banner Ad' THEN 'Display'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) = 'Web Database Email' THEN 'Database Email'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) = 'Web Email' THEN 'Acquisition Email'
				WHEN [Media] = '' THEN 'Unknown'
				ELSE 'Various'
		END AS 'Type'
,		CASE WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Call%Center%' THEN 'Various'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Print%Billboard%' THEN 'Various'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Print%Direct%Mail%' THEN 'Direct Mail'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Print%Brochure%' THEN 'Brochure'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Radio%30%' THEN 'SF'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Radio%60%' THEN 'SF'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) LIKE 'Television%28%30%' THEN 'LF'
				WHEN (Media LIKE 'Television' AND [Level04Format] NOT LIKE '28:30') THEN 'SF'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) = 'Web Database Email' THEN 'Database Email'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) = 'Web Banner Ad' THEN 'Banner Ad'
				WHEN [Media] +  (CASE WHEN ISNULL([Level04Format], '') = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) = 'Web Email' THEN 'Email'
				WHEN [Media] = '' THEN 'Unknown'
				ELSE 'Various'
		END AS 'Subtype'
,		CASE WHEN RIGHT(SourceSSID,2) = 'MP' THEN 'Phone-Mobile'
				WHEN RIGHT(SourceSSID,2) = 'DP' THEN 'Phone-Desktop'
				WHEN RIGHT(SourceSSID,2) = 'MC' THEN 'Chat-Mobile'
				WHEN RIGHT(SourceSSID,2) = 'DC' THEN 'Chat-Desktop'
				WHEN RIGHT(SourceSSID,2) = 'MF' THEN 'Form-Mobile'
				WHEN RIGHT(SourceSSID,2) = 'DF' THEN 'Form-Desktop'
				WHEN RIGHT(SourceSSID,1) = '-' AND LEFT(SourceSSID,1) = 'M' THEN 'Form-Mobile'
				WHEN RIGHT(SourceSSID,1) = '-' AND LEFT(SourceSSID,1) <> 'M' THEN 'Form-Desktop'
				WHEN LEFT(SourceSSID,1) = 'M' THEN 'Phone-Mobile'
				WHEN LEFT(SourceSSID,1) <> 'M' THEN 'Phone-Desktop'
				ELSE 'Not Applicable'
		END AS 'DeviceType'
,		ISNULL([CampaignName], 'Unknown') AS 'CampaignName'
,		ISNULL([Gender], 'Unknown') AS 'Gender'
,		ISNULL([Origin], 'Unknown') AS 'Origin'
,		ISNULL(PromoCode, 'Unknown') AS 'PromoCode'
,		ISNULL([OwnerType],'Unknown') AS 'OwnerType'
--,		ISNULL(REPLACE([Content],'','Unknown'), 'Unknown') AS 'Content'
,		CASE WHEN [Content] IS NULL THEN 'Unknown'
			WHEN [Content] = '' THEN 'Unknown'
			ELSE [Content] END AS 'Content'
,		CASE WHEN (Level02Location LIKE '%BARTH%' OR Level02Location LIKE '%LOCAL US%') THEN 'Barth'
			WHEN (Level02Location LIKE '%CANADA%' OR Level02Location LIKE '%NATIONAL CA%' OR Level02Location LIKE '%LOCAL CA%') THEN 'Canada'
			WHEN (Level02Location LIKE '%USA%' OR Level02Location LIKE '%NATIONAL US%') THEN 'United States'
			WHEN (Level02Location LIKE '%ECOMMERCE%') THEN 'Ecommerce'
			WHEN (Level02Location LIKE '%HANS%') THEN 'Hans'
			WHEN (Level02Location LIKE '%PUERTO RICO%') THEN 'Puerto Rico'
			ELSE
            'Unknown' END AS 'BudgetName'
,		[RowIsCurrent]
,		[RowStartDate]
,		[RowEndDate]
FROM	[bi_mktg_dds].[DimSource]
GO
