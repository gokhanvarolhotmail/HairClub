/* CreateDate: 11/02/2012 13:58:09.153 , ModifyDate: 03/24/2017 09:37:06.027 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionCancelCreateDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionCancelCreateDetail
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionCancelCreateDetail]
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
--Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO [AuditCommissionProcedures] (
			RunDate
        ,	ProcedureName
        ,	StartTime
		)
VALUES  (
			CONVERT(DATE, GETDATE())
        ,	OBJECT_NAME(@@PROCID)
        ,	CONVERT(TIME, GETDATE())
		)


SET @AuditID = SCOPE_IDENTITY()
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


--Declare commission detail temp table
CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CancelHeaderKey INT
,	CommissionHeaderKey INT
)


--Get open commission records
INSERT  INTO #OpenCommissions (
			CancelHeaderKey
        ,	CommissionHeaderKey
		)
        SELECT  FCCH.CancelHeaderKey
        ,       FCH.CommissionHeaderKey
        FROM    [FactCommissionCancelHeader] FCCH
                INNER JOIN [FactCommissionHeader] FCH
                    ON FCCH.ClientKey = FCH.ClientKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                    ON FCH.ClientMembershipKey = DCM.ClientMembershipKey
                       AND DCM.ClientMembershipBeginDate < FCCH.SalesOrderDate
        WHERE   ISNULL(FCH.IsClosed, 0) = 0
                AND ISNULL(FCH.IsClientCancelled, 0) = 0
                AND FCH.CommissionTypeID IN ( 3, 4, 7, 8, 9, 10, 11, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31, 32, 34, 36, 38, 40, 41, 42, 43, 44, 45 ) -- 12, 14, 15, 33 Commission Plans are not retractable
                AND ISNULL(FCH.AdvancedCommission, 0) > 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CancelHeaderKey INT
,       @CommissionHeaderKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through all commission detail records, inserting them individually to check for their existence
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CancelHeaderKey = CancelHeaderKey
            ,       @CommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


            EXEC spSVC_CommissionCancelDetailInsert
                @CancelHeaderKey
            ,   @CommissionHeaderKey


            SET @CurrentCount = @CurrentCount + 1
      END


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
