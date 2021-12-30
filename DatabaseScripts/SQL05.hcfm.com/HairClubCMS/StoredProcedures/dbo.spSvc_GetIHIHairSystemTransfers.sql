/* CreateDate: 03/26/2021 10:05:45.973 , ModifyDate: 06/02/2021 14:13:27.003 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetIHIHairSystemTransfers
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/26/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetIHIHairSystemTransfers
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetIHIHairSystemTransfers]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, CURRENT_TIMESTAMP)) +1, 0))


SELECT	ctr_Prv.CenterDescriptionFullAlt1Calc AS 'PreviousCenterDescription'
,		ct_Prv.CenterTypeDescription AS 'PreviousCenterTypeDescription'
,		ctr_Hso.CenterDescriptionFullAlt1Calc AS 'ToCenterDescription'
,		ct_Hso.CenterTypeDescription AS 'ToCenterTypeDescription'
,		ctr_h.CenterDescriptionFullAlt1Calc AS 'CurrentCenterDescription'
,		hso.HairSystemOrderNumber
,		chs.HairSystemDescriptionShort AS 'SystemType'
,		ctr_Clt.CenterDescriptionFullAlt1Calc AS 'ClientHomeCenterDescription'
,		clt.ClientIdentifier AS 'ClientIdentifier'
,		REPLACE(clt.LastName, ',', '') AS 'LastName'
,		REPLACE(clt.FirstName, ',', '') AS 'FirstName'
,		m.MembershipDescription
,		hso.HairSystemOrderDate
,		hst.HairSystemOrderTransactionDate
,		sf.HairSystemOrderStatusDescriptionShort AS 'StatusFrom'
,		st.HairSystemOrderStatusDescriptionShort AS 'StatusTo'
,		cst.HairSystemOrderStatusDescriptionShort AS 'CurrentStatus'
,		hso.CostContract
,		hso.CostActual
,		hso.CostFactoryShipped
,		hso.CenterPrice
FROM	datHairSystemOrderTransaction hst
		INNER JOIN cfgCenter ctr_Hso
			ON ctr_Hso.CenterID = hst.CenterID
		INNER JOIN lkpCenterType ct_Hso
			ON ct_Hso.CenterTypeID = ctr_Hso.CenterTypeID
		INNER JOIN cfgCenter ctr_Clt
			ON ctr_Clt.CenterID = hst.ClientHomeCenterID
		INNER JOIN datHairSystemOrder hso
			ON hso.HairSystemOrderGUID = hst.HairSystemOrderGUID
		INNER JOIN cfgHairSystem chs
			ON chs.HairSystemID = hso.HairSystemID
		INNER JOIN datClient clt
			ON clt.ClientGUID = hst.ClientGUID
		INNER JOIN datClientMembership cm
			ON cm.ClientMembershipGUID = hst.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = cm.MembershipID
		INNER JOIN lkpHairSystemOrderProcess hsp
			ON hsp.HairSystemOrderProcessID = hst.HairSystemOrderProcessID
		INNER JOIN lkpHairSystemOrderStatus sf --Status From
			ON sf.HairSystemOrderStatusID = hst.PreviousHairSystemOrderStatusID
		INNER JOIN lkpHairSystemOrderStatus st --Status To
			ON st.HairSystemOrderStatusID = hst.NewHairSystemOrderStatusID
		INNER JOIN lkpHairSystemOrderStatus cst
			ON cst.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		LEFT OUTER JOIN cfgCenter ctr_h
			ON ctr_h.CenterID = hso.CenterID
		LEFT OUTER JOIN cfgCenter ctr_Prv
			ON ctr_Prv.CenterID = hst.PreviousCenterID
		LEFT OUTER JOIN lkpCenterType ct_Prv
			ON ct_Prv.CenterTypeID = ctr_Prv.CenterTypeID
WHERE	hst.HairSystemOrderTransactionDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
		AND sf.HairSystemOrderStatusDescriptionShort = 'XferReq'
		AND ctr_Prv.CenterNumber = 341
ORDER BY hst.HairSystemOrderTransactionDate

END
GO
