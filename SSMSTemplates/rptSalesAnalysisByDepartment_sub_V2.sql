/*
==============================================================================
PROCEDURE:				rptSalesAnalysisByDepartment_sub
VERSION:				v1.0 
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
AUTHOR: 				Rachelen Hut
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED: 		3/28/2014

==============================================================================
DESCRIPTION:	
This report is to show Totals for New Business, Non Program, Products, Recurring Business and Services revenue 
similar to Franchise Royalty.  It is the sub report for Sales Analysis by Department.

==============================================================================
NOTES:
05/01/2014 - RH - Changed "AND sc.SalesCodeDescription NOT LIKE '%NonPgm%' AND m.RevenueGroupID = 2 THEN 'Membership Recurring Business'"
						to "AND sc.SalesCodeDescription NOT LIKE '%NonPgm%' AND m.RevenueGroupID <> 1 THEN 'Membership Recurring Business'"
10/29/2015 - RH - Changed code for Refunds to show: CASE WHEN sod.PriceTaxCalc < 0 AND sod.IsRefundedFlag = 1  THEN sod.PriceTaxCalc 
						since the column RefundedTotalPrice was not populated (WO#119979)
10/05/2017 - RH - Added code @EndDate = @EndDate + '23:59:59'
==============================================================================
SAMPLE EXECUTION: 
EXEC rptSalesAnalysisByDepartment_sub 292, '10/1/2017', '10/31/2017', 0, 'Membership New Business' 

EXEC rptSalesAnalysisByDepartment_sub 292, '10/1/2015', '10/31/2015', 0, 'Membership Recurring Business' 

EXEC rptSalesAnalysisByDepartment_sub 201, '10/1/2015', '10/31/2015', 0, 'Membership Non Program' 
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptSalesAnalysisByDepartment_sub_V2]
    @CenterId                       INT
  , @StartDate                      DATETIME
  , @EndDate                        DATETIME
  , @GenderID                       INT = 0 --0 All, 1 Male, 2 Female
  , @SalesCodeDepartmentDescription NVARCHAR(100)
AS
SET NOCOUNT ON ;

SET @EndDate = @EndDate + '23:59:59' ;

SELECT
    [TimeZoneID]
  , [UTCOffset]
  , [UsesDayLightSavingsFlag]
  , [IsActiveFlag]
  , [dbo].[GetUTCFromLocal](@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
  , [dbo].[GetUTCFromLocal](DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
INTO [#UTCDateParms]
FROM [dbo].[lkpTimeZone]
WHERE [IsActiveFlag] = 1 ;

DECLARE
    @MembershipManagement_DivisionID INT
  , @Services_DivisionID             INT
  , @Products_DivisionID             INT ;

SELECT @MembershipManagement_DivisionID = [SalesCodeDivisionID]
FROM [dbo].[lkpSalesCodeDivision]
WHERE [SalesCodeDivisionDescriptionShort] = 'MbrMgmt' ;

SELECT @Services_DivisionID = [SalesCodeDivisionID]
FROM [dbo].[lkpSalesCodeDivision]
WHERE [SalesCodeDivisionDescriptionShort] = 'Services' ;

SELECT @Products_DivisionID = [SalesCodeDivisionID]
FROM [dbo].[lkpSalesCodeDivision]
WHERE [SalesCodeDivisionDescriptionShort] = 'Products' ;

CREATE TABLE [#Analysis]
(
    [SalesCodeDivisionID]            INT
  , [SalesCodeDivisionDescription]   NVARCHAR(100)
  , [SalesCodeDepartmentID]          INT
  , [SalesCodeDepartmentDescription] NVARCHAR(100)
  , [Department]                     NVARCHAR(100)
  , [SalesCodeID]                    INT
  , [SalesCodeDescriptionShort]      NVARCHAR(15)
  , [SalesCodeDescription]           NVARCHAR(50)
  , [Code]                           NVARCHAR(100)
  , [OrderDate]                      DATETIME
  , [InvoiceNumber]                  NVARCHAR(50)
  , [Quantity]                       INT
  , [Price]                          DECIMAL(21, 6)
  , [Discount]                       MONEY
  , [TotalTaxCalc]                   MONEY
  , [ExtendedPriceCalc]              DECIMAL(33, 6)
  , [PriceTaxCalc]                   DECIMAL(35, 6)
  , [ClientFullNameCalc]             NVARCHAR(127)
  , [Cashier]                        NVARCHAR(5)
  , [ConGUID]                        UNIQUEIDENTIFIER
  , [Consultant]                     NVARCHAR(5)
  , [ConFullName]                    NVARCHAR(127)
  , [Stylist]                        NVARCHAR(5)
  , [PerformerGUID]                  UNIQUEIDENTIFIER
  , [PerformerName]                  NVARCHAR(102)
  , [RevenueGroupID]                 INT
  , [RefundedTotalPrice]             MONEY
) ;

IF @GenderID = 0
    BEGIN
        INSERT INTO [#Analysis]
        SELECT
            [scdv].[SalesCodeDivisionID]
          , [scdv].[SalesCodeDivisionDescription]
          , [sc].[SalesCodeDepartmentID]
          , CASE WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' AND [m].[RevenueGroupID] = 1 THEN 'Membership New Business'
                WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' AND [m].[RevenueGroupID] <> 1 AND [sc].[SalesCodeDescription] NOT LIKE '%NonPgm%' THEN 'Membership Recurring Business'
                WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' AND [sc].[SalesCodeDescription] LIKE '%(NonPgm)%' THEN 'Membership Non Program'
                ELSE [scd].[SalesCodeDepartmentDescription]
            END AS [SalesCodeDepartmentDescription]
          , CAST([sc].[SalesCodeDepartmentID] AS VARCHAR) + ' - ' + [scd].[SalesCodeDepartmentDescription] AS [Department]
          , [sc].[SalesCodeID]
          , [sc].[SalesCodeDescriptionShort]
          , [sc].[SalesCodeDescription]
          , [sc].[SalesCodeDescriptionShort] + ' - ' + [sc].[SalesCodeDescription] AS [Code]
          , [dbo].[GetLocalFromUTC]([so].[OrderDate], [tz].[UTCOffset], [tz].[UsesDayLightSavingsFlag]) AS [OrderDate]
          --,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate
          , [so].[InvoiceNumber]
          , [sod].[Quantity]
          , [sod].[Price]
          , [sod].[Discount]
          , [sod].[TotalTaxCalc]
          , [sod].[ExtendedPriceCalc]
          , [sod].[PriceTaxCalc]
          , [cl].[ClientFullNameCalc]
          , [csh].[EmployeeInitials] AS [Cashier]
          , [sod].[Employee1GUID] AS [ConGUID]
          , [con].[EmployeeInitials] AS [Consultant]
          , ISNULL([con].[EmployeeInitials] + ' - ', '') + ISNULL([con].[EmployeeFullNameCalc], '') AS [ConFullName]
          , [sty].[EmployeeInitials] AS [Stylist]
          , CASE WHEN [scdv].[SalesCodeDivisionID] = @Services_DivisionID OR [scdv].[SalesCodeDivisionID] = @Products_DivisionID THEN COALESCE([sod].[Employee2GUID], [sod].[Employee1GUID], [sod].[Employee3GUID])
                ELSE COALESCE([sod].[Employee1GUID], [sod].[Employee2GUID], [sod].[Employee3GUID])
            END AS [PerformerGUID]
          , CASE WHEN [scdv].[SalesCodeDivisionID] = @Services_DivisionID OR [scdv].[SalesCodeDivisionID] = @Products_DivisionID THEN COALESCE([sty].[EmployeeFullNameCalc], [con].[EmployeeFullNameCalc], [doc].[EmployeeFullNameCalc])
                ELSE COALESCE([con].[EmployeeFullNameCalc], [sty].[EmployeeFullNameCalc], [doc].[EmployeeFullNameCalc])
            END AS [PerformerName]
          , CASE WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' THEN [m].[RevenueGroupID] ELSE 0 END AS [RevenueGroupID]
          , CASE WHEN [sod].[PriceTaxCalc] < 0 AND [sod].[IsRefundedFlag] = 1 THEN [sod].[PriceTaxCalc] ELSE '0.00' END AS [RefundedTotalPrice]
        FROM [dbo].[datSalesOrderDetail] AS [sod]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [con] ON [con].[EmployeeGUID] = [sod].[Employee1GUID]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [sty] ON [sty].[EmployeeGUID] = [sod].[Employee2GUID]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [doc] ON [doc].[EmployeeGUID] = [sod].[Employee3GUID]
        INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [sod].[SalesCodeID]
        INNER JOIN [dbo].[lkpSalesCodeDepartment] AS [scd] ON [scd].[SalesCodeDepartmentID] = [sc].[SalesCodeDepartmentID]
        INNER JOIN [dbo].[lkpSalesCodeDivision] AS [scdv] ON [scdv].[SalesCodeDivisionID] = [scd].[SalesCodeDivisionID] AND [scdv].[SalesCodeDivisionID] <> @MembershipManagement_DivisionID
        INNER JOIN [dbo].[datSalesOrder] AS [so] ON [so].[SalesOrderGUID] = [sod].[SalesOrderGUID] AND [so].[CenterID] = @CenterId AND [so].[IsVoidedFlag] <> 1
        INNER JOIN [dbo].[cfgCenter] AS [ctr] ON [so].[CenterID] = [ctr].[CenterID]
        INNER JOIN [dbo].[lkpTimeZone] AS [tz] ON [ctr].[TimeZoneID] = [tz].[TimeZoneID]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [csh] ON [csh].[EmployeeGUID] = [so].[EmployeeGUID]
        INNER JOIN [dbo].[datClient] AS [cl] ON [cl].[ClientGUID] = [so].[ClientGUID]
        INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [so].[ClientMembershipGUID]
        INNER JOIN [dbo].[cfgMembership] AS [m] ON [m].[MembershipID] = [cm].[MembershipID]
        JOIN [#UTCDateParms] AS [UTCDateParms] ON [UTCDateParms].[TimeZoneID] = [tz].[TimeZoneID]
        WHERE [so].[OrderDate] BETWEEN [UTCDateParms].[UTCStartDate] AND [UTCDateParms].[UTCEndDate]
          --WHERE dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate and @EndDate + '23:59:59'
          --WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate and @EndDate + '23:59:59'
          AND [scd].[IsActiveFlag] = 1
        ORDER BY [cl].[ClientFullNameCalc]
               , [so].[InvoiceNumber] ;
    END ;
ELSE
    BEGIN
        INSERT INTO [#Analysis]
        SELECT
            [scdv].[SalesCodeDivisionID]
          , [scdv].[SalesCodeDivisionDescription]
          , [sc].[SalesCodeDepartmentID]
          , CASE WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' AND [m].[RevenueGroupID] = 1 THEN 'Membership New Business'
                WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' AND [m].[RevenueGroupID] <> 1 AND [sc].[SalesCodeDescription] NOT LIKE '%NonPgm%' THEN 'Membership Recurring Business'
                WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' AND [sc].[SalesCodeDescription] LIKE '%(NonPgm)%' THEN 'Membership Non Program'
                ELSE [scd].[SalesCodeDepartmentDescription]
            END AS [SalesCodeDepartmentDescription]
          , CAST([sc].[SalesCodeDepartmentID] AS VARCHAR) + ' - ' + [scd].[SalesCodeDepartmentDescription] AS [Department]
          , [sc].[SalesCodeID]
          , [sc].[SalesCodeDescriptionShort]
          , [sc].[SalesCodeDescription]
          , [sc].[SalesCodeDescriptionShort] + ' - ' + [sc].[SalesCodeDescription] AS [Code]
          , [dbo].[GetLocalFromUTC]([so].[OrderDate], [tz].[UTCOffset], [tz].[UsesDayLightSavingsFlag]) AS [OrderDate]
          --,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate
          , [so].[InvoiceNumber]
          , [sod].[Quantity]
          , [sod].[Price]
          , [sod].[Discount]
          , [sod].[TotalTaxCalc]
          , [sod].[ExtendedPriceCalc]
          , [sod].[PriceTaxCalc]
          , [cl].[ClientFullNameCalc]
          , [csh].[EmployeeInitials] AS [Cashier]
          , [sod].[Employee1GUID] AS [ConGUID]
          , [con].[EmployeeInitials] AS [Consultant]
          , ISNULL([con].[EmployeeInitials] + ' - ', '') + ISNULL([con].[EmployeeFullNameCalc], '') AS [ConFullName]
          , [sty].[EmployeeInitials] AS [Stylist]
          , CASE WHEN [scdv].[SalesCodeDivisionID] = @Services_DivisionID OR [scdv].[SalesCodeDivisionID] = @Products_DivisionID THEN COALESCE([sod].[Employee2GUID], [sod].[Employee1GUID], [sod].[Employee3GUID])
                ELSE COALESCE([sod].[Employee1GUID], [sod].[Employee2GUID], [sod].[Employee3GUID])
            END AS [PerformerGUID]
          , CASE WHEN [scdv].[SalesCodeDivisionID] = @Services_DivisionID OR [scdv].[SalesCodeDivisionID] = @Products_DivisionID THEN COALESCE([sty].[EmployeeFullNameCalc], [con].[EmployeeFullNameCalc], [doc].[EmployeeFullNameCalc])
                ELSE COALESCE([con].[EmployeeFullNameCalc], [sty].[EmployeeFullNameCalc], [doc].[EmployeeFullNameCalc])
            END AS [PerformerName]
          , CASE WHEN [scd].[SalesCodeDepartmentDescription] = 'Membership Revenue' THEN [m].[RevenueGroupID] ELSE 0 END AS [RevenueGroupID]
          , CASE WHEN [sod].[PriceTaxCalc] < 0 AND [sod].[IsRefundedFlag] = 1 THEN [sod].[PriceTaxCalc] ELSE '0.00' END AS [RefundedTotalPrice]
        FROM [dbo].[datSalesOrderDetail] AS [sod]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [con] ON [con].[EmployeeGUID] = [sod].[Employee1GUID]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [sty] ON [sty].[EmployeeGUID] = [sod].[Employee2GUID]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [doc] ON [doc].[EmployeeGUID] = [sod].[Employee3GUID]
        INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [sod].[SalesCodeID]
        INNER JOIN [dbo].[lkpSalesCodeDepartment] AS [scd] ON [scd].[SalesCodeDepartmentID] = [sc].[SalesCodeDepartmentID]
        INNER JOIN [dbo].[lkpSalesCodeDivision] AS [scdv] ON [scdv].[SalesCodeDivisionID] = [scd].[SalesCodeDivisionID] AND [scdv].[SalesCodeDivisionID] <> @MembershipManagement_DivisionID
        INNER JOIN [dbo].[datSalesOrder] AS [so] ON [so].[SalesOrderGUID] = [sod].[SalesOrderGUID] AND [so].[CenterID] = @CenterId AND [so].[IsVoidedFlag] <> 1
        INNER JOIN [dbo].[cfgCenter] AS [ctr] ON [so].[CenterID] = [ctr].[CenterID]
        INNER JOIN [dbo].[lkpTimeZone] AS [tz] ON [ctr].[TimeZoneID] = [tz].[TimeZoneID]
        LEFT OUTER JOIN [dbo].[datEmployee] AS [csh] ON [csh].[EmployeeGUID] = [so].[EmployeeGUID]
        INNER JOIN [dbo].[datClient] AS [cl] ON [cl].[ClientGUID] = [so].[ClientGUID] AND [cl].[GenderID] = @GenderID
        INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [so].[ClientMembershipGUID]
        INNER JOIN [dbo].[cfgMembership] AS [m] ON [m].[MembershipID] = [cm].[MembershipID]
        JOIN [#UTCDateParms] AS [UTCDateParms] ON [UTCDateParms].[TimeZoneID] = [tz].[TimeZoneID]
        WHERE [so].[OrderDate] BETWEEN [UTCDateParms].[UTCStartDate] AND [UTCDateParms].[UTCEndDate]
          --WHERE dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate and @EndDate + '23:59:59'
          --WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate and @EndDate + '23:59:59'
          AND [scd].[IsActiveFlag] = 1
        ORDER BY [cl].[ClientFullNameCalc]
               , [so].[InvoiceNumber] ;
    END ;

SELECT *
FROM [#Analysis]
WHERE [SalesCodeDepartmentDescription] = @SalesCodeDepartmentDescription ;

DROP TABLE [#UTCDateParms] ;
GO

RETURN ;

EXEC [dbo].[rptSalesAnalysisByDepartment_sub_V2]
    @CenterId = 100
  , @StartDate = '20220101'
  , @EndDate = '20220315'
  , @GenderID = 0 --0 All, 1 Male, 2 Female
  , @SalesCodeDepartmentDescription = 'Shampoos' ;
GO