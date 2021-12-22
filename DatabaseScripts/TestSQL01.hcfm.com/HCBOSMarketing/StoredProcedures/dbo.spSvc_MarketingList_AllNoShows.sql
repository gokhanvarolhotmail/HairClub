/* CreateDate: 01/08/2009 16:00:13.847 , ModifyDate: 08/03/2010 14:23:15.977 */
GO
/*===============================================================================================
-- Procedure Name:			spSvc_MarketingList_AllNoShows
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		James Hannah III
--
-- Date Created:			12/1/2008
-- Date Implemented:
-- Date Last Modified:		3/30/2010
--
-- Destination Server:		SQL03
-- Destination Database:	BOSMarketing
-- Related Application:		N/A

================================================================================================
**NOTES**
	01/27/2009 -- AP -- Added functionality to allow the selection of Corporate AND Franchise centers in the same result set.
	02/02/2009  -- AP -- Added Ludwig, Norwood, and occupation columns to the output.
	02/03/2009  -- AP -- Get the Occupation column from the Lead table instead of the Activity table, to avoid duplicate records.
	02/03/2009  -- AP -- Add the CampaignID to the output, so it can be appended to the filename of the saved list.
	03/05/2009 -- AP -- Updated output to include the Activity date.
	03/17/2009 -- AP -- Check each client to ensure that they have no APPOINT activities after the NoShow.
	03/30/2010  -- JH -- Fixed include bebacks functionality and also included INHOUSES in query.
	8/2/2010  -- MB -- Added ContactID to the output
================================================================================================
Sample Execution:

EXEC spSvc_MarketingList_AllNoShows 'TestCampaign_NoShow_01282009', 'A test no-show list.', '1', 'C', '800', 'Male', '1', '1/1/2009', '3/31/2009', '1/1/2009', '3/31/2009', 'x', 'x', 'x', 'x', '0', 'jhannah'
================================================================================================
-- GenderID Parameter Values:
-- 1 - Male
-- 2 - Female
================================================================================================*/


CREATE PROCEDURE [dbo].[spSvc_MarketingList_AllNoShows]
	@CampaignName	VARCHAR(60)
,	@CampaignDescription VARCHAR(1000)
,	@ListID		SMALLINT
,	@CenterType	CHAR(1)
,	@Center	VARCHAR(1000)
,	@Gender	VARCHAR(10)
,	@GenderID	TINYINT
,	@CreationStartDate	SMALLDATETIME
,	@CreationEndDate	SMALLDATETIME
,	@ResultStartDate	SMALLDATETIME
,	@ResultEndDate	SMALLDATETIME
,	@DoNotCall	CHAR(1)
,	@DoNotMail	CHAR(1)
,	@DoNotContact CHAR(1)
,	@DoNotEmail	CHAR(1)
,	@BeBacks	bit
,	@Username	VARCHAR(40)

AS
DECLARE
	@EndCreationDateTime SMALLDATETIME
,	@EndResultDateTime	SMALLDATETIME
,	@StartDateID	INT
,	@EndDateID	INT
,	@CampaignID	INT

BEGIN
	SET @EndCreationDateTime = DATEADD(mi, -1, DATEADD(dd, 1, @CreationEndDate))

	SELECT @StartDateID = DateID
		FROM [HCWH1\SQL2005].[Warehouse].dbo.[DimDate]
		WHERE Date = @ResultStartDate

	SELECT @EndDateID = DateID
		FROM [HCWH1\SQL2005].[Warehouse].dbo.[DimDate]
		WHERE Date = @ResultEndDate

	CREATE TABLE #NoShows (
		Center		INT
	,	RecordID	VARCHAR(10))

	-----------------------------------------------------------------------------------------------
	-- Insert the Campaign Info and Parameters into the CampaignNames table
	INSERT INTO CampaignNames (
		CampaignName
	,	DateCreated
	,	CreatedBy
	,	ListID
	,	CampaignDescription
	,	Param_Centers
	,	Param_Regions
	,	Param_ResultStartDate
	,	Param_ResultEndDAte
	,	Param_ShowStartDate
	,	Param_ShowEndDate
	,	Param_Gender
	,	Param_GenderID
	,	Param_Member1
	,	Param_CancelStartDate
	,	Param_CancelEndDate
	,	Param_SurStartDate
	,	Param_SurEndDate
	,	Param_SurpostStartDate
	,	Param_SurpostEndDAte
	,	Param_DoNotMail
	,	Param_DoNotEmail
	,	Param_DoNotCall
	,	Param_DoNotContact
	,	Param_LeadCreationStartDate
	,	Param_LeadCreationEndDate
	,	Param_BeBacks
	,	StartTime	)
	VALUES (
		@CampaignName
	,	GETDATE()
	,	@UserName
	,	@ListID
	,	@CampaignDescription
	,	CASE @CenterType WHEN 'C' THEN @Center ELSE NULL END
	,	CASE @CenterType WHEN 'R' THEN @Center ELSE NULL END
	,	@ResultStartDate
	,	@ResultEndDate
	,	NULL
	,	NULL
	,	@Gender
	,	@GenderID
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	NULL
	,	@DoNotMail
	,	@DoNotEmail
	,	@DoNotCall
	,	@DoNotContact
	,	@CreationStartDate
	,	@CreationEndDate
	,	@BeBacks
	,	GETDATE()	)

	-- Get the CampaignID for the newly created CampaignName record.
	SELECT @CampaignID = @@IDENTITY

	------------------------------------------------------------------------------------------------------
	-- Insert the result set the CampaignResults table.
	-- By Center  ----------------------------------------------------------------------
	IF (@CenterType = 'C')
	BEGIN
		IF (@Center NOT IN ('C', 'F', 'S', 'FS', 'AC', 'AS')) -- If several specific centers have been selected.
		BEGIN
			IF (@GenderID = 3) -- Both Male and Female
			BEGIN
				INSERT INTO [#NoShows] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN dbo.SplitCenterIDs (@Center) sci
						ON l.Center = sci.CenterNumber
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
			END
			IF (@GenderID != 3) -- Either Male OR Female
			BEGIN
				INSERT INTO [#NoShows] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN dbo.SplitCenterIDs (@Center) sci
						ON l.Center = sci.CenterNumber
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND l.GenderID = @GenderID
			END
		END
		IF (@Center IN ('C', 'F', 'S', 'FS')) -- If Center is only ONE of the following (corporate, franchise, surgery, franchis-surgery)
		BEGIN
			IF (@GenderID = 3) -- Both Male and Female
			BEGIN
				INSERT INTO [#NoShows] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.Center = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND c.TYPE = @Center
			END
			IF (@GenderID != 3) -- Either Male OR Female
			BEGIN
				INSERT INTO [#NoShows] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.Center = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND l.GenderID = @GenderID
				AND c.TYPE = @Center
			END
		END
		IF (@Center IN ('AC'))  -- All Centers (Corporate AND Franchise)
		BEGIN
			IF (@GenderID = 3) -- Both Male and Female
			BEGIN
				INSERT INTO [#NoShows] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.Center = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND c.TYPE IN ('C', 'F')
			END
			IF (@GenderID != 3) -- Either Male OR Female
			BEGIN
				INSERT INTO [#NoShows] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.Center = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND l.GenderID = @GenderID
				AND c.TYPE IN ('C', 'F')
			END
		END
	END
	--------------------------------------------------------------------------------------------------------
	-- By Region	----------------------------------------------------------------------------------------
	IF (@CenterType = 'R')
	BEGIN
		IF (@GenderID = 3) -- Both Male and Female
		BEGIN
			INSERT INTO [#NoShows] (
				[Center],
				[RecordID]	)
			SELECT
				l.Center
			,	l.RecordID
			FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
					ON l.Center = c.Center_Num
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
					ON c.RegionID = r.RegionID
				INNER JOIN dbo.SplitCenterIDs (@Center) sci
					ON c.RegionID = sci.CenterNumber
			WHERE
				l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
		END
		IF (@GenderID != 3) -- Either Male OR Female
		BEGIN
			INSERT INTO [#NoShows] (
				[Center],
				[RecordID]	)
			SELECT
				l.Center
			,	l.RecordID
			FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
					ON l.Center = c.Center_Num
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
					ON c.RegionID = r.RegionID
				INNER JOIN dbo.SplitCenterIDs (@Center) sci
					ON c.RegionID = sci.CenterNumber
			WHERE
				l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
			AND l.GenderID = @GenderID
		END
	END

	----------------------------------------------------------------------------------------------------------

	SELECT DISTINCT
		@CampaignID 'CampaignID'
	,	l.[Center]
	,	c.Center AS 'CenterName'
	,	c.RegionID
	,	r.Region
	,	l.Appointment_Date
	,	l.Gender
	,	l.GenderID
	,	l.RecordID
	,	l.RecordID 'ContactID'
	,	l.FirstName
	,	l.LastName
	,	l.Address1
	,	l.Address2
	,	l.City
	,	l.State
	,	l.[Zip]
	,	l.Phone
	,	l.Ethnicity
	,	l.EthnicityID
	,	l.Age
	,	l.AgeID
	,	l.MaritalStatus
	,	l.MaritalStatusID
	,	l.Email
	,	NULL 'Member1'
	,	NULL 'Member2'
	,	l.Creation_Date
	,	l.[Ludwig]
	,	l.[Norwood]
	,	l.[Occupation]
	INTO #NoShowLeads
	FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
		INNER JOIN #NoShows ns
			ON l.Center = ns.[Center]
			AND l.[RecordID] = ns.[RecordID]
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
			ON l.Center = c.Center_Num
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
			ON c.RegionID = r.RegionID

	--------------------------------------------------------------------------------------------------------------------

	SELECT DISTINCT
		ns.CampaignID
	,	ns.[Center]
	,	ns.CenterName
	,	ns.RegionID
	,	ns.Region
	,	ns.Gender
	,	ns.GenderID
	,	ns.RecordID
	,	ns.ContactID
	,	ns.FirstName
	,	ns.LastName
	,	ns.Address1
	,	ns.Address2
	,	ns.City
	,	ns.State
	,	ns.[Zip]
	,	ns.Phone
	,	ns.Ethnicity
	,	ns.EthnicityID
	,	ns.Age
	,	ns.AgeID
	,	ns.MaritalStatus
	,	ns.MaritalStatusID
	,	ns.Email
	,	ns.Member1
	,	ns.Member2
	,	ns.Creation_Date
	,	ns.Ludwig
	,	ns.Norwood
	,	MAX(ns.Occupation) 'Occupation'
	,	MAX(a.Date) 'AppointmentDate'
	INTO #AllLeads
	FROM #NoShowLeads ns
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Activity] a
			ON RTRIM(ns.RecordID) = RTRIM(a.RecordID)
			AND ns.Center = a.Center
	WHERE a.DateID BETWEEN @StartDateID AND @EndDateID
		AND a.IsShow = 0
		AND CONVERT(VARCHAR,a.IsBeBack) LIKE CASE WHEN @BeBacks = '1' THEN '%' ELSE '0' END
		AND a.act_Code IN ('APPOINT','BEBACK','INHOUSE')
	GROUP BY
		ns.CampaignID
	,	ns.[Center]
	,	ns.CenterName
	,	ns.RegionID
	,	ns.Region
	,	ns.Gender
	,	ns.GenderID
	,	ns.RecordID
	,	ns.ContactID
	,	ns.FirstName
	,	ns.LastName
	,	ns.Address1
	,	ns.Address2
	,	ns.City
	,	ns.State
	,	ns.[Zip]
	,	ns.Phone
	,	ns.Ethnicity
	,	ns.EthnicityID
	,	ns.Age
	,	ns.AgeID
	,	ns.MaritalStatus
	,	ns.MaritalStatusID
	,	ns.Email
	,	ns.Member1
	,	ns.Member2
	,	ns.Creation_Date
	,	ns.Ludwig
	,	ns.Norwood
	ORDER BY ns.Center, ns.RecordID

	---------------------------------------------------------------------------------------------------------
	-- Join on the Activity table again to get the date of the last Appointment
	SELECT
		l.*
	,	MAX(a.Date) 'LastAppointmentDate'
	INTO #LeadsAppointments
	FROM #AllLeads l
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Activity] a
			ON l.RecordID = a.RecordID
	WHERE a.[act_code] IN ('APPOINT', 'BEBACK','INHOUSE')
	GROUP BY
		l.CampaignID
	,	l.[Center]
	,	l.CenterName
	,	l.RegionID
	,	l.Region
	,	l.Gender
	,	l.GenderID
	,	l.RecordID
	,	l.ContactID
	,	l.FirstName
	,	l.LastName
	,	l.Address1
	,	l.Address2
	,	l.City
	,	l.State
	,	l.[Zip]
	,	l.Phone
	,	l.Ethnicity
	,	l.EthnicityID
	,	l.Age
	,	l.AgeID
	,	l.MaritalStatus
	,	l.MaritalStatusID
	,	l.Email
	,	l.Member1
	,	l.Member2
	,	l.Creation_Date
	,	l.Ludwig
	,	l.Norwood
	,	l.Occupation
	,	l.AppointmentDate

	---------------------------------------------------------------------------------------------------------
	-- Remove all records from #LeadsAppointments that have an IsShow in the specified date range.
	SELECT
		la.RecordID
	INTO #IsShowRecords
	FROM [#LeadsAppointments] la
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.Activity a
			ON la.RecordID = a.[recordid]
	WHERE a.DateID BETWEEN @StartDateID AND @EndDateID
	  AND a.[IsShow] = 1

	DELETE
	FROM [#LeadsAppointments]
	WHERE RecordID IN (SELECT RecordID FROM [#IsShowRecords] WHERE [RecordID] IS NOT NULL)

	---------------------------------------------------------------------------------------------------------
	-- Insert the records into the CampaignResults table, that do not have
	INSERT INTO CampaignResults (
		CampaignID
	,	Center
	,	CenterName
	,	RegionID
	,	Region
	,	ApptDate
	,	Gender
	,	GenderID
	,	RecordID
	,	ContactID
	,	FirstName
	,	LastName
	,	Address1
	,	Address2
	,	City
	,	[State]
	,	Zip
	,	Phone
	,	Ethnicity
	,	EthnicityID
	,	Age
	,	AgeID
	,	MaritalStatus
	,	MaritalStatusID
	,	Email
	,	Member1
	,	Member2
	,	CreationDate
	,	Ludwig
	,	Norwood
	,	Occupation	)
	SELECT
		l.CampaignID
	,	l.[Center]
	,	l.CenterName
	,	l.RegionID
	,	l.Region
	,	l.AppointmentDate
	,	l.Gender
	,	l.GenderID
	,	l.RecordID
	,	l.ContactID
	,	l.FirstName
	,	l.LastName
	,	l.Address1
	,	l.Address2
	,	l.City
	,	l.State
	,	l.[Zip]
	,	l.Phone
	,	l.Ethnicity
	,	l.EthnicityID
	,	l.Age
	,	l.AgeID
	,	l.MaritalStatus
	,	l.MaritalStatusID
	,	l.Email
	,	l.Member1
	,	l.Member2
	,	l.Creation_Date
	,	l.Ludwig
	,	l.Norwood
	,	l.Occupation
	FROM [#LeadsAppointments] l
	WHERE LastAppointmentDate = AppointmentDate

	---------------------------------------------------------------------------------------------------------

	UPDATE CampaignNames
	SET CampaignName = RTRIM(CampaignName) + '_' + RTRIM(CAST(CampaignID AS VARCHAR))
	,	EndTime = GETDATE()
	WHERE CampaignID = @CampaignID

	SELECT
		CampaignID
	,	Center
	,	CenterName
	,	Region
	,	ApptDate	-- This is the Activity Date
	,	Gender
	,	FirstName
	,	LastName
	,	Address1
	,	Address2
	,	City
	,	[State]
	,	Zip
	,	Phone
	,	Ethnicity
	,	Age
	,	MaritalStatus
	,	Occupation
	,	Ludwig
	,	Norwood
	,	Email
	,	CreationDate
	,	ContactID
	FROM CampaignResults
	WHERE CampaignID = @CampaignID

END
GO
