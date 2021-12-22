/*===============================================================================================
-- Procedure Name:			rptCreditAndRefusal
-- Procedure Description:
--
-- Created By:				Mike Maass
-- Implemented By:			Mike Maass
-- Last Modified By:		Mike Maass
--
-- Date Created:			6/23/2011
-- Date Implemented:		6/23/2011
-- Date Last Modified:		6/30/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
	* 6/23/11 MLM - Initial Creation
	* 6/30/11 AMH - Added Date Filter
	* 1/13/12 MVT - Modified to exclude Repair credits/refusals by excluding
					Hair Orders with a Charge Decision specified.
	* 1/26/12 HDu - Added Factory Code to output(Trackit #71037)

--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC rptCreditAndRefusal
	@StartDate = '2011-08-01',
	@EndDate = '2012-01-01',
	@CenterIDs = '1',
	@MembershipIDs ='1,2,3,4,5,42,43,44,45',
	@HairSystemIDs = '1,2,3,4,5,6,7,8,9,10',
	@CreditDecision = '1',
	@EmployeeGUID = 'F923F21A-66DA-4ACF-9AC0-96191447B327',
	@IncAllMemberships = 1,
	@IncAllHairSystems = 1
================================================================================================*/
CREATE PROCEDURE [dbo].[rptCreditAndRefusal](
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@CenterIDs nvarchar(MAX),
	@MembershipIDs nvarchar(MAX),
	@HairSystemIDs nvarchar(MAX),
	@CreditDecision int,
	@EmployeeGUID varchar(36),
	@IncAllMemberships bit = 1,
	@IncAllHairSystems bit = 1)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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

	-- Output results
	SELECT [Orders].HairSystemOrderNumber AS 'HairSystemOrderNumber'
	,	[HairSystem].HairSystemDescriptionShort AS 'SystemTypeCode'
	,	[HairSystemDesignTemplate].HairSystemDesignTemplateDescription AS 'TemplateSize'
	,	[HairSystemHairLength].HairSystemHairLengthDescriptionShort AS 'HairLength'
	,	RTRIM([Center].CenterDescriptionFullCalc) AS 'Center'
	,   [Client].[ClientFullNameCalc] as 'Client'
	,   CASE WHEN [Orders].RequestForCreditAcceptedDate IS NOT NULL THEN 'Accepted'
			WHEN [Orders].RequestForCreditDeclinedDate IS NOT NULL THEN 'Refused'
			ELSE 'Unknown'
		END As CreditDecisionDescription
	,   ISNULL([Orders].RequestForCreditAcceptedDate,[Orders].RequestForCreditDeclinedDate) as CreditDecisionDate
	,   m.MembershipID
	,	m.MembershipDescription
	, v.VendorDescriptionShort
	FROM datHairSystemOrder [Orders]
		INNER JOIN lkpHairSystemHairLength [HairSystemHairLength]
			ON [Orders].HairSystemHairLengthID = [HairSystemHairLength].HairSystemHairLengthID
		INNER JOIN lkpHairSystemDesignTemplate [HairSystemDesignTemplate]
			ON [Orders].HairSystemDesignTemplateID = [HairSystemDesignTemplate].HairSystemDesignTemplateID
		INNER JOIN cfgHairSystem [HairSystem]
			ON [Orders].HairSystemID = [HairSystem].HairSystemID
		INNER JOIN lkpHairSystemOrderStatus [HairSystemOrderStatus]
			ON [Orders].HairSystemOrderStatusID = [HairSystemOrderStatus].HairSystemOrderStatusID
		INNER JOIN cfgCenter [Center]
			ON [Orders].ClientHomeCenterID = [Center].CenterID
		INNER JOIN [dbo].[fnGetCentersForUser](@User) ctr
			ON ctr.CenterID = center.CenterID
		INNER JOIN datClient [Client]
			ON [Orders].ClientGUID = [Client].ClientGUID
		INNER JOIN datClientMembership [cm]
			ON [Orders].ClientMembershipGUID = [cm].ClientMembershipGUID
		INNER JOIN cfgMembership [m]
			ON [cm].MembershipID = [m].MembershipID
		LEFT JOIN dbo.datPurchaseOrderDetail pod ON [Orders].HairSystemOrderGUID = pod.HairSystemOrderGUID
		LEFT JOIN dbo.datPurchaseOrder po ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
		LEFT JOIN dbo.cfgVendor v ON v.VendorID = po.VendorID
	WHERE --[Orders].ChargeDecisionID IS NOT NULL
		 (
			(@CreditDecision = 1 AND ([Orders].RequestForCreditAcceptedDate IS NOT NULL OR [Orders].RequestForCreditDeclinedDate IS NOT NULL) )
			 OR (@CreditDecision = 2 AND [Orders].RequestForCreditAcceptedDate IS NOT NULL )
			 OR (@CreditDecision = 3 AND [Orders].RequestForCreditDeclinedDate IS NOT NULL)
		)
		 AND [Orders].ChargeDecisionID IS NULL
		 AND center.CenterID IN (SELECT item from fnSplit(@CenterIDs, ','))
		 AND (@IncAllMemberships = 1 OR  m.MembershipID in (SELECT item from fnSplit(@MembershipIDs, ',')))
		 AND (@IncAllHairSystems = 1 OR  orders.HairSystemID in (SELECT item from fnSplit(@HairSystemIDs, ',')))
		 AND ([Orders].RequestForCreditAcceptedDate BETWEEN @StartDate AND @EndDate
			OR [Orders].RequestForCreditDeclinedDate BETWEEN @StartDate AND @EndDate)
	ORDER BY [Orders].CenterID
	,	[Client].ClientNumber_Temp
	,	[HairSystem].HairSystemDescriptionShort

END
