/* CreateDate: 06/25/2008 17:46:06.943 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW MediaSourceLevel02_vw
AS
SELECT
	l.Level02ID
,	l.Level02LocationCode
,	l.Level02Location
,	l.MediaID
,	m.Media
FROM MediaSourceLevel02 l
	INNER JOIN MediaSourceMediaTypes m
		ON l.MediaID = m.MediaID
GO
