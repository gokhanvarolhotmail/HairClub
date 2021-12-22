/* CreateDate: 06/12/2008 16:36:09.900 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TollFreeNumbersConnection_vw]
AS
SELECT
	NumberID
,	Number
,	HCDNIS
,	VendorDNIS
,	VoiceMail
,	q.Qwest
,	h.QwestID
,	Active
,	Notes
,	s.SourceCode
,	m.Media
,	dbo.DateOnly(s.StartDate) as 'StartDate'
,	dbo.DateOnly(s.EndDate) as 'EndDate'
FROM MediaSourceTollFreeNumbers h
	LEFT OUTER JOIN MediaSourceQwestOptions q
		ON h.QwestID = q.QwestID
	LEFT OUTER JOIN MediaSourceSources s
		ON h.NumberID = s.PhoneID
	LEFT OUTER JOIN MediaSourceMediaTypes m
		ON s.MediaID = m.MediaID
WHERE h.NumberTypeID = 2
GO
