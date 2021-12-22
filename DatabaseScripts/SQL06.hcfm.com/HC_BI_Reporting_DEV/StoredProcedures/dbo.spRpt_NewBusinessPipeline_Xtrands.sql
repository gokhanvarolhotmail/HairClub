/* CreateDate: 05/18/2015 16:11:36.350 , ModifyDate: 12/02/2019 09:41:28.613 */
GO
/***********************************************************************
PROCEDURE:				spRpt_NewBusinessPipeline_Xtrands
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_NewBusinessPipeline
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/19/2015
------------------------------------------------------------------------
NOTES:

Sale Date is the sale date for Xtrands intial sale from 18 months ago until Today - and the employee associated with that sale.
------------------------------------------------------------------------
CHANGE HISTORY:
08/18/2015 - RH - Added code to remove Cancels
09/27/2016 - RH - Removed LastPaymentDate
09/29/2016 - RH - Added a field CancelledClients to find MIA/ Cancelled/ Expired clients
10/04/2016 - RH - Removed converted clients (#131128)
10/28/2016 - RH - Added code to find up to 4 dates for past HMI appointments - Baseline1, 2, 3 and 4; removed cancels that were being missed (#131333)
11/17/2016 - RH - Added Cancelled clients to place on second page of the report (#131333)
11/27/2019 - RH - Changed hard-coded sales codes to WHERE SalesCodeDescription LIKE '%Xtrand%' AND SalesCodeTypeDescription = 'Service'; Removed code for baselines 1 - 4
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewBusinessPipeline_Xtrands '212', '70,75' --MembershipSSID's
EXEC spRpt_NewBusinessPipeline_Xtrands '281', '1'  --ALL Memberships

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NewBusinessPipeline_Xtrands]
(
	@CenterID NVARCHAR(MAX),
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

PRINT @InitialSaleDate
PRINT @Today


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
WHERE  DC.CenterSSID = @CenterID
		AND DC.Active = 'Y'


/********************************** Get list of memberships *************************************/
IF @MembershipSSIDs = '1'  --ALL
BEGIN
	INSERT  INTO #Memberships
	SELECT MembershipSSID
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
	WHERE BusinessSegmentSSID = 6	--Xtrands
		AND RevenueGroupSSID = 1	--NB
END
ELSE
BEGIN

	INSERT  INTO #Memberships
        SELECT  SplitValue
        FROM    dbo.fnSplit(@MembershipSSIDs, ',')
END


/********************************** Get list of New Business memberships for specified center(s) *************************************/
SELECT  CTR.CenterManagementAreaSSID
,       CTR.CenterManagementAreaDescription
,       CTR.CenterSSID
,       CTR.CenterDescriptionNumber
,       ClientSSID
,       ClientKey
,       ClientIdentifier
,       ClientFullName
,       ClientMembershipSSID
,       ClientMembershipKey
,       BosleySiebelID
,       MembershipDescription
,       ClientMembershipContractPrice
,       ClientMembershipContractPaidAmount
,       ContractBalance
,		NB_XtrCnt
,       SaleDate
,		ExpectedConversionDate
,       EmployeeInitials
,       Consultant
INTO    #Clients
FROM    #Centers CTR
		CROSS APPLY (SELECT CLT.ClientSSID
						,       CLT.ClientKey
						,       CLT.ClientIdentifier
						,       CLT.ClientFullName
						,       DCM.ClientMembershipSSID
						,       DCM.ClientMembershipKey
						,       CLT.BosleySiebelID
						,       M.MembershipDescription
						,       DCM.ClientMembershipContractPrice
						,       DCM.ClientMembershipContractPaidAmount
						,       (ClientMembershipContractPrice - ClientMembershipContractPaidAmount) AS 'ContractBalance'
						,		FST.NB_XTRCnt
						,       DD.FullDate AS 'SaleDate'
						,		ExpectedConversionDate
						,       ISNULL(PFR.EmployeeInitials,Sty.EmployeeInitials) AS 'EmployeeInitials'
						,       ISNULL(PFR.EmployeeFullName,Sty.EmployeeFullName) AS 'Consultant'
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
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON DSO.ClientMembershipKey = DCM.ClientMembershipKey --Change FST to DSO
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
						ON DCM.MembershipKey = M.MembershipKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON DCM.CenterKey = C.CenterKey  --Change FST to DCM
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
						ON FST.Employee1Key = PFR.EmployeeKey
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
						ON FST.Employee2Key = STY.EmployeeKey
					WHERE     FST.ClientKey = CLT.ClientKey
						AND CTR.CenterKey = FST.CenterKey
						AND FST.ClientMembershipKey = DCM.ClientMembershipKey
						AND DCM.MembershipSSID IN ( SELECT MembershipSSID FROM #Memberships)
						AND DD.FullDate > @InitialSaleDate
						AND ISNULL(NB_XtrCnt,0) > 0
						AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
						AND SOD.IsVoidedFlag = 0) q
WHERE Ranking = 1



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

/******************* Find Cancelled Clients ***********************************************************/
--Find cancelled or expired clients --KEEP these clients and put them on the second page of the report

SELECT  CLT.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CASE WHEN DCM.MembershipStatus = 'CANCEL' THEN 1				--Find clients who have cancelled or are past three months from expiration date
				WHEN  DATEADD(MM,3,DCM.MembershipEndDate) < @Today THEN 1
		ELSE 0 END AS 'CancelledClient'
INTO    #Cancels
FROM    #Clients CLT
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(CLT.ClientIdentifier) DCM
WHERE CLT.CenterSSID = @CenterID
GROUP BY CASE WHEN DCM.MembershipStatus = 'CANCEL' THEN 1
       WHEN DATEADD(MM ,3 ,DCM.MembershipEndDate) < @Today THEN 1
       ELSE 0
       END
       , CLT.ClientKey
       , CLT.ClientIdentifier
       , CLT.ClientFullName


/********************************** Get First Service **************************************************/

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
WHERE DSC.SalesCodeDescription LIKE '%Xtrand%'
		AND DSC.SalesCodeTypeDescription = 'Service'
		AND DD.FullDate <= @Today
)o

WHERE FSRank = 1


/********************************** Get Last Service *************************************/

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
WHERE DSC.SalesCodeDescription LIKE '%Xtrand%'
		AND DSC.SalesCodeTypeDescription = 'Service'
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
WHERE DSC.SalesCodeDescription LIKE '%Xtrand%'
		AND DSC.SalesCodeTypeDescription = 'Service'
		AND DA.IsDeletedFlag = 0
		AND DA.AppointmentDate > @Today
)q

WHERE NARank = 1

/*************************** Find the HMI Appointments *******************************************/
/*
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
	AND (SC.SalesCodeDescriptionShort LIKE '%CNSLT%' OR SC.SalesCodeSSID IN (773,774,775,776,788))  --Xtrands Services
	AND APP.CheckInTime IS NOT NULL
AND PHOTO.PhotoTypeID IN(4,5)
GROUP BY APP.AppointmentSSID
,	#Clients.ClientIdentifier
,	#Clients.ClientSSID
,	APP.AppointmentDate
)q
WHERE q.Density >= 2 AND Width >= 2

SELECT ClientIdentifier
,	CASE WHEN Ranking = 1 THEN 'Baseline1'
		WHEN Ranking = 2 THEN  'Baseline2'
		WHEN Ranking = 3 THEN  'Baseline3'
		WHEN Ranking = 4 THEN  'Baseline4'	END AS 'DateCol'
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
*/
/********************************** Combine Data *************************************/


SELECT  C.Consultant
,       C.EmployeeInitials
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       C.MembershipDescription
,		C.ClientMembershipKey
,       C.BosleySiebelID
,       C.SaleDate
,       C.ClientMembershipContractPrice
,       C.ClientMembershipContractPaidAmount
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

,       C.ExpectedConversionDate
,		@InitialSaleDate AS 'InitialSaleDate'
,		C.NB_XtrCnt
INTO    #Results
FROM    #Clients C
		LEFT JOIN #FirstService FS
			ON C.ClientKey = FS.ClientKey
		LEFT JOIN #LastService LS
			ON C.ClientKey = LS.ClientKey
        LEFT JOIN #NextAppt NA
			ON C.ClientKey = NA.ClientKey

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
,       R.ClientMembershipContractPaidAmount
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
,		NB_XtrCnt
,		ISNULL(CANCEL.CancelledClient,0) AS 'CancelledClient'
FROM    #Results R
LEFT JOIN #Accumulators A
	ON R.ClientKey = A.ClientKey
LEFT JOIN #Cancels CANCEL
	ON CANCEL.ClientKey = R.ClientKey
WHERE R.SaleDate IS NOT NULL
	AND ISNULL(R.NB_XTRCnt,0) > 0
GROUP BY  R.Consultant
,       R.EmployeeInitials
,       R.ClientKey
,       R.ClientIdentifier
,       R.ClientFullName
,       R.MembershipDescription
,		R.ClientMembershipKey
,       R.BosleySiebelID
,       R.SaleDate
,       R.ClientMembershipContractPrice
,       R.ClientMembershipContractPaidAmount
,       R.ContractBalance
,       R.CenterManagementAreaSSID
,       R.CenterManagementAreaDescription
,       R.CenterDescriptionNumber
,		R.FirstServiceDate
,		R.FirstServiceChkOutTime
,		R.FirstServiceStylist
,		R.LastServiceDate
,		R.LastServiceChkOutTime
,		R.LastServiceStylist
,		NextAppt
,		NextApptout
,		NextApptEmployee
,       R.ExpectedConversionDate
,		ISNULL(A.RemainingSalonVisits,0)
,		ISNULL(A.RemainingProductKits,0)
,		R.NB_XtrCnt
,		ISNULL(CANCEL.CancelledClient,0)




END
GO
