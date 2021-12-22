/***********************************************************************

PROCEDURE:				selEmployeeByCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		11/18/10

LAST REVISION DATE: 	11/18/10

--------------------------------------------------------------------------------------------------------
NOTES:

		* 01/14/2011 - MLM:	Add Handling for Corporate, Franchise, And Joint Venture Groups
		* 01/25/2011 - MLM: Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
		* 01/26/2011 - MLM: Changed the Select to Select Distinct
		* 01/26/2011 - MLM: Added Parameter for IsSurgeryCenter
		* 02/25/2011 - MLM: Exclude Center 100 from corporate Centers Group
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selEmployeeByCenter '2'

***********************************************************************/

CREATE PROCEDURE [dbo].[selEmployeeByCenter]
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


	SELECT	 DISTINCT
			e.EmployeeGUID
			,e.CenterID
			,e.EmployeeFullNameCalc
	FROM	datEmployee e
		INNER JOIN [dbo].[fnGetCentersForUser](@User) c on E.CenterID = c.CenterID
	WHERE e.IsActiveFlag = 1
		AND  e.CenterID in (SELECT item from fnSplit(@CenterID, ','))
		AND  (@IsSurgeryCenter IS NULL OR c.IsSurgeryCenter = @IsSurgeryCenter )
	ORDER BY e.EmployeeFullNameCalc




END
