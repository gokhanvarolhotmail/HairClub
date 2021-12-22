/***********************************************************************

PROCEDURE:				selReportParameterCount

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		02/11/11

LAST REVISION DATE: 	02/11/11

--------------------------------------------------------------------------------------------------------
NOTES:

		* 02/11/2011 - MLM:	Initial Creation
		* 02/25/2011 - MLM: Exclude Center 100 from corporate Centers Group

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selReportParameterCount '2'

***********************************************************************/

CREATE PROCEDURE [dbo].[selReportParameterCount]
	@CenterID nvarchar(MAX),
	@EmployeeGUID varchar(36),
	@IsSurgeryCenter BIT

AS
BEGIN
	SET NOCOUNT ON;

	--GET THE UserLogin
	DECLARE @User varchar(100)
	SELECT @User = UserLogin FROM dbo.datEmployee WHERE EmployeeGUID = @EmployeeGUID

	DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'JV'

-- Add Corporate CenterIDs to List
IF EXISTS(SELECT item from fnSplit(@CenterID, ',') WHERE item = 1)
	BEGIN
		Select @CenterID = COALESCE(@CenterID  + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
	END

-- Add Franchise CenterIDs to List
IF EXISTS(SELECT item from fnSplit(@CenterID, ',') WHERE item = 2)
	BEGIN
		Select @CenterID = COALESCE(@CenterID + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @FranchiseCenterTypeID
	END

-- Add JointVenture CenterIDs to List
IF EXISTS(SELECT item from fnSplit(@CenterID, ',') WHERE item = 3)
	BEGIN
		Select @CenterID = COALESCE(@CenterID + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @JointVentureCenterTypeID
	END


	-- Declare the Counts
	DECLARE @EmployeeCount integer
	DECLARE @MembershipCount integer
	DECLARE @HairSystemCount integer

	SELECT	@EmployeeCount = COUNT(*)
	FROM	datEmployee e
		INNER JOIN [dbo].[fnGetCentersForUser](@User) c on E.CenterID = c.CenterID
	WHERE e.IsActiveFlag = 1
		AND  e.CenterID in (SELECT item from fnSplit(@CenterID, ','))
		AND  (@IsSurgeryCenter IS NULL OR c.IsSurgeryCenter = @IsSurgeryCenter )


	SELECT @MembershipCount = COUNT(*)
	FROM            cfgMembership


	Select @HairSystemCount = COUNT(*)
	FROM cfgHairSystem
	WHERE IsActiveFlag = 1


	SELECT @MembershipCount as MembershipCnt,
		@EmployeeCount as EmployeeCnt,
		@HairSystemCount as HairSystemCnt



END
