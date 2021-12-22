/***********************************************************************
PROCEDURE:				extCommissionCheckHSOForPriorityStatus
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2017
DESCRIPTION:			Uses HSO Number to check for Priority Status
------------------------------------------------------------------------
NOTES:

	09/14/2017	SAL	Updated to return CenterDescriptionFullCalc AS 'Center'
						and updated GROUP BY

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extCommissionCheckHSOForPriorityStatus 4330713
***********************************************************************/
CREATE PROCEDURE [dbo].[extCommissionCheckHSOForPriorityStatus]
(
	@HairSystemOrderNumber INT
)
AS
BEGIN

SET NOCOUNT ON;


SELECT  ctr.CenterDescriptionFullCalc AS 'Center'
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' +  clt.LastName + ', ' + clt.FirstName AS 'Client'
,		hso.HairSystemOrderNumber
,       MIN(dbo.GetLocalFromUTC(hst.HairSystemOrderTransactionDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag)) AS 'HairSystemOrderTransactionDate'
,		sf.HairSystemOrderStatusDescription AS 'StatusFrom'
,		st.HairSystemOrderStatusDescription AS 'StatusTo'
INTO	#PriorityHair
FROM    datHairSystemOrder hso WITH ( NOLOCK )
        INNER JOIN datHairSystemOrderTransaction hst WITH ( NOLOCK )
            ON hst.HairSystemOrderGUID = hso.HairSystemOrderGUID
        INNER JOIN datClient clt WITH ( NOLOCK )
            ON clt.ClientGUID = hst.ClientGUID
        INNER JOIN cfgCenter ctr WITH ( NOLOCK )
            ON ctr.CenterID = hst.CenterID
        INNER JOIN lkpTimeZone tz WITH ( NOLOCK )
            ON tz.TimeZoneID = ctr.TimeZoneID
        INNER JOIN lkpHairSystemOrderStatus sf WITH ( NOLOCK ) --Status From
            ON hst.PreviousHairSystemOrderStatusID = sf.HairSystemOrderStatusID
        INNER JOIN lkpHairSystemOrderStatus st WITH ( NOLOCK ) --Status To
            ON hst.NewHairSystemOrderStatusID = st.HairSystemOrderStatusID
		INNER JOIN lkpHairSystemOrderProcess hsp
			ON hsp.HairSystemOrderProcessID = hst.HairSystemOrderProcessID
WHERE   ( sf.HairSystemOrderStatusDescriptionShort <> 'PRIORITY' AND st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
		AND ( sf.HairSystemOrderStatusDescriptionShort <> st.HairSystemOrderStatusDescriptionShort )
		AND hsp.HairSystemOrderProcessDescriptionShort <> 'XFERREJ'
		AND hso.HairSystemOrderNumber = @HairSystemOrderNumber
GROUP BY ctr.CenterDescriptionFullCalc
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' +  clt.LastName + ', ' + clt.FirstName
,		hso.HairSystemOrderNumber
,		sf.HairSystemOrderStatusDescription
,		st.HairSystemOrderStatusDescription


SELECT  TOP 1
		*
FROM    #PriorityHair PH
ORDER BY PH.HairSystemOrderTransactionDate DESC

END
