/* CreateDate: 06/27/2011 20:28:28.153 , ModifyDate: 02/27/2017 09:49:26.543 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptCreditDecision
-- Procedure Description:
--
-- Created By:				Mike Maass
-- Implemented By:			Mike Maass
-- Last Modified By:		Mike Maass
--
-- Date Created:			2/25/2011
-- Date Implemented:		2/25/2011
-- Date Last Modified:		6/30/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

Sample Execution:

EXEC rptCreditDecision

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
	* 2/2/11 MLM - Initial Creation
	* 3/1/11 MLM - Added BeginDate, EndDate, And CreditDecisionIds Parameters
	* 6/30/11 AMH - Added StartDate and EndDate Filter

--------------------------------------------------------------------------------------------------------
================================================================================================*/
CREATE PROCEDURE [dbo].[rptCreditDecision](
@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@CenterIDs nvarchar(MAX),
	@MembershipIDs nvarchar(MAX),
	@HairSystemIDs nvarchar(MAX),
	@CreditDecisionIDs nvarchar(max),
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
	,   [CD].ChargeDecisionDescription As CreditDecisionDescription
	,   ISNULL([Orders].RequestForCreditAcceptedDate,[Orders].RequestForCreditDeclinedDate) as CreditDecisionDate
	,   m.MembershipID
	,	m.MembershipDescription
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
		INNER JOIN lkpChargeDecision [cd]
			ON [Orders].ChargeDecisionID = [cd].[ChargeDecisionID]
		INNER JOIN datClientMembership [cm]
			ON [Orders].ClientMembershipGUID = [cm].ClientMembershipGUID
		INNER JOIN cfgMembership [m]
			ON [cm].MembershipID = [m].MembershipID
	WHERE [Orders].ChargeDecisionID IN (SELECT item from fnSplit(@CreditDecisionIDs, ','))
		 AND center.CenterID IN (SELECT item from fnSplit(@CenterIDs, ','))
		 AND (@IncAllMemberships = 1 OR  m.MembershipID in (SELECT item from fnSplit(@MembershipIDs, ',')))
		 AND (@IncAllHairSystems = 1 OR  orders.HairSystemID in (SELECT item from fnSplit(@HairSystemIDs, ',')))
		 AND (([Orders].RequestForCreditAcceptedDate IS NOT NULL AND [Orders].RequestForCreditAcceptedDate BETWEEN @StartDate AND @EndDate)
		OR ([Orders].RequestForCreditDeclinedDate IS NOT NULL AND [Orders].RequestForCreditDeclinedDate BETWEEN @StartDate AND @EndDate))
	ORDER BY [Orders].CenterID
	,   [CD].ChargeDecisionDescription
	,	[Client].ClientNumber_Temp
	,	[HairSystem].HairSystemDescriptionShort


END
GO
