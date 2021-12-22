/* CreateDate: 09/30/2008 11:57:59.677 , ModifyDate: 01/25/2010 08:13:27.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:	spApp_GetDistinctPhoneNumbers

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
-- EXEC spApp_GetDistinctPhoneNumbers 'All', 0

***********************************************************************/

CREATE PROCEDURE spApp_GetDistinctPhoneNumbers
	@NumberStatus		VARCHAR(30)
,	@NumberTypeID		INT
AS
BEGIN

-- Create Temp Tables to hold data
CREATE TABLE #ActiveOrNullSources (
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

CREATE TABLE [#InactiveSources] (
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

-- Insert all records from TollFreeNumbers_vw with either no associated source, or only an active source
-- into a temp table.
	IF @NumberTypeID = 0
	BEGIN
		IF @NumberStatus = 'All'
		BEGIN
			INSERT INTO #ActiveOrNullSources
			SELECT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, SourceCode, Media, StartDate, EndDate
			FROM TollFreeNumbers_Vw
			WHERE (SourceCode IS NULL OR SourceCode = '' OR CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME))

			INSERT INTO #InactiveSources
			SELECT DISTINCT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, NULL 'SourceCode', NULL 'Media', NULL 'StartDate', NULL 'EndDate'
			FROM [TollFreeNumbers_vw]
			WHERE SourceCode IS NOT NULL
			AND SourceCode != ''
			AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME)
			AND NumberID NOT IN (SELECT NumberID FROM [#ActiveOrNullSources] WHERE NumberID IS NOT NULL)

		END
		IF @Numberstatus = 'Active'
		BEGIN
			INSERT INTO #ActiveOrNullSources
			SELECT *
			FROM TollFreeNumbers_Vw
			WHERE (SourceCode IS NULL OR SourceCode = '' OR CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME))
			AND Active = 1

			INSERT INTO #InactiveSources
			SELECT DISTINCT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, NULL 'SourceCode', NULL 'Media', NULL 'StartDate', NULL 'EndDate'
			FROM [TollFreeNumbers_vw]
			WHERE SourceCode IS NOT NULL
			AND SourceCode != ''
			AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME)
			AND Active = 1
			AND NumberID NOT IN (SELECT NumberID FROM [#ActiveOrNullSources] WHERE NumberID IS NOT NULL)

		END
		IF @NumberStatus = 'Inactive'
		BEGIN
			INSERT INTO #ActiveOrNullSources
			SELECT *
			FROM TollFreeNumbers_Vw
			WHERE (SourceCode IS NULL OR SourceCode = '' OR CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME))
			AND Active = 0

			INSERT INTO #InactiveSources
			SELECT DISTINCT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, NULL 'SourceCode', NULL 'Media', NULL 'StartDate', NULL 'EndDate'
			FROM [TollFreeNumbers_vw]
			WHERE SourceCode IS NOT NULL
			AND SourceCode != ''
			AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME)
			AND Active = 0
			AND NumberID NOT IN (SELECT NumberID FROM [#ActiveOrNullSources] WHERE NumberID IS NOT NULL)

		END
	END
	IF @NumberTypeID > 0
	BEGIN
		IF @NumberStatus = 'All'
		BEGIN
			INSERT INTO #ActiveOrNullSources
			SELECT *
			FROM TollFreeNumbers_Vw
			WHERE (SourceCode IS NULL OR SourceCode = '' OR CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME))
			AND NumberTypeID = @NumberTypeID

			INSERT INTO #InactiveSources
			SELECT DISTINCT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, NULL 'SourceCode', NULL 'Media', NULL 'StartDate', NULL 'EndDate'
			FROM [TollFreeNumbers_vw]
			WHERE SourceCode IS NOT NULL
			AND SourceCode != ''
			AND NumberTypeID = @NumberTypeID
			AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME)
			AND NumberID NOT IN (SELECT NumberID FROM [#ActiveOrNullSources] WHERE NumberID IS NOT NULL)

		END
		IF @NumberStatus = 'Active'
		BEGIN
			INSERT INTO #ActiveOrNullSources
			SELECT *
			FROM TollFreeNumbers_Vw
			WHERE (SourceCode IS NULL OR SourceCode = '' OR CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME))
			AND NumberTypeID = @NumberTypeID
			AND Active = 1

			INSERT INTO #InactiveSources
			SELECT DISTINCT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, NULL 'SourceCode', NULL 'Media', NULL 'StartDate', NULL 'EndDate'
			FROM [TollFreeNumbers_vw]
			WHERE SourceCode IS NOT NULL
			AND SourceCode != ''
			AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME)
			AND Active = 1
			AND NumberTypeID = @NumberTypeID
			AND NumberID NOT IN (SELECT NumberID FROM [#ActiveOrNullSources] WHERE NumberID IS NOT NULL)

		END
		IF @NumberStatus = 'Inactive'
		BEGIN
			INSERT INTO #ActiveOrNullSources
			SELECT *
			FROM TollFreeNumbers_Vw
			WHERE (SourceCode IS NULL OR SourceCode = '' OR CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME))
			AND NumberTypeID = @NumberTypeID
			AND Active = 0

			INSERT INTO #InactiveSources
			SELECT DISTINCT NumberID, Number, NumberTypeID, NumberType, HCDNIS, VendorDNIS, VendorDNIS2, VoiceMail, Qwest, QwestID, Active, Notes, NULL 'SourceCode', NULL 'Media', NULL 'StartDate', NULL 'EndDate'
			FROM [TollFreeNumbers_vw]
			WHERE SourceCode IS NOT NULL
			AND SourceCode != ''
			AND CAST(dbo.DateOnly(GETDATE()) AS SMALLDATETIME) NOT BETWEEN CAST(StartDate AS SMALLDATETIME) AND CAST(EndDate AS SMALLDATETIME)
			AND Active = 0
			AND NumberTypeID = @NumberTypeID
			AND NumberID NOT IN (SELECT NumberID FROM [#ActiveOrNullSources] WHERE NumberID IS NOT NULL)
		END
	END

	SELECT *
	FROM #ActiveOrNullSources
	UNION
	SELECT *
	FROM [#InactiveSources]
	ORDER BY [Number]
END
GO
