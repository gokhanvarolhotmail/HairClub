/* CreateDate: 07/30/2015 15:51:15.307 , ModifyDate: 07/30/2015 15:51:15.307 */
GO
CREATE VIEW [dbo].[TollFreeNumbers_vw]
AS
SELECT
	NumberID
,	Number
,	h.NumberTypeID
,	t.NumberType
,	HCDNIS
,	VendorDNIS
,	VendorDNIS2
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
	LEFT OUTER JOIN MediaSourceNumberTypes t
		ON h.NumberTypeID = t.NumberTypeID
	LEFT OUTER JOIN MediaSourceMediaTypes m
		ON s.MediaID = m.MediaID
GO
