/* CreateDate: 08/08/2012 15:42:41.117 , ModifyDate: 08/08/2012 15:43:10.377 */
GO
/***********************************************************************

PROCEDURE:		spsvc_IMSSourceExport_ONCV

VERSION:		v1.0

DESTINATION SERVER:	HCWH1\SQL2005

DESTINATION DATABASE: 	WAREHOUSE

AUTHOR: 		Marlon Burrell

IMPLEMENTOR: 		Marlon Burrell

DATE IMPLEMENTED: 	9/11/2009

LAST REVISION DATE: 9/11/2009

------------------------------------------------------------------------
NOTES: 		Exports Sources with associated 1800 numbers
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_IMSSourceExport_ONCV

***********************************************************************/

create PROCEDURE [dbo].[spsvc_MediaSourceExport_ONCV]
AS
    BEGIN

	SELECT MediaSourceSources.SourceID
	,	MediaSourceSources.SourceCode
	,	MediaSourceSources.SourceName
	,	REPLACE(MediaSourceSources.[Description], char(13)+char(10), ' ') AS 'Description'
	,	MediaSourceTollFreeNumbers.Number
	,	MediaSourceNumberTypes.NumberType
	,	MediaSourceMediaTypes.Media
	,	MediaSourceLevel02.Level02Location AS 'Location'
	,	MediaSourceLevel03.Level03Language AS 'Language'
	,	MediaSourceLevel04.Level04Format AS 'Format'
	,	MediasourceLevel05.Level05Creative AS 'Creative'
	,	dbo.DateOnly(MediaSourceSources.StartDate) as 'StartDate'
	,	dbo.DateOnly(MediaSourceSources.EndDate) as 'EndDate'
	,	MediaSourceSources.CreationDate
	,	MediaSourceSources.LastUpdateDate
	FROM [SQL03].[BOSMarketing].dbo.MediaSourceSources MediaSourceSources
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediaSourceTollFreeNumbers MediaSourceTollFreeNumbers
			ON MediaSourceSources.PhoneID = MediaSourceTollFreeNumbers.NumberID
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediaSourceNumberTypes MediaSourceNumberTypes
			ON MediaSourceSources.NumberTypeID = MediaSourceNumberTypes.NumberTypeID
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediaSourceMediaTypes MediaSourceMediaTypes
			ON MediaSourceSources.MediaID = MediaSourceMediaTypes.MediaID
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediaSourceLevel02 MediaSourceLevel02
			ON MediaSourceSources.Level02ID = MediaSourceLevel02.Level02ID
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediaSourceLevel03 MediaSourceLevel03
			ON MediaSourceSources.Level03ID = MediaSourceLevel03.Level03ID
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediaSourceLevel04 MediaSourceLevel04
			ON MediaSourceSources.Level04ID = MediaSourceLevel04.Level04ID
		LEFT OUTER JOIN [SQL03].[BOSMarketing].dbo.MediasourceLevel05 MediasourceLevel05
			ON MediaSourceSources.Level05ID = MediasourceLevel05.Level05ID

	END
GO
