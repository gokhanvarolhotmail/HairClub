/* CreateDate: 03/16/2016 15:34:34.260 , ModifyDate: 04/29/2016 11:53:09.793 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwChannelTypeSubtype
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	[HC_BI_MKTG_DDS]
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			03/16/2016
------------------------------------------------------------------------
NOTES: This view is being used for Advertising reports
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [bi_mktg_dds].[vwChannelTypeSubtype] ORDER BY MediaFormat

SELECT * FROM [bi_mktg_dds].[vwChannelTypeSubtype] ORDER BY SourceKey
***********************************************************************/
CREATE VIEW [bi_mktg_dds].[vwChannelTypeSubtype]
AS


SELECT q.Media
,	q.[Format]
,	q.MediaFormat
,	CASE WHEN MediaFormat LIKE 'Call%Center%' THEN 4 --'Miscellaneous'
		WHEN MediaFormat LIKE 'Print%' THEN 5 --'Print'
		WHEN MediaFormat LIKE 'Public%' THEN 4 --'Miscellaneous'
		WHEN MediaFormat LIKE 'Radio%' THEN 1 --'Broadcast'
		WHEN MediaFormat LIKE 'Referrals%' THEN 4 --'Miscellaneous'
		WHEN MediaFormat LIKE 'Sweepstakes%' THEN 4 --'Miscellaneous'
		WHEN MediaFormat LIKE 'Television%' THEN 1 --'Broadcast'
		WHEN MediaFormat LIKE 'Unknown%' THEN 4 --'Miscellaneous'
		WHEN MediaFormat LIKE 'Walk%In%' THEN 4 --'Miscellaneous'
		WHEN (MediaFormat LIKE 'Web%' AND MediaFormat NOT LIKE '%Email%') THEN 3 --'Digital'
		WHEN MediaFormat LIKE 'Web%Email%' THEN 2 --'Database'
	END AS 'ChannelID'
,	CASE WHEN MediaFormat LIKE 'Call%Center%' THEN 'Miscellaneous'
		WHEN MediaFormat LIKE 'Print%' THEN 'Print'
		WHEN MediaFormat LIKE 'Public%' THEN 'Miscellaneous'
		WHEN MediaFormat LIKE 'Radio%' THEN 'Broadcast'
		WHEN MediaFormat LIKE 'Referrals%' THEN 'Miscellaneous'
		WHEN MediaFormat LIKE 'Sweepstakes%' THEN 'Miscellaneous'
		WHEN MediaFormat LIKE 'Television%' THEN 'Broadcast'
		WHEN MediaFormat LIKE 'Unknown%' THEN 'Miscellaneous'
		WHEN MediaFormat LIKE 'Walk%In%' THEN 'Miscellaneous'
		WHEN (MediaFormat LIKE 'Web%' AND MediaFormat NOT LIKE '%Email%') THEN 'Digital'
		WHEN MediaFormat LIKE 'Web%Email%' THEN 'Database'
	END AS 'Channel'
,	CASE WHEN MediaFormat LIKE 'Call%Center%' THEN 1 --'Various'
		WHEN MediaFormat LIKE 'Print%Billboard%' THEN 1 --'Various'
		WHEN MediaFormat LIKE 'Print%Brochure%' THEN 2--'Direct Mail'
		WHEN MediaFormat LIKE 'Print%Direct%Mail%' THEN 2--'Direct Mail'
		WHEN MediaFormat LIKE 'Radio%' THEN 3 --'Radio'
		WHEN MediaFormat LIKE 'Television%' THEN 4 --'TV'
		WHEN MediaFormat = 'Web Banner Ad' THEN 5 --'Display'
		WHEN MediaFormat = 'Web Database Email' THEN 6 --'Database Email'
		WHEN MediaFormat = 'Web Email' THEN 7 --'Acquisition Email'
		ELSE 1 --'Various'
	END AS 'TypeID'
,	CASE WHEN MediaFormat LIKE 'Call%Center%' THEN 'Various'
		WHEN MediaFormat LIKE 'Print%Billboard%' THEN 'Various'
		WHEN MediaFormat LIKE 'Print%Brochure%' THEN 'Direct Mail'
		WHEN MediaFormat LIKE 'Print%Direct%Mail%' THEN 'Direct Mail'
		WHEN MediaFormat LIKE 'Radio%' THEN 'Radio'
		WHEN MediaFormat LIKE 'Television%' THEN 'TV'
		WHEN MediaFormat = 'Web Banner Ad' THEN 'Display'
		WHEN MediaFormat = 'Web Database Email' THEN 'Database Email'
		WHEN MediaFormat = 'Web Email' THEN 'Acquisition Email'
		ELSE 'Various'
	END AS 'Type'
,	CASE WHEN MediaFormat LIKE 'Call%Center%' THEN 1 --'Various'
		WHEN MediaFormat LIKE 'Print%Billboard%' THEN 1 --'Various'
		WHEN MediaFormat LIKE 'Print%Direct%Mail%' THEN 2 --'Direct Mail'
		WHEN MediaFormat LIKE 'Print%Brochure%' THEN 3 --'Brochure'
		WHEN MediaFormat LIKE 'Radio%30%' THEN 4 --'SF'
		WHEN MediaFormat LIKE 'Radio%60%' THEN 4 --'SF'
		WHEN MediaFormat LIKE 'Television%28%30%' THEN 5 --'LF'
		WHEN (Media LIKE 'Television' AND [Format] NOT LIKE '28:30') THEN 4 --'SF'
		WHEN MediaFormat = 'Web Database Email' THEN 6 --'Database Email'
		WHEN MediaFormat = 'Web Banner Ad' THEN 7 --'Banner Ad'
		WHEN MediaFormat = 'Web Email' THEN 8 --'Email'
		ELSE 1 --'Various'
	END AS 'SubtypeID'
,	CASE WHEN MediaFormat LIKE 'Call%Center%' THEN 'Various'
		WHEN MediaFormat LIKE 'Print%Billboard%' THEN 'Various'
		WHEN MediaFormat LIKE 'Print%Direct%Mail%' THEN 'Direct Mail'
		WHEN MediaFormat LIKE 'Print%Brochure%' THEN 'Brochure'
		WHEN MediaFormat LIKE 'Radio%30%' THEN 'SF'
		WHEN MediaFormat LIKE 'Radio%60%' THEN 'SF'
		WHEN MediaFormat LIKE 'Television%28%30%' THEN 'LF'
		WHEN (Media LIKE 'Television' AND [Format] NOT LIKE '28:30') THEN 'SF'
		WHEN MediaFormat = 'Web Database Email' THEN 'Database Email'
		WHEN MediaFormat = 'Web Banner Ad' THEN 'Banner Ad'
		WHEN MediaFormat = 'Web Email' THEN 'Email'
		ELSE 'Various'
	END AS 'Subtype'
,	SourceKey

FROM
	(SELECT [Media]
	,	[Level04Format] AS 'Format'
	,	[Media]
		+  (CASE WHEN [Level04Format] = '' THEN '' ELSE ' (' + [Level04Format] + ')' END) AS 'MediaFormat'
	,	SourceKey
	FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimSource]
	WHERE (Media <> '')
	GROUP BY Media
	,	Level04Format
	,	SourceKey
	)q
GO
