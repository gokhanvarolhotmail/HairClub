/* CreateDate: 08/02/2018 13:35:50.777 , ModifyDate: 08/02/2018 15:32:47.680 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            [rptHWPipeline]
 Procedure Description:
 Created By:                Rachelen Hut
 Date Created:              08/02/2018
 Destination Server:        SQL01
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
This report is for Today's clients, so it is on the SQL01.HairClub database
================================================================================================
SAMPLE EXECUTION:

EXEC [rptHWPipeline] '07/21/2018','07/28/2018'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptHWPipeline](
	@StartDate DATETIME
,	@EndDate DATETIME
)

AS
BEGIN

	SET @EndDate = @EndDate + '23:59:00'



/******************* Create temp tables ***********************************************************/

CREATE TABLE #Clients(
	ClientIdentifier INT
,	ClientGUID NVARCHAR(50)
,	ClientFullNameCalc  NVARCHAR(127)
)

CREATE TABLE #SalesOrder(	CenterID INT
	,	SalesOrderGUID NVARCHAR(50)
	,	CenterDescriptionFullCalc NVARCHAR(50)
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(127)
	,	ClientMembershipGUID NVARCHAR(50)
	,	MembershipDescription NVARCHAR(50)
	,	BeginDate DATE
	,	EndDate DATE
	,	LastAppointmentDate DATE
	,	NextAppointmentDate DATE
	,	ContractPaidAmount DECIMAL(14,8)
	,	RevenueGroupID INT
	,	BusinessSegmentID INT
	,	Consultant NVARCHAR(50)
	,	HairSystemTotal INT
	,	HairSystemUsed INT
	,	HairSystemRemaining INT
	,	Ranking INT
)

CREATE TABLE #Laser (ClientIdentifier INT
,	SalesCodeDescription NVARCHAR(60)
)



/**************** Find Clients **************************************************************************/

INSERT INTO #Clients
SELECT CLT.ClientIdentifier
,	CLT.ClientGUID
,	CLT.ClientFullNameCalc
FROM datClient CLT
INNER JOIN dbo.datAppointment APPT
	ON APPT.ClientGUID = CLT.ClientGUID
WHERE CLT.CenterID = 1001
	AND AppointmentDate BETWEEN @StartDate AND @EndDate
	AND ISNULL(APPT.IsDeletedFlag,0) = 0
GROUP BY CLT.ClientIdentifier
,	CLT.ClientGUID
,	CLT.ClientFullNameCalc


/********** Find sales information ************************************************************************************/

INSERT INTO #SalesOrder
SELECT		CTR.CenterID
	,	SO.SalesOrderGUID
	,	CTR.CenterDescriptionFullCalc
	,	CLT.ClientIdentifier
	,	CLT.ClientFullNameCalc
	,	MEM.ClientMembershipGUID
	,	M.MembershipDescription
	,	MEM.BeginDate
	,	MEM.EndDate
	,	NULL AS 'LastAppointmentDate'
	,	NULL AS  'NextAppointmentDate'
	,	M.ContractPrice
	,	M.RevenueGroupID
	,	M.BusinessSegmentID
	,	STUFF(P.Consultant,1,1,'') AS 'Consultant'
	,	AHS.TotalAccumQuantity AS 'HairSystemTotal'
	,	AHS.UsedAccumQuantity AS 'HairSystemUsed'
	,	AHS.AccumQuantityRemainingCalc AS 'HairSystemRemaining'
	,	Ranking
FROM datSalesOrder SO
	INNER JOIN cfgCenter CTR
		ON SO.CenterID = CTR.CenterID
	INNER JOIN datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	INNER JOIN lkpSalesOrderType soType
		ON soType.SalesOrderTypeID = SO.SalesOrderTypeID
	INNER JOIN datClient CLT
		ON CLT.ClientGUID = SO.ClientGUID
	INNER JOIN #Clients
		ON CLT.ClientIdentifier = #Clients.ClientIdentifier
	CROSS APPLY
		(SELECT #Clients.ClientIdentifier
					,	ClientMembershipGUID	--Find latest memebership
					,	CM.BeginDate
					,	CM.EndDate
					,	CM.MembershipID
					,	ROW_NUMBER()OVER(PARTITION BY #Clients.ClientIdentifier, CM.ClientMembershipGUID ORDER BY CM.BeginDate DESC) AS Ranking
					FROM dbo.datClientMembership CM
					WHERE CM.ClientGUID = #Clients.ClientGUID
					AND (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
						OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
						OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
						OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
					) MEM
	INNER JOIN dbo.cfgMembership M ON MEM.MembershipID = M.MembershipID
	LEFT JOIN datClientMembershipAccum AHS
		ON AHS.ClientMembershipGUID = MEM.ClientMembershipGUID AND AHS.AccumulatorID = 8 --Hair Systems
	CROSS APPLY (SELECT ', ' + CON.EmployeeInitials
					FROM datEmployee AS CON
					INNER JOIN datSalesOrderDetail SOD
						ON SOD.Employee1GUID = CON.EmployeeGUID
					INNER JOIN 	datSalesOrder SO
						ON SO.SalesOrderGUID = SOD.SalesOrderGUID
					WHERE #Clients.ClientGUID = SO.ClientGUID
					GROUP BY CON.EmployeeInitials
					ORDER BY CON.EmployeeInitials
					FOR XML PATH('')
					) AS P (Consultant)
WHERE CLT.ClientIdentifier IN(SELECT ClientIdentifier FROM #Clients)
	AND soType.SalesOrderTypeDescriptionShort = 'MO'  --Membership Order
	AND M.MembershipDescriptionShort NOT IN ( 'SHOWNOSALE', 'SNSSURGOFF' )
	AND MEM.Ranking = 1
GROUP BY CTR.CenterID
	,	SO.SalesOrderGUID
	,	CTR.CenterDescriptionFullCalc
	,	CLT.ClientIdentifier
	,	CLT.ClientFullNameCalc
	,	MEM.ClientMembershipGUID
	,	M.MembershipDescription
	,	MEM.BeginDate
	,	MEM.EndDate
	,	M.ContractPrice
	,	M.RevenueGroupID
	,	M.BusinessSegmentID
	,	STUFF(P.Consultant,1,1,'')
	,	AHS.TotalAccumQuantity
	,	AHS.UsedAccumQuantity
	,	AHS.AccumQuantityRemainingCalc
	,	Ranking

/************************* Find the Previous Appointment Date ***************************************/

UPDATE SO
SET LastAppointmentDate =  dbo.fn_GetPreviousAppointmentDate(SO.ClientMembershipGUID)
FROM #SalesOrder SO
INNER JOIN dbo.datSalesOrder DSO
	ON SO.ClientMembershipGUID = DSO.ClientMembershipGUID
WHERE LastAppointmentDate IS NULL

/************************* Find the Next Appointment Date *******************************************/

UPDATE SO
SET NextAppointmentDate = CONVERT(DATETIME,dbo.fn_GetNextAppointmentDate(SO.ClientMembershipGUID) )
FROM #SalesOrder SO
INNER JOIN dbo.datSalesOrder DSO
	ON SO.ClientMembershipGUID = DSO.ClientMembershipGUID
WHERE NextAppointmentDate IS NULL

/********************* Find the Cashier if there is no Consultant ***********************************/

UPDATE #SalesOrder
SET #SalesOrder.Consultant = CSH.EmployeeInitials
FROM #SalesOrder
	LEFT JOIN dbo.datSalesOrder SO
		ON SO.SalesOrderGUID = #SalesOrder.SalesOrderGUID
	LEFT OUTER JOIN datEmployee CSH
		ON CSH.EmployeeGUID = SO.EmployeeGUID
WHERE #SalesOrder.Consultant IS NULL


/********************* Find the Stylist if there is no Consultant ***********************************/

UPDATE #SalesOrder
SET #SalesOrder.Consultant = STY.EmployeeInitials
FROM #SalesOrder
	LEFT JOIN dbo.datSalesOrderDetail SOD
		ON SOD.SalesOrderGUID = #SalesOrder.SalesOrderGUID
	LEFT OUTER JOIN datEmployee STY
		ON STY.EmployeeGUID = SOD.Employee2GUID
WHERE #SalesOrder.Consultant IS NULL


/**********Find Laser Devices Purchased *************************************************************/

INSERT INTO #Laser
SELECT #Clients.ClientIdentifier
,	SC.SalesCodeDescription
FROM #Clients
INNER JOIN datSalesOrder SO ON SO.ClientGUID = #Clients.ClientGUID
INNER JOIN dbo.datSalesOrderDetail SOD ON SOD.SalesOrderGUID = SO.SalesOrderGUID
INNER JOIN dbo.cfgSalesCode SC ON SC.SalesCodeID = SOD.SalesCodeID
INNER JOIN dbo.lkpSalesCodeDepartment SCD ON SCD.SalesCodeDepartmentID = SC.SalesCodeDepartmentID
WHERE SC.SalesCodeDescription LIKE '%laser%'
	AND SC.SalesCodeDepartmentID IN(3065,3080)
	AND IsSerialized = 1

/********** Final select ****************************************************************************/

SELECT 		#SalesOrder.CenterID
,	CenterDescriptionFullCalc
,	#SalesOrder.ClientIdentifier
,	ClientFullNameCalc
,	ClientMembershipGUID
,	MembershipDescription
,	BeginDate
,	EndDate
,	LastAppointmentDate
,	NextAppointmentDate
,	ContractPaidAmount
,	RevenueGroupID
,	BusinessSegmentID
,	Consultant
,	HairSystemTotal
,	HairSystemUsed
,	HairSystemRemaining
,	Ranking
,	#Laser.SalesCodeDescription AS 'LaserDevices'
FROM #SalesOrder
LEFT JOIN #Laser
	ON #Laser.ClientIdentifier = #SalesOrder.ClientIdentifier
WHERE Ranking = 1
GROUP BY 	#SalesOrder.CenterID
,	CenterDescriptionFullCalc
,	#SalesOrder.ClientIdentifier
,	ClientFullNameCalc
,	ClientMembershipGUID
,	MembershipDescription
,	BeginDate
,	EndDate
,	LastAppointmentDate
,	NextAppointmentDate
,	ContractPaidAmount
,	RevenueGroupID
,	BusinessSegmentID
,	Consultant
,	HairSystemTotal
,	HairSystemUsed
,	HairSystemRemaining
,	Ranking
,	#Laser.SalesCodeDescription



END
GO
