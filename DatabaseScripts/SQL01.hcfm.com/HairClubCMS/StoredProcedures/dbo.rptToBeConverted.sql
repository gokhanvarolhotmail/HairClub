/*===============================================================================================
-- Procedure Name:			rptToBeConverted
-- Procedure Description:
--
-- Created By:				Mike Maass
-- Implemented By:			Mike Maass
-- Last Modified By:		Mike Maass
--
-- Date Created:			10/07/2013
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:

10/07/2013 - MLM - Initial Creation
12/04/2013 - RMH - Added join on dbo.lkpBusinessSegment for the BusinessSegmentID and description.
03/28/2014 - DSL - Excluded memberships with a status of Expire
04/07/2014 - DSL - Added the following columns:
					- Consultant
					- Pre-Checkup Date
					- NB1A Date
					- 24HR Checkup Date
					- Hair System Order Due Date
04/28/2014 - DL - Changed report so that clients are kept on the report up to 12 months after expiration
04/27/2017   PRM  Updated to reference new datClientPhone table
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptToBeConverted] 201, '59,60,8,9,53,45,46,47,48,4,5,13,10'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptToBeConverted]
(
	@CenterID INT,
	@MembershipIDs nvarchar(max)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

	DECLARE @PhoneTypeID_Home int
	SELECT @PhoneTypeID_Home = PhoneTypeID FROM lkpPhoneType WHERE PhoneTypeDescriptionShort = 'Home'

/********************************** Get Clients *************************************/
;
WITH    MEMBERSHIP_CTE
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY cm.ClientGUID ORDER BY c.ClientGUID, cm.EndDate DESC ) AS RowNumber
               ,        cm.ClientGUID
               ,        cm.ClientMembershipGUID
               ,        cm.MembershipID
               ,        cm.BeginDate
               ,        cm.EndDate
               ,        so.OrderDate AS DateOfSale
			   ,		sod.Employee1GUID
               ,        ISNULL(cm.ContractPrice, 0) AS ContractPrice
               ,        ISNULL(cm.ContractPaidAmount, 0) AS ContractPaidAmount
               FROM     datClient c
                        INNER JOIN datClientMembership cm
                            ON c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
                               OR c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
                               OR c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
                        INNER JOIN cfgMembership m
                            ON cm.MembershipID = m.MembershipID
                        INNER JOIN datSalesOrder so
                            ON cm.ClientMembershipGUID = so.ClientMembershipGUID
                        INNER JOIN datSalesOrderDetail sod
                            ON so.SalesOrderGUID = sod.SalesOrderGUID
                        INNER JOIN cfgSalesCode sc
                            ON sod.SAlesCodeID = sc.SalesCodeID
               WHERE    c.CenterID = @CenterID
                        AND sc.SalesCodeDescriptionShort = 'INITASG'
                        AND cm.MembershipID IN ( SELECT item
                                                 FROM   fnSplit(@MembershipIDs, ',') )
                        AND cm.EndDate > DATEADD(MONTH, -12, CONVERT(VARCHAR(11), GETDATE(), 101))
             )
     SELECT cl.ClientGUID
	 ,		cl.ClientIdentifier
	 ,		cl.ClientFullNameCalc
     ,      cl.CenterID
     ,      m.MembershipID
     ,      m.MembershipDescription + ' (' + CONVERT(VARCHAR(11), cm.EndDate, 101) + ')' AS 'MembershipDescription'
	 ,		m.MembershipSortOrder
     ,      m.BusinessSegmentID
     ,      bs.BusinessSegmentDescription
     ,      cm.DateOfSale
	 ,		DE.EmployeeFullNameCalc
	 ,      (SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = cl.ClientGUID AND PhoneTypeID = @PhoneTypeID_Home) AS HomePhone
     ,      dbo.fn_GetNextAppointmentDate(cm.ClientMembershipGUID) NextAppointmentDate
     ,      cl.ARBalance
	 ,		cm.ContractPrice
     ,      cm.ContractPrice - cm.ContractPaidAmount AS ContractBalance
     INTO	#Clients
	 FROM   MEMBERSHIP_CTE cm
            INNER JOIN datClient cl ON cl.ClientGUID = cm.ClientGUID
            INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
            INNER JOIN lkpBusinessSegment bs ON m.BusinessSegmentID = bs.BusinessSegmentID
			INNER JOIN datEmployee DE ON DE.EmployeeGUID = cm.Employee1GUID
     WHERE  cm.RowNumber = 1
     ORDER BY cl.ClientFullNameCalc


/********************************** Get Pre-Checkup Dates *************************************/
SELECT	C.ClientGUID
,		MIN(DSO.OrderDate) AS 'PreCheckupDate'
INTO	#PreCheckupDate
FROM	datSalesOrder DSO
		INNER JOIN datSalesOrderDetail DSOD
			ON DSO.SalesOrderGUID = DSOD.SalesOrderGUID
		INNER JOIN cfgSalesCode CSC
			ON DSOD.SalesCodeID = CSC.SalesCodeID
		INNER JOIN #Clients C
			ON DSO.ClientGUID = C.ClientGUID
WHERE   CSC.SalesCodeDepartmentID = 5030
		AND CSC.SalesCodeID = 728
GROUP BY C.ClientGUID


/********************************** Get 24HR Checkup Dates *************************************/
SELECT	C.ClientGUID
,		MIN(DSO.OrderDate) AS '24HrCheckupDate'
INTO	#24HrCheckupDate
FROM	datSalesOrder DSO
		INNER JOIN datSalesOrderDetail DSOD
			ON DSO.SalesOrderGUID = DSOD.SalesOrderGUID
		INNER JOIN cfgSalesCode CSC
			ON DSOD.SalesCodeID = CSC.SalesCodeID
		INNER JOIN #Clients C
			ON DSO.ClientGUID = C.ClientGUID
WHERE   CSC.SalesCodeDepartmentID = 5030
		AND CSC.SalesCodeID = 727
GROUP BY C.ClientGUID


/********************************** Get Initial Application Date *************************************/
SELECT	C.ClientGUID
,		MIN(DSO.OrderDate) AS 'InitialApplicationDate'
INTO	#InitialApplicationDate
FROM	datSalesOrder DSO
		INNER JOIN datSalesOrderDetail DSOD
			ON DSO.SalesOrderGUID = DSOD.SalesOrderGUID
		INNER JOIN cfgSalesCode CSC
			ON DSOD.SalesCodeID = CSC.SalesCodeID
		INNER JOIN #Clients C
			ON DSO.ClientGUID = C.ClientGUID
WHERE   CSC.SalesCodeDepartmentID = 5010
		AND CSC.SalesCodeID = 648
GROUP BY C.ClientGUID


/********************************** Get Hair Arrival Date *************************************/
SELECT  DHSO.ClientGUID
,       MIN(DHSO.DueDate) AS 'HairArrivalDate'
INTO	#HairArrivalDate
FROM    dbo.datHairSystemOrder DHSO
        LEFT JOIN dbo.cfgHairSystem HS
            ON HS.HairSystemID = DHSO.HairSystemID
        INNER JOIN dbo.lkpHairSystemOrderStatus LHSOS
            ON DHSO.HairSystemOrderStatusID = LHSOS.HairSystemOrderStatusID
               AND LHSOS.HairSystemOrderStatusDescriptionShort IN ( 'CENT', 'NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship', 'FAC-Ship' )
		INNER JOIN #Clients C
			ON DHSO.ClientGUID = C.ClientGUID
WHERE   ( DHSO.CenterID = @CenterID
          AND DHSO.hairsystemorderstatusID <> 8 )
        OR ( DHSO.ClientHomeCenterID = @CenterID
             AND DHSO.HairSystemOrderStatusID = 8 )
GROUP BY DHSO.ClientGUID


/********************************** Display Data *************************************/
SELECT  C.BusinessSegmentID
,       C.BusinessSegmentDescription
,		C.ClientFullNameCalc
,       C.MembershipDescription
,		C.DateOfSale
,		C.EmployeeFullNameCalc AS 'Consultant'
,       C.HomePhone
,       C.ContractPrice
,       C.ContractBalance
,       HAD.HairArrivalDate
,       PCD.PreCheckupDate
,       C.NextAppointmentDate
,       IAD.InitialApplicationDate
,       HCD.[24HrCheckupDate]
FROM    #Clients C
        LEFT JOIN #PreCheckupDate PCD ON PCD.ClientGUID = C.ClientGUID
        LEFT JOIN #24HrCheckupDate HCD ON HCD.ClientGUID = C.ClientGUID
        LEFT JOIN #InitialApplicationDate IAD ON IAD.ClientGUID = C.ClientGUID
        LEFT JOIN #HairArrivalDate HAD ON HAD.ClientGUID = C.ClientGUID
ORDER BY C.BusinessSegmentID
,		C.MembershipSortOrder
,		C.ClientIdentifier

END

/****** Object:  StoredProcedure [dbo].[rptCreditCardPaymentSummary]    Script Date: 11/22/2013 10:58:26 AM ******/
SET ANSI_NULLS ON
