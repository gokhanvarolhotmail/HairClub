/* CreateDate: 07/30/2015 15:51:15.350 , ModifyDate: 07/30/2015 15:51:15.350 */
GO
CREATE VIEW [dbo].[TollFreeNumbersCallzilla_vw]
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
WHERE h.NumberTypeID = 3
GO
