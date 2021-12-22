/* CreateDate: 09/30/2008 11:59:07.927 , ModifyDate: 01/25/2010 08:13:27.323 */
GO
/***********************************************************************

PROCEDURE:	spApp_MediaSourcePhoneSourceAuditAdd

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 9/29/2008

LAST REVISION DATE: 9/29/2008

--------------------------------------------------------------------------------------------------------
NOTES:
-- This SP will add and PhoneID and the SourceID of the record associated with it to the
-- MediaSourcePhoneSourceAudit table.
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
-- EXEC spApp_MediaSourcePhoneSourceAuditAdd

***********************************************************************/

CREATE PROCEDURE spApp_MediaSourcePhoneSourceAuditAdd
	@PhoneID	INT
,	@SourceID	INT
AS
BEGIN
	INSERT INTO MediaSourcePhoneSourceAudit (
		PhoneID
	,	SourceID
	,	DateEntered	)
	VALUES (
		@PhoneID
	,	@SourceID
	,	GETDATE()	)
END
GO
