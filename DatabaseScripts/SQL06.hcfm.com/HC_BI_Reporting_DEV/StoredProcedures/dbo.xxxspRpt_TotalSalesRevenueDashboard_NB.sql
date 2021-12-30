/* CreateDate: 11/07/2018 13:48:15.657 , ModifyDate: 12/17/2019 11:27:37.023 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_TotalSalesRevenueDashboard_NB]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/19/2015
------------------------------------------------------------------------
NOTES:
--New business - Top 5 with Hair "in center" who have never been applied
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_TotalSalesRevenueDashboard_NB] '201'

EXEC [spRpt_TotalSalesRevenueDashboard_NB] '201, 203, 230, 232, 235, 237, 240, 258, 263, 267, 283, 219, 289, 202, 231, 256, 257, 299'
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_TotalSalesRevenueDashboard_NB]
(
	@CenterNumber NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;


/************** Find Dates ******************************************************************************************/

DECLARE @ThisMonth DATETIME
DECLARE @ThisMembershipBeginDate DATETIME
DECLARE @Month INT
DECLARE @Year INT

SET @Month = MONTH(GETUTCDATE())
SET @Year = YEAR(GETUTCDATE())

SET @ThisMonth = CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATE)
SET @ThisMembershipBeginDate = DATEADD(MM,-12,@ThisMonth)

PRINT @ThisMonth
PRINT @ThisMembershipBeginDate


/***************************** Create temp tables *************************************************************/

CREATE TABLE #CenterNumber (CenterNumber INT)



CREATE TABLE #NB_Top5(
	HairSystemOrderStatusDescription NVARCHAR(50)
,	ThisMembershipBeginDate DATE
,	ThisMonth DATE
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(50)
,	ClientLastName NVARCHAR(50)
,	ClientEmailAddress NVARCHAR(100)
,	ClientPhone1 NVARCHAR(15)
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipBeginDate DATE
,	ClientMembershipStatusDescription NVARCHAR(50)
,	Active INT
,	ClientMembershipDuration INT
,	AppointmentDate DATETIME
,	AppointmentStartTime DATETIME
,	HairSystemReceivedDate DATETIME
,	ContractPrice DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	ContractBalance DECIMAL(18,4)
,	ClientMembershipKey INT
)

CREATE TABLE #TotalPayments(
	ClientKey INT
,   ClientMembershipKey INT
,	ClientMembershipEndDate DATE
,	ClientMembershipContractPrice DECIMAL(18,4)
,	BusinessSegmentSSID INT
,   ExtendedPrice DECIMAL(18,4)
)

CREATE TABLE #SUM_TotalPayments(
	ClientKey INT
,   ClientMembershipContractPrice DECIMAL(18,4)
,	ExtendedPrice DECIMAL(18,4)
,	ContractBalance DECIMAL(18,4)
)

/*********************** Find CenterNumbers using fnSplit *****************************************************/

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

/************** Find initial sales for the past 4 months **************************************************************/

SELECT @ThisMembershipBeginDate ThisMembershipBeginDate
,	@ThisMonth ThisMonth
,	CTR.CenterNumber
,	CTR.CenterDescription
,	CLT.ClientSSID
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.ClientARBalance
,	CLT.ClientEMailAddress
,	'(' + LEFT(CLT.ClientPhone1,3) + ') ' + SUBSTRING(CLT.ClientPhone1,4,3) + '-' + RIGHT(CLT.ClientPhone1,4) Phone1
,	DM.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipStatusDescription
,	CASE WHEN DCM.ClientMembershipStatusDescription = 'Active' THEN 1 ELSE 0 END  Active
,	DATEDIFF(DAY,DCM.ClientMembershipBeginDate,GETDATE()) ClientMembershipDuration
,	Active_Memberships.ClientMembershipContractPrice
,	Active_Memberships.ClientMembershipKey
INTO #InitialSale
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CLT.CenterSSID
INNER JOIN #CenterNumber CN
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)  --No Surgery
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
	ON DM.MembershipSSID = DCM.MembershipSSID
OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipKey
							  ,         DCM.ClientMembershipContractPrice
							  ,		    DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipIdentifier
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
											ON CTR.CenterSSID = CLT.CenterSSID
										INNER JOIN #CenterNumber CN
											ON CTR.CenterNumber = CN.CenterNumber
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
											ON DM.MembershipKey = DCM.MembershipKey
							  WHERE     ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
										AND DCM.ClientMembershipStatusDescription = 'Active'
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) Active_Memberships
WHERE DCM.ClientMembershipBeginDate >= @ThisMembershipBeginDate
AND DM.RevenueGroupSSID = 1			--NB
AND DM.BusinessSegmentSSID = 1		--XTR+
AND DM.MembershipDescription <> 'New Client (ShowNoSale)'
AND CLT.DoNotCallFlag = 0
AND CLT.DoNotContactFlag = 0

/************** Find initial clients who have been applied (and remove these later) ************************************************/

SELECT INI.ThisMembershipBeginDate,
        INI.ThisMonth,
        INI.CenterNumber,
        INI.CenterDescription,
        INI.ClientSSID,
        INI.ClientKey,
        INI.ClientIdentifier,
        INI.ClientFirstName,
        INI.ClientLastName,
        INI.ClientARBalance,
		INI.ClientEMailAddress,
		INI.Phone1,
        INI.MembershipDescription,
        INI.ClientMembershipBeginDate,
        INI.ClientMembershipStatusDescription,
        INI.Active,
        INI.ClientMembershipDuration,
		INI.ClientMembershipContractPrice,
		INI.ClientMembershipKey
INTO #Applied
FROM #InitialSale INI
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON FST.ClientKey = INI.ClientKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN #CenterNumber CN
	ON CTR.CenterNumber = CN.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON DSC.SalesCodeKey = FST.SalesCodeKey
WHERE FST.SalesCodeKey IN(SELECT SalesCodeKey FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode WHERE SalesCodeDescriptionShort = 'NB1A')
AND INI.Active = 1
GROUP BY INI.ThisMembershipBeginDate,
         INI.ThisMonth,
         INI.CenterNumber,
         INI.CenterDescription,
         INI.ClientSSID,
         INI.ClientKey,
         INI.ClientIdentifier,
         INI.ClientFirstName,
         INI.ClientLastName,
         INI.ClientARBalance,
		 INI.ClientEMailAddress,
		INI.Phone1,
         INI.MembershipDescription,
         INI.ClientMembershipBeginDate,
         INI.ClientMembershipStatusDescription,
         INI.Active,
         INI.ClientMembershipDuration,
		INI.ClientMembershipContractPrice,
		INI.ClientMembershipKey


/********************************** Get Hair Order Information *************************************/
;
WITH    HairOrder_CTE
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY hso.ClientKey ORDER BY hso.ClientKey, hso.HairSystemOrderDate ASC ) AS RowNumber
               ,        ce.CenterSSID
               ,        hso.ClientKey
			   ,		ISA.ClientIdentifier
               ,        hso.ClientHomeCenterKey
               ,        hso.HairSystemOrderDate
               ,        hso.HairSystemOrderNumber
               ,        hso.HairSystemAppliedDate
               ,        hso.HairSystemDueDate
               ,        hso.ClientMembershipKey
               ,        m.MembershipDescription
			   ,		hso.HairSystemOrderStatusKey
			   ,		HSOS.HairSystemOrderStatusDescription
			   ,        hso.HairSystemReceivedDate
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder hso
                        INNER JOIN #InitialSale ISA
                            ON hso.ClientKey = ISA.ClientKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
                            ON hso.CenterKey = ce.CenterKey
						INNER JOIN #CenterNumber CN
							ON ce.CenterNumber = CN.CenterNumber
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                            ON hso.ClientMembershipKey = cm.ClientMembershipKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                            ON cm.MembershipKey = m.MembershipKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus HSOS
							ON HSOS.HairSystemOrderStatusKey = hso.HairSystemOrderStatusKey
						WHERE ISA.Active = 1
             )
     SELECT ho_cte.RowNumber
     ,      ho_cte.CenterSSID
     ,      ho_cte.ClientKey
	 ,      ho_cte.ClientIdentifier
     ,      ho_cte.ClientHomeCenterKey
     ,      ho_cte.HairSystemOrderDate
     ,      ho_cte.HairSystemOrderNumber
     ,      ho_cte.HairSystemAppliedDate
     ,      ho_cte.HairSystemDueDate
     ,      ho_cte.ClientMembershipKey
     ,      ho_cte.MembershipDescription
	 ,		ho_cte.HairSystemOrderStatusDescription
	 ,      ho_cte.HairSystemReceivedDate
     INTO   #HairOrder
     FROM   HairOrder_CTE ho_cte
     WHERE  ho_cte.RowNumber = 1

/************** Find Hair Orders with a status of 'Received at Center','Priority Hair' **************************/
SELECT
  HO.HairSystemOrderStatusDescription,
  INI.ThisMembershipBeginDate,
  INI.ThisMonth,
  INI.CenterNumber,
  INI.CenterDescription,
  INI.ClientKey,
  INI.ClientIdentifier,
  INI.ClientFirstName,
  INI.ClientLastName,
  INI.ClientEMailAddress,
		INI.Phone1,

  INI.MembershipDescription,
  INI.ClientMembershipBeginDate,
  INI.ClientMembershipStatusDescription,
  INI.Active,
  INI.ClientMembershipDuration,
  HO.HairSystemReceivedDate,
  INI.ClientMembershipContractPrice,
  INI.ClientMembershipKey
INTO #HairInCenter
FROM #HairOrder HO
INNER JOIN #InitialSale INI
	ON INI.ClientKey = HO.ClientKey
WHERE HO.HairSystemOrderStatusDescription IN('Received at Center','Priority Hair')
AND INI.Active = 1
AND INI.ClientKey NOT IN (SELECT ClientKey FROM #Applied)  --Find those who have not been applied
AND INI.ClientMembershipDuration <= 120						--Only those clients whose initial sale date is less than or equal to 120 days

/***************** Combine Hair Orders and Initial Sales for clients without appointments **********************/

INSERT INTO #NB_Top5
SELECT  HC.HairSystemOrderStatusDescription
       ,	HC.ThisMembershipBeginDate
       ,	HC.ThisMonth
       ,	HC.CenterNumber
       ,	HC.CenterDescription
       ,	HC.ClientKey
       ,	HC.ClientIdentifier
       ,	HC.ClientFirstName
       ,	HC.ClientLastName
	   ,	HC.ClientEMailAddress
		,	HC.Phone1
       ,	HC.MembershipDescription
       ,	HC.ClientMembershipBeginDate
       ,	HC.ClientMembershipStatusDescription
       ,	HC.Active
       ,	HC.ClientMembershipDuration
       ,	APPT.AppointmentDate
	   ,	APPT.AppointmentStartTime
	   ,	HC.HairSystemReceivedDate
	   ,	HC.ClientMembershipContractPrice
	   ,	NULL AS ExtendedPrice
	   ,	NULL AS ContractBalance
	   ,	HC.ClientMembershipKey
FROM #HairInCenter  HC
OUTER APPLY(SELECT AppointmentDate
				,	AppointmentStartTime
				,	ROW_NUMBER()OVER(PARTITION BY ClientKey ORDER BY A.AppointmentDate) AS Ranking
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment A
			WHERE A.ClientKey = HC.ClientKey
				AND A.AppointmentDate > GETDATE()
			) APPT
WHERE (APPT.AppointmentDate IS NULL OR APPT.Ranking = 1)

/******Find the Total Payments ****************************************************************************/

INSERT INTO #TotalPayments

		SELECT  FST.ClientKey
		,       DCM.ClientMembershipKey
		,		DCM.ClientMembershipEndDate
		,		SA.ClientMembershipContractPrice
		,		M.BusinessSegmentSSID
		,       FST.ExtendedPrice *	FST.Quantity AS ExtendedPrice
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
					ON FST.OrderDateKey = DD.DateKey
				INNER JOIN #InitialSale SA
					ON FST.ClientKey = SA.ClientKey AND FST.ClientMembershipKey = SA.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
					ON FST.SalesCodeKey = DSC.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
					ON FST.SalesOrderKey = DSO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
					ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
					ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M  WITH ( NOLOCK )
					ON M.MembershipKey = FST.MembershipKey
		WHERE   FST.ClientKey IN(SELECT ClientKey FROM #InitialSale)
					AND (FST.NB_TradAmt <> 0
							OR FST.NB_GradAmt <> 0
							OR FST.NB_ExtAmt <> 0
							OR FST.NB_XTRAmt <> 0)
					AND DCM.ClientMembershipEndDate >= GETUTCDATE()
					AND DSC.SalesCodeDepartmentSSID IN ( 2020 )
					AND DSC.SalesCodeDescriptionShort NOT IN ( 'EXTPMTLC', 'EXTPMTLCP', 'EXTPMTLH', 'EXTPMTLB', 'EXTPMTLCN', 'EXTPMTCAP82', 'EXTPMTCAP202', 'EXTPMTCAP272', 'EXTCAP312', 'EXTPMTCAP312', 'EXTCAP202TI', 'EXTCAP272TI', 'EXTCAP312TI' ) -- Exclude Laser Comb, Laser Helmet, Laser Band or Capillus Payments
					AND DSOD.IsVoidedFlag = 0
					AND M.BusinessSegmentSSID IN(1,2,6)
		GROUP BY FST.ClientKey
		,       DCM.ClientMembershipKey
		,		DCM.ClientMembershipEndDate
		,		SA.ClientMembershipContractPrice
		,		M.BusinessSegmentSSID
		,       FST.ExtendedPrice * FST.Quantity


INSERT INTO #SUM_TotalPayments
SELECT ClientKey
,       SUM(ClientMembershipContractPrice) AS ClientMembershipContractPrice
,       SUM(TP.ExtendedPrice) AS ExtendedPrice
,		SUM(TP.ClientMembershipContractPrice) - SUM(TP.ExtendedPrice) AS ContractBalance
FROM #TotalPayments TP
GROUP BY ClientKey

UPDATE NB
SET NB.ExtendedPrice = STP.ExtendedPrice
FROM #NB_Top5 NB
INNER JOIN #SUM_TotalPayments STP
	ON STP.ClientKey = NB.ClientKey
WHERE NB.ExtendedPrice IS NULL

UPDATE NB
SET NB.ContractBalance = STP.ContractBalance
FROM #NB_Top5 NB
INNER JOIN #SUM_TotalPayments STP
	ON STP.ClientKey = NB.ClientKey
WHERE NB.ContractBalance IS NULL

 /************************************************************/
IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
SELECT CenterNumber
,	'NB' AS Section
,	ThisMembershipBeginDate
,	ThisMonth
,	AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CenterDescription
,	ClientKey
,	ClientIdentifier
,	ClientFirstName
,	ClientLastName
,	ClientEmailAddress
,	ClientPhone1
,	ClientMembershipKey
,	MembershipDescription
,	ClientMembershipBeginDate
,	ClientMembershipStatusDescription
,	HairSystemOrderStatusDescription
,	Active
,	ClientMembershipDuration
,	HairSystemReceivedDate
,	ContractPrice
,	ExtendedPrice AS TotalPayments
,	ContractBalance
FROM #NB_Top5
ORDER BY ClientMembershipBeginDate DESC
END
ELSE
BEGIN
SELECT TOP 5 CenterNumber
,	'NB' AS Section
,	ThisMembershipBeginDate
,	ThisMonth
,	AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CenterDescription
,	ClientKey
,	ClientIdentifier
,	ClientFirstName
,	ClientLastName
,	ClientEmailAddress
,	ClientPhone1
,	ClientMembershipKey
,	MembershipDescription
,	ClientMembershipBeginDate
,	ClientMembershipStatusDescription
,	HairSystemOrderStatusDescription
,	Active
,	ClientMembershipDuration
,	HairSystemReceivedDate
,	ContractPrice
,	ExtendedPrice AS TotalPayments
,	ContractBalance
FROM #NB_Top5
ORDER BY ClientMembershipBeginDate DESC
END


END
GO
