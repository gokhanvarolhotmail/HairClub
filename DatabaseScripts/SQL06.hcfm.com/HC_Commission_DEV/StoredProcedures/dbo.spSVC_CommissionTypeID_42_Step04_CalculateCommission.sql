/* CreateDate: 07/26/2016 16:12:03.763 , ModifyDate: 10/23/2018 13:26:40.417 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_42_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/14/2016
DESCRIPTION:			ST-6g Priority Hair Application
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_42_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_42_Step04_CalculateCommission]
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
-- Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO [AuditCommissionProcedures] (
				RunDate
        ,		ProcedureName
        ,		StartTime
		)
VALUES  (
				CONVERT(DATE, GETDATE())
        ,		OBJECT_NAME(@@PROCID)
        ,		CONVERT(TIME, GETDATE())
		)


SET @AuditID = SCOPE_IDENTITY()
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


-- Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CenterSSID INT
,	EmployeeKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	SalesCodeKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 42


/* Get Stylist Supervisors for each center */
SELECT	EC.CenterID
,       E.EmployeeKey
,       DE.EmployeeFullNameCalc AS 'EmployeeFullName'
,       EC.IsActiveFlag
INTO	#StylistSupervisors
FROM    SQL05.HairClubCMS.dbo.datEmployee DE
        INNER JOIN SQL05.HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
            ON E.EmployeeSSID = DE.EmployeeGUID
        INNER JOIN SQL05.HairClubCMS.dbo.datEmployeeCenter EC
            ON EC.EmployeeGUID = DE.EmployeeGUID
        INNER JOIN SQL05.HairClubCMS.dbo.cfgEmployeePositionJoin EPJ
            ON EPJ.EmployeeGUID = DE.EmployeeGUID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpEmployeePosition LEP
            ON LEP.EmployeePositionID = EPJ.EmployeePositionID
WHERE   EC.IsActiveFlag = 1
        AND EPJ.IsActiveFlag = 1
        AND LEP.EmployeePositionDescription = 'Stylist Supervisor'
ORDER BY EC.CenterID
,       E.EmployeeKey


/* Determine what centers (if any) have multiple Stylist Supervisors */
SELECT  SS.CenterID
INTO	#DuplicateSS
FROM    #StylistSupervisors SS
GROUP BY SS.CenterID
HAVING COUNT(*) > 1


/* Remove multiple Stylist Supervisors */
DELETE	SS
FROM    #StylistSupervisors SS
		INNER JOIN #DuplicateSS DS
			ON DS.CenterID = SS.CenterID


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
				CommissionHeaderKey
		,		CenterSSID
		,		EmployeeKey
        ,		CommissionTypeID
        ,		SalesOrderKey
        ,		ClientMembershipKey
        ,		MembershipKey
        ,		SalesCodeKey
		)
        SELECT  FCH.CommissionHeaderKey
		,		FCH.CenterSSID
		,		FCH.EmployeeKey
        ,       FCH.CommissionTypeID
        ,       FCH.SalesOrderKey
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey
        ,       FCD.SalesCodeKey
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NULL
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentCenterSSID INT
,       @CurrentEmployeeKey INT
,       @CurrentStylistSupervisorEmployeeKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SET @CurrentCommissionHeaderKey = (SELECT OC.CommissionHeaderKey FROM #OpenCommissions OC WHERE OC.RowID = @CurrentCount)
			SET @CurrentCenterSSID = (SELECT OC.CenterSSID FROM #OpenCommissions OC WHERE OC.RowID = @CurrentCount)
			SET @CurrentEmployeeKey = (SELECT OC.EmployeeKey FROM #OpenCommissions OC WHERE OC.RowID = @CurrentCount)


            SET @CurrentStylistSupervisorEmployeeKey = ( SELECT ss.EmployeeKey FROM #StylistSupervisors ss WHERE ss.CenterID = @CurrentCenterSSID )


			-- Update FactCommissionHeader
            UPDATE  FactCommissionHeader
            SET     CalculatedCommission = CASE WHEN ( @CurrentEmployeeKey = @CurrentStylistSupervisorEmployeeKey ) THEN 10 ELSE 15 END
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL


			-- Increment loop counter
            SET @CurrentCount = @CurrentCount + 1
      END


------------------------------------------------------------------------------------------
-- Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
