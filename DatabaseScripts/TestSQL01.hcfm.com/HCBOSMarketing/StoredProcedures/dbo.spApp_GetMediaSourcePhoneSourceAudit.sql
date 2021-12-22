/* CreateDate: 09/30/2008 14:58:31.987 , ModifyDate: 01/25/2010 08:13:27.387 */
GO
/***********************************************************************

PROCEDURE:	spApp_GetMediaSourcePhoneSourceAudit

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 9/30/2008

LAST REVISION DATE: 9/30/2008

--------------------------------------------------------------------------------------------------------
NOTES:
-- This SP will get the records from the MediaSourcePhoneSourceAudit table that are related
-- to the PhoneID selected by the user.
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
-- EXEC spApp_GetMediaSourcePhoneSourceAudit 55

***********************************************************************/

CREATE PROCEDURE spApp_GetMediaSourcePhoneSourceAudit
	@PhoneID	INT
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
		PhoneID = @PhoneID

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
