/* CreateDate: 06/25/2008 12:07:22.390 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
