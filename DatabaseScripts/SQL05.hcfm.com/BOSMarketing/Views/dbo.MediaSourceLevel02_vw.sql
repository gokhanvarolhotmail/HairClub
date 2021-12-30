/* CreateDate: 07/30/2015 15:50:32.093 , ModifyDate: 07/30/2015 15:50:32.093 */
GO
CREATE VIEW [dbo].[MediaSourceLevel02_vw]
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
