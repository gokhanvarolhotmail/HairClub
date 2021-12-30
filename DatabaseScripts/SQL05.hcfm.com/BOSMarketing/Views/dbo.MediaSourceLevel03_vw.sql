/* CreateDate: 07/30/2015 15:50:32.173 , ModifyDate: 07/30/2015 15:50:32.173 */
GO
CREATE VIEW [dbo].[MediaSourceLevel03_vw]
AS
SELECT
	l.Level03ID
,	l.Level03LanguageCode
,	l.Level03Language
,	l.MediaID
,	m.Media
FROM MediaSourceLevel03 l
	INNER JOIN MediaSourceMediaTypes m
		ON l.MediaID = m.MediaID
GO
