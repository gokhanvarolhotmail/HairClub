/* CreateDate: 11/13/2012 14:06:57.930 , ModifyDate: 09/18/2017 19:35:07.160 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spRpt_CommissionSummaryByEmployee]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Commission summary by employee
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_CommissionSummaryByEmployee] 292, 335, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_CommissionSummaryByEmployee]
(
    @CenterSSID INT,
    @PayPeriodKey INT,
    @Filter INT
)
AS
BEGIN
    SET NOCOUNT ON;

    /*
		@Filter
		1 = Potential
		2 = Advanced
	*/

    CREATE TABLE #Commission
    (
        CommissionHeaderKey INT,
        CenterSSID INT,
        CenterDescription VARCHAR(100),
        EmployeeKey INT,
        EmployeeFullName VARCHAR(255),
        CommissionTypeID INT,
        CommissionTypeDescription VARCHAR(100),
        ClientKey INT,
        ClientFullName VARCHAR(100),
        Commission MONEY,
        PayPeriodStartDate DATETIME,
        PayPeriodEndDate DATETIME,
        Membership VARCHAR(100)
    );



    IF @Filter = 1 --Select all open potential commission
    BEGIN
        INSERT INTO #Commission
        SELECT FCH.CommissionHeaderKey,
               FCH.CenterSSID,
               CTR.CenterDescription + ' (' + CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ')' AS 'CenterDescriptionNumber',
               ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey',
               ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName',
               CT.CommissionTypeID,
               CT.[Grouping] AS 'CommissionTypeDescription',
               DC.ClientKey,
               CONVERT(VARCHAR, ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)) + ' - ' + DC.ClientFullName AS 'ClientFullName',
               ISNULL(FCH.CalculatedCommission, 0),
               NULL,
               NULL,
               FCH.MembershipDescription
        FROM [dbo].[FactCommissionHeader] FCH
            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
                ON FCH.ClientKey = DC.ClientKey
            INNER JOIN DimCommissionType CT
                ON FCH.CommissionTypeID = CT.CommissionTypeID
            INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
                ON FCH.CenterKey = CTR.CenterKey
            LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
                ON FCH.EmployeeKey = DE.EmployeeKey
            LEFT OUTER JOIN FactCommissionOverride FCO
                ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
        WHERE FCH.CenterSSID = @CenterSSID
              AND FCH.IsClosed = 0
              AND FCH.AdvancedPayPeriodKey IS NULL
              AND FCH.RetractedPayPeriodKey IS NULL
              AND ISNULL(FCH.CalculatedCommission, 0) <> 0;
    END;
    ELSE IF @Filter = 2 --Select all advanced or retracted commission
    BEGIN
        --Get "advanced" commission
        INSERT INTO #Commission
        SELECT FCH.CommissionHeaderKey,
               FCH.CenterSSID,
               CONVERT(VARCHAR(3), CTR.ReportingCenterSSID) + ' - ' + CTR.CenterDescription AS 'CenterDescriptionNumber',
               ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) AS 'EmployeeKey',
               ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeFullName',
               CT.CommissionTypeID,
               CT.[Grouping] AS 'CommissionTypeDescription',
               DC.ClientKey,
               CONVERT(VARCHAR, ISNULL(DC.ClientNumber_Temp, DC.ClientIdentifier)) + ' - ' + DC.ClientFullName AS 'ClientFullName',
               ISNULL(FCH.AdvancedCommission, 0),
               PP.StartDate,
               PP.EndDate,
               FCH.MembershipDescription
        FROM [dbo].[FactCommissionHeader] FCH
            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
                ON FCH.ClientKey = DC.ClientKey
            INNER JOIN DimCommissionType CT
                ON FCH.CommissionTypeID = CT.CommissionTypeID
            INNER JOIN lkpPayPeriods PP
                ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
            INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
                ON FCH.CenterKey = CTR.CenterKey
            LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
                ON FCH.EmployeeKey = DE.EmployeeKey
            LEFT OUTER JOIN FactCommissionOverride FCO
                ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
        WHERE FCH.CenterSSID = @CenterSSID
              AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
              AND ISNULL(FCH.AdvancedCommission, 0) <> 0;
    END;


    SELECT *
    FROM #Commission
    ORDER BY EmployeeFullName,
             ClientFullName;
END;
GO
