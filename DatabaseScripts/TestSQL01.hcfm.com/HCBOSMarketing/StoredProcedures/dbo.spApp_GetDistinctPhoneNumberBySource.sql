/* CreateDate: 06/18/2009 12:50:06.600 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
/***********************************************************************

PROCEDURE:	spApp_GetDistinctPhoneNumberBySource

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 5/14/2009

LAST REVISION DATE: 5/14/2009

--------------------------------------------------------------------------------------------------------
NOTES:
-- This SP will display each Phone Number 1 time only -- joined with its source (only displays active source
-- or displays a NULL).  It will allow the user to filter the numbers returned by Number-Type, Active Status,
-- Number, and Source Code/Name.
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
-- EXEC spApp_GetDistinctPhoneNumberBySource 'All', 0, NULL, 'C'

******************************************* ****************************/
CREATE PROCEDURE spApp_GetDistinctPhoneNumberBySource
	@NumberStatus		VARCHAR(30)
,	@NumberTypeID		INT
,	@Number				VARCHAR(20)
,	@Source				VARCHAR(100)
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

--SELECT * FROM [#DistinctNumbers]

	-- Check to see if @Number variable is NULL, which means the user did not enter a phone number
	-- to filter by.
	IF ((@Number IS NULL) OR (@Number = ''))
	BEGIN
		-- Query the temp table to get the Phone number(s) searched for by the user, filtering
		-- by SourceCode only.
		SET @SqlStmnt = 'SELECT * FROM #DistinctNumbers WHERE SourceCode LIKE '''
		SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Source)
		SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' ORDER BY Number'
	END

	-- If @Number is not NULL, the user entered a number to filter by.
	IF ((@Number IS NOT NULL) AND (@Number != ''))
	BEGIN
		-- Query the temp table to get the Phone Number(s) searched for by the user, filtering
		-- by SourceCode and PhoneNumber.
		SET @SqlStmnt = 'SELECT * FROM #DistinctNumbers WHERE dbo.UnformatPhoneNumber(Number) LIKE '''
		SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Number)
		SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' AND SourceCode LIKE '''
		SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Source)
		SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' ORDER BY Number'
	END


	EXEC(@SqlStmnt)
END
GO
