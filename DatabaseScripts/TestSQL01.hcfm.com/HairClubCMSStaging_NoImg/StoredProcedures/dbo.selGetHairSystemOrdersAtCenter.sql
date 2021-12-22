/* CreateDate: 12/07/2020 07:53:14.007 , ModifyDate: 03/01/2021 17:56:29.277 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE selGetHairSystemOrdersAtCenter
	-- Add the parameters for the stored procedure here
	@centerId int = null, --Allow null centers
	@startDate date,
	@endDate DATE,
	@isFailFlag BIT = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT hso.HairSystemOrderNumber as 'OrderNumber' , hso.CreateUser , nc.CreateDate, cen.CenterDescription, client.FirstName, client.LastName , status.HairSystemOrderStatusDescription as 'OrderState', nc.NotesClient as 'ClientNotes', concat(vendor.VendorDescriptionShort , ' - ', vendor.VendorDescription) as 'VendorDescription', hscm.ScoreCardMetricAnswer as 'QAAttributeValue', scm.ScoreCardMetricDescription as 'QAAttribute' FROM datHairSystemOrder hso
		JOIN datClientMembership clientm ON clientm.ClientMembershipGUID = hso.ClientMembershipGUID
		JOIN cfgMembership  mem ON mem.MembershipID = clientm.MembershipID
		JOIN datClient client ON client.ClientGUID = clientm.ClientGUID
		JOIN cfgCenter cen ON cen.CenterID = hso.CenterID
		JOIN lkpHairSystemOrderStatus status ON status.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		JOIN datNotesClient nc ON hso.HairSystemOrderGuid = nc.HairSystemOrderGuid
		JOIN cfgHairSystemVendorContractPricing AS hsVcp ON hso.HairSystemVendorContractPricingID = hsVcp.HairSystemVendorContractPricingID
		JOIN cfgHairSystemVendorContract AS hsVc ON hsVcp.HairSystemVendorContractID = hsVc.HairSystemVendorContractID
		JOIN cfgVendor AS vendor ON hsVc.VendorID = vendor.VendorID
		join datHairSystemOrderScorecard hscc on hscc.HairSystemOrderGUID= hso.HairSystemOrderGUID
		join datHairSystemOrderScorecardMetric hscm on hscm.HairSystemOrderScorecardID = hscc.HairSystemOrderScorecardID
		join lkpScoreCardMetric scm on hscm.ScoreCardMetricID=scm.ScoreCardMetricID
		join lkpScorecardCategory sc on hscc.ScorecardCategoryID = sc.ScorecardCategoryID
		where (status.HairSystemOrderStatusDescription = 'Received at Center' and sc.ScoreCardCategoryDescriptionShort like 'HairQA')
	     and nc.CreateDate >= @startDate and nc.CreateDate < dateadd(day, 1,@endDate) --Date range
		and cen.CenterID =isnull(@centerId,cen.CenterID) AND hscc.IsFailProcess = isnull(@isFailFlag,hscc.IsFailProcess)
		ORDER BY nc.NotesClientDate DESC , hso.HairSystemOrderNumber desc, scm.ScoreCardMetricDescription asc
END
GO
