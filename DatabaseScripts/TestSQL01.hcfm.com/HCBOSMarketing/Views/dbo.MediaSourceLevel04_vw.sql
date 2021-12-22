/* CreateDate: 06/25/2008 17:49:22.020 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW MediaSourceLevel04_vw
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
