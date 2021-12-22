/* CreateDate: 05/12/2009 15:15:54.367 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
/***********************************************************************

PROCEDURE:	spApp_GetMediaSourceSourceNumberAudit

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 5/11/2009

LAST REVISION DATE: 5/11/2009

--------------------------------------------------------------------------------------------------------
NOTES:
-- This SP will get the records from the MediaSourcePhoneSourceAudit table that are related
-- to the PhoneID selected by the user.
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
-- EXEC spApp_GetMediaSourceSourceNumberAudit 270

***********************************************************************/

CREATE PROCEDURE spApp_GetMediaSourceSourceNumberAudit
	@SourceID	INT
AS
BEGIN
	SELECT
		PhoneID
	,	SourceID
	,	DateEntered
	INTO #PhoneSourceAudit
	FROM
		MediaSourcePhoneSourceAudit
	WHERE
		SourceID = @SourceID

	SELECT
		p.PhoneID
	,	n.Number
	,	p.SourceID
	,	s.SourceName
	,	p.DateEntered
	FROM #PhoneSourceAudit p
		LEFT OUTER JOIN [MediaSourceTollFreeNumbers] n
			ON p.PhoneID = n.NumberID
		LEFT OUTER JOIN [MediaSourceSources] s
			ON p.SourceID = s.SourceID
	ORDER BY p.DateEntered

END
GO
