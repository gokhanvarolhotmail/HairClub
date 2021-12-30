/* CreateDate: 06/25/2008 17:48:58.003 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
CREATE VIEW MediaSourceLevel03_vw
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
