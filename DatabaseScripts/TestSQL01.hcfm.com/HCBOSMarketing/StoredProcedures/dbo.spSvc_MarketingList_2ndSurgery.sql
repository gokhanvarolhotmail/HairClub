/* CreateDate: 01/02/2009 12:42:22.463 , ModifyDate: 12/07/2011 16:52:29.727 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spSvc_MarketingList_2ndSurgery
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		Alex Pasieka
--
-- Date Created:			12/31/2008
-- Date Implemented:
-- Date Last Modified:		12/31/2008
--
-- Destination Server:		HCSQL2\SQL2005
-- Destination Database:	BOSMarketing
-- Related Application:		N/A

================================================================================================
**NOTES**
	1/28/2009 -- AP -- Functionality added to allow user to select all corporate and franchise centers.
	2/02/2009 -- AP -- Added columns for Ludwig, Norwood, occupation to the final result set.
	2/3/2009  -- AP -- Add the CampaignID to the output, so it can be appended to the filename of the saved list.
	8/2/2010  -- MB -- Added ContactID to the output
================================================================================================

Sample Execution:

EXEC spSvc_MarketingList_2ndSurgery 'Test2ndSurgeryList', 'A test 2nd Surgery list.', 5, 'C', 'S', 'Male', '1', '1/1/2008', '12/1/2008', '1/1/2008', '12/1/2008', 'x', 'x', 'x', 'x', 'apasieka'
================================================================================================
-- GenderID Parameter Values:
-- 1 - Male
-- 2 - Female
================================================================================================*/

CREATE PROCEDURE [dbo].[spSvc_MarketingList_2ndSurgery]
	@CampaignName	VARCHAR(60)
,	@CampaignDescription VARCHAR(1000)
,	@ListID		SMALLINT
,	@CenterType	CHAR(1)
,	@Center	VARCHAR(1000)
,	@Gender	VARCHAR(10)
,	@GenderID	TINYINT
,	@SurStartDate SMALLDATETIME
,	@SurEndDate	SMALLDATETIME
,	@SurpostStartDate SMALLDATETIME
,	@SurpostEndDate	SMALLDATETIME
,	@DoNotCall	CHAR(1)
,	@DoNotMail	CHAR(1)
,	@DoNotContact CHAR(1)
,	@DoNotEmail	CHAR(1)
,	@Username	VARCHAR(40)
AS
DECLARE
	@EndSurDateTime SMALLDATETIME
,	@EndSurpostDateTime	SMALLDATETIME
,	@CampaignID	INT
,	@GenderIDToExclude TINYINT

BEGIN
	SET @EndSurDateTime = DATEADD(mi, -1, DATEADD(dd, 1, @SurEndDate))
	SET @EndSurpostDateTime = DATEADD(mi, -1, DATEADD(dd, 1, @SurpostEndDate))

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

	----------------------------------------------------------------------------------------------
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
	,	Param_SurStartDate
	,	Param_SurEndDate
	,	Param_SurpostStartDate
	,	Param_SurpostEndDate
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
	,	@SurStartDate
	,	@SurEndDate
	,	@SurpostStartDate
	,	@SurpostEndDate
	,	@DoNotCall
	,	@DoNotMail
	,	@DoNotContact
	,	@DoNotEmail
	,	GETDATE()	)

	------------------------------------------------------------------------------------------------------
	-- Get the CampaignID for the newly created CampaignName record.
	SELECT @CampaignID = @@IDENTITY

	-- Create temp table to hold the records with a SURPOST code from the Source_TransactionsSurgery table.
	CREATE TABLE #SurpostRecords (
		CenterNum	SMALLINT
	,	Client_No	INT
	,	Date	SMALLDATETIME
	,	MemberNo INT	)

	-- Create temp table to hold the SURPOST records that are for a first-time surgery client (i.e.,
	-- records with either a 0 or NULL value in the Member_No column).
	CREATE TABLE [#Transactions] (
		CenterNum	SMALLINT
	,	Client_No	INT
	,	SurDate		SMALLDATETIME
	,	SurpostDate	SMALLDATETIME	)

/*
	--------------------------------------------------------------------------------------------------------
	-- Insert the records from the Client table into the temp table created above.
	-- By Center ---------------------------------------------------------------------------------------
	IF (@CenterType = 'C')
	BEGIN
		IF (@Center NOT IN ('C', 'F', 'S', 'FS', 'AC'))
		BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum]
			,	[Client_No]
			,	[SurDate]
			,	[SurpostDate])
			SELECT CTR.CenterSSID
			,	CL.ClientIdentifier
			,	SURG.OrderDate AS 'SurgeryDate'
			,	CLM.ClientMembershipBeginDate AS 'SaleDate'
			FROM SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
				INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_ENT_DDS_vwDimCenter CTR
					ON SURG.ClientHomeCenterKey = CTR.CenterKey
				INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_vwDimSalesCode SC
					ON sc.SalesCodeKey = SURG.SalesCodeKey
				INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_DimClient CL
					ON SURG.ClientKey = CL.ClientKey
				INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_vwDimClientMembership CLM
					ON SURG.ClientMembershipkey = CLM.ClientMembershipkey
				INNER JOIN dbo.SplitCenterIDs(@Center) sci
					ON CTR.CenterSSID = sci.CenterNumber
			WHERE SURG.SalesCodeKey in (481)
				AND SURG.OrderDate BETWEEN @SurpostStartDate AND @SurpostEndDate
		END
		IF (@Center IN ('C', 'F', 'S', 'FS'))
		BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum]
			,	[Client_No]
			,	[SurDate]
			,	[SurpostDate])
			SELECT CTR.CenterSSID
			,	CL.ClientIdentifier
			,	SURG.OrderDate AS 'SurgeryDate'
			,	CLM.ClientMembershipBeginDate AS 'SaleDate'
			FROM dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
				INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR
					ON SURG.ClientHomeCenterKey = CTR.CenterKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCode SC
					ON sc.SalesCodeKey = SURG.SalesCodeKey
				INNER JOIN dbo.synHC_CMS_DDS_DimClient CL
					ON SURG.ClientKey = CL.ClientKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM
					ON SURG.ClientMembershipkey = CLM.ClientMembershipkey
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
					ON CTR.CenterSSID = c.[Center_Num]
			WHERE SURG.SalesCodeKey in (481)
				AND SURG.OrderDate BETWEEN @SurpostStartDate AND @SurpostEndDate
				AND c.[type] = @Center
		END
		IF (@Center IN ('AC'))
		BEGIN
			INSERT INTO [#Transactions] (
				[CenterNum]
			,	[Client_No]
			,	[SurDate]
			,	[SurpostDate])
			SELECT CTR.CenterSSID
			,	CL.ClientIdentifier
			,	SURG.OrderDate AS 'SurgeryDate'
			,	CLM.ClientMembershipBeginDate AS 'SaleDate'
			FROM dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
				INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR
					ON SURG.ClientHomeCenterKey = CTR.CenterKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCode SC
					ON sc.SalesCodeKey = SURG.SalesCodeKey
				INNER JOIN dbo.synHC_CMS_DDS_DimClient CL
					ON SURG.ClientKey = CL.ClientKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM
					ON SURG.ClientMembershipkey = CLM.ClientMembershipkey
				INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
					ON CTR.CenterSSID = c.[Center_Num]
			WHERE SURG.SalesCodeKey in (481)
				AND SURG.OrderDate BETWEEN @SurpostStartDate AND @SurpostEndDate
				AND c.[type] IN ('S', 'FS')
		END
	END

	-- By Region ------------------------------------------------------------------------------
	IF (@CenterType = 'R')
	BEGIN
		INSERT INTO [#Transactions] (
			[CenterNum]
		,	[Client_No]
		,	[SurDate]
		,	[SurpostDate])
		SELECT CTR.CenterSSID
		,	CL.ClientIdentifier
		,	SURG.OrderDate AS 'SurgeryDate'
		,	CLM.ClientMembershipBeginDate AS 'SaleDate'
		FROM SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
			INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_ENT_DDS_vwDimCenter CTR
				ON SURG.ClientHomeCenterKey = CTR.CenterKey
			INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_vwDimSalesCode SC
				ON sc.SalesCodeKey = SURG.SalesCodeKey
			INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_DimClient CL
				ON SURG.ClientKey = CL.ClientKey
			INNER JOIN SQL06.HC_BI_Reporting.dbo.synHC_CMS_DDS_vwDimClientMembership CLM
				ON SURG.ClientMembershipkey = CLM.ClientMembershipkey
			INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
				ON CTR.CenterSSID = c.[Center_Num]
			INNER JOIN dbo.SplitCenterIDs(@Center) sci
				ON c.[RegionID] = sci.CenterNumber
		WHERE SURG.SalesCodeKey in (481)
			AND SURG.OrderDate BETWEEN @SurpostStartDate AND @SurpostEndDate
	END

	--------------------------------------------------------------------------------------------------------
	-- Join the #Transactions temp table with the Source_Client_Profile table in order to get the HomeCenter
	-- and HomeID columns, which will be used to join to the Client, Completion, and Lead tables.
	SELECT
		t.CenterNum
	,	t.Client_No
	,	t.SurDate
	,	t.SurpostDate
	,	scp.HomeCenter
	,	scp.HomeID
	INTO #HomeCenter
	FROM [#Transactions] t
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Source_Client_Profile] scp
			ON t.[CenterNum] = scp.[Center]
			AND t.[Client_No] = scp.[Client_no]
	WHERE scp.HomeID != 0
	AND scp.HomeID IS NOT NULL
	AND scp.HomeCenter != 0
	AND scp.HomeCenter IS NOT NULL

	----------------------------------------------------------------------------------------------------
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
	,	hc.SurDate
	,	hc.SurpostDate
	INTO #Clients
	FROM [HCWH1\SQL2005].[Warehouse].dbo.[Client] cl
		INNER JOIN [#HomeCenter] hc
			ON cl.[Center] = hc.[HomeCenter]
			AND cl.[Client_no] = hc.[HomeID]
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
			ON cl.Center = c.[Center_Num]
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblRegion] r
			ON c.[RegionID] = r.[RegionID]
	WHERE cl.[GenderID] != @GenderIDToExclude

	----------------------------------------------------------------------------------------------
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

	-----------------------------------------------------------------------------------------------
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
	,	Member1
	,	Ludwig
	,	Norwood
	,	Occupation	)
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
	,	cl.Membership
	,	l.[Ludwig]
	,	l.[Norwood]
	,	l.[Occupation]
	FROM [#ClientsComp] cl
		INNER JOIN [HCWH1\SQL2005].[Warehouse].dbo.[Lead] l
			ON cl.[RecordID] = l.[RecordID]
	WHERE ISNULL(l.cst_do_not_Mail, 'N') != @DoNotMail
		AND ISNULL(l.do_not_solicit, 'N') != @DoNotContact
		AND ISNULL(l.cst_do_not_call, 'N') != @DoNotCall
		AND ISNULL(l.Email, 'N') != @DoNotEmail

	-----------------------------------------------------------------------------------------

	UPDATE CampaignNames
	SET CampaignName = RTRIM(CampaignName) + '_' + RTRIM(CAST(CampaignID AS VARCHAR))
	,	EndTime = GETDATE()
	WHERE CampaignID = @CampaignID

	SELECT
		@CampaignID 'CampaignID'
	,	Center
	,	CenterName
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
	,	ContactID
	FROM CampaignResults
	WHERE CampaignID = @CampaignID

*/
END
GO
