/* CreateDate: 06/18/2008 12:36:14.757 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MediaSourcesAllNumbers_vw]
AS
SELECT
	s.SourceID
,	s.SourceCode
,	s.SourceName
,	s.PhoneID
,	hc.Number
,	s.NumberTypeID
,	nt.NumberType
,	s.MediaID
,	mt.Media
,	s.Level02ID
,	l2.Level02Location
,	s.Level03ID
,	l3.Level03Language
,	s.Level04ID
,	l4.Level04Format
,	s.Level05ID
,	l5.Level05Creative
,	dbo.DateOnly(s.StartDate) as 'StartDate'
,	dbo.DateOnly(s.EndDate) as 'EndDate'
,	s.CreationDate
,	s.LastUpdateDate
,	s.Description
,	ISNULL(s.IsInHouseSourceFlag, 'N') 'IsInHouseSourceFlag'
FROM
	MediaSourceSources s
		LEFT OUTER JOIN MediaSourceTollFreeNumbers hc
			ON s.PhoneID = hc.NumberID
		LEFT OUTER JOIN MediaSourceNumberTypes nt
			ON s.NumberTypeID = nt.NumberTypeID
		LEFT OUTER JOIN MediaSourceMediaTypes mt
			ON s.MediaID = mt.MediaID
		LEFT OUTER JOIN MediaSourceLevel02 l2
			ON s.Level02ID = l2.Level02ID
		LEFT OUTER JOIN MediaSourceLevel03 l3
			ON s.Level03ID = l3.Level03ID
		LEFT OUTER JOIN MediaSourceLevel04 l4
			ON s.Level04ID = l4.Level04ID
		LEFT OUTER JOIN MediasourceLevel05 l5
			ON s.Level05ID = l5.Level05ID
GO
