/* CreateDate: 12/31/2010 13:21:07.083 , ModifyDate: 02/27/2017 09:49:27.867 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptHairSystemOrderStatus

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		11/18/10

LAST REVISION DATE: 	11/18/10

--------------------------------------------------------------------------------------------------------
NOTES:

		* 01/14/2011 - MLM	Add Handling for Corporate, Franchise, And Joint Venture Groups
		* 01/21/2011 - MLM  Changed the join on HairSystemOrder from CenterID to ClientHomeCenterID
		* 01/25/2011 - MLM: Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
		* 02/11/2011 - MLM: Added IncAll Parameters to 'Hack' around the Select All
		* 02/25/2011 - MLM: Exclude Center 100 from corporate Centers Group
		* 03/02/2011 - MLM: Removed Measuredby and EnteredBy
		* 09/19/2011 - HDu: WO#66920 Added Center Full description to report and Total
		* 02/22/2016 - RLM: (#123160) Changed join for ClientMembershipGUID to HairSystemOrderTransaction

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptHairSystemOrderStatus NULL, NULL, '1,2,3,4,5,6,7,8,9,10','288','45,46,47,48,50','1,2,3,4,5,6,7,8,9,10', null, 1,1

***********************************************************************/

CREATE PROCEDURE [dbo].[rptHairSystemOrderStatus]
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@HairSystemOrderStatusIDs nvarchar(MAX),
	@CenterIDs nvarchar(MAX),
	@MembershipIDs nvarchar(MAX),
	@HairSystemIDs nvarchar(MAX),
	@EmployeeGUID varchar(36),
	@IncAllMemberships bit = 1,
	@IncAllHairSystems bit = 1

AS
BEGIN
	SET NOCOUNT ON;

	--GET THE UserLogin
	DECLARE @User varchar(100)
	SELECT @User = UserLogin FROM dbo.datEmployee WHERE EmployeeGUID = @EmployeeGUID

	--SET @User = 'aptak'

	IF (@StartDate IS NULL) SET @StartDate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(GETUTCDATE())-1),GETUTCDATE()),101) --beginning of the month
	IF (@EndDate IS NULL) SET @EndDate = CONVERT(VARCHAR(25),GETUTCDATE(),101)  --Today

	--Set EndDate to the Next day for Selection purpose
	SET @EndDate = DATEADD(day, 1, @EndDate)

	DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'JV'

	-- Add Corporate CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIDs, ',') WHERE item = 1)
		BEGIN
			Select @CenterIDs = COALESCE(@CenterIDs  + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
		END

	-- Add Franchise CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIDs, ',') WHERE item = 2)
		BEGIN
			Select @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @FranchiseCenterTypeID
		END

	-- Add JointVenture CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterIDs, ',') WHERE item = 3)
		BEGIN


			Select @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @JointVentureCenterTypeID
		END

	DECLARE @ProcessID_Imported int
    SELECT @ProcessID_Imported = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'IMPORTED'

	SELECT DISTINCT hso.HairSystemOrderGUID
		,hsot.ClientHomeCenterID as CenterID
		,hso.HairSystemOrderNumber
		,hsos.HairSystemOrderStatusID
		,hsos.HairSystemOrderStatusDescriptionShort
		,hsos.HairSystemOrderStatusSortOrder
		,DATEADD(dd, 0, DATEDIFF(dd, 0,hsot.HairSystemOrderTransactionDate)) as HairSystemOrderTransactionDate
		,hs.HairSystemID
		,hs.HairSystemDescriptionShort
		,m.MembershipID
		,m.MembershipDescription
		,c.ClientGUID
		,c.ClientFullNameCalc
		,emp.EmployeeGUID AS MeasuredByGUID
		,emp.EmployeeInitials AS MeasuredBy
		,emp2.EmployeeGUID as OrderByGUID
		,emp2.EmployeeInitials as OrderedBy
		,COALESCE(hsosCurrent.HairSystemOrderStatusDescriptionShort,hsos.HairSystemOrderSTatusDescriptionShort) AS CurrentStatusDescription
		,COALESCE(hsotCurrent.HairSystemOrderTransactionDate, hso.CreateDate) As CurrentStatusDate
		,HomeCenter.CenterDescriptionFullCalc CenterDescriptionFullCalc

	FROM dbo.datHairSystemOrderTransaction hsot
	INNER JOIN dbo.cfgCenter HomeCenter ON HomeCenter.CenterID = hsot.ClientHomeCenterID
	INNER JOIN dbo.datHairSystemOrder hso on hsot.HairSystemOrderGUID = hso.HairSystemOrderGUID
	INNER JOIN dbo.lkpHairSystemOrderStatus hsos on hsot.NewHairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	INNER JOIN dbo.cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID
	INNER JOIN dbo.datClient c on hsot.ClientGUID = c.ClientGUID
	--INNER JOIN dbo.datClientMembership cm on cm.ClientMembershipGUID = hso.ClientMembershipGUID
	INNER JOIN dbo.datClientMembership cm on cm.ClientMembershipGUID = hsot.ClientMembershipGUID
	INNER JOIN dbo.cfgMembership m on cm.MembershipID = m.MembershipID
	INNER JOIN [dbo].[fnGetCentersForUser](@User) ctr ON ctr.CenterID = hsot.ClientHomeCenterID
	LEFT OUTER JOIN [dbo].datHairSystemOrderTransaction hsotCurrent ON hso.HairSystemOrderGUID = hsotCurrent.HairSystemOrderGUID AND
		hsotCurrent.NewHairSystemOrderStatusID = hso.HairSystemOrderStatusID AND
		hsotCurrent.NewHairSystemOrderStatusID <> hsotCurrent.PreviousHairSystemOrderStatusID AND
		hsotCurrent.HairSystemOrderTransactionDate = (SELECT MAX(HairSystemOrderTransactionDate) FROM dbo.datHairSystemOrderTransaction
			WHERE NewHairSystemOrderStatusID = hso.HairSystemOrderStatusID and hso.HairSystemOrderGUID = HairSystemOrderGUID and
				NewHairSystemOrderStatusID <> PreviousHairSystemOrderStatusID)
	LEFT OUTER JOIN [dbo].lkpHairSystemOrderStatus hsosCurrent ON hsotCurrent.NewHairSystemOrderStatusID = hsosCurrent.HairSystemOrderStatusID
	LEFT OUTER JOIN datEmployee emp on hso.MeasurementEmployeeGUID = emp.EmployeeGUID
	LEFT OUTER JOIN datEmployee emp2 on hso.OrderedByEmployeeGUID = emp2.EmployeeGUID
	WHERE ISNULL(hsot.PreviousHairSystemOrderStatusID,999) <> hsot.NewHairSystemOrderStatusID -- Only retrieving Status Changes
		AND hsot.HairSystemOrderProcessID <> @ProcessID_Imported -- Exclude Imported Orders
		AND hsot.HairSystemOrderTransactionDate BETWEEN @StartDate AND @EndDate
		AND ctr.CenterID IN (SELECT item from fnSplit(@CenterIDs, ','))
		AND hsos.HairSystemOrderStatusID in (SELECT item from fnSplit(@HairSystemOrderStatusIDs, ','))
		AND (@IncAllMemberships = 1 OR  m.MembershipID in (SELECT item from fnSplit(@MembershipIDs, ',')))
		AND (@IncAllHairSystems = 1 OR  hs.HairSystemID in (SELECT item from fnSplit(@HairSystemIDs, ',')))

	ORDER BY  c.ClientFullNameCalc, hsot.ClientHomeCenterID, hsos.HairSystemOrderStatusSortOrder, HairSystemOrderTransactionDate, hso.HairSystemOrderNumber


END
GO
