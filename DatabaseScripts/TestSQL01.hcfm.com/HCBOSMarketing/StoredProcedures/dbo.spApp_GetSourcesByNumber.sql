/* CreateDate: 06/18/2009 12:49:33.530 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:	spApp_GetSourcesByNumber

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 5/19/2009

LAST REVISION DATE: 5/19/2009

--------------------------------------------------------------------------------------------------------
NOTES:
-- This SP will return a result set containing all Sources, after being filtered by MediaType,
-- Active Status, Source Code, and Number.

10/30/09 -- Add In-House flag to output
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
-- EXEC spApp_GetSourcesByNumber 'All', 2, NULL, 'T'

******************************************* ****************************/
CREATE PROCEDURE spApp_GetSourcesByNumber
	@SourceStatus		VARCHAR(30)
,	@MediaTypeID		INT
,	@Number				VARCHAR(20)
,	@Source				VARCHAR(100)
AS
BEGIN

DECLARE
	@SqlStmnt VARCHAR(1000)

   	-- Create temp table to hold filtered records from SP spApp_GetDistinctPhoneNumbers.
   	CREATE TABLE #Sources (
   		SourceID		INT
	,	Media			VARCHAR(50)
	,	Level02Location	VARCHAR(50)
	,	Level03Language	VARCHAR(50)
	,	Level04Format	VARCHAR(50)
	,	SourceName		VARCHAR(100)
	,	SourceCode		VARCHAR(50)
	,	Level05Creative	VARCHAR(50)
	,	IsInHouseSourceFlag			CHAR(1)
	,	Number			VARCHAR(50)
	,	NumberType		VARCHAR(50)
	,	StartDate		VARCHAR(12)
	,	EndDate			VARCHAR(50)	)


	-- Insert records from MediaSourcesAllNumbers_vw into temp table.
	IF (@MediaTypeID = 0) -- All Media Types
	BEGIN
		IF (@SourceStatus = 'All') -- Both Active and Inactive Sources
		BEGIN
			INSERT INTO #Sources
			SELECT
				SourceID
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	SourceName
			,	SourceCode
			,	Level05Creative
			,	IsInHouseSourceFlag
			,	Number
			,	NumberType
			,	StartDate
			,	EndDate
			FROM MediaSourcesAllNumbers_vw
		END
		IF (@SourceStatus = 'Active')
		BEGIN
			INSERT INTO #Sources
			SELECT
				SourceID
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	SourceName
			,	SourceCode
			,	Level05Creative
			,	IsInHouseSourceFlag
			,	Number
			,	NumberType
			,	StartDate
			,	EndDate
			FROM MediaSourcesAllNumbers_vw
			WHERE GETDATE() BETWEEN [StartDate] AND [EndDate]
		END
		IF (@SourceStatus = 'Inactive')
		BEGIN
			INSERT INTO #Sources
			SELECT
				SourceID
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	SourceName
			,	SourceCode
			,	Level05Creative
			,	IsInHouseSourceFlag
			,	Number
			,	NumberType
			,	StartDate
			,	EndDate
			FROM MediaSourcesAllNumbers_vw
			WHERE GETDATE() NOT BETWEEN [StartDate] AND [EndDate]
		END
	END
	IF (@MediaTypeID != 0) -- Specific Media Type
	BEGIN
		IF (@SourceStatus = 'All') -- Both Active and Inactive Sources
		BEGIN
			INSERT INTO #Sources
			SELECT
				SourceID
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	SourceName
			,	SourceCode
			,	Level05Creative
			,	IsInHouseSourceFlag
			,	Number
			,	NumberType
			,	StartDate
			,	EndDate
			FROM MediaSourcesAllNumbers_vw
			WHERE MediaID = @MediaTypeID
		END
		IF (@SourceStatus = 'Active')
		BEGIN
			INSERT INTO #Sources
			SELECT
				SourceID
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	SourceName
			,	SourceCode
			,	Level05Creative
			,	IsInHouseSourceFlag
			,	Number
			,	NumberType
			,	StartDate
			,	EndDate
			FROM MediaSourcesAllNumbers_vw
			WHERE GETDATE() BETWEEN [StartDate] AND [EndDate]
			AND MediaID = @MediaTypeID
		END
		IF (@SourceStatus = 'Inactive')
		BEGIN
			INSERT INTO #Sources
			SELECT
				SourceID
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	SourceName
			,	SourceCode
			,	Level05Creative
			,	IsInHouseSourceFlag
			,	Number
			,	NumberType
			,	StartDate
			,	EndDate
			FROM MediaSourcesAllNumbers_vw
			WHERE GETDATE() NOT BETWEEN [StartDate] AND [EndDate]
			AND MediaID = @MediaTypeID
		END
	END

	-- Check to see if @Number variable is NULL, which means the user did not enter a phone number
	-- to filter by.
	IF ((@Number IS NULL) OR (@Number = ''))
	BEGIN
		-- Query the temp table to get the Phone number(s) searched for by the user, filtering
		-- by SourceCode only.
		SET @SqlStmnt = 'SELECT * FROM #Sources WHERE SourceCode LIKE '''
		SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Source)
		SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' ORDER BY SourceName'
	END

	-- If @Number is not NULL, the user entered a number to filter by.
	IF ((@Number IS NOT NULL) AND (@Number != ''))
	BEGIN
		-- Query the temp table to get the Phone Number(s) searched for by the user, filtering
		-- by SourceCode and PhoneNumber.
		SET @SqlStmnt = 'SELECT * FROM #Sources WHERE dbo.UnformatPhoneNumber(Number) LIKE '''
		SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Number)
		SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' AND SourceCode LIKE '''
		SET @SqlStmnt = RTRIM(@SqlStmnt) + RTRIM(@Source)
		SET @SqlStmnt = RTRIM(@SqlStmnt) + '%'' ORDER BY SourceName'
	END


	EXEC(@SqlStmnt)
END
GO
