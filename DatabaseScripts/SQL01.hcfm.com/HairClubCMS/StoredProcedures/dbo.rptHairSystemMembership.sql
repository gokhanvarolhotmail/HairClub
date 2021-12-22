/***********************************************************************

PROCEDURE:				rptHairSystemMembership

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		11/18/10

LAST REVISION DATE: 	11/18/10

--------------------------------------------------------------------------------------------------------
NOTES:

01/14/2011 - MLM - Add Handling for Corporate, Franchise, And Joint Venture Groups
01/25/2011 - MLM - Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
02/11/2011 - MLM - Added IncAll Parameters to 'Hack' around the Select All
02/25/2011 - MLM - Exclude Center 100 from corporate Centers Group
03/01/2011 - MLM - Removed MeasuredBy and EnteredBy
10/18/2017 - RMH - Added GROUP BY to remove duplicates
05/22/2018 - RMH - (#146745) Added MembershipStatus and MembershipEndDate

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptHairSystemMembership NULL, NULL, '804','10,21,35','1,2,3,4,5,6,7','F9D17F0A-96D2-476E-AE9F-A3A353F975D0'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptHairSystemMembership]
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
		Select @CenterIDs = COALESCE(@CenterIDs  + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @CorpCenterTypeID  AND IsCorporateHeadquartersFlag = 0
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


SELECT hso.HairSystemOrderGUID
,	hso.ClientHomeCenterID as CenterID
,	center.CenterDescriptionFullCalc
,	hso.HairSystemOrderNumber
,	hsos.HairSystemOrderStatusID
,	hsos.HairSystemOrderStatusDescriptionShort
,	hso.HairSystemOrderDate
,	hs.HairSystemSortOrder
,	hs.HairSystemID
,	hs.HairSystemDescriptionShort
,	m.MembershipID
,	m.MembershipDescription
,	m.MembershipSortOrder
,	c.ClientGUID
,	c.ClientFullNameCalc
,	emp.EmployeeGUID AS MeasuredByGUID
,	 emp.EmployeeFullNameCalc
,	emp.EmployeeInitials AS 'MeasuredBy'
,	emp2.EmployeeGUID as 'OrderedByGUID'
,	emp2.EmployeeInitials as 'OrderedBy'
,	COALESCE(hsotCurrent.HairSystemOrderTransactionDate,hso.CreateDate) AS 'CurrentStatusDate'
,	COALESCE(hsosCurrent.HairSystemOrderStatusDescriptionShort,hsos.HairSystemOrderSTatusDescriptionShort) AS 'CurrentStatusDescription'
,	cm.EndDate
,	cm.ClientMembershipStatusID
,	CMS.ClientMembershipStatusDescription
FROM dbo.datHairSystemOrder hso
	INNER JOIN dbo.lkpHairSystemOrderStatus hsos on hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	INNER JOIN dbo.cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID
	INNER JOIN dbo.datClient c on hso.ClientGUID = c.ClientGUID
	INNER JOIN dbo.datClientMembership cm on cm.ClientMembershipGUID = hso.ClientMembershipGUID
	INNER JOIN dbo.cfgMembership m on cm.MembershipID = m.MembershipID
	INNER JOIN dbo.lkpClientMembershipStatus CMS ON CMS.ClientMembershipStatusID = cm.ClientMembershipStatusID
	INNER JOIN dbo.cfgCenter center on hso.ClientHomeCenterID = center.CenterID
	INNER JOIN [dbo].[fnGetCentersForUser](@User) ctr ON ctr.CenterID = center.CenterID
	LEFT OUTER JOIN datEmployee emp on hso.MeasurementEmployeeGUID = emp.EmployeeGUID
	LEFT OUTER JOIN datEmployee emp2 on hso.OrderedByEmployeeGUID = emp2.EmployeeGUID
	LEFT OUTER JOIN [dbo].datHairSystemOrderTransaction hsotCurrent ON hso.HairSystemOrderGUID = hsotCurrent.HairSystemOrderGUID AND
		hsotCurrent.NewHairSystemOrderStatusID = hso.HairSystemOrderStatusID AND
		hsotCurrent.NewHairSystemOrderStatusID <> ISNULL(hsotCurrent.PreviousHairSystemOrderStatusID,999) AND
		hsotCurrent.HairSystemOrderTransactionDate = (SELECT MAX(HairSystemOrderTransactionDate) FROM dbo.datHairSystemOrderTransaction
		WHERE NewHairSystemOrderStatusID = hso.HairSystemOrderStatusID and hso.HairSystemOrderGUID = HairSystemOrderGUID and
			NewHairSystemOrderStatusID <> ISNULL(hsotCurrent.PreviousHairSystemOrderStatusID,999))
	LEFT OUTER JOIN [dbo].lkpHairSystemOrderStatus hsosCurrent ON hsotCurrent.NewHairSystemOrderStatusID = hsosCurrent.HairSystemOrderStatusID
WHERE hso.HairSystemOrderDate BETWEEN @StartDate AND @EndDate
	AND center.CenterID IN (SELECT item from fnSplit(@CenterIDs, ','))
	AND (@IncAllMemberships = 1 OR  m.MembershipID in (SELECT item from fnSplit(@MembershipIDs, ',')))
	AND (@IncAllHairSystems = 1 OR  hs.HairSystemID in (SELECT item from fnSplit(@HairSystemIDs, ',')))
GROUP BY COALESCE(hsotCurrent.HairSystemOrderTransactionDate ,hso.CreateDate)
,	COALESCE(hsosCurrent.HairSystemOrderStatusDescriptionShort
,	hsos.HairSystemOrderSTatusDescriptionShort)
,	hso.HairSystemOrderGUID
,	hso.ClientHomeCenterID
,	center.CenterDescriptionFullCalc
,	hso.HairSystemOrderNumber
,	hsos.HairSystemOrderStatusID
,	hsos.HairSystemOrderStatusDescriptionShort
,	hso.HairSystemOrderDate
,	hs.HairSystemSortOrder
,	hs.HairSystemID
,	hs.HairSystemDescriptionShort
,	m.MembershipID
,	m.MembershipDescription
,	m.MembershipSortOrder
,	c.ClientGUID
,	c.ClientFullNameCalc
,	emp.EmployeeGUID
,	emp.EmployeeFullNameCalc
,	emp.EmployeeInitials
,	emp2.EmployeeGUID
,	emp2.EmployeeInitials
,	cm.EndDate
,	cm.ClientMembershipStatusID
,	CMS.ClientMembershipStatusDescription
--ORDER BY m.MembershipSortOrder, hs.HairSystemSortOrder, hso.HairSystemOrderDate, emp.EmployeeFullNameCalc --Move this sort to the report


END
