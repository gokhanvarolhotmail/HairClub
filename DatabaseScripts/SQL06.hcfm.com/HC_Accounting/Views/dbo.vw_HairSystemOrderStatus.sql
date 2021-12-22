CREATE VIEW [dbo].[vw_HairSystemOrderStatus]
AS
SELECT  DHSO.HairSystemOrderNumber
,		CTR.CenterID
,       CTR.CenterNumber
,		CTR.CenterDescriptionFullCalc AS 'CenterDescription'
,		CT.CenterTypeDescriptionShort AS 'CenterType'
,       DHSOT.ClientHomeCenterID
,       CLT.ClientIdentifier AS 'ClientIdentifier'
,       CLT.LastName AS 'LastName'
,       CLT.FirstName AS 'FirstName'
,       CM.MembershipDescription AS 'Membership'
,       DATEADD(HOUR, CASE WHEN LTZ.[UsesDayLightSavingsFlag] = 0 THEN ( LTZ.[UTCOffset] )
                           WHEN DATEPART(WK, DHSOT.HairSystemOrderTransactionDate) <= 10
                                OR DATEPART(WK, DHSOT.HairSystemOrderTransactionDate) >= 45 THEN ( LTZ.[UTCOffset] )
                           ELSE ( ( LTZ.[UTCOffset] ) + 1 )
                      END, DHSOT.HairSystemOrderTransactionDate) AS 'HairSystemOrderTransactionDate'
,       SF.HairSystemOrderStatusDescription AS 'StatusFrom'
,       ST.HairSystemOrderStatusDescription AS 'StatusTo'
,		HSO_ST.HairSystemOrderStatusDescription AS 'CurrentStatus'
,		ISNULL(LHSOPR.HairSystemOrderPriorityReasonDescription, '') AS 'PriorityReason'
,		DHSO.CostContract
,		DHSO.CostActual
,		DHSO.CostFactoryShipped
,       DHSOT.LastUpdate
,       DHSOT.LastUpdateUser
,		DHSOT.CreateDate
,		DHSOT.CreateUser
FROM    SQL05.HairClubCMS.dbo.datHairSystemOrderTransaction DHSOT
        INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemOrder DHSO
            ON DHSO.HairSystemOrderGUID = DHSOT.HairSystemOrderGUID
        INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter CTR
            ON CTR.CenterID = DHSOT.CenterID
		INNER JOIN SQL05.HairClubCMS.dbo.lkpCenterType CT
			ON CT.CenterTypeID = CTR.CenterTypeID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpTimeZone LTZ
            ON LTZ.TimeZoneID = CTR.TimeZoneID
        INNER JOIN SQL05.HairClubCMS.dbo.datClient CLT
            ON DHSOT.ClientGUID = CLT.ClientGUID
        INNER JOIN SQL05.HairClubCMS.dbo.datClientMembership DCM
            ON DHSOT.ClientMembershipGUID = DCM.ClientMembershipGUID
        INNER JOIN SQL05.HairClubCMS.dbo.cfgMembership CM
            ON DCM.MembershipID = CM.MembershipID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderProcess LHSOP
            ON DHSOT.HairSystemOrderProcessID = LHSOP.HairSystemOrderProcessID
		INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderStatus HSO_ST
			ON HSO_ST.HairSystemOrderStatusID = DHSO.HairSystemOrderStatusID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderStatus SF --Status From
            ON DHSOT.PreviousHairSystemOrderStatusID = SF.HairSystemOrderStatusID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderStatus ST --Status To
            ON DHSOT.NewHairSystemOrderStatusID = ST.HairSystemOrderStatusID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderPriorityReason LHSOPR
			ON LHSOPR.HairSystemOrderPriorityReasonID = DHSOT.HairSystemOrderPriorityReasonID
WHERE	DHSOT.HairSystemOrderTransactionDate >= '1/1/2013'
