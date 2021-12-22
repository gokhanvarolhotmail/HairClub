/* CreateDate: 01/08/2009 15:58:14.503 , ModifyDate: 08/03/2010 14:23:09.410 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spSvc_MarketingList_Upgrades
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		Alex Pasieka
--
-- Date Created:			12/29/2008
-- Date Implemented:
-- Date Last Modified:		12/29/2008
--
-- Destination Server:		HCSQL2\SQL2005
-- Destination Database:	BOSMarketing
-- Related Application:		N/A

================================================================================================
**NOTES**
	1/28/2009 -- AP -- Functionality added to allow user to select all corporate and franchise centers.
	2/02/2009 -- AP -- Add columns for Ludwig, Norwood, and occupation to final result set.
	2/3/2009  -- AP -- Add the CampaignID to the output, so it can be appended to the filename of the saved list.
	2/12/2000 -- AP -- Adds the Client_No to the output
	8/2/2010  -- MB -- Added ContactID to the output
================================================================================================

Sample Execution:

EXEC spSvc_MarketingList_Upgrades 'TestUpgradeList', 'A test Upgrades list.', 3, 'C', 'C', 'Male', '1', '1111', '1/1/2008', '3/1/2008', '1/1/2000', '12/31/2025', 'x', 'x', 'x', 'x', 'apasieka'
================================================================================================
-- GenderID Parameter Values:
-- 1 - Male
-- 2 - Female
================================================================================================*/

CREATE PROCEDURE [dbo].[spSvc_MarketingList_Upgrades]
	@CampaignName	VARCHAR(60)
,	@CampaignDescription VARCHAR(1000)
,	@ListID		SMALLINT
,	@CenterType	CHAR(1)
,	@Center	VARCHAR(1000)
,	@Gender	VARCHAR(10)
,	@GenderID	TINYINT
,	@MemIDs	VARCHAR(1000)
,	@MemBeginStartDate	SMALLDATETIME
,	@MemBeginEndDate	SMALLDATETIME
,	@MemExpStartDate	SMALLDATETIME
,	@MemExpEndDate		SMALLDATETIME
,	@DoNotCall	CHAR(1)
,	@DoNotMail	CHAR(1)
,	@DoNotContact CHAR(1)
,	@DoNotEmail	CHAR(1)
,	@Username	VARCHAR(40)
AS
DECLARE
	@EndMemBeginDateTime SMALLDATETIME
,	@EndMemExpDateTime	SMALLDATETIME
,	@CampaignID	INT
,	@GenderIDToExclude TINYINT

BEGIN
	SET @EndMemBeginDateTime = DATEADD(mi, -1, DATEADD(dd, 1, @MemBeginEndDate))
	SET @EndMemExpDateTime = DATEADD(mi, -1, DATEADD(dd, 1, @MemExpEndDate))

	IF (@GenderID = 1)
	BEGIN
		SET @GenderIDToExclude = 2
	END
	IF (@GenderID = 2)
	BEGIN
		SET @GenderIDToExclude = 1
	END
	IF (@GenderID = 3)
	BEGIN
		SET @GenderIDToExclude = 3
	END


	-- Insert the campaign info and parameters into the CampaignNames table.
	INSERT INTO CampaignNames (
		CampaignName
	,	DateCreated
	,	CreatedBy
	,	ListID
	,	CampaignDescription
	,	Param_Centers
	,	Param_Regions
	,	Param_Gender
	,	Param_GenderID
	,	Param_Member1
	,	Param_MembershipBeginStartDate
	,	Param_MembershipBeginEndDate
	,	Param_MembershipExpStartDate
	,	Param_MembershipExpEndDate
	,	Param_DoNotCall
	,	Param_DoNotMail
	,	Param_DoNotContact
	,	Param_DoNotEmail
	,	StartTime	)
	VALUES	(
		@CampaignName
	,	GETDATE()
	,	@Username
	,	@ListID
	,	@CampaignDescription
	,	CASE @CenterType WHEN 'C' THEN @Center ELSE NULL END
	,	CASE @CenterType WHEN 'R' THEN @Center ELSE NULL END
	,	@Gender
	,	@GenderID
	,	@MemIDs
	,	@MemBeginStartDate
	,	@MemBeginEndDate
	,	@MemExpStartDate
	,	@MemExpEndDate
	,	@DoNotCall
	,	@DoNotMail
	,	@DoNotContact
	,	@DoNotEmail
	,	GETDATE()	)

	-- Get the CampaignID for the newly created CampaignName record.
	SELECT @CampaignID = @@IDENTITY

	-- Create temp table to hold records from the Client table.
	CREATE TABLE [#Clients] (
		CenterNum	INT
	,	Center		VARCHAR(50)
	,	RegionID	SMALLINT
	,	Region		VARCHAR(50)
	,	Gender		VARCHAR(20)
	,	GenderID	TINYINT
	,	ContactID	VARCHAR(50)
	,	Client_No	INT
	,	First_Name	VARCHAR(20)
	,	Last_Name	VARCHAR(30)
	,	[Address]	VARCHAR(50)
	,	City		VARCHAR(20)
	,	[State]		CHAR(2)
	,	Zip			VARCHAR(9)
	,	Phone_Home	VARCHAR(14)
	,	Membership	VARCHAR(10)
	,	Membership_Beg	SMALLDATETIME
	,	Membership_End	SMALLDATETIME	)

	-- Create temp table to hold the Membership ID's
	CREATE TABLE #MemIDs (
		MembershipID INT)

	--------------------------------------------------------------------------------------------------
	-- Populate the temp table with the Membership ID's selected by the user
	IF (@MemIDs = '9999')
	BEGIN
		INSERT INTO [#MemIDs]
		SELECT MembershipID
		FROM [HCWH1\SQL2005].[Warehouse].dbo.vw_MarketingListMemberTypes
		WHERE Membership LIKE 'New Business%'
	END
	IF (@MemIDs = '1111')
	BEGIN
		INSERT INTO [#MemIDs]
		SELECT MembershipID
		FROM [HCWH1\SQL2005].[Warehouse].dbo.vw_MarketingListMemberTypes
		WHERE Membership LIKE 'Recurring%'
	END
	IF EXISTS (SELECT ParsedList FROM dbo.SplitStrings(@MemIDs) WHERE ParsedList = '1111')
	BEGIN
		IF EXISTS (SELECT ParsedList FROM dbo.SplitStrings(@MemIDs) WHERE ParsedList = '9999')
		BEGIN
			INSERT INTO #MemIDs
			SELECT MembershipID
			FROM [HCWH1\SQL2005].[Warehouse].dbo.vw_MarketingListMemberTypes
			WHERE Membership LIKE 'Recurring%' OR Membership LIKE 'New Business%'
		END
	END
	IF (@MemIDs != '1111') AND (@MemIDs != '9999')
	BEGIN
		INSERT INTO [#MemIDs]
		SELECT CenterNumber
		FROM dbo.SplitCenterIDs(@MemIDs)
	END

	----------------------------------------------------------------------------------------------------
	-- Insert the records from the Client table into the temp table created above.
	-- By Center ---------------------------------------------------------------------------------------
	IF (@CenterType = 'C')
	BEGIN
		IF (@Center NOT IN ('C', 'F', 'S', 'FS', 'AC'))
		BEGIN
			INSERT INTO [#Clients] (
				[CenterNum],
				[Center],
				[RegionID],
				[Region],
				[Gender],
				[GenderID],
				[ContactID],
				[Client_No],
				[First_Name],
				[Last_Name],
				[Address],
				[City],
				[State],
				[Zip],
				[Phone_Home],
				[Membership],
				[Membership_Beg],
				[Membership_End]	)
			SELECT
				cl.Center 'CenterNum'
			,	c.Center
			,	c.RegionID
			,	r.Region
			,	cl.Gender
			,	cl.GenderID
			,	cl.ContactID
			,	cl.Client_No
			,	cl.First_Name
			,	cl.Last_Name
			,	cl.Address
			,	cl.City
			,	cl.State
			,	cl.Zip
			,	cl.Phone_Home
			,	cl.Membership
			,	cl.Membership_Beg
			,	cl.Membership_Exp
			FROM [HCWH1\SQL2005].[Warehouse].dbo.Client cl
				INNER JOIN dbo.SplitCenterIDs(@Center) sci
					ON cl.Center = sci.CenterNumber
				INNER JOIN #MemIDs smi
					ON cl.[MembershipID] = smi.MembershipID
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
					ON cl.Center = c.[Center_Num]
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
					ON c.[RegionID] = r.[RegionID]
			WHERE [Membership_Beg] BETWEEN @MemBeginStartDate AND @EndMemBeginDateTime
				AND [Membership_Exp] BETWEEN @MemExpStartDate AND @EndMemExpDateTime
				AND cl.[GenderID] != @GenderIDToExclude
		END
		IF (@Center IN ('C', 'F', 'S', 'FS'))
		BEGIN
			INSERT INTO [#Clients] (
				[CenterNum],
				[Center],
				[RegionID],
				[Region],
				[Gender],
				[GenderID],
				[ContactID],
				[Client_No],
				[First_Name],
				[Last_Name],
				[Address],
				[City],
				[State],
				[Zip],
				[Phone_Home],
				[Membership],
				[Membership_Beg],
				[Membership_End]	)
			SELECT
				cl.Center 'CenterNum'
			,	c.Center
			,	c.RegionID
			,	r.Region
			,	cl.Gender
			,	cl.GenderID
			,	cl.ContactID
			,	cl.Client_No
			,	cl.First_Name
			,	cl.Last_Name
			,	cl.Address
			,	cl.City
			,	cl.State
			,	cl.Zip
			,	cl.Phone_Home
			,	cl.Membership
			,	cl.Membership_Beg
			,	cl.Membership_Exp
			FROM [HCWH1\SQL2005].[Warehouse].dbo.Client cl
				INNER JOIN #MemIDs smi
					ON cl.[MembershipID] = smi.MembershipID
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
					ON cl.Center = c.[Center_Num]
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
					ON c.[RegionID] = r.[RegionID]
			WHERE [Membership_Beg] BETWEEN @MemBeginStartDate AND @EndMemBeginDateTime
				AND [Membership_Exp] BETWEEN @MemExpStartDate AND @EndMemExpDateTime
				AND cl.[GenderID] != @GenderIDToExclude
				AND c.TYPE = @Center

		END
		IF (@Center IN ('AC'))
		BEGIN
			INSERT INTO [#Clients] (
				[CenterNum],
				[Center],
				[RegionID],
				[Region],
				[Gender],
				[GenderID],
				[ContactID],
				[Client_No],
				[First_Name],
				[Last_Name],
				[Address],
				[City],
				[State],
				[Zip],
				[Phone_Home],
				[Membership],
				[Membership_Beg],
				[Membership_End]	)
			SELECT
				cl.Center 'CenterNum'
			,	c.Center
			,	c.RegionID
			,	r.Region
			,	cl.Gender
			,	cl.GenderID
			,	cl.ContactID
			,	cl.Client_No
			,	cl.First_Name
			,	cl.Last_Name
			,	cl.Address
			,	cl.City
			,	cl.State
			,	cl.Zip
			,	cl.Phone_Home
			,	cl.Membership
			,	cl.Membership_Beg
			,	cl.Membership_Exp
			FROM [HCWH1\SQL2005].[Warehouse].dbo.Client cl
				INNER JOIN #MemIDs smi
					ON cl.[MembershipID] = smi.MembershipID
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
					ON cl.Center = c.[Center_Num]
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
					ON c.[RegionID] = r.[RegionID]
			WHERE [Membership_Beg] BETWEEN @MemBeginStartDate AND @EndMemBeginDateTime
				AND [Membership_Exp] BETWEEN @MemExpStartDate AND @EndMemExpDateTime
				AND cl.[GenderID] != @GenderIDToExclude
				AND c.TYPE IN ('F', 'C')
		END
	END

	-- By Region ------------------------------------------------------------------------------
	IF (@CenterType = 'R')
	BEGIN
		INSERT INTO [#Clients] (
			[CenterNum],
			[Center],
			[RegionID],
			[Region],
			[Gender],
			[GenderID],
			[ContactID],
			[Client_No],
			[First_Name],
			[Last_Name],
			[Address],
			[City],
			[State],
			[Zip],
			[Phone_Home],
			[Membership],
			[Membership_Beg],
			[Membership_End]	)
		SELECT
			cl.Center 'CenterNum'
		,	c.Center
		,	c.RegionID
		,	r.Region
		,	cl.Gender
		,	cl.GenderID
		,	cl.ContactID
		,	cl.Client_No
		,	cl.First_Name
		,	cl.Last_Name
		,	cl.Address
		,	cl.City
		,	cl.State
		,	cl.Zip
		,	cl.Phone_Home
		,	cl.Membership
		,	cl.Membership_Beg
		,	cl.Membership_Exp
		FROM [HCWH1\SQL2005].[Warehouse].dbo.Client cl
			INNER JOIN #MemIDs smi
				ON cl.[MembershipID] = smi.MembershipID
			INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
				ON cl.Center = c.[Center_Num]
			INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
				ON c.[RegionID] = r.[RegionID]
			INNER JOIN dbo.SplitCenterIDs(@Center) sci
				ON c.[RegionID] = sci.CenterNumber
		WHERE [Membership_Beg] BETWEEN @MemBeginStartDate AND @EndMemBeginDateTime
			AND [Membership_Exp] BETWEEN @MemExpStartDate AND @EndMemExpDateTime
			AND cl.[GenderID] != @GenderIDToExclude
	END

	---------------------------------------------------------------------------------------------------
	-- Join the #Clients temp table with the Completion table, which will provide the RecordID,
	-- which is necessary in order to join to the Lead table.
	SELECT
		cl.*
	,	cmpl.RecordID
	INTO #ClientsComp
	FROM #Clients cl
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Completion] cmpl
			ON cl.CenterNum = cmpl.[CenterID]
			AND cl.Client_No = cmpl.[Client_No]
	ORDER BY cl.Last_Name, cl.[First_Name]

	----------------------------------------------------------------------------------------------------
	-- Insert the records into the CampaignResults table.
	INSERT INTO CampaignResults (
		CampaignID
	,	Center
	,	CenterName
	,	Client_No
	,	RegionID
	,	Region
	,	Gender
	,	GenderID
	,	RecordID
	,	FirstName
	,	LastName
	,	Address1
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
	,	Occupation
	,	Ludwig
	,	Norwood	)
	SELECT DISTINCT
		@CampaignID
	,	cl.CenterNum
	,	cl.Center
	,	cl.Client_No
	,	cl.RegionID
	,	cl.Region
	,	cl.Gender
	,	cl.GenderID
	,	cl.RecordID
	,	cl.First_Name
	,	cl.Last_Name
	,	cl.Address
	,	cl.City
	,	cl.[State]
	,	cl.Zip
	,	cl.Phone_Home
	,	l.Ethnicity
	,	l.EthnicityID
	,	l.Age
	,	l.AgeID
	,	l.MaritalStatus
	,	l.MaritalSTatusID
	,	l.Email
	,	cl.Membership
	,	l.[Occupation]
	,	l.[Ludwig]
	,	l.[Norwood]
	FROM [#ClientsComp] cl
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Lead] l
			ON cl.[RecordID] = l.[RecordID]
	WHERE ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
		AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
		AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
		AND ISNULL(l.Email, 'N') != @DoNotEmail

	---------------------------------------------------------------------------------------

	UPDATE CampaignNames
	SET CampaignName = RTRIM(CampaignName) + '_' + RTRIM(CAST(CampaignID AS VARCHAR))
	,	EndTime = GETDATE()
	WHERE CampaignID = @CampaignID

	SELECT
		@CampaignID 'CampaignID'
	,	Center
	,	CenterName
	,	Client_No
	,	Region
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
	,	ISNULL(Member1, 'Unknown') 'Membership'
	,	ContactID
	FROM CampaignResults
	WHERE CampaignID = @CampaignID

END
GO
