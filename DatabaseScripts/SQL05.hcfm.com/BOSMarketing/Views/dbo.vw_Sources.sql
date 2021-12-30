/* CreateDate: 04/09/2018 14:14:03.437 , ModifyDate: 04/23/2018 16:27:08.407 */
GO
CREATE VIEW [dbo].[vw_Sources]
AS
SELECT  s.SourceID AS 'SourceCodeID'
,       ISNULL(s.SourceCode, '') AS 'SourceCode'
,       ISNULL(s.SourceName, '') AS 'Description'
,		ISNULL(mt.MediaID, 0) AS 'MediaID'
,       ISNULL(mt.Media, '') AS 'Media'
,		ISNULL(hc.NumberID, 0) AS 'NumberID'
,       ISNULL(hc.Number, '') AS 'Number'
,       hc.HCDNIS
,		ISNULL(nt.NumberTypeID, 0) AS 'NumberTypeID'
,       ISNULL(nt.NumberType, '') AS 'NumberType'
,		ISNULL(l2.Level02ID, 0) AS 'LocationID'
,       ISNULL(l2.Level02Location, '') AS 'Location'
,		ISNULL(l3.Level03ID, 0) AS 'LanguageID'
,       ISNULL(l3.Level03Language, '') AS 'Language'
,		ISNULL(l4.Level04ID, 0) AS 'FormatID'
,       ISNULL(l4.Level04Format, '') AS 'Format'
,		ISNULL(l5.Level05ID, 0) AS 'CreativeID'
,       ISNULL(l5.Level05Creative, '') AS 'Creative'
,       dbo.DateOnly(s.StartDate) AS 'StartDate'
,       dbo.DateOnly(s.EndDate) AS 'EndDate'
,       ISNULL(s.IsInHouseSourceFlag, 'N') 'InHouseSource'
,       ISNULL(s.IsHansWiemannSourceFlag, 'N') 'IsHansWiemannSource'
,		CASE WHEN GETDATE() BETWEEN StartDate AND EndDate THEN 1 ELSE 0 END AS 'StatusID'
,		CASE WHEN GETDATE() BETWEEN StartDate AND EndDate THEN 'Active' ELSE 'Inactive' END AS 'StatusDescription'
,		s.[Description] AS 'Notes'
,		s.CreationDate
,		s.LastUpdateDate
FROM    MediaSourceSources s
        LEFT OUTER JOIN MediaSourceTollFreeNumbers hc
            ON s.PhoneID = hc.NumberID
        LEFT OUTER JOIN MediaSourceNumberTypes nt
            ON s.NumberTypeID = nt.NumberTypeID
        LEFT OUTER JOIN MediaSourceMediaTypes mt
            ON s.MediaID = mt.MediaID
        LEFT OUTER JOIN MediaSourceLevel02 l2
            ON s.Level02ID = l2.Level02ID
        LEFT OUTER JOIN MediaSourceLevel03 l3
            ON s.Level03ID = l3.Level03ID
        LEFT OUTER JOIN MediaSourceLevel04 l4
            ON s.Level04ID = l4.Level04ID
        LEFT OUTER JOIN MediaSourceLevel05 l5
            ON s.Level05ID = l5.Level05ID
GO
