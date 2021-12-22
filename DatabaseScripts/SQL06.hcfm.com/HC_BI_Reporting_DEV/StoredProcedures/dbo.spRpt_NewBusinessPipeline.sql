/* CreateDate: 10/23/2015 13:46:43.230 , ModifyDate: 02/19/2020 14:44:27.347 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
10/26/2015 - RH - Added Seven Day, Fourteen Day and Twentyone Day Checkups (#119869) and OPENQUERY
11/19/2015 - RH - Corrected change to NB1A - not populating (WO#120649)
09/28/2016 - RH - Added a large CASE statement to find stylists that do not match - in the first 4 appointments; Added CancelledClients to find expired and cancelled clients (#129374)
01/05/2017 - RH - Removed OPENQUERY to find App data (#132688)
01/12/2017 - RH - Changed vwDimCenter in #Centers query, Changed ClientIdentifier to ClientKey in the #Appt/#Service queries (#134605)
01/20/2017 - RH - Find appointment data from SQL05 using OPENQUERY to find current and future appointments real time (#134808)
11/28/2018 - MH - Adding Areas and New Business memberships
12/07/2018 - RH - (Case 6071) Removed where CancelledClient = 1
02/19/2020 - RH - (TrackIT 2209) Added ISNULL(R.Consultant,'Unknown') AS consultant; limited memberships to XTR+ Initial; If memberships have multiple MembershipSSIDs then combine them
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewBusinessPipeline '251', '1'
EXEC spRpt_NewBusinessPipeline '201', '45'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NewBusinessPipeline]
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
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
)

CREATE TABLE #Memberships ( MembershipSSID INT )

CREATE TABLE #Appt( ClientGUID UNIQUEIDENTIFIER
,	AppointmentGUID UNIQUEIDENTIFIER
,	EmployeeGUID UNIQUEIDENTIFIER
,	SalesCodeDescriptionShort NVARCHAR(50)
,	AppointmentDate DATETIME
,	CheckoutTime DATETIME
)


/********************************** Get list of centers *************************************/
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroup'
		,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		CenterNumber
		,		DC.CenterSSID
		,		CenterDescription
		,		DC.CenterDescriptionNumber

		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE  DCT.CenterTypeDescriptionShort = 'c'
				AND DC.Active = 'Y'


INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroup'
		,		DR.RegionSortOrder AS 'MainGroupSortOrder'
		,		CenterNumber
		,		DC.CenterSSID
		,		CenterDescription
		,		DC.CenterDescriptionNumber

		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   DCT.CenterTypeDescriptionShort IN ('F', 'JV')
				AND DC.Active = 'Y'


DELETE C FROM #Centers C WHERE C.CenterSSID NOT IN ( SELECT SplitValue FROM dbo.fnSplit(@CenterID, ',') )


/********************************** Get list of memberships *************************************/

IF @MembershipSSIDs = '1'  --ALL
BEGIN
	INSERT INTO #Memberships
SELECT MembershipSSID --, MembershipDescription, M.RevenueGroupDescription, M.BusinessSegmentDescription
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		WHERE MembershipDescription LIKE 'Xtrands+%Initial%'

END
ELSE
BEGIN
	INSERT  INTO #Memberships
        SELECT  SplitValue
        FROM    dbo.fnSplit(@MembershipSSIDs, ',')


		IF(SELECT TOP 1 MembershipSSID FROM #Memberships WHERE MembershipSSID = 3) = 3  --Add MembershipSSID = 47 for "Xtrands+ Initial 6"
		BEGIN
		INSERT INTO #Memberships
		SELECT CASE WHEN @MembershipSSIDs LIKE '%3%' THEN 47 END
		END

		IF(SELECT TOP 1 MembershipSSID FROM #Memberships WHERE MembershipSSID = 4) = 4	--Add MembershipSSID = 48 for "Xtrands+ Initial 6 Solutions"
		BEGIN
		INSERT INTO #Memberships
		SELECT CASE WHEN @MembershipSSIDs LIKE '%4%' THEN 48 END
		END

		IF(SELECT TOP 1 MembershipSSID FROM #Memberships WHERE MembershipSSID = 5) = 5	--Add MembershipSSID = 46 for "Xtrands+ Initial 12 Solutions"
		BEGIN
		INSERT INTO #Memberships
		SELECT CASE WHEN @MembershipSSIDs LIKE '%5%' THEN 46 END
		END

		IF(SELECT TOP 1 MembershipSSID FROM #Memberships WHERE MembershipSSID = 45) = 45	--Add MembershipSSID = 45 for "Xtrands+ Initial 12"
		BEGIN
		INSERT INTO #Memberships
		SELECT CASE WHEN @MembershipSSIDs LIKE '%45%' THEN 279 END
		END

END

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
,		DATEADD(MM,3,DCM.MembershipEndDate) AS 'ExpirationDate'
,		DCM.MembershipStatus
,		CASE WHEN DCM.MembershipStatus IN('CANCEL','Canceled') THEN 1	--Find clients who have cancelled or are past three months from expiration date
				WHEN  DATEADD(MM,3,DCM.MembershipEndDate) < @Today THEN 1
		ELSE 0 END AS 'CancelledClient'
INTO    #Clients
FROM    #Centers C
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) DCM
WHERE   DCM.MembershipSSID IN ( SELECT M.MembershipSSID FROM #Memberships M )
        AND DCM.RevenueGroupSSID = 1
        AND DCM.BusinessSegmentSSID = 1


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
                            ON hso.CenterKey = ce.CenterKey
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
     ,		DATEADD(DAY,7,ho_cte.HairSystemAppliedDate) AS 'SevenDayDate'
	 ,		DATEADD(DAY,14,ho_cte.HairSystemAppliedDate) AS 'FourteenDayDate'
	 ,		DATEADD(DAY,21,ho_cte.HairSystemAppliedDate) AS 'TwentyoneDayDate'
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

/******** Find Appt data from SQL05 using OPENQUERY to find current and future appointments real time ***********/

DECLARE @SQL NVARCHAR(MAX)

SELECT @SQL = 'SELECT * FROM OPENQUERY(SQL05, ''SELECT A.ClientGUID, A.AppointmentGUID, AE.EmployeeGUID,
												SC.SalesCodeDescriptionShort, A.AppointmentDate, A.CheckoutTime
												FROM    HairClubCMS.dbo.datAppointment A
														INNER JOIN HairClubCMS.dbo.datAppointmentDetail AD
															ON A.AppointmentGUID = AD.AppointmentGUID
														INNER JOIN HairclubCMS.dbo.cfgSalesCode SC
															ON AD.SalesCodeID = SC.SalesCodeID
														INNER JOIN HairClubCMS.dbo.datAppointmentEmployee AE
															ON A.AppointmentGUID = AE.AppointmentGUID
												WHERE A.AppointmentDate > ''''' + CAST(@StartDate AS VARCHAR(12))+ '''''
												AND (SalesCodeDescriptionShort LIKE ''''CK%''''
														OR SalesCodeDescriptionShort = ''''NB1A''''
														OR SalesCodeDescriptionShort = ''''CONV'''')
														AND SalesCodeDescriptionShort NOT IN (''''CKUD'''',''''CKUN'''')
														AND A.IsDeletedFlag = 0
														AND CenterID =  ''''' +  CAST(@CenterID AS VARCHAR(3))+ ''''''') '

INSERT INTO #Appt
EXEC(@SQL)


/********************************** Populate #Services with #Appt data *************************************/

SELECT  C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       DE.EmployeeInitials
,        CASE WHEN A.SalesCodeDescriptionShort IN ('NB1A') THEN 'NB1App'
		  WHEN A.SalesCodeDescriptionShort = 'CONV' THEN 'CONV'
          WHEN A.SalesCodeDescriptionShort IN ('CKUPRE','CKUPREG') THEN 'PRECHECK'
          WHEN A.SalesCodeDescriptionShort IN ('CKU24','CKU24G')THEN 'CHECK24'
          WHEN A.SalesCodeDescriptionShort IN ('CKU3DAY','CKU3DAYG') THEN 'CKU3DAY'
		  WHEN (A.SalesCodeDescriptionShort IN('CKU','CKUG') AND (A.AppointmentDate BETWEEN HO.HairSystemAppliedDate AND HO.SevenDayDate)) THEN 'SevenDayDate'
		  WHEN (A.SalesCodeDescriptionShort IN('CKU','CKUG') AND (A.AppointmentDate > HO.SevenDayDate AND A.AppointmentDate <= HO.FourteenDayDate)) THEN 'FourteenDayDate'
		  WHEN (A.SalesCodeDescriptionShort IN('CKU','CKUG') AND (A.AppointmentDate > HO.FourteenDayDate AND A.AppointmentDate <= DATEADD(MONTH,1,HO.TwentyoneDayDate))) THEN 'TwentyoneDayDate'
        END AS 'DateCol'
,       A.AppointmentDate AS 'DateColVal'
,       A.CheckoutTime AS 'DateColVal2'
INTO    #Services
FROM    #Appt A
    INNER JOIN #Clients C
        ON A.ClientGUID = C.ClientSSID
	LEFT OUTER JOIN #HairOrder HO
		ON C.ClientMembershipKey = HO.ClientMembershipKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
        ON DE.EmployeeSSID = A.EmployeeGUID
WHERE A.AppointmentDate >= C.MembershipBeginDate


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

,		CONVERT(VARCHAR, MAX(CASE S.DateCol WHEN 'SevenDayDate' THEN S.DateColVal ELSE NULL END), 101) AS 'SevenDayDate'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'SevenDayDate' THEN S.DateColVal2 ELSE NULL END), 101) AS 'SevenDayOut'
,		MAX(CASE S.DateCol WHEN 'SevenDayDate' THEN S.EmployeeInitials ELSE '' END) AS 'SevenDayStylist'

,		CONVERT(VARCHAR, MAX(CASE S.DateCol WHEN 'FourteenDayDate' THEN S.DateColVal ELSE NULL END), 101) AS 'FourteenDayDate'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'FourteenDayDate' THEN S.DateColVal2 ELSE NULL END), 101) AS 'FourteenDayOut'
,		MAX(CASE S.DateCol WHEN 'FourteenDayDate' THEN S.EmployeeInitials ELSE '' END) AS 'FourteenDayStylist'

,		CONVERT(VARCHAR, MAX(CASE S.DateCol WHEN 'TwentyoneDayDate' THEN S.DateColVal ELSE NULL END), 101) AS 'TwentyoneDayDate'
,		CONVERT(VARCHAR, MIN(CASE S.DateCol WHEN 'TwentyoneDayDate' THEN S.DateColVal2 ELSE NULL END), 101) AS 'TwentyoneDayOut'
,		MAX(CASE S.DateCol WHEN 'TwentyoneDayDate' THEN S.EmployeeInitials ELSE '' END) AS 'TwentyoneDayStylist'
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
,       P.SevenDayDate
,       P.SevenDayOut
,       P.SevenDayStylist

,       P.FourteenDayDate
,       P.FourteenDayOut
,       P.FourteenDayStylist

,       P.TwentyoneDayDate
,       P.TwentyoneDayOut
,       P.TwentyoneDayStylist
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
,		C.ExpirationDate
,		C.CancelledClient
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
WHERE C.CancelledClient = 0					--Remove Cancelled Clients


/********************************** Display Results *************************************/
SELECT  ISNULL(R.Consultant,'Unknown') AS Consultant
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

,       CAST(R.SevenDayDate AS DATETIME) AS 'SevenDayDate'
,       R.SevenDayOut
,       CASE WHEN R.SevenDayOut IS NULL
                  AND R.SevenDayDate >= @Today THEN 'Future_Not_co'
             WHEN R.SevenDayOut IS NULL
                  AND R.SevenDayDate < @Today THEN 'Past_Not_co'
             WHEN R.SevenDayOut IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'SevenDayOutStatus'
,       R.SevenDayStylist

,       CAST(R.FourteenDayDate AS DATETIME) AS 'FourteenDayDate'
,       R.FourteenDayOut
,       CASE WHEN R.FourteenDayOut IS NULL
                  AND R.FourteenDayDate >= @Today THEN 'Future_Not_co'
             WHEN R.FourteenDayOut IS NULL
                  AND R.FourteenDayDate < @Today THEN 'Past_Not_co'
             WHEN R.FourteenDayOut IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'FourteenDayOutStatus'
,       R.FourteenDayStylist

,       CAST(R.TwentyoneDayDate AS DATETIME) AS 'TwentyoneDayDate'
,       R.TwentyoneDayOut
,       CASE WHEN R.TwentyoneDayOut IS NULL
                  AND R.TwentyoneDayDate >= @Today THEN 'Future_Not_co'
             WHEN R.TwentyoneDayOut IS NULL
                  AND R.TwentyoneDayDate < @Today THEN 'Past_Not_co'
             WHEN R.TwentyoneDayOut IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'TwentyoneDayOutStatus'
,       R.TwentyoneDayStylist

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
,		--Large CASE statement to find Stylists that don't match		--R.PreCheckStylist = R.CKU3DAYStylist
		CASE WHEN ((R.PreCheckStylist = R.CKU3DAYStylist) AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = '')
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.PreCheckStylist = R.CKU3DAYStylist) AND (R.CKU3DAYStylist = R.NB1AppStylist)
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.PreCheckStylist = R.CKU3DAYStylist) AND (R.CKU3DAYStylist = R.NB1AppStylist) AND (R.NB1AppStylist = R.Check24Stylist))
				THEN 0


				--R.PreCheckStylist IS NULL OR R.PreCheckStylist = ''
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.CKU3DAYStylist = R.NB1AppStylist)
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '')
														AND (R.NB1AppStylist = R.Check24Stylist))
				THEN 0
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.CKU3DAYStylist = R.NB1AppStylist)
														AND (R.NB1AppStylist = R.Check24Stylist))
				THEN 0

				--R.NB1AppStylist IS NULL OR R.NB1AppStylist = ''
			WHEN ((R.NB1AppStylist IS NULL OR R.NB1AppStylist = '') AND (R.PreCheckStylist = R.CKU3DAYStylist)
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.NB1AppStylist IS NULL OR R.NB1AppStylist = '') AND (R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '')
														AND (R.PreCheckStylist = R.Check24Stylist))
				THEN 0
			WHEN ((R.NB1AppStylist IS NULL OR R.NB1AppStylist = '') AND (R.PreCheckStylist = R.CKU3DAYStylist)
														AND (R.CKU3DAYStylist = R.Check24Stylist))
				THEN 0



				--R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = ''
			WHEN ((R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '') AND (R.PreCheckStylist = R.NB1AppStylist)
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '') AND (R.PreCheckStylist =  R.Check24Stylist)
														AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = ''))
				THEN 0
			WHEN ((R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '') AND (R.PreCheckStylist = R.Check24Stylist)
														AND (R.NB1AppStylist = R.Check24Stylist))
				THEN 0



			--Last possibilities
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = '')
														AND (R.CKU3DAYStylist = R.Check24Stylist))
				THEN 0
			WHEN ((R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '') AND (R.Check24Stylist IS NULL OR R.Check24Stylist = '')
														AND (R.PreCheckStylist = R.NB1AppStylist))
				THEN 0

			--All are NULL or Blank
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '')
														AND (R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '')
														AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = '')
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))

				THEN 0

			---When there is only one stylist listed
			WHEN (PreCheckStylist IS NOT NULL AND (R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '')
														AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = '')
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND CKU3DAYStylist IS NOT NULL
														AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = '')
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '')
														AND NB1AppStylist IS NOT NULL
														AND (R.Check24Stylist IS NULL OR R.Check24Stylist = ''))
				THEN 0
			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.CKU3DAYStylist IS NULL OR R.CKU3DAYStylist = '')
														AND (R.NB1AppStylist IS NULL OR R.NB1AppStylist = '')
														AND Check24Stylist IS NOT NULL)
				THEN 0

			WHEN ((R.PreCheckStylist IS NULL OR R.PreCheckStylist = '') AND (R.CKU3DAYStylist <> R.NB1AppStylist)
														AND Check24Stylist IS NULL OR R.CKU3DAYStylist = '')
				THEN 1
		ELSE 1 END AS 'StylistsDontMatch'
,		R.ExpirationDate
,		R.CancelledClient
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
,		R.SevenDayDate
,		R.SevenDayOut
,		R.SevenDayStylist
,		R.FourteenDayDate
,		R.FourteenDayOut
,		R.FourteenDayStylist
,		R.TwentyoneDayDate
,		R.TwentyoneDayOut
,		R.TwentyoneDayStylist
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
,		R.ExpirationDate
,		R.CancelledClient

END
GO
