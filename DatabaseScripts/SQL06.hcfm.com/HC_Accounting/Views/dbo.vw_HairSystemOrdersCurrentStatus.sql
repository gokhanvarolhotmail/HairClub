CREATE VIEW [dbo].[vw_HairSystemOrdersCurrentStatus]
AS
SELECT  ctr_hso.CenterID
,		ctr_hso.CenterNumber
,		ctr_hso.CenterDescriptionFullCalc AS 'CenterDescription'
,		ct_hso.CenterTypeDescription AS 'CenterType'
,		ctr_clt.CenterID AS 'ClientHomeCenterID'
,		ctr_clt.CenterNumber AS 'ClientHomeCenterNumber'
,		ctr_clt.CenterDescriptionFullCalc AS 'ClientHomeCenterDescription'
,		ct_clt.CenterTypeDescription AS 'ClientHomeCenterType'
,       clt.ClientIdentifier
,		clt.ClientFullNameCalc AS 'ClientName'
,		rg.RevenueGroupDescription AS 'RevenueGroup'
,		bs.BusinessSegmentDescription AS 'BusinessSegment'
,       m.MembershipDescription AS 'Membership'
,		cm.BeginDate
,		cm.EndDate
,		cms.ClientMembershipStatusDescription AS 'ClientMembershipStatus'
,		hso.HairSystemOrderNumber
,		hso.CostContract
,		hso.CostActual
,		hso.CostFactoryShipped
,       HSOS.HairSystemOrderStatusDescription AS 'HairSystemOrderStatus'
FROM    SQL05.HairClubCMS.dbo.datHairSystemOrder hso
        INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter ctr_hso
            ON ctr_hso.CenterID = hso.CenterID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpCenterType ct_hso
			ON ct_hso.CenterTypeID = ctr_hso.CenterTypeID
        INNER JOIN SQL05.HairClubCMS.dbo.datClient clt
            ON clt.ClientGUID = hso.ClientGUID
        INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter ctr_clt
            ON ctr_clt.CenterID = clt.CenterID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpCenterType ct_clt
			ON ct_clt.CenterTypeID = ctr_clt.CenterTypeID
        INNER JOIN SQL05.HairClubCMS.dbo.datClientMembership cm
            ON cm.ClientMembershipGUID = hso.ClientMembershipGUID
		INNER JOIN SQL05.HairClubCMS.dbo.lkpClientMembershipStatus cms
			ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
        INNER JOIN SQL05.HairClubCMS.dbo.cfgMembership m
            ON m.MembershipID = cm.MembershipID
		INNER JOIN SQL05.HairClubCMS.dbo.lkpRevenueGroup rg
			ON rg.RevenueGroupID = m.RevenueGroupID
		INNER JOIN SQL05.HairClubCMS.dbo.lkpBusinessSegment bs
			ON bs.BusinessSegmentID = m.BusinessSegmentID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderStatus hsos
			ON hsos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
