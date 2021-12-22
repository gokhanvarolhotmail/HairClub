/* CreateDate: 07/26/2016 16:13:11.600 , ModifyDate: 10/24/2019 14:03:24.507 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_42_Step01_CreateHeader
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

EXEC spSVC_CommissionTypeID_42_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_42_Step01_CreateHeader]
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


-- Declare variables and commission header temp table
DECLARE @CommissionTypeID INT
,       @RefreshInterval INT
,       @TransactionStartDate DATETIME
,       @TransactionEndDate DATETIME
,       @PlanStartDate DATETIME
,       @PlanEndDate DATETIME


CREATE TABLE #Header (
	RowID INT IDENTITY(1, 1)
,	CenterKey INT
,	CenterSSID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	HairSystemOrderGUID UNIQUEIDENTIFIER
,	HairSystemOrderNumber INT
)


--Default all variables
SELECT	@CommissionTypeID = 42
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


SELECT  @PlanStartDate = BeginDate
,       @PlanEndDate = ISNULL(EndDate, GETDATE())
FROM    DimCommissionType
WHERE   CommissionTypeID = @CommissionTypeID


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


/* Get Apps in the last 60 days */
SELECT  C.CenterKey AS 'CenterKey'
,       C.CenterSSID AS 'CenterSSID'
,       SO.SalesOrderKey AS 'SalesOrderKey'
,       SO.OrderDate AS 'SalesOrderDate'
,       DC.ClientKey
,       DC.ClientIdentifier
,       DC.ClientFirstName AS 'FirstName'
,       DC.ClientLastName AS 'LastName'
,       CM.ClientMembershipKey AS 'ClientMembershipKey'
,       M.MembershipKey AS 'MembershipKey'
,       M.MembershipDescription AS 'MembershipDescription'
,       E.EmployeeKey AS 'EmployeeKey'
,       E.EmployeeFullName AS 'EmployeeFullName'
,       H.HairSystemOrderSSID AS 'HairSystemOrderGUID'
,       H.HairSystemOrderNumber
INTO	#Applications
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON DC.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON SO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder H
			ON SOD.HairSystemOrderSSID = H.HairSystemOrderSSID
WHERE   C.CenterTypeKey = 2
		AND C.Active = 'Y'
		AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
		AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
		AND SC.SalesCodeDescriptionShort IN ( 'NB1A', 'APP', 'APPSOL' )
		AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
		AND SOD.IsVoidedFlag = 0


/* Determine if HSO for each App was a PRIORITY HSO */
SELECT  clt.ClientIdentifier AS 'ClientIdentifier'
,		hso.HairSystemOrderNumber
,       MIN(dbo.GetLocalFromUTC(hst.HairSystemOrderTransactionDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag)) AS 'HairSystemOrderTransactionDate'
INTO	#PriorityHair
FROM    #Applications A
		INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemOrder hso WITH ( NOLOCK )
			ON hso.HairSystemOrderGUID = A.HairSystemOrderGUID
        INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemOrderTransaction hst WITH ( NOLOCK )
            ON hst.HairSystemOrderGUID = hso.HairSystemOrderGUID
        INNER JOIN SQL05.HairClubCMS.dbo.datClient clt WITH ( NOLOCK )
            ON clt.ClientGUID = hst.ClientGUID
        INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter ctr WITH ( NOLOCK )
            ON ctr.CenterID = hst.CenterID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpTimeZone tz WITH ( NOLOCK )
            ON tz.TimeZoneID = ctr.TimeZoneID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderStatus sf WITH ( NOLOCK ) --Status From
            ON hst.PreviousHairSystemOrderStatusID = sf.HairSystemOrderStatusID
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderStatus st WITH ( NOLOCK ) --Status To
            ON hst.NewHairSystemOrderStatusID = st.HairSystemOrderStatusID
		INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderProcess hsp
			ON hsp.HairSystemOrderProcessID = hst.HairSystemOrderProcessID
WHERE   ( sf.HairSystemOrderStatusDescriptionShort <> 'PRIORITY' AND st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
		AND ( sf.HairSystemOrderStatusDescriptionShort <> st.HairSystemOrderStatusDescriptionShort )
		AND hsp.HairSystemOrderProcessDescriptionShort <> 'XFERREJ'
		AND hso.LastUpdateUser <> 'sa-Inv'
GROUP BY clt.ClientIdentifier
,		hso.HairSystemOrderNumber


/* Create Header record for Stylist */
INSERT  INTO #Header
		SELECT  A.CenterKey
		,       A.CenterSSID
		,       A.SalesOrderKey
		,       A.SalesOrderDate
		,       A.ClientKey
		,       A.ClientIdentifier
		,       A.FirstName
		,       A.LastName
		,       A.ClientMembershipKey
		,       A.MembershipKey
		,       A.MembershipDescription
		,       A.EmployeeKey
		,       A.EmployeeFullName
		,       A.HairSystemOrderGUID
		,       A.HairSystemOrderNumber
		FROM    #Applications A
				CROSS APPLY ( SELECT TOP 1
										PH.ClientIdentifier
							  ,         PH.HairSystemOrderTransactionDate
							  FROM      #PriorityHair PH
							  WHERE     PH.HairSystemOrderNumber = A.HairSystemOrderNumber
							  ORDER BY  PH.HairSystemOrderTransactionDate ASC
							) x_P
		WHERE   ( A.ClientIdentifier <> x_P.ClientIdentifier )
					OR ( DATEDIFF(MONTH, CAST(x_P.HairSystemOrderTransactionDate AS DATE), A.SalesOrderDate) > 12 )


/* Create Header record for Stylist Supervisor */
INSERT  INTO #Header (
				CenterKey
        ,		CenterSSID
        ,		SalesOrderKey
        ,		SalesOrderDate
        ,		ClientKey
		,		ClientIdentifier
		,		FirstName
		,		LastName
        ,		ClientMembershipKey
        ,		MembershipKey
        ,		MembershipDescription
        ,		EmployeeKey
        ,		EmployeeFullName
		,		HairSystemOrderGUID
		,		HairSystemOrderNumber
		)
		SELECT  H.CenterKey
		,       H.CenterSSID
		,       H.SalesOrderKey
		,       H.SalesOrderDate
		,       H.ClientKey
		,       H.ClientIdentifier
        ,       H.FirstName
        ,       H.LastName
		,       H.ClientMembershipKey
		,       H.MembershipKey
		,       H.MembershipDescription
		,       SS.EmployeeKey
		,       SS.EmployeeFullName
		,		H.HairSystemOrderGUID
		,		H.HairSystemOrderNumber
		FROM    #Header H
				INNER JOIN #StylistSupervisors SS
					ON SS.CenterID = H.CenterSSID
		WHERE	H.EmployeeKey <> SS.EmployeeKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CenterKey INT
,       @CenterSSID INT
,       @SalesOrderKey INT
,       @SalesOrderDate DATETIME
,       @ClientKey INT
,       @ClientMembershipKey INT
,       @MembershipKey INT
,       @MembershipDescription NVARCHAR(50)
,       @EmployeeKey INT
,       @EmployeeFullName NVARCHAR(102)


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #Header


-- Loop through all commission header records, inserting them individually to check for their existence
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CenterKey = CenterKey
            ,       @CenterSSID = CenterSSID
            ,       @SalesOrderKey = SalesOrderKey
            ,       @SalesOrderDate = SalesOrderDate
            ,       @ClientKey = ClientKey
            ,       @ClientMembershipKey = ClientMembershipKey
            ,       @MembershipKey = MembershipKey
            ,       @MembershipDescription = MembershipDescription
            ,		@EmployeeKey = ISNULL(EmployeeKey, -1)
			,		@EmployeeFullName = ISNULL(EmployeeFullName, '')
            FROM    #Header
            WHERE   RowID = @CurrentCount


            EXEC spSVC_CommissionHeaderInsert
                @CommissionTypeID
            ,   @CenterKey
            ,   @CenterSSID
            ,   @SalesOrderKey
            ,   @SalesOrderDate
            ,   @ClientKey
            ,   @ClientMembershipKey
            ,   @MembershipKey
            ,   @MembershipDescription
            ,   @EmployeeKey
            ,   @EmployeeFullName


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
