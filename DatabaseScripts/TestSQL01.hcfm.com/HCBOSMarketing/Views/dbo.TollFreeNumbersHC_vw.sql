/* CreateDate: 06/12/2008 15:24:04.363 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
CREATE VIEW [dbo].[TollFreeNumbersHC_vw]
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
WHERE h.NumberTypeID = 1
GO
