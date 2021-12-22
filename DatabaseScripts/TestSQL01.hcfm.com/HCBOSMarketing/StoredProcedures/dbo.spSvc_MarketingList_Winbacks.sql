/* CreateDate: 01/08/2009 15:58:51.800 , ModifyDate: 08/03/2010 14:23:06.460 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spSvc_MarketingList_Winbacks
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
	1/30/2009 -- AP -- Functionality added to allow user to select specific Cancel Reasons and specific
	2/02/2009 -- AP -- Added Ludwig, Norwood, and occupation columns to the final result set.
	2/3/2009  -- AP -- Add the CampaignID to the output, so it can be appended to the filename of the saved list.
	2/3/2009  -- AP -- Select just the MAX CancelTrxDate for each client.
	8/2/2010  -- MB -- Added ContactID to the output
================================================================================================

Sample Execution:

EXEC spSvc_MarketingList_Winbacks 'TestWinbackList', 'A test Winback list.', 4, 'C', 'AC', 'Both', '3', '1/1/2008', '2/3/2009', 'x', 'Y', 'Y', 'x', '9999', '1111, 9999', 'apasieka'
================================================================================================
-- GenderID Parameter Values:
-- 1 - Male
-- 2 - Female
================================================================================================*/

CREATE PROCEDURE [dbo].[spSvc_MarketingList_Winbacks]
	@CampaignName	VARCHAR(60)
,	@CampaignDescription VARCHAR(1000)
,	@ListID		SMALLINT
,	@CenterType	CHAR(1)
,	@Center	VARCHAR(1000)
,	@Gender	VARCHAR(10)
,	@GenderID	TINYINT
,	@CancelStartDate	SMALLDATETIME
,	@CancelEndDate		SMALLDATETIME
,	@DoNotCall	CHAR(1)
,	@DoNotMail	CHAR(1)
,	@DoNotContact CHAR(1)
,	@DoNotEmail	CHAR(1)
,	@CancelReasonIDs	VARCHAR(1000)
,	@MemIDs	VARCHAR(1000)
,	@Username	VARCHAR(40)
AS
DECLARE
	@EndCancelDateTime SMALLDATETIME
,	@CampaignID	INT
,	@GenderIDToExclude TINYINT


BEGIN
	SET @EndCancelDateTime = DATEADD(mi, -1, DATEADD(dd, 1, @CancelEndDate))

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

	---------------------------------------------------------------------------------------
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
	,	Param_CancelStartDate
	,	Param_CancelEndDate
	,	Param_DoNotCall
	,	Param_DoNotMail
	,	Param_DoNotContact
	,	Param_DoNotEmail
	,	Param_CancelReasonIDs
	,	Param_Member1
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
	,	@CancelStartDate
	,	@CancelEndDate
	,	@DoNotCall
	,	@DoNotMail
	,	@DoNotContact
	,	@DoNotEmail
	,	@CancelReasonIDs
	,	@MemIDs
	,	GETDATE()	)

	-- Get the CampaignID for the newly created CampaignName record.
	SELECT @CampaignID = @@IDENTITY

	-----------------------------------------------------------------------------------------

	-- Create temp table to hold records from the Transaction table.
	CREATE TABLE [#Transactions] (
		CenterNum	SMALLINT
	,	Client_No	INT
	,	Date		SMALLDATETIME
	,	CancelReasonID	INT
	,	Member1	VARCHAR(20))

	-- Create temp table to hold the records with the CancelReason appended.
		CREATE TABLE #ClientCancels (
		CenterNum	INT
	,	Center	VARCHAR(40)
	,	RegionID	INT
	,	Region	VARCHAR(50)
	,	Client_No int
	,	Gender	VARCHAR(10)
	,	GenderID	TINYINT
	,	RecordID	VARCHAR(10)
	,	First_Name	VARCHAR(20)
	,	Last_Name	VARCHAR(20)
	,	[Address]	VARCHAR(60)
	,	City	VARCHAR(60)
	,	[State]	CHAR(2)
	,	Zip	VARCHAR(10)
	,	Phone_Home	CHAR(20)
	,	Ethnicity	VARCHAR(30)
	,	EthnicityID	tinyint
	,	Age	VARCHAR(50)
	,	AgeID	TINYINT
	,	MaritalStatus	VARCHAR(30)
	,	MaritalStatusID	TINYINT
	,	Email	CHAR(50)
	,	Membership	VARCHAR(30)
	,	CancelTrxDate	SMALLDATETIME
	,	CancelReasonID	INT
	,	CancelReason	VARCHAR(50)
	,	Member1 VARCHAR(30)	)

	---------------------------------------------------------------------------------------------------
	-- Create temp table to hold the Membership ID's
	CREATE TABLE #MemIDs (
		MembershipID INT)

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
		SELECT ParsedList
		FROM dbo.SplitStrings(@MemIDs)
	END

	---------------------------------------------------------------------------------------------------

	-- Insert the records from the Client table into the temp table created above.
	-- By Center ---------------------------------------------------------------------------------------
	IF (@CenterType = 'C')
	BEGIN
		IF (@Center NOT IN ('C', 'F', 'S', 'FS', 'AC'))
		BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum],
				[Client_No],
				[Date],
				[CancelReasonID],
				[Member1]	)
			SELECT
				t.Center
			,	t.Client_No
			,	t.[Date]
			,	t.[CancelReasonID]
			,	t.[Membership]
			FROM [HCWH1\SQL2005].[Warehouse].dbo.[transaction] t
				INNER JOIN dbo.SplitCenterIDs(@Center) sci
					ON t.Center = sci.CenterNumber
			WHERE t.Date BETWEEN @CancelStartDate AND @CancelEndDate
				AND t.Code IN ('NB1X', 'PCPX', 'NB2X')
		END
		IF (@Center IN ('C', 'F', 'S', 'FS'))
		BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum],
				[Client_No],
				[Date],
				[CancelReasonID],
				[Member1]	)
			SELECT
				t.Center
			,	t.Client_No
			,	t.[Date]
			,	t.[CancelReasonID]
			,	t.[Membership]
			FROM [HCWH1\SQL2005].[Warehouse].dbo.[transaction] t
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
					ON t.Center = c.[Center_Num]
			WHERE t.Date BETWEEN @CancelStartDate AND @CancelEndDate
				AND t.Code IN ('NB1X', 'PCPX', 'NB2X')
				AND c.TYPE = @Center
		END
		IF (@Center IN ('AC'))
		BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum],
				[Client_No],
				[Date],
				[CancelReasonID],
				[Member1]	)
			SELECT
				t.Center
			,	t.Client_No
			,	t.[Date]
			,	t.[CancelReasonID]
			,	t.Membership
			FROM [HCWH1\SQL2005].[Warehouse].dbo.[transaction] t
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
					ON t.Center = c.[Center_Num]
			WHERE t.Date BETWEEN @CancelStartDate AND @CancelEndDate
				AND t.Code IN ('NB1X', 'PCPX', 'NB2X')
				AND c.TYPE IN ('F', 'C')
		END
	END

	-- By Region ------------------------------------------------------------------------------
	IF (@CenterType = 'R')
	BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum],
				[Client_No],
				[Date],
				[CancelReasonID],
				[Member1]	)
			SELECT
				t.Center
			,	t.Client_No
			,	t.[Date]
			,	t.[CancelReasonID]
			,	t.Membership
			FROM [HCWH1\SQL2005].[Warehouse].dbo.[transaction] t
			INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.tblCenter c
				ON t.Center = c.[Center_Num]
			INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
				ON c.[RegionID] = r.[RegionID]
			INNER JOIN dbo.SplitCenterIDs(@Center) sci
				ON c.[RegionID] = sci.CenterNumber
		WHERE t.Date BETWEEN @CancelStartDate AND @CancelEndDate
			AND t.Code IN ('NB1X', 'PCPX', 'NB2X')

	END
	-------------------------------------------------------------------------------------------------

	-- Join the #Transactions temp table with the Client table, to get the Client info and to verify
	-- that each client still has a Membership status of 'CANCEL'.
	SELECT
		cl.Center 'CenterNum'
	,	c.[Center]
	,	c.[RegionID]
	,	r.[Region]
	,	cl.[Gender]
	,	cl.[GenderID]
	,	cl.[ContactID]
	,	cl.[Client_no]
	,	cl.[First_Name]
	,	cl.[Last_Name]
	,	cl.[Address]
	,	cl.[City]
	,	cl.[State]
	,	cl.[Zip]
	,	cl.[Phone_Home]
	,	cl.[Membership]
	,	t.[Date] 'CancelTrxDate'
	,	t.[CancelReasonID]
	,	t.[Member1]
	INTO #Clients
	FROM [HCWH1\SQL2005].[Warehouse].dbo.[Client] cl
		INNER JOIN [#Transactions] t
			ON cl.[Center] = t.[CenterNum]
			AND cl.[Client_no] = t.[Client_No]
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
			ON cl.Center = c.[Center_Num]
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
			ON c.[RegionID] = r.[RegionID]
	WHERE cl.[GenderID] != @GenderIDToExclude
		AND cl.[Membership] = 'CANCEL'

	----------------------------------------------------------------------------------------------

	-- Join the #Clients temp table with the Completion table, which will provide the RecordID,
	-- which is necessary in order to join to the Lead table.
	SELECT
		cl.CenterNum
	,	cl.Center
	,	cl.RegionID
	,	cl.Region
	,	cl.Gender
	,	cl.GenderID
	,	cl.ContactID
	,	cl.[Client_no]
	,	cl.[First_Name]
	,	cl.[Last_Name]
	,	cl.[Address]
	,	cl.[City]
	,	cl.[State]
	,	cl.Zip
	,	cl.[Phone_Home]
	,	cl.[Membership]
	,	cl.CancelTrxDate
	,	cl.[CancelReasonID]
	,	cl.[Member1]
	,	MAX(cmpl.RecordID) 'RecordID'
	INTO #ClientsComp
	FROM #Clients cl
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Completion] cmpl
			ON cl.CenterNum = cmpl.[CenterID]
			AND cl.Client_No = cmpl.[Client_No]
	GROUP BY CenterNum
	,	cl.Center
	,	cl.RegionID
	,	cl.Region
	,	cl.Gender
	,	cl.GenderID
	,	cl.ContactID
	,	cl.[Client_no]
	,	cl.[First_Name]
	,	cl.[Last_Name]
	,	cl.[Address]
	,	cl.[City]
	,	cl.[State]
	,	cl.Zip
	,	cl.[Phone_Home]
	,	cl.[Membership]
	,	cl.CancelTrxDate
	,	cl.[CancelReasonID]
	,	cl.[Member1]
	ORDER BY cl.Last_Name, cl.[First_Name]

	----------------------------------------------------------------------------------------------

	-- Join the #ClientsComp table with the Lead table to get the demographic columns.
	SELECT DISTINCT
		cl.CenterNum
	,	cl.Center
	,	cl.RegionID
	,	cl.Region
	,	cl.Client_No
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
	,	cl.CancelTrxDate
	,	cl.Member1
	,	ISNULL(cl.CancelReasonID, 0) 'CancelReasonID'
	INTO #ClientsLead
	FROM [#ClientsComp] cl
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Lead] l
			ON cl.[RecordID] = l.[RecordID]
	WHERE ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
		AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
		AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
		AND ISNULL(l.Email, 'N') != @DoNotEmail

	---------------------------------------------------------------------------------------------------------

	-- Joins the #ClientsLead table with the CancelReason table to get the description of the CancelReasonIDs.
	-- If user selects ALL Cancel Reasons
	IF EXISTS (SELECT ParsedList FROM dbo.SplitStrings(@CancelReasonIDs) WHERE ParsedList = '9999')
	BEGIN
		INSERT INTO [#ClientCancels] (
			[CenterNum],
			[Center],
			[RegionID],
			[Region],
			[Client_No],
			[Gender],
			[GenderID],
			[RecordID],
			[First_Name],
			[Last_Name],
			[Address],
			[City],
			[State],
			[Zip],
			[Phone_Home],
			[Ethnicity],
			[EthnicityID],
			[Age],
			[AgeID],
			[MaritalStatus],
			[MaritalStatusID],
			[Email],
			[Membership],
			[CancelTrxDate],
			[Member1],
			[CancelReasonID],
			[CancelReason]	)
		SELECT
			cl.*
		,	ISNULL(cr.CancelReasonDescription, 'Unknown') AS 'CancelReason'
		FROM #ClientsLead cl
			LEFT OUTER JOIN [HCSQL2\SQL2005].[Infostore].dbo.CancelReason cr
				ON cl.CancelReasonID = cr.CancelReasonID
	END
	ELSE
	BEGIN
		INSERT INTO [#ClientCancels] (
			[CenterNum],
			[Center],
			[RegionID],
			[Region],
			[Client_No],
			[Gender],
			[GenderID],
			[RecordID],
			[First_Name],
			[Last_Name],
			[Address],
			[City],
			[State],
			[Zip],
			[Phone_Home],
			[Ethnicity],
			[EthnicityID],
			[Age],
			[AgeID],
			[MaritalStatus],
			[MaritalStatusID],
			[Email],
			[Membership],
			[CancelTrxDate],
			[Member1],
			[CancelReasonID],
			[CancelReason]	)
		SELECT
			cl.*
		,	ISNULL(cr.CancelReasonDescription, 'Unknown') AS 'CancelReason'
		FROM #ClientsLead cl
			INNER JOIN dbo.SplitCenterIDs(@CancelReasonIDs) sci
				ON cl.CancelReasonID = sci.CenterNumber
			LEFT OUTER JOIN [HCSQL2\SQL2005].[Infostore].dbo.CancelReason cr
				ON cl.CancelReasonID = cr.CancelReasonID
	END

	---------------------------------------------------------------------------------------------------------
	-- De-dupe the records on the #ClientLead table, taking just the MAX trx-date.
	SELECT
		CenterNum
	,	Center
	,	RegionID
	,	Region
	,	[Client_No]
	,	[Gender]
	,	[GenderID]
	,	[First_Name]
	,	[Last_Name]
	,	[Address]
	,	[City]
	,	[State]
	,	Zip
	,	[Phone_Home]
	,	[Membership]
	,	MAX(CAST([CancelTrxDate] AS DATETIME)) 'CancelTrxDate'
	INTO #DistinctClientCancels
	FROM [#ClientCancels]
	GROUP BY CenterNum
	,	Center
	,	RegionID
	,	Region
	,	[Client_No]
	,	[Gender]
	,	[GenderID]
	,	[First_Name]
	,	[Last_Name]
	,	[Address]
	,	[City]
	,	[State]
	,	Zip
	,	[Phone_Home]
	,	[Membership]

	---------------------------------------------------------------------------------------------------------
	-- Join the #DistinctClientCancels and #ClientCancels together (on CancelTrxDate) to get the Cancel Reason.
	SELECT DISTINCT
		d.CenterNum
	,	d.Center
	,	d.RegionID
	,	d.Region
	,	d.[Client_No]
	,	d.[Gender]
	,	d.[GenderID]
	,	c.[RecordID]
	,	d.[First_Name]
	,	d.[Last_Name]
	,	d.[Address]
	,	d.[City]
	,	d.[State]
	,	d.Zip
	,	d.[Phone_Home]
	,	d.[Membership]
	,	c.[Member1]
	,	d.[CancelTrxDate]
	,	c.CancelReasonID
	,	c.CancelReason
	INTO #FinalClientCancels
	FROM #DistinctClientCancels d
		INNER JOIN [#ClientCancels] c
			ON d.[CenterNum] = c.[CenterNum]
			AND d.[Client_No] = c.[Client_No]
			AND CAST(d.CancelTrxDate AS VARCHAR) = CAST(c.[CancelTrxDate] AS VARCHAR)

	---------------------------------------------------------------------------------------------------------
	-- Insert the records into the CampaignResults table.
	INSERT INTO CampaignResults (
		CampaignID
	,	Center
	,	CenterName
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
	,	Occupation
	,	Member1
	,	CancelTrxDate
	,	CancelReasonID
	,	CancelReason
	,	Ludwig
	,	Norwood	)
	SELECT DISTINCT
		@CampaignID
	,	cl.CenterNum
	,	cl.Center
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
	,	l.[Occupation]
	,	cl.Membership
	,	cl.CancelTrxDate
	,	cl.CancelReasonID
	,	cl.CancelReason
	,	l.Ludwig
	,	l.Norwood
	FROM [#FinalClientCancels] cl
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Lead] l
			ON cl.[RecordID] = l.[RecordID]

	-------------------------------------------------------------------------------------

	UPDATE CampaignNames
	SET CampaignName = RTRIM(CampaignName) + '_' + RTRIM(CAST(CampaignID AS VARCHAR))
	,	EndTime = GETDATE()
	WHERE CampaignID = @CampaignID

	SELECT
		@CampaignID 'CampaignID'
	,	Center
	,	CenterName
	,	Region
	,	ApptDate
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
	,	ISNULL(CancelReason, 'Unknown') 'CancelReason'
	,	CancelTrxDate
	,	CreationDate
	,	ContactID
	FROM CampaignResults
	WHERE CampaignID = @CampaignID

	---------------------------------------------------------------------------------------------------

END
GO
