/* CreateDate: 12/31/2010 13:21:07.047 , ModifyDate: 02/27/2017 09:49:30.073 */
GO
/***********************************************************************

PROCEDURE:				rptREDOAndRepairAnalysis

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
		* 01/25/2011 - MLM: Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
		* 02/11/2011 - MLM: Added IncAll Parameters to 'Hack' around the Select All
		* 02/25/2011 - MLM: Exclude Center 100 from corporate Centers Group
		* 03/02/2011 - MLM: Removed MeasuredBy and OrderedBy

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptREDOAndRepairAnalysis NULL, NULL, '100,201','10,21,35','1,2,3,4,5,6,7'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptREDOAndRepairAnalysis]
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
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

	IF (@StartDate IS NULL) SET @StartDate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(GETUTCDATE())-1),GETUTCDATE()),101)
	IF (@EndDate IS NULL) SET @EndDate = CONVERT(VARCHAR(25),GETUTCDATE(),101)


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


	SELECT cent.CenterDescriptionFullCalc
		,hso.ClientHomeCenterID as CenterID
		,hso.HairSystemOrderNumber
		,hso.IsRedoOrderFlag
		,hso.IsRepairOrderFlag
	FROM dbo.datHairSystemOrder hso
		INNER JOIN dbo.cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID
		INNER JOIN dbo.datClient c on hso.ClientGUID = c.ClientGUID
		INNER JOIN dbo.datClientMembership cm on cm.ClientMembershipGUID = hso.ClientMembershipGUID
		INNER JOIN dbo.cfgMembership m on cm.MembershipID = m.MembershipID
		INNER JOIN dbo.cfgCenter cent on hso.ClientHomeCenterID = cent.CenterID
		INNER JOIN [dbo].[fnGetCentersForUser](@User) ctr ON ctr.CenterID = cent.CenterID
		LEFT OUTER JOIN datEmployee emp on hso.MeasurementEmployeeGUID = emp.EmployeeGUID
		LEFT OUTER JOIN datEmployee emp2 on hso.OrderedByEmployeeGUID = emp2.EmployeeGUID
		LEFT OUTER JOIN dbo.lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID
	WHERE hso.HairSystemOrderDate BETWEEN @StartDate AND @EndDate
		AND cent.CenterID IN (SELECT item from fnSplit(@CenterIDs, ','))
		AND (@IncAllMemberships = 1 OR  m.MembershipID in (SELECT item from fnSplit(@MembershipIDs, ',')))
		AND (@IncAllHairSystems = 1 OR  hs.HairSystemID in (SELECT item from fnSplit(@HairSystemIDs, ',')))
	ORDER BY hso.ClientHomeCenterID, hso.HairSystemOrderDate, m.MembershipSortOrder, hs.HairSystemSortOrder


END
GO
