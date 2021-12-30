/* CreateDate: 07/05/2019 15:59:13.217 , ModifyDate: 07/18/2019 11:53:51.883 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ProcedurePipeline
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_ProcedurePipeline
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/05/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ProcedurePipeline 202, '1/1/2017','7/31/2019'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ProcedurePipeline]
(
	@CenterSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/************* Create temp tables *************************************/

CREATE TABLE #Clients(
	CenterSSID INT
,	CenterDescription NVARCHAR(50)
,	ClientKey INT
,	ClientSSID NVARCHAR(50)
,	ClientIdentifier INT
,	ClientFirstName NVARCHAR(100)
,	ClientLlastName NVARCHAR(100)
,	BosleySiebelID NVARCHAR(20)
,	ClientMembershipKey INT
,	ClientMembershipSSID NVARCHAR(50)
,	MembershipKey INT
,	MembershipSSID NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipStatusDescription NVARCHAR(50)
,	ClientMembershipContractPrice DECIMAL(18,4)
,	ClientMembershipContractPaidAmount DECIMAL(18,4)  ---Change this to Total Payments
,	ClientMembershipBeginDate DATE
,	ClientMembershipEndDate DATE
)


CREATE TABLE #Initial(
	BosleySiebelID NVARCHAR(20)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientSSID NVARCHAR(50)
,	ClientFirstName NVARCHAR(50)
,	ClientLastName NVARCHAR(50)
,	contactkey NVARCHAR(20)
,	HCConsultant NVARCHAR(3)
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipStatusDescription NVARCHAR(50)
,	ClientMembershipContractPrice DECIMAL(18,4)
,	ClientMembershipContractPaidAmount DECIMAL(18,4)
,	ClientMembershipKey INT
,	ClientMembershipBeginDate DATE
,	ClientMembershipEndDate DATE
,	ProcedureDone date
,	EstimatedGraftAmount INT
,	ActualGraftAmount INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionNumber NVARCHAR(104)
,	INITASG_FullDate DATE
,	BosleyAppointment DATE
,	TriGen DECIMAL(18,4)
,	PostEXT DECIMAL(18,4)
,	PRP DECIMAL(18,4)
,	Laser DECIMAL(18,4)
,   [8Month] DATE
,   [12Month] DATE
,   [13+Month] DATE
)


CREATE TABLE #BOSAppt(
	CenterSSID INT
,	ClientHomeCenterSSID INT
,	ClientKey INT
,	ClientIdentifier INT
,	AppointmentDate DATE
,	AppointmentStartTime TIME
,	AppointmentEndTime TIME
,	CheckOutTime TIME
,	AppointmentSubject NVARCHAR(50)
,	AppointmentTypeDescription NVARCHAR(50)
)


CREATE TABLE #SalesCodes(
SalesCodeDescriptionShort NVARCHAR(20) NULL
,	SalesCodeTypeDescription NVARCHAR(150) NULL
,	SalesCodeKey INT NULL
,	SalesCodeSSID INT NULL
,	SalesCodeDescription NVARCHAR(150) NULL
,	TriGen INT NULL
,	PostEXT INT NULL
,	PRP INT NULL
,	Laser INT NULL
)


CREATE TABLE #AddOns(
	ClientKey INT
,	ClientIdentifier INT
,	SalesCodeKey INT
,	SalesCodeDescription NVARCHAR(60)
,	SalesCodeDescriptionShort NVARCHAR(20)
,	FullDate DATE
,	Quantity INT
,	ExtendedPrice DECIMAL(18,4)
,	TriGen DECIMAL(18,4)
,	PostEXT DECIMAL(18,4)
,	PRP DECIMAL(18,4)
,	Laser DECIMAL(18,4)
)


CREATE TABLE #Followup(
	AppointmentKey INT
,   AppointmentSSID NVARCHAR(50)
,	AppointmentDate DATE
,	AppointmentStartTime TIME
,   CenterKey INT
,   CenterSSID INT
,   ClientHomeCenterKey INT
,   ClientHomeCenterSSID INT
,   ClientKey INT
,   ClientSSID NVARCHAR(50)
,   ClientMembershipKey int
,   ClientMembershipSSID NVARCHAR(50)
,	ClientMembershipBeginDate DATE
,   [8Month] DATE
,   [12Month] DATE
,   [13+Month] DATE
,	Ranking INT
)

/************************* Find the active clients ************************/
INSERT INTO #Clients
SELECT  CLT.CenterSSID
,	CTR.CenterDescription
,	CLT.ClientKey
,	CLT.ClientSSID
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.BosleySiebelID
,	DCM.ClientMembershipKey
,	DCM.ClientMembershipSSID
,	DCM.MembershipKey
,	M.MembershipSSID
,	M.MembershipDescription
,	DCM.ClientMembershipStatusDescription
,	DCM.ClientMembershipContractPrice
,	DCM.ClientMembershipContractPaidAmount
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipEndDate
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
			OR CLT.CurrentSurgeryClientMembershipSSID = DCM.ClientMembershipSSID
			OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
			OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID
			)
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON M.MembershipSSID = DCM.MembershipSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON CTR.CenterKey = DCM.CenterKey
WHERE CTR.CenterSSID = @CenterSSID
AND (CLT.BosleySiebelID <> '')
--REMOVE the following so that all clients show
--AND DCM.ClientMembershipStatusDescription NOT IN('Cancel','Canceled','Expire','Expired')
--AND DCM.ClientMembershipEndDate > GETDATE()
ORDER BY CLT.ClientLastName, CLT.ClientFirstName

--SELECT * FROM #Clients

/************* Find the intial set of data ********************************/

INSERT INTO #Initial
SELECT C.BosleySiebelID
,	C.ClientKey
,	C.ClientIdentifier
,	C.ClientSSID
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.contactkey
,	E.EmployeeInitials AS 'HCConsultant'
,	M.MembershipDescription
,	C.ClientMembershipStatusDescription
,	C.ClientMembershipContractPrice
,	C.ClientMembershipContractPaidAmount
,	C.ClientMembershipKey
,	C.ClientMembershipBeginDate
,	C.ClientMembershipEndDate
,	DD.FullDate AS 'ProcedureDone'
,	INIASG.S1_EstGraftsCnt AS 'EstimatedGraftAmount'
,	ISNULL(FST_Grafts.S_SurgeryGraftsCnt,0) AS 'ActualGraftAmount'
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,	DD_INIASG.FullDate AS INITASG_FullDate
,	NULL AS BosleyAppointment
,	NULL AS TriGen
,	NULL AS PostEXT
,	NULL AS PRP
,	NULL AS Laser
,   NULL AS [8Month]
,   NULL AS [12Month]
,   NULL AS [13+Month]
FROM #Clients C
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	ON FST.ClientMembershipKey = C.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
		ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON DSO.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipKey = M.MembershipKey

	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST_Grafts  --Procedure Done
		ON CM.ClientMembershipKey = FST_Grafts.ClientMembershipKey
			AND FST_Grafts.SalesCodeKey = 1701
	LEFT JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	          	ON DD.DateKey = FST_Grafts.OrderDateKey

	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction INIASG
		ON CM.ClientMembershipKey = INIASG.ClientMembershipKey AND INIASG.SalesCodeKey = 467  --Initial assignment
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_INIASG
		ON INIASG.OrderDateKey = DD_INIASG.DateKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON INIASG.Employee1Key = E.EmployeeKey

	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FST.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
		ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE CTR.CenterSSID = @CenterSSID
	AND DSO.IsVoidedFlag = 0
	AND DD_INIASG.FullDate BETWEEN @StartDate AND @EndDate
GROUP BY C.BosleySiebelID
,	C.ClientKey
,	C.ClientIdentifier
,	C.ClientSSID
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.contactkey
,	E.EmployeeInitials
,	M.MembershipDescription
,	C.ClientMembershipContractPrice
,	C.ClientMembershipContractPaidAmount
,	C.ClientMembershipKey
,	C.ClientMembershipBeginDate
,	C.ClientMembershipEndDate
,	C.ClientMembershipStatusDescription
,	DD.FullDate
,	INIASG.S1_EstGraftsCnt
,	FST_Grafts.S_SurgeryGraftsCnt
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,	DD_INIASG.FullDate


/******************* Find Bosley Appointments ****************************/
INSERT INTO #BOSAppt
SELECT APPT.CenterSSID
,	APPT.ClientHomeCenterSSID
,	#Initial.ClientKey
,	#Initial.ClientIdentifier
,	APPT.AppointmentDate
,	APPT.AppointmentStartTime
,	APPT.AppointmentEndTime
,	APPT.CheckOutTime
,	APPT.AppointmentSubject
,	APPT.AppointmentTypeDescription
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
INNER JOIN #Initial
	ON #Initial.ClientKey = APPT.ClientKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON DCM.ClientMembershipKey = APPT.ClientMembershipKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipKey = DCM.MembershipKey
WHERE APPT.AppointmentTypeDescription = 'Bosley Appointment'
AND APPT.IsDeletedFlag = 0


/********************* Insert BOS Appointments *****************************/

UPDATE I
SET I.BosleyAppointment = BOS.AppointmentDate
FROM #Initial I
INNER JOIN #BOSAppt BOS
	ON BOS.ClientKey = I.ClientKey
WHERE I.BosleyAppointment IS NULL

/******************* Find Add-Ons SalesCodeKeys ****************************/

INSERT INTO #SalesCodes
SELECT 	SalesCodeDescriptionShort
,	SalesCodeTypeDescription
,	SalesCodeKey
,	SalesCodeSSID
,	SalesCodeDescription
,	CASE WHEN SalesCodeDescriptionShort LIKE '%TG%' THEN 1 ELSE 0 END AS 'TriGen'
,	CASE WHEN  SalesCodeDescriptionShort LIKE '%PostEXT%' THEN 1 ELSE 0 END AS 'PostEXT'
,	CASE WHEN SalesCodeDescription LIKE '%PRP%' THEN 1 ELSE 0 END AS  'PRP'
,	CASE WHEN SalesCodeDescriptionShort LIKE '%Laser%' THEN 1 ELSE 0 END AS  'Laser'
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE SalesCodeDepartmentSSID = 1006
UNION
SELECT SalesCodeDescriptionShort
,	SalesCodeTypeDescription
,	SalesCodeKey
,	SalesCodeSSID
,	SalesCodeDescription
,	CASE WHEN SalesCodeDescriptionShort LIKE '%TG%' THEN 1 ELSE 0 END AS 'TriGen'
,	CASE WHEN  SalesCodeDescriptionShort LIKE '%PostEXT%' THEN 1 ELSE 0 END AS 'PostEXT'
,	CASE WHEN SalesCodeDescription LIKE '%PRP%' THEN 1 ELSE 0 END AS  'PRP'
,	CASE WHEN SalesCodeDescriptionShort LIKE '%Laser%' THEN 1 ELSE 0 END AS  'Laser'
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE SalesCodeDescription LIKE '%Post%'
AND SalesCodeTypeDescription = 'Membership'


/************ Find PRP, Laser and PostEXT ***************************************************/

INSERT INTO #AddOns
SELECT #Initial.ClientKey
,	#Initial.ClientIdentifier
,	FST.SalesCodeKey
,	DSC.SalesCodeDescription
,	DSC.SalesCodeDescriptionShort
,	DD.FullDate
,	FST.Quantity
,	FST.ExtendedPrice
,	CODES.TriGen
,	CODES.PostEXT
,	CODES.PRP
,	CODES.Laser
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN #Initial
	ON #Initial.ClientKey = FST.ClientKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
INNER JOIN #SalesCodes CODES
	ON CODES.SalesCodeKey = FST.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON FST.SalesCodeKey = DSC.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON FST.SalesOrderKey = DSO.SalesOrderKey
WHERE  DSO.IsVoidedFlag = 0

/********* UPDATE #Initial with the amounts for each AddOn ***************/

--Update TriGen
UPDATE I
SET I.TriGen = AO.ExtendedPrice
FROM #Initial I
INNER JOIN #AddOns AO
	ON AO.ClientIdentifier = I.ClientIdentifier
WHERE I.TriGen IS NULL AND AO.TriGen = 1

--Update PostEXT
UPDATE I
SET I.PostEXT = AO.ExtendedPrice
FROM #Initial I
INNER JOIN #AddOns AO
	ON AO.ClientIdentifier = I.ClientIdentifier
WHERE I.PostEXT IS NULL AND AO.PostEXT = 1

--Update PRP
UPDATE I
SET I.PRP = AO.ExtendedPrice
FROM #Initial I
INNER JOIN #AddOns AO
	ON AO.ClientIdentifier = I.ClientIdentifier
WHERE I.PRP IS NULL AND AO.PRP = 1


--Update Laser
UPDATE I
SET I.Laser = AO.ExtendedPrice
FROM #Initial I
INNER JOIN #AddOns AO
	ON AO.ClientIdentifier = I.ClientIdentifier
WHERE I.Laser IS NULL AND AO.Laser = 1



/************ Find follow up appointments *************************/

INSERT INTO #Followup
SELECT  APPT.AppointmentKey
,       APPT.AppointmentSSID
,		APPT.AppointmentDate
,		APPT.AppointmentStartTime
,       APPT.CenterKey
,       APPT.CenterSSID
,       APPT.ClientHomeCenterKey
,       APPT.ClientHomeCenterSSID
,       I.ClientKey
,       I.ClientSSID
,       APPT.ClientMembershipKey
,       APPT.ClientMembershipSSID
,		I.ClientMembershipBeginDate
,       oaEMO.AppointmentDate AS '8Month'
,       oaTMO.AppointmentDate AS  '12Month'
,       oaBTM.AppointmentDate AS  '13+Month'
,		ROW_NUMBER()OVER(PARTITION BY APPT.ClientMembershipKey ORDER BY APPT.AppointmentDate, APPT.AppointmentStartTime DESC) AS Ranking
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
INNER JOIN #Initial I
	ON I.ClientMembershipKey = APPT.ClientMembershipKey
OUTER APPLY(SELECT TOP 1 EMO.Appointmentdate
				FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment EMO  --Eighth Month
				WHERE EMO.AppointmentDate BETWEEN DATEADD("M",8,I.ClientMembershipBeginDate) AND DATEADD("M",11,I.ClientMembershipBeginDate)
					AND I.ClientKey = EMO.ClientKey AND EMO.IsDeletedFlag = 0
				ORDER BY EMO.AppointmentDate DESC) oaEMO
OUTER APPLY(SELECT TOP 1 TMO.Appointmentdate
				FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment TMO	--Twelfth Month
				WHERE TMO.AppointmentDate BETWEEN DATEADD("M",12,I.ClientMembershipBeginDate) AND DATEADD("M",13,I.ClientMembershipBeginDate)
					AND I.ClientKey = TMO.ClientKey AND TMO.IsDeletedFlag = 0
				ORDER BY TMO.AppointmentDate DESC) oaTMO
OUTER APPLY(SELECT TOP 1 BTM.Appointmentdate
				FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment BTM	--Beyond Twelve Months
				WHERE BTM.AppointmentDate > DATEADD("M",13,I.ClientMembershipBeginDate)
					AND I.ClientKey = BTM.ClientKey AND BTM.IsDeletedFlag = 0
				ORDER BY BTM.AppointmentDate DESC) oaBTM
WHERE APPT.IsDeletedFlag = 0


/********* UPDATE #Initial with the follow-up appointments per client ********************************************************************/

UPDATE I
SET I.[8Month] = F.[8Month]
FROM #Initial I
INNER JOIN #Followup F
	ON F.ClientMembershipKey = I.ClientMembershipKey
WHERE I.[8Month] IS NULL

UPDATE I
SET I.[12Month] = F.[12Month]
FROM #Initial I
INNER JOIN #Followup F
	ON F.ClientMembershipKey = I.ClientMembershipKey
WHERE I.[12Month] IS NULL

UPDATE I
SET I.[13+Month] = F.[13+Month]
FROM #Initial I
INNER JOIN #Followup F
	ON F.ClientMembershipKey = I.ClientMembershipKey
WHERE I.[13+Month] IS NULL

/***************** Final select ********************************************************************/


SELECT  * FROM #Initial ORDER BY ClientLastName




END
GO
