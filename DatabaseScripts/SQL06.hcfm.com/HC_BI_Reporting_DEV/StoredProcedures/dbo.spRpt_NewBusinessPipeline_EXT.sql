/* CreateDate: 05/18/2015 13:20:59.057 , ModifyDate: 04/15/2020 09:06:46.600 */
GO
/***********************************************************************
PROCEDURE:				spRpt_NewBusinessPipeline_EXT
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_NewBusinessPipeline
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/19/2015
------------------------------------------------------------------------
NOTES:

It’s not really accurate to compare Net $ for this EXT on the Flash, as refunds could show on the Flash report
that were from sales that were NOT made during the same month.

Sale Date is the sale date for EXT intial sale from 18 months ago until Today - and the employee associated with that sale.

------------------------------------------------------------------------
CHANGE HISTORY:
08/18/2015 - RH - Added code to remove Cancels
09/29/2016 - RH - Added a field CancelledClients to find MIA/ Cancelled/ Expired clients; Removed LastPaymentDate (#129374)
10/04/2016 - RH - Removed converted clients (#131128)
10/28/2016 - RH - Added code to find up to 4 dates for past HMI appointments - Baseline1, 2, 3 and 4; removed cancels that were being missed (#131333)
11/17/2016 - RH - Added Cancelled clients to place on second page of the report (#131333)
04/04/2019 - RH - Added SalesCodeDepartmentSSID = 5030 AND DSC.SalesCodeDescription = 'TrichoView Service' to include all clients; Added code to find Total Payments; Changed Expected Conversion Date to 12 months
02/20/2020 - RH - (TrackIT 6955) Changed ExpectedConversionDate to populate from the Client table except for EXT 12 clients using a calculated date of 12 months from the first service date; limited EXT memberships; corrected that Delray Beach was not showing
04/14/2020 - RH - (TrackIT 8050) Added 'Canceled',"Expired' as a membership status to the Cancel section
------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC spRpt_NewBusinessPipeline_EXT '202', '6,7,8,9,13,53,59,60,83' --MembershipSSID's
EXEC spRpt_NewBusinessPipeline_EXT '1080', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NewBusinessPipeline_EXT]
(
	@CenterID NVARCHAR(MAX),  --Only one center allowed
	@MembershipSSIDs NVARCHAR(MAX)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @InitialSaleDate DATETIME
DECLARE @Today DATETIME

SET @InitialSaleDate = DATEADD(MONTH, -17,(CAST(CAST(DATEPART(MONTH, GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(DATEPART(YEAR, GETUTCDATE()) AS VARCHAR(4)) AS DATE))) --18 months ago
SET @Today = (DATEADD(dd, 0, DATEDIFF(dd, 0, GETUTCDATE())))



/********************************** Create temp table objects *************************************/


CREATE TABLE #Memberships ( MembershipSSID INT )


/********************************** Get list of centers *************************************/

SELECT  CMA.CenterManagementAreaSSID
,		CMA.CenterManagementAreaDescription
,		DC.CenterSSID
,		DC.CenterKey
,		DC.CenterDescriptionNumber
,		DCT.CenterTypeDescriptionShort
INTO #Centers
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DC.CenterTypeKey = DCT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
WHERE   DC.CenterSSID = @CenterID
		AND DC.Active = 'Y'


/********************************** Get list of memberships *************************************/
IF @MembershipSSIDs = '1'  --ALL
BEGIN
	INSERT  INTO #Memberships
	SELECT MembershipSSID
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
	WHERE BusinessSegmentSSID = 2	--EXT
		AND RevenueGroupSSID = 1	--NB
		AND MembershipSSID IN(6,7,8,9,13,53,59,60,83,86)

END
ELSE
BEGIN

	INSERT  INTO #Memberships
        SELECT  SplitValue
        FROM    dbo.fnSplit(@MembershipSSIDs, ',')
END

/* Limit the memberships to these
6	EXT 6
7	EXT 12
8	EXT Enhanced 6
9	EXT Enhanced 12
13	Post Extreme
53	EXT Enhanced 9
59	EXT 9 (Bosley)
60	EXT 9 Solutions(Bosley)
83	EXT Initial
86	Post Ext (Bosley)
*/


/********************************** Get list of New Business memberships for specified center(s) *************************************/

SELECT  CTR.CenterManagementAreaSSID
,       CTR.CenterManagementAreaDescription
,       CTR.CenterSSID
,       CTR.CenterDescriptionNumber
,       r.ClientSSID
,       r.ClientKey
,       r.ClientIdentifier
,       r.ClientFullName
,       r.ClientMembershipSSID
,       r.ClientMembershipKey
,       r.BosleySiebelID
,		r.MembershipSSID
,       r.MembershipDescription
,       r.ClientMembershipContractPrice
,       NULL AS ContractPaidAmount
,		NULL AS ContractBalance
,		r.NB_ExtCnt
,       r.SaleDate
,		r.ExpectedConversionDate
,       r.EmployeeInitials
,       r.Consultant
INTO    #Clients
FROM    #Centers CTR
		CROSS APPLY (
		SELECT CLT.ClientSSID
						,       CLT.ClientKey
						,       CLT.ClientIdentifier
						,       CLT.ClientFullName
						,       DCM.ClientMembershipSSID
						,       DCM.ClientMembershipKey
						,       CLT.BosleySiebelID
						,		M.MembershipSSID
						,       M.MembershipDescription
						,       DCM.ClientMembershipContractPrice
						,       NULL AS ContractPaidAmount  --Change this to amount paid from Dom's query
						,       NULL AS 'ContractBalance'
						,		FST.NB_ExtCnt
						,       DD.FullDate AS 'SaleDate'
						,       ISNULL(PFR.EmployeeInitials,Sty.EmployeeInitials) AS 'EmployeeInitials'
						,       ISNULL(PFR.EmployeeFullName,Sty.EmployeeFullName) AS 'Consultant'
						,		CLT.ExpectedConversionDate
						,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientKey ORDER BY DD.FullDate DESC) AS 'Ranking'
					FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						ON FST.ClientKey = CLT.ClientKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
						ON FST.SalesCodeKey = DSC.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
						ON FST.SalesOrderKey = DSO.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
						ON DCM.MembershipKey = M.MembershipKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
						ON DCM.CenterKey = CTR.CenterKey
					INNER JOIN #Centers C
						ON C.CenterKey = CTR.CenterKey
					LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
						ON FST.Employee1Key = PFR.EmployeeKey
					LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
						ON FST.Employee2Key = STY.EmployeeKey
					WHERE     FST.ClientKey = CLT.ClientKey
						AND CTR.CenterKey = FST.CenterKey
       					AND DCM.MembershipSSID IN ( SELECT MembershipSSID FROM #Memberships)
						AND DD.FullDate > @InitialSaleDate
						AND ISNULL(NB_ExtCnt,0) > 0
						)r
	WHERE Ranking = 1


/************** Get Total Payments *****************************************************************************/

SELECT  FST.ClientKey
,       DCM.ClientMembershipKey
,       SUM(FST.ExtendedPrice) AS 'TotalPayments'
INTO #TotalPayments
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients CLT
			ON CLT.ClientMembershipKey = FST.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
WHERE   DSC.SalesCodeDepartmentSSID IN ( 2020 )
              AND DSC.SalesCodeDescriptionShort NOT IN ( 'EXTPMTLC', 'EXTPMTLCP', 'EXTPMTLH', 'EXTPMTLB', 'EXTPMTLCN', 'EXTPMTCAP82', 'EXTPMTCAP202', 'EXTPMTCAP272', 'EXTCAP312', 'EXTPMTCAP312', 'EXTCAP202TI', 'EXTCAP272TI', 'EXTCAP312TI' ) -- Exclude Laser Comb, Laser Helmet, Laser Band or Capillus Payments
              AND DSOD.IsVoidedFlag = 0
GROUP BY FST.ClientKey
,       DCM.ClientMembershipKey


UPDATE #Clients
SET #Clients.ContractPaidAmount = TP.TotalPayments
FROM #Clients
INNER JOIN #TotalPayments TP
	ON TP.ClientMembershipKey = #Clients.ClientMembershipKey
WHERE #Clients.ContractPaidAmount IS NULL


UPDATE #Clients
SET #Clients.ContractBalance = (#Clients.ClientMembershipContractPrice - TP.TotalPayments)
FROM #Clients
INNER JOIN #TotalPayments TP
	ON TP.ClientMembershipKey = #Clients.ClientMembershipKey
WHERE #Clients.ContractBalance IS NULL


/******************* Find Converted Clients *******************************************************/

SELECT  CLT.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		DCM.MembershipDescriptionShort
,		DCM.MembershipStatus
,		DCM.RevenueGroupSSID
INTO    #Converted
FROM    #Clients CLT
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(CLT.ClientIdentifier) DCM
WHERE CLT.CenterSSID = @CenterID
AND DCM.RevenueGroupSSID = 2

--Remove converted clients
DELETE FROM #Clients
WHERE ClientIdentifier IN(SELECT ClientIdentifier FROM #Converted WHERE MembershipStatus = 'Active')


/******************* Find Cancelled Clients *******************************************************/
IF OBJECT_ID('tempdb..#Cancels') IS NOT NULL
BEGIN
	DROP TABLE #Cancels
END

SELECT  CLT.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CASE WHEN DCM.MembershipStatus IN('CANCEL','Canceled','Expired')  THEN 1				--Find clients who have cancelled or are past three months from expiration date
				WHEN  DATEADD(MM,3,DCM.MembershipEndDate) < @Today THEN 1
		ELSE 0 END AS 'CancelledClient'
INTO    #Cancels
FROM    #Clients CLT
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(CLT.ClientIdentifier) DCM
WHERE CLT.CenterSSID = @CenterID
GROUP BY CASE WHEN DCM.MembershipStatus IN('CANCEL','Canceled','Expired') THEN 1
       WHEN DATEADD(MM ,3 ,DCM.MembershipEndDate) < @Today THEN 1
       ELSE 0
       END
       , CLT.ClientKey
       , CLT.ClientIdentifier
       , CLT.ClientFullName


/********************************** Get First Service *************************************/

/*
SalesCodeSSID	SalesCodeDescription
392	EXT Pro Service
393	EXT Service
671	EXT Service w Laser
672	EXT Membership Service
684	EXT Laser only
784	EXT Service Solutions
785	EXT Membership Service Solutions
804	Women's EXT Membership Service
805	Women's EXT Service
*/

SELECT  o.FSRank
      , o.ClientKey
      , o.ClientIdentifier
      , o.ClientFullName
      , o.FirstServiceDate
      , o.FirstServiceChkOutTime
      , o.FirstServiceStylist
INTO #FirstService
FROM
(SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) FSRank
,		CLT.ClientKey
,       CLT.ClientIdentifier
,		CLT.ClientFullName
,		ISNULL(DD.FullDate,'') AS 'FirstServiceDate'
,		ISNULL(DA.CheckOutTime,'') AS 'FirstServiceChkOutTime'
,		ISNULL(DE.EmployeeInitials,'') AS 'FirstServiceStylist'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
			ON FST.ClientKey = DA.ClientKey
			AND DD.Fulldate = DA.AppointmentDate
        INNER JOIN #Clients CLT
            ON DA.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
            ON FST.Employee2Key = DE.EmployeeKey
WHERE (SalesCodeDepartmentSSID = 5035  --EXT Services
OR (SalesCodeDepartmentSSID = 5030 AND DSC.SalesCodeDescription = 'TrichoView Service'))
        AND DD.FullDate <= @Today
		AND DA.IsDeletedFlag = 0
)o

WHERE FSRank = 1

/********************************** Get Last Service *************************************/

IF OBJECT_ID('tempdb..#LastService') IS NOT NULL
BEGIN
	DROP TABLE #LastService
END

SELECT  p.LSRank
      , p.ClientKey
      , p.ClientIdentifier
      , p.ClientFullName
      , p.LastServiceDate
      , p.LastServiceChkOutTime
      , p.LastServiceStylist
INTO #LastService
FROM
(SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate DESC) LSRank
,		CLT.ClientKey
,       CLT.ClientIdentifier
,		CLT.ClientFullName
,		ISNULL(DD.FullDate,'') AS 'LastServiceDate'
,		ISNULL(DA.CheckOutTime,'') AS 'LastServiceChkOutTime'
,		ISNULL(DE.EmployeeInitials,'') AS 'LastServiceStylist'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
			ON FST.ClientKey = DA.ClientKey
			AND DD.Fulldate = DA.AppointmentDate
        INNER JOIN #Clients CLT
            ON DA.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
            ON FST.Employee2Key = DE.EmployeeKey
WHERE (SalesCodeDepartmentSSID = 5035  --EXT Services
OR (SalesCodeDepartmentSSID = 5030 AND DSC.SalesCodeDescription = 'TrichoView Service'))
        AND DA.IsDeletedFlag = 0
		AND DA.AppointmentDate <= @Today
)p

WHERE LSRank = 1


/********************************** Get the Next Appointment **************/

SELECT  q.NARank
,		q.ClientKey
,		q.ClientIdentifier
,		q.ClientFullName
,		q.NextAppt
,		NULL AS NextApptout --Future appointments will not be checked out
,		q.NextApptEmployee
INTO #NextAppt
FROM
(SELECT  ROW_NUMBER() OVER(PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC) NARank
,		CLT.ClientKey
,       CLT.ClientIdentifier
,		CLT.ClientFullName
,		ISNULL(DA.AppointmentDate,'') AS 'NextAppt'
,		ISNULL(DA.CheckOutTime,'') AS 'NextApptout'
,		ISNULL(DE.EmployeeInitials,'') AS 'NextApptEmployee'
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
            ON DA.AppointmentKey = FAD.AppointmentKey
        INNER JOIN #Clients CLT
            ON DA.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FAD.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE
            ON DA.AppointmentKey = FAE.AppointmentKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
            ON FAE.EmployeeKey = DE.EmployeeKey
WHERE (SalesCodeDepartmentSSID = 5035  --EXT Services
OR (SalesCodeDepartmentSSID = 5030 AND DSC.SalesCodeDescription = 'TrichoView Service'))
        AND DA.IsDeletedFlag = 0
		AND DA.AppointmentDate > @Today
)q

WHERE NARank = 1

/*************************** Find the HMI Appointments *******************************************/

SELECT q.ClientIdentifier
,	q.AppointmentDate
,	q.Density, q.Width
,	ROW_NUMBER()OVER(PARTITION BY ClientIdentifier ORDER BY AppointmentDate ASC) AS 'Ranking'
INTO #HMI
FROM (
SELECT	APP.AppointmentSSID
,	#Clients.ClientIdentifier
,	#Clients.ClientSSID
,	APP.AppointmentDate
,	SUM(CASE WHEN PHOTO.PhotoTypeID = 4 THEN 1 ELSE 0 END) AS  'Density'
,	SUM(CASE WHEN PHOTO.PhotoTypeID = 5 THEN 1 ELSE 0 END) AS  'Width'
FROM  #Clients
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APP
	ON #Clients.ClientSSID = APP.ClientSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
	ON APP.AppointmentKey = FAD.AppointmentKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON FAD.SalesCodeKey = SC.SalesCodeKey
LEFT JOIN [synHairclubCMS_datAppointmentPhoto] PHOTO
	ON APP.AppointmentSSID = PHOTO.AppointmentGUID
WHERE APP.IsDeletedFlag = 0
	AND (SC.SalesCodeDescriptionShort LIKE '%CNSLT%' OR SC.SalesCodeDepartmentSSID IN(5030,5035,5036))
	AND APP.CheckInTime IS NOT NULL
AND PHOTO.PhotoTypeID IN(4,5)
GROUP BY APP.AppointmentSSID
,	#Clients.ClientIdentifier
,	#Clients.ClientSSID
,	APP.AppointmentDate
)q
WHERE q.Density >= 2 AND Width >= 2

IF OBJECT_ID('tempdb..#SRC') IS NOT NULL
BEGIN
	DROP TABLE #SRC
END

SELECT ClientIdentifier
,	CASE WHEN Ranking = 1 THEN 'Baseline1'
		WHEN Ranking = 2 THEN  'Baseline2'
		WHEN Ranking = 3 THEN  'Baseline3'
		WHEN Ranking = 4 THEN  'Baseline4'
	END AS 'DateCol'
,	CAST(AppointmentDate AS NVARCHAR(12)) AS 'DateColVal'
INTO #SRC
FROM #HMI


/********************************** Pivot Data *************************************/

SELECT ClientIdentifier
,		CONVERT(VARCHAR, MIN(CASE #SRC.DateCol WHEN 'Baseline1' THEN #SRC.DateColVal ELSE NULL END), 101) AS 'Baseline1'
,		CONVERT(VARCHAR, MIN(CASE #SRC.DateCol WHEN 'Baseline2' THEN #SRC.DateColVal ELSE NULL END), 101) AS 'Baseline2'
,		CONVERT(VARCHAR, MIN(CASE #SRC.DateCol WHEN 'Baseline3' THEN #SRC.DateColVal ELSE NULL END), 101) AS 'Baseline3'
,		CONVERT(VARCHAR, MIN(CASE #SRC.DateCol WHEN 'Baseline4' THEN #SRC.DateColVal ELSE NULL END), 101) AS 'Baseline4'
INTO #PVT
FROM #SRC
GROUP BY ClientIdentifier


/********************************** Combine Data *************************************/

SELECT  C.Consultant
,       C.EmployeeInitials
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       C.MembershipDescription
,		C.ClientMembershipKey
,       C.BosleySiebelID
,		C.SaleDate
,       C.ClientMembershipContractPrice
,       C.ContractPaidAmount
,       C.ContractBalance
,       C.CenterManagementAreaSSID
,       C.CenterManagementAreaDescription
,       C.CenterDescriptionNumber

,		FS.FirstServiceDate
,		FS.FirstServiceChkOutTime
,		FS.FirstServiceStylist

,		LS.LastServiceDate
,		LS.LastServiceChkOutTime
,		LS.LastServiceStylist

,		NextAppt
,		NextApptout
,		NextApptEmployee
,		DATEADD(MONTH,M.MembershipDurationMonths,FS.FirstServiceDate) AS 'ExpectedConversionDate'
,		NB_ExtCnt
,		Baseline1
,		Baseline2
,		Baseline3
,		Baseline4
INTO    #Results
FROM    #Clients C
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipSSID = C.MembershipSSID
		LEFT JOIN #FirstService FS
			ON C.ClientKey = FS.ClientKey
		LEFT JOIN #LastService LS
			ON C.ClientKey = LS.ClientKey
        LEFT JOIN #NextAppt NA
			ON C.ClientKey = NA.ClientKey
		LEFT JOIN #PVT
			ON C.ClientIdentifier = #PVT.ClientIdentifier



/**********  Find the Remaining Visits and Remaining Kits ****************************/

SELECT	R.ClientKey
,	R.ClientMembershipKey
,	(CMA_visits.TotalAccumQuantity-CMA_visits.UsedAccumQuantity) AS 'RemainingSalonVisits'
,	(CMA_kits.TotalAccumQuantity-CMA_kits.UsedAccumQuantity) AS 'RemainingProductKits'
INTO #Accumulators
FROM #Results R
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_visits
			ON R.ClientMembershipKey = CMA_visits.ClientMembershipKey
				AND CMA_visits.AccumulatorSSID = 9 --Salon Visits
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA_kits
			ON R.ClientMembershipKey = CMA_kits.ClientMembershipKey
				AND CMA_kits.AccumulatorSSID = 11 --Product Kits
WHERE R.ClientMembershipKey IN(SELECT ClientMembershipKey FROM #Results)


/********************************** Display Results *************************************/
SELECT  R.Consultant
,       R.EmployeeInitials
,       R.ClientKey
,       R.ClientIdentifier
,       R.ClientFullName
,       R.MembershipDescription
,		R.ClientMembershipKey
,       R.BosleySiebelID
,       R.SaleDate
,       R.ClientMembershipContractPrice
,       R.ContractPaidAmount
,       R.ContractBalance
,       R.CenterManagementAreaSSID
,       R.CenterManagementAreaDescription
,       R.CenterDescriptionNumber
,       R.FirstServiceDate
,		R.FirstServiceChkOutTime
,       CASE WHEN R.FirstServiceChkOutTime IS NULL
                  AND R.FirstServiceDate >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.FirstServiceChkOutTime IS NULL
                  AND R.FirstServiceDate < @Today THEN 'Past_Not_co'
             WHEN R.FirstServiceChkOutTime IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'FirstServiceStatus'
,       R.FirstServiceStylist
,		R.LastServiceDate
,		R.LastServiceChkOutTime
,       CASE WHEN R.LastServiceChkOutTime IS NULL
                  AND R.LastServiceDate >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.LastServiceChkOutTime IS NULL
                  AND R.LastServiceDate < @Today THEN 'Past_Not_co'
             WHEN R.LastServiceChkOutTime IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'LastServiceStatus'
,		R.LastServiceStylist
,       R.NextAppt
,		R.NextApptout
,       CASE WHEN R.NextApptout IS NULL
                  AND R.NextAppt >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.NextApptout IS NULL
                  AND R.NextAppt < @Today THEN 'Past_Not_co'
             WHEN R.NextApptout IS NOT NULL THEN 'co'
             ELSE '0'
        END AS 'NextApptStatus'
,       R.NextApptEmployee
,       R.ExpectedConversionDate
,		ISNULL(A.RemainingSalonVisits,0) AS 'RemainingSalonVisits'
,		ISNULL(A.RemainingProductKits,0) AS 'RemainingProductKits'
,		@InitialSaleDate AS 'InitialSaleDate'
,		NB_ExtCnt
,		ISNULL(CANCEL.CancelledClient,0) AS 'CancelledClient'
,		CAST(Baseline1 AS DATETIME) AS 'Baseline1'
,		CAST(Baseline2 AS DATETIME) AS 'Baseline2'
,		CAST(Baseline3 AS DATETIME) AS 'Baseline3'
,		CAST(Baseline4 AS DATETIME) AS 'Baseline4'

,		CASE WHEN (ISNULL(CANCEL.CancelledClient,0) = 0 AND R.FirstServiceDate IS NOT NULL)  THEN 1 ELSE 0 END AS 'Baseline1Gainesboro'
,		CASE WHEN (DATEADD(MONTH,2,FirstServiceDate) <= GETDATE() AND ISNULL(CANCEL.CancelledClient,0) = 0 AND R.FirstServiceDate IS NOT NULL)  THEN 1 ELSE 0 END AS 'Baseline2LightGray'
,		CASE WHEN (DATEADD(MONTH,6,FirstServiceDate) <= GETDATE() AND ISNULL(CANCEL.CancelledClient,0) = 0 AND R.FirstServiceDate IS NOT NULL) THEN 1 ELSE 0 END AS 'Baseline3Silver'
,		CASE WHEN (DATEADD(MONTH,9,FirstServiceDate) <= GETDATE() AND ISNULL(CANCEL.CancelledClient,0) = 0 AND R.FirstServiceDate IS NOT NULL) THEN 1 ELSE 0 END AS 'Baseline4DarkGray'
FROM    #Results R
LEFT JOIN #Accumulators A
	ON R.ClientKey = A.ClientKey
LEFT JOIN #Cancels CANCEL
	ON CANCEL.ClientKey = R.ClientKey
WHERE R.SaleDate > @InitialSaleDate
	AND ISNULL(R.NB_ExtCnt,0) > 0
GROUP BY R.Consultant
,       R.EmployeeInitials
,       R.ClientKey
,       R.ClientIdentifier
,       R.ClientFullName
,       R.MembershipDescription
,		R.ClientMembershipKey
,       R.BosleySiebelID
,       R.SaleDate
,       R.ClientMembershipContractPrice
,       R.ContractPaidAmount
,       R.ContractBalance
,       R.CenterManagementAreaSSID
,       R.CenterManagementAreaDescription
,       R.CenterDescriptionNumber
,       R.FirstServiceDate
,		R.FirstServiceChkOutTime
,       CASE WHEN R.FirstServiceChkOutTime IS NULL
                  AND R.FirstServiceDate >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.FirstServiceChkOutTime IS NULL
                  AND R.FirstServiceDate < @Today THEN 'Past_Not_co'
             WHEN R.FirstServiceChkOutTime IS NOT NULL THEN 'co'
             ELSE '0'
        END
,       R.FirstServiceStylist
,		R.LastServiceDate
,		R.LastServiceChkOutTime
,       CASE WHEN R.LastServiceChkOutTime IS NULL
                  AND R.LastServiceDate >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.LastServiceChkOutTime IS NULL
                  AND R.LastServiceDate < @Today THEN 'Past_Not_co'
             WHEN R.LastServiceChkOutTime IS NOT NULL THEN 'co'
             ELSE '0'
        END
,		R.LastServiceStylist
,       R.NextAppt
,		R.NextApptout
,       CASE WHEN R.NextApptout IS NULL
                  AND R.NextAppt >= @Today THEN 'Future_Not_co' --This is for the lettering color in the report - Green, Red or Black
             WHEN R.NextApptout IS NULL
                  AND R.NextAppt < @Today THEN 'Past_Not_co'
             WHEN R.NextApptout IS NOT NULL THEN 'co'
             ELSE '0'
        END
,       R.NextApptEmployee
,       R.ExpectedConversionDate
,		ISNULL(A.RemainingSalonVisits,0)
,		ISNULL(A.RemainingProductKits,0)
,		NB_ExtCnt
,		ISNULL(CANCEL.CancelledClient,0)
,		CAST(Baseline1 AS DATETIME)
,		CAST(Baseline2 AS DATETIME)
,		CAST(Baseline3 AS DATETIME)
,		CAST(Baseline4 AS DATETIME)





END
GO
