/***********************************************************************
PROCEDURE:				spRpt_NewBusinessPipeline
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_NewBusinessPipeline
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		04/06/2015
------------------------------------------------------------------------
NOTES:

Clients will show on the report until they convert or

1. 12 months since NB1 App Date, or
2. 18 months since Sales Date if no NB1 App Date


04/29/2015 - RH - Added line AND appt.IsDeletedFlag = 0 to Checkup query (#114232)
05/14/2015 - DL - Rewrote stored procedure. A backup of the original stored procedure has been saved (#114339)
09/18/2015 - RH - Added code to find Total Checkups -- CKU24G,CKU3DAYG,CKUG,CKUPREG (Hair Care and Styling Lessons)
10/23/2015 - RH - Added checkups to the Total Checkups, added FirstSalonVisitDate (#119869)


------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewBusinessPipeline '211', '3, 4, 5, 10, 45, 46, 47, 48, 55, 56'
EXEC spRpt_NewBusinessPipeline '292', '48'
EXEC spRpt_NewBusinessPipeline '211', '1'
EXEC spRpt_NewBusinessPipeline '212', '48, 55, 56'
***********************************************************************/
CREATE PROCEDURE [dbo].[xxx_spRpt_NewBusinessPipeline]
(
	@CenterID NVARCHAR(MAX),
	@MembershipSSIDs NVARCHAR(MAX)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @Today DATETIME


SET @StartDate = DATEADD(MONTH, -18,(CAST(CAST(DATEPART(MONTH, GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(DATEPART(YEAR, GETUTCDATE()) AS VARCHAR(4)) AS DATE))) --18 months ago
SET @EndDate = GETUTCDATE()
SET @Today = (DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Memberships ( MembershipSSID INT )


/********************************** Get list of centers *************************************/
INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
				AND DC.Active = 'Y'


INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				AND DC.Active = 'Y'


DELETE C FROM #Centers C WHERE C.CenterSSID NOT IN ( SELECT SplitValue FROM dbo.fnSplit(@CenterID, ',') )


/********************************** Get list of memberships *************************************/
IF @MembershipSSIDs = '1'  --ALL
BEGIN
	SET @MembershipSSIDs = '3, 4, 5, 10, 45, 46, 47, 48, 55, 56'
END


INSERT  INTO #Memberships
        SELECT  SplitValue
        FROM    dbo.fnSplit(@MembershipSSIDs, ',')


/********************************** Get list of NB1 memberships for specified center(s) *************************************/
SELECT  C.MainGroupID AS 'RegionSSID'
,       C.MainGroup AS 'RegionDescription'
,       C.CenterSSID
,       C.CenterDescription AS 'CenterDescriptionNumber'
,       DCM.ClientSSID
,       DCM.ClientKey
,       DCM.ClientIdentifier
,       DCM.ClientName AS 'ClientFullName'
,       DCM.ClientMembershipSSID
,       DCM.ClientMembershipKey
,       DCM.SiebelID AS 'BosleySiebelID'
,       DCM.Membership AS 'MembershipDescription'
,       DCM.ContractPrice AS 'ClientMembershipContractPrice'
,       DCM.ContractPaidAmount AS 'ClientMembershipContractPaidAmount'
,       ( DCM.ContractPrice - DCM.ContractPaidAmount ) AS 'ContractBalance'
,		DCM.MembershipBeginDate
,		DCM.MembershipEndDate
INTO    #Clients
FROM    #Centers C
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) DCM
WHERE   DCM.MembershipSSID IN ( SELECT M.MembershipSSID FROM #Memberships M )
        AND DCM.RevenueGroupSSID = 1
        AND DCM.BusinessSegmentSSID = 1
		AND DCM.MembershipStatus <> 'Cancel'

--SELECT 'Clients' AS TableName, * FROM #Clients C


/********************************** Get initial sale data for NB1 clients *************************************/
SELECT  C.RegionSSID
,       C.RegionDescription
,       C.CenterSSID
,       C.CenterDescriptionNumber
,       C.ClientSSID
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       C.BosleySiebelID
,       C.MembershipDescription
,       Sale.SaleDate
,		Sale.ExpectedConversionDate
,       Sale.EmployeeInitials
,       Sale.Consultant
,       C.ClientMembershipSSID
,       C.ClientMembershipKey
,       C.ClientMembershipContractPrice
,       C.ClientMembershipContractPaidAmount
,       C.ContractBalance
,		Sale.NB_TradCnt
,		Sale.NB_GradCnt
INTO	#InitialSale
FROM    #Clients C
        CROSS APPLY ( SELECT TOP 1
                                FST.ClientKey
                      ,         FST.ClientMembershipKey
                      ,         DD.FullDate AS 'SaleDate'
					  ,			CLT.ExpectedConversionDate
                      ,         PFR.EmployeeInitials
                      ,         PFR.EmployeeFullName AS 'Consultant'
					  ,			FST.NB_TradCnt
					  ,			FST.NB_GradCnt
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                                    ON FST.OrderDateKey = DD.DateKey
								INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									ON CLT.ClientKey = FST.ClientKey
								INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
									ON DSC.SalesCodeKey = FST.SalesCodeKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
                                    ON FST.SalesOrderKey = DSO.SalesOrderKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                                    ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
                                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
                                    ON FST.Employee1Key = PFR.EmployeeKey
                                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
                                    ON FST.Employee2Key = STY.EmployeeKey
                      WHERE     FST.ClientKey = C.ClientKey
                                AND DCM.ClientMembershipKey = C.ClientMembershipKey
                                AND DSC.SalesCodeKey IN ( 467, 497, 676, 1723 ) -- INITASG, NEWMEM, GUARANTEE, TXFRIN
                      ORDER BY  DSO.OrderDate ASC
                    ) Sale


--SELECT 'InitialSale' AS TableName, * FROM #InitialSale ISA


/******************* Find the Last Payment Date **************************************************/
SELECT	C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName
,		MAX(DD.FullDate) AS 'LastPaymentDate'
INTO	#LastPayment
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DSC.SalesCodeDepartmentSSID = 2020
GROUP BY C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName


--SELECT 'LastPayment' AS TableName, * FROM #LastPayment LP

/******************* Find the First Salon Visit Date **************************************************/
SELECT	C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName
,		MIN(DD.FullDate) AS 'FirstSalonVisitDate'
INTO	#FirstSalonVisitDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DD.FullDate >= @StartDate
		AND DSC.SalesCodeDescriptionShort IN('SVCPCP','SVCSOL')
GROUP BY C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName

--SELECT '#FirstSalonVisitDate' AS TableName, * FROM #FirstSalonVisitDate


/********************************** Get Hair Order Information *************************************/
;
WITH    HairOrder_CTE
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hso.ClientKey ORDER BY hso.ClientKey, hso.HairSystemOrderDate ASC ) AS RowNumber
               ,        ce.CenterSSID
               ,        hso.ClientKey
			   ,		ISA.ClientIdentifier
			   ,		ISA.ClientFullName
               ,        hso.ClientHomeCenterKey
               ,        hso.HairSystemOrderDate
               ,        hso.HairSystemOrderNumber
               ,        hso.HairSystemAppliedDate
               ,        hso.HairSystemDueDate
               ,        hso.ClientMembershipKey
               ,        m.MembershipDescription
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder hso
                        INNER JOIN #InitialSale ISA
                            ON hso.ClientKey = ISA.ClientKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
                            ON ce.CenterKey = hso.CenterKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                            ON hso.ClientMembershipKey = cm.ClientMembershipKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                            ON cm.MembershipKey = m.MembershipKey
             )
     SELECT ho_cte.RowNumber
     ,      ho_cte.CenterSSID
     ,      ho_cte.ClientKey
	 ,      ho_cte.ClientIdentifier
	 ,      ho_cte.ClientFullName
     ,      ho_cte.ClientHomeCenterKey
     ,      ho_cte.HairSystemOrderDate
     ,      ho_cte.HairSystemOrderNumber
     ,      ho_cte.HairSystemAppliedDate
     ,      ho_cte.HairSystemDueDate
     ,      ho_cte.ClientMembershipKey
     ,      ho_cte.MembershipDescription
     INTO   #HairOrder
     FROM   HairOrder_CTE ho_cte
     WHERE  ho_cte.RowNumber = 1


--SELECT 'HairOrders' AS TableName, *  FROM #HairOrder HO


/********************************** Get the Next Appointment **************/
SELECT  C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName
,		MIN(DA.AppointmentDate) AS 'NextAppointment'
INTO    #NextAppointment
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
		INNER JOIN #Clients C
			ON C.ClientKey = DA.ClientKey
WHERE   DA.AppointmentDate > GETDATE()
        AND DA.IsDeletedFlag <> 1
GROUP BY C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName


--SELECT 'NextAppointment' AS TableName, * FROM #NextAppointment NA


/********************************** Get Total Number of CheckUp Visits *************************************/

SELECT  q.ClientKey
,       q.ClientIdentifier
,	COUNT(*) AS 'TotalCheckups'
INTO    #TotalCheckups
FROM  (
		SELECT C.ClientKey
		,	C.ClientIdentifier
		,	DSC.SalesCodeDescriptionShort
		,	DA.AppointmentDate
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
			INNER JOIN #Clients C
				ON DA.ClientSSID = C.ClientSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
				ON DA.AppointmentKey = FAD.AppointmentKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
				ON FAD.SalesCodeKey = DSC.SalesCodeKey
		WHERE   DSC.SalesCodeDescriptionShort IN('CKUPRE','CKU24','CKU3','CKUPREG','CKU24G','CKU3DAYG','CKU','CKUG')
				AND DA.IsDeletedFlag = 0
				AND DA.AppointmentDate BETWEEN C.MembershipBeginDate AND C.MembershipEndDate
				AND DA.AppointmentDate < GETDATE()
		)q
GROUP BY  q.ClientKey
        , q.ClientIdentifier

/********************************** Get Services Data *************************************/

/*
	648 - Initial New Style (NB1A)
	667	- Checkup - Membership
	727	- Checkup - 24 Hour
	728	- Checkup - Pre Check
	830 - Checkup - 3 day
*/

SELECT  C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       DE.EmployeeInitials
,       CASE DSC.SalesCodeDescriptionShort
          WHEN 'NB1A' THEN 'NB1App'
          WHEN 'CKUPRE' THEN 'PRECHECK'
		  WHEN 'CKUPREG' THEN 'PRECHECK'
          WHEN 'CKU24' THEN 'CHECK24'
		  WHEN 'CKU24G' THEN 'CHECK24'
          WHEN 'CKU3DAY' THEN 'CKU3DAY'
		  WHEN 'CKU3DAYG' THEN 'CKU3DAY'
        END AS 'DateCol'
,       DA.AppointmentDate AS 'DateColVal'
,       DA.CheckoutTime AS 'DateColVal2'
INTO    #Services
FROM    SQL05.HairClubCMS.dbo.datAppointment DA
        INNER JOIN SQL05.HairClubCMS.dbo.datAppointmentDetail DAD
            ON DAD.AppointmentGUID = DA.AppointmentGUID
        INNER JOIN #Clients C
            ON DA.ClientGUID = C.ClientSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON DAD.SalesCodeID = DSC.SalesCodeSSID
        INNER JOIN SQL05.HairClubCMS.dbo.datAppointmentEmployee DAE
            ON DAE.AppointmentGUID = DA.AppointmentGUID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
            ON DE.EmployeeSSID = DAE.EmployeeGUID
WHERE (SalesCodeDescriptionShort LIKE 'CK%'
		OR SalesCodeDescriptionShort = 'NB1A')
		AND SalesCodeDescriptionShort NOT IN ('CKUD','CKUN') --Checkup Doctor, Medical Assistant
        AND DA.IsDeletedFlag = 0


--SELECT 'Services' AS TableName, * FROM #Services SS


/********************************** Pivot Data *************************************/
SELECT	S.ClientKey
,       S.ClientIdentifier
,		S.ClientFullName
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'NB1App' THEN S.DateColVal ELSE NULL END), 101) AS 'NB1AppDate'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'NB1App' THEN S.DateColVal2 ELSE NULL END), 101) AS 'NB1AppOut'
,		MAX(CASE S.DateCol WHEN 'NB1App' THEN S.EmployeeInitials ELSE '' END) AS 'NB1AppStylist'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'PRECHECK' THEN S.DateColVal ELSE NULL END), 101) AS 'PreCheckDate'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'PRECHECK' THEN S.DateColVal2 ELSE NULL END), 101) AS 'PreCheckOut'
,		MAX(CASE S.DateCol WHEN 'PRECHECK' THEN S.EmployeeInitials ELSE '' END) AS 'PreCheckStylist'
,		CONVERT(VARCHAR, MAX(CASE S.DateCol WHEN 'CHECK24' THEN S.DateColVal ELSE NULL END), 101) AS 'Check24Date'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'CHECK24' THEN S.DateColVal2 ELSE NULL END), 101) AS 'Check24Out'
,		MAX(CASE S.DateCol WHEN 'CHECK24' THEN S.EmployeeInitials ELSE '' END) AS 'Check24Stylist'
,		CONVERT(VARCHAR, MAX(CASE S.DateCol WHEN 'CKU3DAY' THEN S.DateColVal ELSE NULL END), 101) AS 'CKU3DAYDate'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'CKU3DAY' THEN S.DateColVal2 ELSE NULL END), 101) AS 'CKU3DAYOut'
,		MAX(CASE S.DateCol WHEN 'CKU3DAY' THEN S.EmployeeInitials ELSE '' END) AS 'CKU3DAYStylist'
INTO	#Pivot
FROM	#Services S
GROUP BY S.ClientKey
,       S.ClientIdentifier
,		S.ClientFullName


--SELECT 'Pivot' AS TableName, * FROM #Pivot P


/********************************** Combine Data *************************************/
SELECT  ISA.Consultant
,       ISA.EmployeeInitials
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       C.MembershipDescription
,       C.BosleySiebelID
,       ISA.SaleDate
,       C.ClientMembershipContractPrice
,       C.ClientMembershipContractPaidAmount
,       C.ContractBalance
,       P.PreCheckDate
,       P.PreCheckOut
,       P.PreCheckStylist
,       P.CKU3DAYDate
,       P.CKU3DAYOut
,       P.CKU3DAYStylist
,       P.NB1AppDate
,       P.NB1AppOut
,       P.NB1AppStylist
,       P.Check24Date
,       P.Check24Out
,       P.Check24Stylist
,       NA.NextAppointment
,       HO.HairSystemOrderDate
,       HO.HairSystemOrderNumber
,       HO.HairSystemDueDate
,       C.RegionSSID
,       C.RegionDescription
,       C.CenterDescriptionNumber
,       HO.CenterSSID
,       HO.ClientHomeCenterKey
,       HO.HairSystemAppliedDate
,       ISA.ExpectedConversionDate
,       LP.LastPaymentDate
,		ISA.NB_TradCnt
,		ISA.NB_GradCnt
,		TC.TotalCheckups
,		FSV.FirstSalonVisitDate
INTO    #Results
FROM    #Clients C
		LEFT OUTER JOIN #InitialSale ISA
			ON ISA.ClientKey = C.ClientKey
        LEFT JOIN #LastPayment LP
			ON LP.ClientKey = C.ClientKey
        LEFT JOIN #HairOrder HO
			ON HO.ClientKey = C.ClientKey
        LEFT JOIN #NextAppointment NA
			ON NA.ClientKey = C.ClientKey
		LEFT JOIN #TotalCheckups TC
			ON C.ClientKey = TC.ClientKey
		LEFT JOIN #Pivot P
			ON P.ClientKey = C.ClientKey
		LEFT JOIN #FirstSalonVisitDate FSV
			ON FSV.ClientKey = C.ClientKey


--SELECT 'Results' AS TableName, * FROM #Results R


/********************************** Display Results *************************************/
SELECT  R.Consultant
,       R.EmployeeInitials
,       R.ClientKey
,       R.ClientIdentifier
,       R.ClientFullName
,       R.MembershipDescription
,       R.BosleySiebelID
,       R.SaleDate
,       R.ClientMembershipContractPrice
,       R.ClientMembershipContractPaidAmount
,       R.ContractBalance
,       CAST(R.PreCheckDate AS DATETIME) AS 'PreCheckDate'
,       R.PreCheckOut
,       CASE WHEN R.PreCheckOut IS NULL
                  AND R.PreCheckDate >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.PreCheckOut IS NULL
                  AND R.PreCheckDate < @Today THEN 'Past_Not_co'
             WHEN R.PreCheckOut IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'PreCheckOutStatus'
,       R.PreCheckStylist
,       CAST(R.CKU3DAYDate AS DATETIME) AS 'CKU3DAYDate'
,       R.CKU3DAYOut
,       CASE WHEN R.CKU3DAYOut IS NULL
                  AND R.CKU3DAYDate >= @Today THEN 'Future_Not_co'
             WHEN R.CKU3DAYOut IS NULL
                  AND R.CKU3DAYDate < @Today THEN 'Past_Not_co'
             WHEN R.CKU3DAYOut IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'CKU3DAYOutStatus'
,       R.CKU3DAYStylist
,       CAST(R.NB1AppDate AS DATETIME) AS 'NB1AppDate'
,       R.NB1AppOut
,       CASE WHEN R.NB1AppOut IS NULL
                  AND R.NB1AppDate >= @Today THEN 'Future_Not_co'
             WHEN R.NB1AppOut IS NULL
                  AND R.NB1AppDate < @Today THEN 'Past_Not_co'
             WHEN R.NB1AppOut IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'NB1AppOutStatus'
,       R.NB1AppStylist
,       CAST(R.Check24Date AS DATETIME) AS 'Check24Date'
,       R.Check24Out
,       CASE WHEN R.Check24Out IS NULL
                  AND R.Check24Date >= @Today THEN 'Future_Not_co'
             WHEN R.Check24Out IS NULL
                  AND R.Check24Date < @Today THEN 'Past_Not_co'
             WHEN R.Check24Out IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'Check24OutStatus'
,       R.Check24Stylist
,       R.NextAppointment
,       R.HairSystemOrderDate
,       R.HairSystemOrderNumber
,       R.HairSystemDueDate
,       R.RegionSSID
,       R.RegionDescription
,       R.CenterDescriptionNumber
,       R.CenterSSID
,       R.ClientHomeCenterKey
,       R.HairSystemAppliedDate
,       CONVERT(VARCHAR(11), R.ExpectedConversionDate, 101) AS 'ExpectedConversionDate'
,       R.LastPaymentDate
,		R.NB_TradCnt
,		R.NB_GradCnt
,		ISNULL(R.TotalCheckups,0) AS 'TotalCheckups'
,		R.FirstSalonVisitDate
FROM    #Results R
WHERE   ( R.NB1AppDate IS NOT NULL AND CAST(R.NB1AppDate AS DATETIME) > DATEADD(MONTH, -12, @Today) ) --12 months since NB1A
		OR ( R.NB1AppDate IS NULL AND R.SaleDate BETWEEN @StartDate AND @EndDate ) --18 months since Sale
GROUP BY R.Consultant
,       R.EmployeeInitials
,       R.ClientKey
,       R.ClientIdentifier
,       R.ClientFullName
,       R.MembershipDescription
,       R.BosleySiebelID
,       R.SaleDate
,       R.ClientMembershipContractPrice
,       R.ClientMembershipContractPaidAmount
,       R.ContractBalance
,       R.PreCheckDate
,       R.PreCheckOut
,       R.PreCheckStylist
,       R.CKU3DAYDate
,       R.CKU3DAYOut
,       R.CKU3DAYStylist
,       R.NB1AppDate
,       R.NB1AppOut
,       R.NB1AppStylist
,       R.Check24Date
,       R.Check24Out
,       R.Check24Stylist
,       R.NextAppointment
,       R.HairSystemOrderDate
,       R.HairSystemOrderNumber
,       R.HairSystemDueDate
,       R.RegionSSID
,       R.RegionDescription
,       R.CenterDescriptionNumber
,       R.CenterSSID
,       R.ClientHomeCenterKey
,       R.HairSystemAppliedDate
,       R.ExpectedConversionDate
,       R.LastPaymentDate
,		R.NB_TradCnt
,		R.NB_GradCnt
,		ISNULL(R.TotalCheckups,0)
,		R.FirstSalonVisitDate

END
