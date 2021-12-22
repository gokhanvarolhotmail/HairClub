/* CreateDate: 12/31/2010 13:21:07.060 , ModifyDate: 02/27/2017 09:49:28.193 */
GO
/***********************************************************************

PROCEDURE:				rptHairSystemTemplateDetail

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
		* 02/11/2011 - MLM: Added IncAll Parameters to 'Hack' around the Select All

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptHairSystemTemplateDetail NULL, NULL, '100,201','10,21,35','1,2,3,4,5,6,7', 1, NULL, NULL, NULL

***********************************************************************/

CREATE PROCEDURE [dbo].[rptHairSystemTemplateDetail]
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@CenterIDs nvarchar(MAX),
	@MembershipIDs nvarchar(MAX),
	@HairSystemIDs nvarchar(MAX),
	@IsDesignTemplate bit = NULL,
	@IsManualTemplate bit = NULL ,
	@IsMeasurementTemplate bit = NULL ,
	@IsSampleOrder bit = NULL,
	@IncAllMemberships bit = 1,
	@IncAllHairSystems bit = 1

AS
BEGIN
	SET NOCOUNT ON;

	IF (@StartDate IS NULL) SET @StartDate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(GETUTCDATE())-1),GETUTCDATE()),101)
	IF (@EndDate IS NULL) SET @EndDate = CONVERT(VARCHAR(25),GETUTCDATE(),101)


	DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'JV'

	SELECT cent.CenterDescriptionFullCalc
		,hso.ClientHomeCenterID as CenterID
		,hso.HairSystemOrderNumber
		,hsos.HairSystemOrderStatusID
		,hsos.HairSystemOrderStatusDescriptionShort
		,hso.HairSystemOrderDate
		,hs.HairSystemID
		,hs.HairSystemDescriptionShort
		,m.MembershipID
		,m.MembershipDescription
		,c.ClientGUID
		,c.ClientFullNameCalc
		,emp.EmployeeGUID AS MeasuredByGUID
		,emp.EmployeeInitials AS MeasuredBy
		,emp2.EmployeeGUID as OrderedByGUID
		,emp2.EmployeeInitials as OrderedBy
		,CASE WHEN hsdt.HairSystemDesignTemplateID IS NULL THEN CONVERT(BIT,0)
			ELSE CONVERT(BIT,1)
		 END AS IsDesignTemplate
		,hsdt.IsManualTemplateFlag
		,hsdt.IsMeasurementFlag
		,hso.IsSampleOrderFlag
	FROM dbo.datHairSystemOrder hso
	INNER JOIN dbo.lkpHairSystemOrderStatus hsos on hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	INNER JOIN dbo.cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID
	INNER JOIN dbo.datClient c on hso.ClientGUID = c.ClientGUID
	INNER JOIN dbo.datClientMembership cm on cm.ClientMembershipGUID = hso.ClientMembershipGUID
	INNER JOIN dbo.cfgMembership m on cm.MembershipID = m.MembershipID
	INNER JOIN dbo.cfgCenter cent on hso.ClientHomeCenterID = cent.CenterID
	LEFT OUTER JOIN datEmployee emp on hso.MeasurementEmployeeGUID = emp.EmployeeGUID
	LEFT OUTER JOIN datEmployee emp2 on hso.OrderedByEmployeeGUID = emp2.EmployeeGUID
	LEFT OUTER JOIN dbo.lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID
	WHERE hso.HairSystemOrderDate BETWEEN @StartDate AND @EndDate
		AND hso.ClientHomeCenterID in (SELECT item from fnSplit(@CenterIDs, ','))
		AND (@IncAllMemberships = 1 OR  m.MembershipID in (SELECT item from fnSplit(@MembershipIDs, ',')))
		AND (@IncAllHairSystems = 1 OR  hs.HairSystemID in (SELECT item from fnSplit(@HairSystemIDs, ',')))
		AND (@IsDesignTemplate IS NULL OR (hsdt.IsManualTemplateFlag = 0 AND hsdt.IsMeasurementFlag = 0) )
		AND (@IsManualTemplate IS NULL OR hsdt.IsManualTemplateFlag = 1)
		AND (@IsMeasurementTemplate IS NULL OR hsdt.IsMeasurementFlag = 1)
		AND (@IsSampleOrder IS NULL  OR hso.IsSampleOrderFlag = 1)
	ORDER BY c.ClientFullNameCalc, hso.ClientHomeCenterID, m.MembershipSortOrder, hs.HairSystemSortOrder, hso.HairSystemOrderDate

END
GO
