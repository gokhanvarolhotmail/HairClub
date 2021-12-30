/* CreateDate: 09/30/2008 11:58:39.113 , ModifyDate: 01/25/2010 08:13:27.323 */
GO
/***********************************************************************

PROCEDURE:	spApp_GetDistinctPhoneNumberByNumber

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 9/29/2008

LAST REVISION DATE: 9/29/2008

--------------------------------------------------------------------------------------------------------
NOTES:
-- This SP will display each Phone Number 1 time only -- joined with its source (only displays active source
-- or displays a NULL)
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
-- EXEC spApp_GetDistinctPhoneNumberByNumber 'All', 0, '800205'

***********************************************************************/
CREATE PROCEDURE spApp_GetDistinctPhoneNumberByNumber
	@NumberStatus		VARCHAR(30)
,	@NumberTypeID		INT
,	@Number				VARCHAR(20)
AS
BEGIN

DECLARE
	@SqlStmnt VARCHAR(1000)
   	-- Create temp table to hold filtered records from SP spApp_GetDistinctPhoneNumbers.
   	CREATE TABLE #DistinctNumbers (
   		NumberID		INT
	,	Number			VARCHAR(50)
	,	NumberTypeID	TINYINT
	,	NumberType		VARCHAR(50)
	,	HCDNIS			VARCHAR(50)
	,	VendorDNIS		VARCHAR(50)
	,	VendorDNIS2		VARCHAR(50)
	,	VoiceMail		VARCHAR(50)
	,	Qwest			CHAR(50)
	,	QwestID			SMALLINT
	,	Active			BIT
	,	Notes			VARCHAR(200)
	,	SourceCode		VARCHAR(50)
	,	Media			VARCHAR(50)
	,	StartDate		VARCHAR(12)
	,	EndDate			VARCHAR(12)	)

	-- Insert records from spApp_GetDistinctPhoneNumbers into temp table.
	INSERT INTO #DistinctNumbers
		EXEC spApp_GetDistinctPhoneNumbers @NumberStatus, @NumberTypeID

	-- Query the temp table to get the Phone Number searched for by the user.
	SET @SqlStmnt = 'SELECT * FROM #DistinctNumbers WHERE dbo.UnformatPhoneNumber(Number) LIKE '''
	SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Number)
	SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' ORDER BY Number'

	EXEC(@SqlStmnt)
END
GO
