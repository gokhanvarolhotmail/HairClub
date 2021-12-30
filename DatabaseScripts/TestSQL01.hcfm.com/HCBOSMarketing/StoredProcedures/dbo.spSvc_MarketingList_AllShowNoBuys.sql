/* CreateDate: 01/08/2009 15:59:21.787 , ModifyDate: 02/07/2011 09:11:37.330 */
GO
/*===============================================================================================
-- Procedure Name:			spSvc_MarketingList_AllShowNoBuys
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		James Hannah III
--
-- Date Created:			12/29/2008
-- Date Implemented:
-- Date Last Modified:		03/20/2010
--
-- Destination Server:		SQL03
-- Destination Database:	BOSMarketing
-- Related Application:		N/A

================================================================================================
**NOTES**
	01/27/2009 -- AP -- Added functionality to allow the selection of Corporate AND Franchise centers in the same result set.
	01/28/2009 -- AP -- Added functionality to allow selection of specific No Sale Reason types.
	02/02/2009  -- AP -- Added reference to Completion table to get No Sale Reason column.
	02/03/2009  -- AP -- Get Occupation column from the Lead table instead of Activity, to avoid duplicate records.
	02/03/2009  -- AP -- Add the CampaignID to the output, so it can be appended to the filename of the saved list.
	03/05/2009 -- AP -- Updated output to include the Activity date.
	03/19/2009 -- AP -- Check each client to ensure that they have no APPOINT activities after the NoBuy.
	09/02/2009 -- AP -- Removed the @CampaignName variable from a GROUP BY clause, which was causing an error.
	03/03/2010  -- AP -- Replace reference to HCWH1 with HCWH1.
	03/30/2010  -- JH -- Fixed include bebacks functionality and also included INHOUSES in query.
	8/2/2010  -- MB -- Added ContactID to the output
	11/30/10 -- MB -- Added Solution Offered to the output
	02/07/2011 -- MB -- Used temp table for [HCWH1\SQL2005].Warehouse.dbo.Activity instead of querying the table multiple times.
						This should speed up the query

================================================================================================
Sample Execution:.


EXEC spSvc_MarketingList_AllShowNoBuys 'TestCampaign_AllShowNoBuys_090809', 'A test No-Buy list.', '2', 'F', '800', 'Both', '3', '1/1/2009', '3/31/2009', '1/1/2009', '3/31/2009', 'x', 'x', 'x', 'x', '1', 'All Reasons', 'jhannah'
================================================================================================
-- GenderID Parameter Values:
-- 1 - Male
-- 2 - Female
================================================================================================*/


CREATE PROCEDURE [dbo].[spSvc_MarketingList_AllShowNoBuys]
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
,	@BeBacks BIT
,	@NoSaleReason	VARCHAR(1000)
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

	CREATE TABLE #NoBuys (
		Center		INT
	,	RecordID	VARCHAR(10))


	SELECT *
	INTO #Activity
	FROM [HCWH1\SQL2005].[Warehouse].dbo.[Activity]
	WHERE DateID BETWEEN @StartDateID AND @EndDateID

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
	,	Param_NoSaleReason
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
	,	@NoSaleReason
	,	GETDATE()	)

	-- Get the CampaignID for the newly created CampaignName record.
	SELECT @CampaignID = @@IDENTITY

	------------------------------------------------------------------------------------
	-- Insert the result set the CampaignResults table.
	-- By Center  ----------------------------------------------------------------------
	IF (@CenterType = 'C')
	BEGIN
		IF (@Center NOT IN ('C', 'F', 'S', 'FS', 'AC'))
		BEGIN
			IF (@GenderID = 3) -- Both Male AND Female
			BEGIN
				INSERT INTO [#NoBuys] (
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
				INSERT INTO [#NoBuys] (
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
		IF (@Center IN ('C', 'F', 'S', 'FS'))
		BEGIN
			IF (@GenderID = 3) -- Both Male AND Female
			BEGIN
				INSERT INTO [#NoBuys] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.[Center] = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND c.[Type] = @Center
			END
			IF (@GenderID != 3) -- Either Male OR Female
			BEGIN
				INSERT INTO [#NoBuys] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.[Center] = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND l.GenderID = @GenderID
				AND c.[Type] = @Center
			END
		END
		IF (@Center IN ('AC'))
		BEGIN
			IF (@GenderID = 3) -- Both Male AND Female
			BEGIN
				INSERT INTO [#NoBuys] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.[Center] = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND c.[Type] IN ('C', 'F')
			END
			IF (@GenderID != 3) -- Either Male OR Female
			BEGIN
				INSERT INTO [#NoBuys] (
					[Center],
					[RecordID]	)
				SELECT
					l.Center
				,	l.RecordID
				FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
					INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
						ON l.[Center] = c.[Center_Num]
				WHERE
					l.Creation_Date BETWEEN @CreationStartDate AND @EndCreationDateTime
				AND ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
				AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
				AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
				AND ISNULL(l.Email, 'N') != @DoNotEmail
				AND l.GenderID = @GenderID
				AND c.[Type] IN ('C', 'F')
			END
		END
	END
	IF (@CenterType = 'R')
	BEGIN
		IF (@GenderID = 3) -- Both Male AND Female
		BEGIN
			INSERT INTO [#NoBuys] (
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
			INSERT INTO [#NoBuys] (
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

	-------------------------------------------------------------------------------------------------------------

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
	,	l.Creation_Date
	,	l.Ludwig
	,	l.Norwood
	,	MAX(l.[Occupation]) 'Occupation'
	INTO #NoBuyLeads
	FROM [HCWH1\SQL2005].warehouse.dbo.[Lead] l
		INNER JOIN #NoBuys ns
			ON l.Center = ns.[Center]
			AND l.[RecordID] = ns.[RecordID]
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
			ON l.Center = c.Center_Num
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
			ON c.RegionID = r.RegionID
	GROUP BY
		l.[Center]
	,	c.Center
	,	c.RegionID
	,	r.Region
	,	l.Appointment_Date
	,	l.Gender
	,	l.GenderID
	,	l.RecordID
	,	l.RecordID
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
	,	l.Creation_Date
	,	l.Ludwig
	,	l.Norwood

	---------------------------------------------------------------------------------------
	-- Join on the Activity table to get the MAX appointment date for the specified date range.
	SELECT
		nb.*
	,	MAX(a.Date) 'AppointmentDate'
	INTO #NoBuyLeadsApptDate
	FROM [#NoBuyLeads] nb
		INNER JOIN #Activity a
			ON RTRIM(nb.RecordID) = RTRIM(a.RecordID)
	WHERE a.DateID BETWEEN @StartDateID AND @EndDateID
		AND	a.IsShow = 1
		AND a.IsSale = 0
		AND CONVERT(VARCHAR,a.IsBeBack) LIKE CASE WHEN @BeBacks = '1' THEN '%' ELSE '0' END
		AND a.act_Code IN ('APPOINT','BEBACK','INHOUSE')
	GROUP BY
		nb.CampaignID
	,	nb.[Center]
	,	nb.CenterName
	,	nb.RegionID
	,	nb.Region
	,	nb.Appointment_Date
	,	nb.Gender
	,	nb.GenderID
	,	nb.RecordID
	,	nb.ContactID
	,	nb.FirstName
	,	nb.LastName
	,	nb.Address1
	,	nb.Address2
	,	nb.City
	,	nb.State
	,	nb.[Zip]
	,	nb.Phone
	,	nb.Ethnicity
	,	nb.EthnicityID
	,	nb.Age
	,	nb.AgeID
	,	nb.MaritalStatus
	,	nb.MaritalStatusID
	,	nb.Email
	,	nb.Creation_Date
	,	nb.Ludwig
	,	nb.Norwood
	,	nb.Occupation

	------------------------------------------------------------------------------------------------------------
	-- Join on the Activity table again to get the date of the last appointment.
	SELECT
		nb.*
	,	MAX(a.Date) 'LastAppointmentDate'
	INTO #NoBuyLeadsLastAppt
	FROM [#NoBuyLeadsApptDate] nb
		INNER JOIN #Activity a
			ON RTRIM(nb.RecordID) = RTRIM(a.RecordID)
	WHERE a.act_Code IN ('APPOINT', 'BEBACK','INHOUSE')
	GROUP BY
		nb.CampaignID
	,	nb.[Center]
	,	nb.CenterName
	,	nb.RegionID
	,	nb.Region
	,	nb.Appointment_Date
	,	nb.Gender
	,	nb.GenderID
	,	nb.RecordID
	,	nb.ContactID
	,	nb.FirstName
	,	nb.LastName
	,	nb.Address1
	,	nb.Address2
	,	nb.City
	,	nb.State
	,	nb.[Zip]
	,	nb.Phone
	,	nb.Ethnicity
	,	nb.EthnicityID
	,	nb.Age
	,	nb.AgeID
	,	nb.MaritalStatus
	,	nb.MaritalStatusID
	,	nb.Email
	,	nb.Creation_Date
	,	nb.Ludwig
	,	nb.Norwood
	,	nb.Occupation
	,	nb.AppointmentDate


	CREATE CLUSTERED INDEX ix_RecordID ON [#NoBuyLeadsLastAppt] (RecordID)
	------------------------------------------------------------------------------------------------------------
	-- Filter by No Sale Reasons -------------------------------------------------------------------------------
	-- If user selects ALL NoSaleReason types.
	IF EXISTS (SELECT ParsedList FROM dbo.SplitStrings(@NoSaleReason) WHERE ParsedList = 'All Reasons')
	BEGIN
		INSERT INTO CampaignResults (
			CampaignID
		,	Center
		,	CenterName
		,	RegionID
		,	Region
		,	ApptDate	-- This is the Activity Date
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
		,	CreationDate
		,	Ludwig
		,	Norwood
		,	Occupation
		,	NoSaleReason		 )
		SELECT DISTINCT
			ns.CampaignID
		,	ns.[Center]
		,	ns.CenterName
		,	ns.RegionID
		,	ns.Region
		,	a.Date
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
		,	ns.Creation_Date
		,	ns.Ludwig
		,	ns.Norwood
		,	ns.Occupation
		,	MAX(ISNULL(cmp.No_Sale_Reason, '')) 'NoSaleReason'
		FROM #NoBuyLeadsLastAppt ns
			INNER JOIN #Activity a
				ON RTRIM(ns.RecordID) = RTRIM(a.RecordID)
				--AND ns.Center = a.Center
			INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Completion] cmp
				ON RTRIM(a.RecordID) = RTRIM(cmp.RecordID)
				--AND a.Center = cmp.CenterID
		WHERE a.DateID BETWEEN @StartDateID AND @EndDateID
		AND	a.IsShow = 1
		AND a.IsSale = 0
		AND CONVERT(VARCHAR,a.IsBeBack) LIKE CASE WHEN @BeBacks = '1' THEN '%' ELSE '0' END
		AND a.act_Code IN ('APPOINT','BEBACK','INHOUSE')
		AND ns.AppointmentDate = ns.LastAppointmentDate
		GROUP BY
			ns.CampaignID
		,	ns.[Center]
		,	ns.CenterName
		,	ns.RegionID
		,	ns.Region
		,	a.Date
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
		,	ns.Creation_Date
		,	ns.Ludwig
		,	ns.Norwood
		,	ns.Occupation
		ORDER BY ns.Center, ns.RecordID
	END
	ELSE -- User selected just specific NoSaleReason types.
	BEGIN
		INSERT INTO CampaignResults (
			CampaignID
		,	Center
		,	CenterName
		,	RegionID
		,	Region
		,	ApptDate	-- This is the Activity Date
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
		,	CreationDate
		,	Ludwig
		,	Norwood
		,	Occupation
		,	NoSaleReason )
		SELECT DISTINCT
			ns.CampaignID
		,	ns.[Center]
		,	ns.CenterName
		,	ns.RegionID
		,	ns.Region
		,	a.Date
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
		,	ns.Creation_Date
		,	ns.Ludwig
		,	ns.Norwood
		,	ns.Occupation
		,	MAX(ISNULL(cmp.No_Sale_Reason, '')) 'NoSaleReason'
		FROM #NoBuyLeadsLastAppt ns
			INNER JOIN #Activity a
				ON RTRIM(ns.RecordID) = RTRIM(a.RecordID)
				--AND ns.Center = a.Center
			INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Completion] cmp
				ON RTRIM(a.RecordID) = RTRIM(cmp.RecordID)
				--AND a.Center = cmp.CenterID
			INNER JOIN dbo.SplitStrings(@NoSaleReason) nsr
				ON RTRIM(ISNULL(cmp.no_sale_reason, '')) = RTRIM(nsr.ParsedList)
		WHERE a.DateID BETWEEN @StartDateID AND @EndDateID
		AND	a.IsShow = 1
		AND a.IsSale = 0
		AND CONVERT(VARCHAR,a.IsBeBack) LIKE CASE WHEN @BeBacks = '1' THEN '%' ELSE '0' END
		AND a.act_Code IN ('APPOINT','BEBACK','INHOUSE')
		AND ns.AppointmentDate = ns.LastAppointmentDate
		GROUP BY
			ns.CampaignID
		,	ns.[Center]
		,	ns.CenterName
		,	ns.RegionID
		,	ns.Region
		,	a.Date
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
		,	ns.Creation_Date
		,	ns.Ludwig
		,	ns.Norwood
		,	ns.Occupation
		ORDER BY ns.Center, ns.RecordID
	END

	------------------------------------------------------------------------------------------

	UPDATE CampaignNames
	SET CampaignName = RTRIM(CampaignName) + '_' + RTRIM(CAST(CampaignID AS VARCHAR))
	,	EndTime = GETDATE()
	WHERE CampaignID = @CampaignID

	DECLARE @str AS VARCHAR(50)
	SET @str = 'Solution Offered: '

	SELECT @CampaignID 'CampaignID'
	,	r.Center
	,	r.CenterName
	,	r.Region
	,	r.ApptDate	-- This is the Activity Date
	,	r.Gender
	,	r.FirstName
	,	r.LastName
	,	r.Address1
	,	r.Address2
	,	r.City
	,	r.[State]
	,	r.Zip
	,	r.Phone
	,	r.Ethnicity
	,	r.Age
	,	r.MaritalStatus
	,	r.Occupation
	,	r.Ludwig
	,	r.Norwood
	,	r.Email
	,	ISNULL(r.NoSaleReason, 'Unknown') 'NoSaleReason'
	,	r.CreationDate
	,	r.ContactID
	,	CASE WHEN (CHARINDEX(',', c.status_line, CHARINDEX(@str, c.status_line)) - CHARINDEX(@str, c.status_line) - 18)> 0 THEN
			SUBSTRING(status_line
				,	CHARINDEX(@str, c.status_line)+18
				,	(CHARINDEX(',', c.status_line, CHARINDEX(@str, c.status_line)) - CHARINDEX(@str, c.status_line) - 18)
				)
			ELSE ''
		END AS 'SolutionOffered'
	FROM CampaignResults r
		INNER JOIN SQL03.HCM.dbo.cstd_contact_completion c
			ON r.ContactID = c.contact_id
	WHERE r.CampaignID = @CampaignID

END
GO
