/***********************************************************************
PROCEDURE:				spRpt_RecurringBusinessPipeline
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_RecurringBusinessPipeline
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		10/23/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
CHANGE HISTORY:
12/12/2016 - RH - Changed 'APP' to 'NB1A' for Initial New Style, removed the membership in the join, removed 180 day limit for initial app (#133414)
12/16/2016 - RH - Removed any recurring business clients with more than 180 days since the Initial New Style (#133414); removed OPENQUERY
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_RecurringBusinessPipeline '296'
EXEC spRpt_RecurringBusinessPipeline '217'
EXEC spRpt_RecurringBusinessPipeline '250'
EXEC spRpt_RecurringBusinessPipeline '201'
EXEC spRpt_RecurringBusinessPipeline '212'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_RecurringBusinessPipeline]
(
	@CenterID NVARCHAR(MAX)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @Today DATETIME
DECLARE @MembershipSSIDs NVARCHAR(MAX)


SET @StartDate = DATEADD(DAY, -180,(CAST(CAST(DATEPART(MONTH, GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(DATEPART(YEAR, GETUTCDATE()) AS VARCHAR(4)) AS DATE))) --Within 180 days of Conversion Date
SET @EndDate = GETUTCDATE()
SET @Today = (DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())))
SET @MembershipSSIDs = '1'



/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterKey INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Memberships ( MembershipSSID INT )

CREATE TABLE #Appt( ClientIdentifier INT
,	AppointmentKey INT
,	EmployeeKey INT
,	SalesCodeDescriptionShort NVARCHAR(50)
,	AppointmentDate DATETIME
,	CheckoutTime DATETIME
)



/********************************** Get list of centers *************************************/
INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[278]%'
				AND DC.Active = 'Y'

DELETE C FROM #Centers C WHERE C.CenterSSID NOT IN ( SELECT SplitValue FROM dbo.fnSplit(@CenterID, ',') )


/********************************** Get list of memberships *************************************/
IF @MembershipSSIDs = '1'  --ALL
BEGIN
	SELECT  @MembershipSSIDs = COALESCE(@MembershipSSIDs + ', ', '') +  CONVERT(nvarchar,MembershipSSID)
							FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
							WHERE BusinessSegmentSSID = 1 AND RevenueGroupSSID = 2
END
	INSERT  INTO #Memberships
        SELECT  SplitValue
        FROM    dbo.fnSplit(@MembershipSSIDs, ',')


/********************************** Get list of Recurring memberships for specified center(s) *************************************/
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
,       DCM.Membership AS 'MembershipDescription'
,		DCM.MembershipBeginDate
,		DCM.MembershipEndDate
INTO    #Clients
FROM    #Centers C
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) DCM
WHERE   DCM.MembershipSSID IN ( SELECT M.MembershipSSID FROM #Memberships M )
        AND DCM.RevenueGroupSSID = 2
        AND DCM.BusinessSegmentSSID = 1
		AND DCM.MembershipStatus <> 'Cancel'
		AND DCM.MembershipBeginDate >= @StartDate
		AND DCM.MembershipEndDate > @EndDate


/********************************** Get conversion data  *************************************/

SELECT CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFullName
,	DD.FullDate
,	E.EmployeeFullName AS 'Consultant'
,	E.EmployeeInitials
INTO #Conversion
FROM #Clients CLT
INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON CLT.ClientKey = FST.ClientKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
    ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON DSC.SalesCodeKey = FST.SalesCodeKey
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON FST.Employee1Key = E.EmployeeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
    ON FST.SalesOrderKey = DSO.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
    ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
WHERE DCM.ClientMembershipKey = CLT.ClientMembershipKey
AND DSC.SalesCodeSSID = 356


/******************* Remove all clients from #Clients who have not had a Conversion *******************************/
DELETE
FROM #Clients
WHERE ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Conversion)

/******************* Find the First Application (New Style) Date **************************************************/

SELECT	C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName
,		MIN(DD.FullDate) AS 'FirstAppDate'
INTO	#FirstAppDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DSC.SalesCodeDescriptionShort IN('NB1A')
GROUP BY C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName



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
			ON FST.ClientKey = C.ClientKey AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DD.FullDate >= @StartDate
		AND DSC.SalesCodeDescriptionShort IN('SVCPCP','SVCSOL')
GROUP BY C.ClientKey
,		C.ClientIdentifier
,		C.ClientFullName



/********************************** Get Hair Order Information *************************************/
;
WITH    HairOrder_CTE
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hso.ClientKey ORDER BY hso.ClientKey, hso.HairSystemOrderDate ASC ) AS RowNumber
               ,        CE.CenterSSID
               ,        HSO.ClientKey
			   ,		CLT.ClientIdentifier
			   ,		CLT.ClientFullName
               ,        HSO.ClientHomeCenterKey
               ,        HSO.HairSystemOrderDate
               ,        HSO.HairSystemOrderNumber
               ,        HSO.HairSystemDueDate
               ,        HSO.ClientMembershipKey
               ,        CLT.MembershipDescription
				FROM     HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder HSO
				INNER JOIN #Clients CLT
					ON HSO.ClientKey = CLT.ClientKey
				INNER JOIN #Centers CE
					ON HSO.ClientHomeCenterKey = CE.CenterKey
				WHERE CLT.ClientMembershipKey = HSO.ClientMembershipKey
             )
     SELECT ho_cte.RowNumber
     ,      ho_cte.CenterSSID
     ,      ho_cte.ClientKey
	 ,      ho_cte.ClientIdentifier
	 ,      ho_cte.ClientFullName
     ,      ho_cte.ClientHomeCenterKey
     ,      ho_cte.HairSystemOrderDate
     ,      ho_cte.HairSystemOrderNumber
     ,      ho_cte.HairSystemDueDate
     ,      ho_cte.ClientMembershipKey
     ,      ho_cte.MembershipDescription
     ,		DATEADD(DAY,7,FAD.FirstAppDate) AS 'SevenDayDate'
	 ,		DATEADD(DAY,14,FAD.FirstAppDate) AS 'FourteenDayDate'
	 ,		DATEADD(DAY,21,FAD.FirstAppDate) AS 'TwentyoneDayDate'
     INTO   #HairOrder

     FROM   HairOrder_CTE ho_cte
     LEFT OUTER JOIN #FirstAppDate FAD
		ON ho_cte.ClientIdentifier = FAD.ClientIdentifier
     WHERE  ho_cte.RowNumber = 1



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
		WHERE   DSC.SalesCodeDescriptionShort IN('CKUPRE','CKU24','CKU3','CKUPREG','CKU24G','CKU3DAYG','CKU','CKUG','CKPCP')
				AND DA.IsDeletedFlag = 0
				AND DA.AppointmentDate BETWEEN C.MembershipBeginDate AND C.MembershipEndDate
				AND DA.AppointmentDate < GETDATE()
		)q
GROUP BY  q.ClientKey
        , q.ClientIdentifier


/******** Find Appt data *****************************************************************************************/


INSERT INTO #Appt
SELECT A.ClientKey
, A.AppointmentKey
, E.EmployeeKey
, SC.SalesCodeDescriptionShort
, A.AppointmentDate
, A.CheckoutTime
FROM   HC_BI_CMS_DDS.bi_cms_dds.DimAppointment A
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
		ON A.AppointmentKey = FAD.AppointmentKey
	INNER JOIN #Centers
		ON A.CenterKey = #Centers.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FAD.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE
		ON A.AppointmentKey = FAE.AppointmentKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FAE.EmployeeKey = E.EmployeeKey
WHERE A.AppointmentDate BETWEEN @StartDate AND @EndDate
AND (SalesCodeDescriptionShort LIKE 'CK%'
		OR SalesCodeDescriptionShort = 'NB1A'
		OR SalesCodeDescriptionShort = 'CONV')
		AND SalesCodeDescriptionShort NOT IN ('CKUD','CKUN')
		AND A.IsDeletedFlag = 0



/********************************** Populate #Services with #Appt data *************************************/

SELECT  C.ClientKey
,   C.ClientIdentifier
,   C.ClientFullName
,   DE.EmployeeInitials
,   CASE WHEN A.SalesCodeDescriptionShort = 'CONV' THEN 'CONV'
      WHEN A.SalesCodeDescriptionShort IN ('CKUPRE','CKUPREG') THEN 'PRECHECK'
      WHEN A.SalesCodeDescriptionShort IN ('CKU24','CKU24G')THEN 'CHECK24'
      WHEN A.SalesCodeDescriptionShort IN ('CKU3DAY','CKU3DAYG') THEN 'CKU3DAY'
	  WHEN (A.SalesCodeDescriptionShort IN('CKU','CKUG','CKPCP') AND (A.AppointmentDate BETWEEN FAD.FirstAppDate AND HO.SevenDayDate)) THEN 'SevenDayDate'
	  WHEN (A.SalesCodeDescriptionShort IN('CKU','CKUG','CKPCP') AND (A.AppointmentDate > HO.SevenDayDate AND A.AppointmentDate <= HO.FourteenDayDate)) THEN 'FourteenDayDate'
	  WHEN (A.SalesCodeDescriptionShort IN('CKU','CKUG','CKPCP') AND (A.AppointmentDate > HO.FourteenDayDate)) THEN 'TwentyoneDayDate'
    END AS 'DateCol'
,	A.AppointmentDate AS 'DateColVal'
,	A.CheckoutTime AS 'DateColVal2'
INTO #Services
FROM #Appt A
    INNER JOIN #Clients C
        ON A.ClientIdentifier = C.ClientIdentifier
    LEFT OUTER JOIN #FirstAppDate FAD
		ON C.ClientIdentifier = FAD.ClientIdentifier
	LEFT OUTER JOIN #HairOrder HO
		ON C.ClientIdentifier = HO.ClientIdentifier
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
        ON DE.EmployeeKey = A.EmployeeKey
WHERE A.AppointmentDate > C.MembershipBeginDate


/********************************** Pivot Data *************************************/

SELECT	S.ClientKey
,       S.ClientIdentifier
,		S.ClientFullName
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


/********************************** Combine Data *************************************/
SELECT  CONV.Consultant
,       ISNULL(CONV.EmployeeInitials,S.EmployeeInitials) AS 'EmployeeInitials'
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientFullName
,       C.MembershipDescription
,		C.MembershipBeginDate
,       CONV.FullDate
,       P.PreCheckDate
,       P.PreCheckOut
,       P.PreCheckStylist
,       P.CKU3DAYDate
,       P.CKU3DAYOut
,       P.CKU3DAYStylist
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
,		TC.TotalCheckups
,		FSV.FirstSalonVisitDate
,		FA.FirstAppDate
INTO    #Results
FROM    #Clients C
		LEFT OUTER JOIN #Conversion CONV
			ON CONV.ClientKey = C.ClientKey
        LEFT OUTER JOIN #HairOrder HO
			ON HO.ClientKey = C.ClientKey
        LEFT OUTER JOIN #NextAppointment NA
			ON NA.ClientKey = C.ClientKey
		LEFT OUTER JOIN #TotalCheckups TC
			ON C.ClientKey = TC.ClientKey
		LEFT OUTER JOIN #Pivot P
			ON P.ClientKey = C.ClientKey
		LEFT OUTER JOIN #FirstSalonVisitDate FSV
			ON FSV.ClientKey = C.ClientKey
		LEFT OUTER JOIN #FirstAppDate FA
			ON FA.ClientKey = C.ClientKey
		LEFT OUTER JOIN #Services S
			ON C.ClientIdentifier = S.ClientIdentifier


/********************************** Display Results *************************************/

SELECT  R.Consultant
,       R.EmployeeInitials
,       R.ClientKey
,       R.ClientIdentifier
,       R.ClientFullName
,       R.MembershipDescription
,		R.MembershipBeginDate
,       R.FullDate AS 'ConversionDate'

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
,		ISNULL(R.TotalCheckups,0) AS 'TotalCheckups'
,		R.FirstSalonVisitDate
,		R.FirstAppDate
FROM    #Results R
WHERE R.FirstAppDate >= DATEADD(DAY,-180,@Today)  --Remove anyone with an initial new style (NB1A) of more than 180 days
GROUP BY R.PreCheckDate
       , R.PreCheckOut
       , R.PreCheckStylist
	   , R.CKU3DAYDate
       , R.CKU3DAYOut
       , R.CKU3DAYStylist
	   , R.Check24Date
       , R.Check24Out
       , R.Check24Stylist
	         , R.SevenDayDate
       , R.SevenDayOut
       , R.SevenDayStylist
	          , R.FourteenDayDate
       , R.FourteenDayOut
       , R.FourteenDayStylist
	          , R.TwentyoneDayDate
       , R.TwentyoneDayOut
       , R.TwentyoneDayStylist
       , ISNULL(R.TotalCheckups ,0)
       , R.Consultant
       , R.EmployeeInitials
       , R.ClientKey
       , R.ClientIdentifier
       , R.ClientFullName
       , R.MembershipDescription
       , R.MembershipBeginDate
       , R.FullDate
       , R.NextAppointment
       , R.HairSystemOrderDate
       , R.HairSystemOrderNumber
       , R.HairSystemDueDate
       , R.RegionSSID
       , R.RegionDescription
       , R.CenterDescriptionNumber
       , R.CenterSSID
       , R.ClientHomeCenterKey
       , R.FirstSalonVisitDate
       , R.FirstAppDate


END
