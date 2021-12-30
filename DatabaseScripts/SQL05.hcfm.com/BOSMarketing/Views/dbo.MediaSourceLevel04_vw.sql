/* CreateDate: 07/30/2015 15:50:32.217 , ModifyDate: 07/30/2015 15:50:32.217 */
GO
CREATE VIEW [dbo].[MediaSourceLevel04_vw]
AS
SELECT
	l.Level04ID
,	l.Level04FormatCode
,	l.Level04Format
,	l.MediaID
,	m.Media
FROM MediaSourceLevel04 l
	INNER JOIN MediaSourceMediaTypes m
		ON l.MediaID = m.MediaID
GO
