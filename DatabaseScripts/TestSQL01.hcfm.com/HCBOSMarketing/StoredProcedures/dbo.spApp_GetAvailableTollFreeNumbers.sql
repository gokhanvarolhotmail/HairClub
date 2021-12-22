/* CreateDate: 09/29/2008 13:14:10.167 , ModifyDate: 02/20/2012 14:55:48.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:	spApp_GetAvailableTollFreeNumbers

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: BOSMarketing

RELATED APPLICATION:  OLAP Media Source

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 9/29/2008

LAST REVISION DATE: 9/29/2008

--------------------------------------------------------------------------------------------------------
NOTES:
 This SP will display all Phone Numbers that are available (i.e., do not have an active source associated
 with them.  This list will be used in the drop down list for selecting a phone number when creating/editing
 a source.

	02/20/2012 - MB - The procedure was changed to retun the current phone number as well as the available
						numbers (WO# 72511)
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
EXEC spApp_GetAvailableTollFreeNumbers 901, 5

***********************************************************************/


CREATE PROCEDURE [dbo].[spApp_GetAvailableTollFreeNumbers]
	@NumberID	INT
,	@NumberTypeID	INT
AS
BEGIN
	-- Temp table to hold PhoneID's being used by active sources'
	SELECT NumberID
	INTO #NonAvailablePhoneIDs
	FROM [TollFreeNumbers_vw]
	WHERE [NumberID] != 0
		AND [NumberID] IS NOT NULL
		AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(dbo.DateOnly(StartDate) AS SMALLDATETIME) AND CAST(dbo.DateOnly(EndDate) AS SMALLDATETIME)


	SELECT DISTINCT NumberID
	,	Number
	,	NumberTypeID
	FROM (
		SELECT NumberID
		,	Number
		,	NumberTypeID
		FROM [TollFreeNumbers_vw]
		WHERE NumberID = @NumberID

		UNION

		SELECT DISTINCT NumberID
		,	Number
		,	NumberTypeID
		FROM [TollFreeNumbers_vw]
		WHERE Active = 1		-- Phone Number is active
			AND NumberTypeID = @NumberTypeID
			AND	(SourceCode IS NULL
				OR SourceCode = ''
				OR (CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(dbo.DateOnly(StartDate) AS SMALLDATETIME) AND CAST(dbo.DateOnly(EndDate) AS SMALLDATETIME))
				OR NumberID = @NumberID)
			AND NumberID NOT IN (SELECT NumberID FROM [#NonAvailablePhoneIDs] WHERE NumberID IS NOT NULL AND NumberID != @NumberID)
	) tmp
	ORDER BY Number
END
GO
