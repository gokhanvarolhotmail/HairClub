/* CreateDate: 03/29/2013 13:48:50.377 , ModifyDate: 01/24/2022 14:52:23.043 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSOrderDenormalizationUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		10/24/2012

LAST REVISION DATE: 	02/04/2013

==============================================================================
DESCRIPTION:	Update Order (Sales Order Denormalized) table
==============================================================================
NOTES:
		* 09/11/2012 MVT - Created
		* 11/20/2012 MVT - Updated to fill in Division, Division Description, Department,
							Department Description, and Sales Code Description for a Tender Record.
		* 11/26/2012 MVT - Fixed tender issues.
		* 12/07/2012 MVT - Updated to user Center time zone for order date
		* 12/07/2012 MVT - Added GL and GLName columns
		* 12/09/2012 MVT - Added logic to record Tender Identifier.
		* 12/16/2012 MVT - Added Sales Order Type
		* 12/20/2012 MVT - Modified to only insert orders that started 10 min prior to this proc running.
							This is done so that orders are imported as a whole with all detail and tender
							records.
		* 01/15/2013 KRM - Modified GL derivation to be based on Business Segment
		* 01/15/2013 MVT - Added logic to distinguish between FO and SO tenders.  Added 998* Departments for FO's.
							Added CC Type to Sales Code Description field for Tender.
		* 01/18/2013 MVT - Fixed issue with GL join.
		* 02/04/2013 MVT - Added Finance Company name to the Finance tender types
		* 03/29/2013 MVT - Moved proc from SQL01 HairClubCMS DB to SQL05. Changed Name from dbaOrderDenormalizationUpdate.
		* 04/02/2013 MVT - Modified so that the order record related to the SO is updated each time the SO, SO Detail, or SO Tender are modified.
		* 01/09/2014 MVT - Added another check to try and prevent duplicate tenders.
		* 02/05/2014 MB  - Replaced initial 2 queries with optimized version and indexes to gain effeciency
		* 04/24/2014 MVT - Added Siebel ID column
		* 04/28/2014 MVT - Modified script to update Siebel ID column
		* 05/28/2014 MVT - Added BosleyProcedureOffice, BosleyConsultOffice, and CreditCardLast4Digits columns
		* 05/30/2014 MVT - Added SalesCodeSerialNumber column
		* 01/07/2015 KRM - Added in new GL derivation for XtrandsMem
		* 03/23/2015 DSL - Added join to lkpGeneralLedger table for Xtrands Business Segment & changed SELECT statement to use that table for the GL ID
		* 02/16/2016 DSL - Added join to datHairSystemOrder table for new HairSystemOrderNumber column
		* 02/16/2016 DSL - Added logic to determine Gender value for new column in dbaOrder table
		* 08/31/2016 MVT - TFS #7799 - Added logic to Update "Tax1" and "Tax2" columns.
		* 03/02/2017 MVT - Improved performance by restructuring the inserts into the #UpdateOrders table to only
							orders that need to be updates ++ Modified the Updates to start with #UpdateOrders temp
							table and joining to dbaOrders, instead of vice versa.  This limits the starting set of
							data to only needed updates. ++ Determined the MinCreateDate ahead of time instead of doing
							DateDiff in the Where clause of the Insert Select statement.
		* 06/04/2018 DSL - Updated logic to use CenterNumber instead of CenterID
		* 03/25/2021 KRM - Updated logic to handle new Tender Type - FinanceAR
		* 03/25/2021 KRM - Added ApprovalCode
		* 01/24/2022 GVAROL Fixed NULL FirstName Crashes ... ISNULL([c].[FirstName], 'N/A')
==============================================================================
SAMPLE EXECUTION:
EXEC [extHairClubCMSOrderDenormalizationUpdate]
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSOrderDenormalizationUpdate ]
AS
SET NOCOUNT ON ;

DECLARE
    @ProcStartTime AS DATETIME = GETUTCDATE()
  , @MinCreateDate AS DATETIME = DATEADD(HOUR, -1, GETUTCDATE()) ;

IF OBJECT_ID('[tempdb]..[#UpdateOrders]') IS NOT NULL
    DROP TABLE [#UpdateOrders] ;

CREATE TABLE [#UpdateOrders] ( [SalesOrderGuid] UNIQUEIDENTIFIER PRIMARY KEY ) ;

-- detail records that changed
INSERT INTO [#UpdateOrders]
SELECT DISTINCT
       [SO].[SalesOrderGUID]
FROM [dbo].[dbaOrder] AS [O]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrderDetail] AS [SOD] ON [SOD].[SalesOrderDetailGUID] = [O].[SalesOrderDetailGuid]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [SO] ON [SO].[SalesOrderGUID] = [SOD].[SalesOrderGUID]
WHERE [SOD].[LastUpdate] > [O].[RecordLastUpdate] OR [SO].[LastUpdate] > [O].[SalesOrderLastUpdate] ;

-- tender records that changed
INSERT INTO [#UpdateOrders]
SELECT DISTINCT
       [SOT].[SalesOrderGUID]
FROM [dbo].[dbaOrder] AS [O]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrderTender] AS [SOT] ON [SOT].[SalesOrderTenderGUID] = [O].[SalesOrderTenderGuid]
LEFT OUTER JOIN [#UpdateOrders] AS [UO] ON [SOT].[SalesOrderGUID] = [UO].[SalesOrderGuid]
WHERE [SOT].[LastUpdate] > [O].[RecordLastUpdate] AND [UO].[SalesOrderGuid] IS NULL ;

-- Update Detail record if SO or Detail record were updated
UPDATE [ord]
SET
    [ord].[SalesOrderInvoiceNumber] = [so].[InvoiceNumber]
  , [ord].[SalesOrderlineID] = [so].[InvoiceNumber] + '-' + CAST([sod].[EntrySortOrder] AS NVARCHAR(4))
  , [ord].[ReferenceSalesOrderInvoiceNumber] = [rso].[InvoiceNumber]
  , [ord].[SalesOrderType] = ISNULL([ot].[SalesOrderTypeDescription], 'Not Defined')
  , [ord].[TransactionCenterID] = [cent].[CenterNumber]
  , [ord].[TransactionCenterName] = [cent].[CenterDescription]
  , [ord].[ClientHomeCenterID] = [hcent].[CenterNumber]
  , [ord].[ClientHomeCenterName] = [hcent].[CenterDescription]
  , [ord].[OrderDate] = DATEADD(HOUR, CASE WHEN [tz].[UsesDayLightSavingsFlag] = 0 THEN ( [tz].[UTCOffset] )WHEN DATEPART(WK, [so].[OrderDate]) <= 10 OR DATEPART(WK, [so].[OrderDate]) >= 45 THEN ( [tz].[UTCOffset] )ELSE (( [tz].[UTCOffset] ) + 1 )END, [so].[OrderDate])
  , [ord].[IsOrderInBalance] = CASE WHEN ABS(( SELECT ISNULL(SUM(ISNULL([sod].[PriceTaxCalc], 0)), 0)
                                               FROM [HairClubCMS].[dbo].[datSalesOrderDetail] AS [sod]
                                               WHERE [sod].[SalesOrderGUID] = [ord].[SalesOrderGuid] ) - ( SELECT ISNULL(SUM(ISNULL([sot].[Amount], 0)), 0)FROM [HairClubCMS].[dbo].[datSalesOrderTender] AS [sot] WHERE [sot].[SalesOrderGUID] = [ord].[SalesOrderGuid] )) > 0.01 THEN 0
                                   ELSE 1
                               END
  , [ord].[IsOrderVoided] = [so].[IsVoidedFlag]
  , [ord].[IsOrderClosed] = [so].[IsClosedFlag]
  , [ord].[ClientIdentifier] = [c].[ClientIdentifier]
  , [ord].[LastName] = [c].[LastName]
  , [ord].[FirstName] = ISNULL([c].[FirstName], 'N/A')
  , [ord].[MembershipID] = [m].[MembershipID]
  , [ord].[MembershipDescription] = [m].[MembershipDescription]
  , [ord].[BusinessSegment] = [bs].[BusinessSegmentDescription]
  , [ord].[ClientMembershipIdentifier] = [cm].[ClientMembershipIdentifier]
  , [ord].[GL] = CASE WHEN [m].[BusinessSegmentID] = 2 THEN [glext].[GeneralLedgerDescriptionShort]
                     WHEN [m].[BusinessSegmentID] = 3 THEN [glsur].[GeneralLedgerDescriptionShort]
                     WHEN [m].[BusinessSegmentID] = 6 THEN [glxtr].[GeneralLedgerDescriptionShort]
                     ELSE [glbio].[GeneralLedgerDescriptionShort]
                 END
  , [ord].[GLName] = CASE WHEN [m].[BusinessSegmentID] = 2 THEN [glext].[GeneralLedgerDescription]
                         WHEN [m].[BusinessSegmentID] = 3 THEN [glsur].[GeneralLedgerDescription]
                         WHEN [m].[BusinessSegmentID] = 6 THEN [glxtr].[GeneralLedgerDescription]
                         ELSE [glbio].[GeneralLedgerDescription]
                     END
  , [ord].[Division] = [div].[SalesCodeDivisionID]
  , [ord].[DivisionDescription] = [div].[SalesCodeDivisionDescription]
  , [ord].[Department] = [dep].[SalesCodeDepartmentID]
  , [ord].[DepartmentDescription] = [dep].[SalesCodeDepartmentDescription]
  , [ord].[Code] = [sc].[SalesCodeDescriptionShort]
  , [ord].[SalesCodeDescription] = [sc].[SalesCodeDescription]
  , [ord].[SalesCodeId] = [sc].[SalesCodeID]
  , [ord].[UnitPrice] = ROUND(ISNULL([sod].[Price], 0), 2)
  , [ord].[Quantity] = ISNULL([sod].[Quantity], 0)
  , [ord].[QuantityPrice] = ROUND(ISNULL([sod].[Price] * [sod].[Quantity], 0), 2)
  , [ord].[Discount] = ROUND(ISNULL([sod].[Discount], 0), 2)
  , [ord].[NetPrice] = ROUND(ISNULL([sod].[ExtendedPriceCalc], 0), 2)
  , [ord].[Tax1] = ROUND(ISNULL([sod].[Tax1], 0), 2)
  , [ord].[Tax2] = ROUND(ISNULL([sod].[Tax2], 0), 2)
  , [ord].[Price] = ROUND(ISNULL([sod].[PriceTaxCalc], 0), 2)
  , [ord].[RecordLastUpdate] = [sod].[LastUpdate]
  , [ord].[SalesOrderLastUpdate] = [so].[LastUpdate]
  , [ord].[SalesOrderGuid] = [so].[SalesOrderGUID]
  , [ord].[ReferenceSalesOrderGuid] = [so].[RefundedSalesOrderGUID]
  , [ord].[SalesOrderDetailGuid] = [sod].[SalesOrderDetailGUID]
  , [ord].[LastUpdate] = GETUTCDATE()
  , [ord].[LastUpdateUser] = 'DenormSD-Update'
  , [ord].[DepositNumber] = [ed].[DepositNumber]
  , [ord].[SiebelID] = [c].[SiebelID]
  , [ord].[BosleyProcedureOffice] = [c].[BosleyProcedureOffice]
  , [ord].[BosleyConsultOffice] = [c].[BosleyConsultOffice]
  , [ord].[SalesCodeSerialNumber] = [sod].[SalesCodeSerialNumber]
  , [ord].[Gender] = CASE WHEN ISNULL([c].[GenderID], 1) = 1 THEN 'Male' ELSE 'Female' END
  , [ord].[HairSystemOrderNumber] = ISNULL(LTRIM(RTRIM([hso].[HairSystemOrderNumber])), '')
FROM [#UpdateOrders] AS [uo]
INNER JOIN [dbo].[dbaOrder] AS [ord] ON [uo].[SalesOrderGuid] = [ord].[SalesOrderGuid]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrderDetail] AS [sod] WITH( NOLOCK )ON [sod].[SalesOrderDetailGUID] = [ord].[SalesOrderDetailGuid] AND [sod].[SalesOrderGUID] = [ord].[SalesOrderGuid]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [so] WITH( NOLOCK )ON [sod].[SalesOrderGUID] = [so].[SalesOrderGUID]
LEFT JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [rso] WITH( NOLOCK )ON [so].[RefundedSalesOrderGUID] = [rso].[SalesOrderGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgCenter] AS [cent] WITH( NOLOCK )ON [cent].[CenterID] = [so].[CenterID]
INNER JOIN [HairClubCMS].[dbo].[lkpTimeZone] AS [tz] WITH( NOLOCK )ON [cent].[TimeZoneID] = [tz].[TimeZoneID]
LEFT JOIN [HairClubCMS].[dbo].[cfgCenter] AS [hcent] WITH( NOLOCK )ON [hcent].[CenterID] = [so].[ClientHomeCenterID]
INNER JOIN [HairClubCMS].[dbo].[datClient] AS [c] WITH( NOLOCK )ON [c].[ClientGUID] = [so].[ClientGUID]
INNER JOIN [HairClubCMS].[dbo].[datClientMembership] AS [cm] WITH( NOLOCK )ON [cm].[ClientMembershipGUID] = [so].[ClientMembershipGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [cm].[MembershipID]
INNER JOIN [HairClubCMS].[dbo].[lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
INNER JOIN [HairClubCMS].[dbo].[cfgSalesCode] AS [sc] WITH( NOLOCK )ON [sc].[SalesCodeID] = [sod].[SalesCodeID]
--LEFT JOIN lkpGeneralLedger gl ON sc.GLNumber = gl.GeneralLedgerID
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glbio] WITH( NOLOCK )ON [sc].[BIOGeneralLedgerID] = [glbio].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glext] WITH( NOLOCK )ON [sc].[EXTGeneralLedgerID] = [glext].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glsur] WITH( NOLOCK )ON [sc].[SURGeneralLedgerID] = [glsur].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glxtr] WITH( NOLOCK )ON [sc].[XTRGeneralLedgerID] = [glxtr].[GeneralLedgerID]
INNER JOIN [HairClubCMS].[dbo].[lkpSalesCodeDepartment] AS [dep] WITH( NOLOCK )ON [dep].[SalesCodeDepartmentID] = [sc].[SalesCodeDepartmentID]
INNER JOIN [HairClubCMS].[dbo].[lkpSalesCodeDivision] AS [div] WITH( NOLOCK )ON [div].[SalesCodeDivisionID] = [dep].[SalesCodeDivisionID]
LEFT JOIN [HairClubCMS].[dbo].[lkpSalesOrderType] AS [ot] WITH( NOLOCK )ON [ot].[SalesOrderTypeID] = [so].[SalesOrderTypeID]
LEFT JOIN [HairClubCMS].[dbo].[datEndOfDay] AS [ed] WITH( NOLOCK )ON [ed].[EndOfDayGUID] = [so].[EndOfDayGUID]
LEFT JOIN [HairClubCMS].[dbo].[datHairSystemOrder] AS [hso] ON [hso].[HairSystemOrderGUID] = [sod].[HairSystemOrderGUID]
OPTION( RECOMPILE ) ;

--WHERE so.LastUpdate > ord.SalesOrderLastUpdate OR uo.SalesOrderGuid IS NOT NULL

-- Update Tender record if SO or Tender record were updated
UPDATE [ord]
SET
    [ord].[SalesOrderInvoiceNumber] = [so].[InvoiceNumber]
  , [ord].[SalesOrderType] = ISNULL([ot].[SalesOrderTypeDescription], 'Not Defined')
  , [ord].[SalesOrderlineID] = [so].[InvoiceNumber] + '-T' + CAST([sot].[EntrySortOrder] AS NVARCHAR(4))
  , [ord].[ReferenceSalesOrderInvoiceNumber] = [rso].[InvoiceNumber]
  , [ord].[TransactionCenterID] = [cent].[CenterNumber]
  , [ord].[TransactionCenterName] = [cent].[CenterDescription]
  , [ord].[ClientHomeCenterID] = [hcent].[CenterNumber]
  , [ord].[ClientHomeCenterName] = [hcent].[CenterDescription]
  , [ord].[OrderDate] = DATEADD(HOUR, CASE WHEN [tz].[UsesDayLightSavingsFlag] = 0 THEN ( [tz].[UTCOffset] )WHEN DATEPART(WK, [so].[OrderDate]) <= 10 OR DATEPART(WK, [so].[OrderDate]) >= 45 THEN ( [tz].[UTCOffset] )ELSE (( [tz].[UTCOffset] ) + 1 )END, [so].[OrderDate])
  , [ord].[IsOrderInBalance] = CASE WHEN ABS(( SELECT ISNULL(SUM(ISNULL([sod].[PriceTaxCalc], 0)), 0)
                                               FROM [HairClubCMS].[dbo].[datSalesOrderDetail] AS [sod]
                                               WHERE [sod].[SalesOrderGUID] = [ord].[SalesOrderGuid] ) - ( SELECT ISNULL(SUM(ISNULL([sot].[Amount], 0)), 0)FROM [HairClubCMS].[dbo].[datSalesOrderTender] AS [sot] WHERE [sot].[SalesOrderGUID] = [ord].[SalesOrderGuid] )) > 0.01 THEN 0
                                   ELSE 1
                               END
  , [ord].[IsOrderVoided] = [so].[IsVoidedFlag]
  , [ord].[IsOrderClosed] = [so].[IsClosedFlag]
  , [ord].[ClientIdentifier] = [c].[ClientIdentifier]
  , [ord].[LastName] = [c].[LastName]
  , [ord].[FirstName] = ISNULL([c].[FirstName], 'N/A')
  , [ord].[MembershipID] = [m].[MembershipID]
  , [ord].[MembershipDescription] = [m].[MembershipDescription]
  , [ord].[BusinessSegment] = [bs].[BusinessSegmentDescription]
  , [ord].[ClientMembershipIdentifier] = [cm].[ClientMembershipIdentifier]
  , [ord].[Division] = 99
  , [ord].[DivisionDescription] = 'Tender'
  , [ord].[Department] = CASE WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9980
                             WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9981
                             WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9982
                             WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9983
                             WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9984
                             WHEN [tt].[TenderTypeDescriptionShort] = 'AR' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9985
                             WHEN [tt].[TenderTypeDescriptionShort] = 'CC' THEN 9990
                             WHEN [tt].[TenderTypeDescriptionShort] = 'Check' THEN 9991
                             WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' THEN 9992
                             WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' THEN 9993
                             WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' THEN 9994
                             WHEN [tt].[TenderTypeDescriptionShort] = 'AR' THEN 9995
                             WHEN [tt].[TenderTypeDescriptionShort] = 'FinanceAR' THEN 9996
                             ELSE 9999
                         END
  , [ord].[DepartmentDescription] = CASE WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Credit Card - EFT'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'ACH'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Cash - EFT'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Finance - EFT'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Inter Company - EFT'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'AR - EFT'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'CC' THEN 'Credit Card'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' THEN 'Check'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' THEN 'Cash'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' THEN 'Finance'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'FinanceAR' THEN 'FinanceAR'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' THEN 'Inter Company'
                                        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' THEN 'AR'
                                        ELSE 'Unknown'
                                    END
  , [ord].[Code] = CASE WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'ACH'
                       WHEN [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN [tt].[TenderTypeDescriptionShort] + ' - EFT'
                       ELSE [tt].[TenderTypeDescriptionShort]
                   END
  , [ord].[SalesCodeDescription] = CASE WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' AND [cct].[CreditCardTypeDescription] IS NOT NULL THEN 'Credit Card - EFT (' + [cct].[CreditCardTypeDescription] + ')'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Credit Card - EFT'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'ACH'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Cash - EFT'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' AND [fc].[FinanceCompanyDescription] IS NOT NULL THEN 'Finance - EFT (' + [fc].[FinanceCompanyDescription] + ')'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Finance - EFT'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Inter Company - EFT'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'AR' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'AR - EFT'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [cct].[CreditCardTypeDescription] IS NOT NULL THEN 'Credit Card (' + [cct].[CreditCardTypeDescription] + ')'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'CC' THEN 'Credit Card'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Check' THEN 'Check'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' THEN 'Cash'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [fc].[FinanceCompanyDescription] IS NOT NULL THEN 'Finance (' + [fc].[FinanceCompanyDescription] + ')'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'FinanceAR' AND [fc].[FinanceCompanyDescription] IS NOT NULL THEN 'FinanceAR (' + [fc].[FinanceCompanyDescription] + ')'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' THEN 'Finance'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' THEN 'Inter Company'
                                       WHEN [tt].[TenderTypeDescriptionShort] = 'AR' THEN 'AR'
                                       ELSE 'Unknown'
                                   END
  , [ord].[Tender] = ROUND([sot].[Amount], 2)
  , [ord].[RecordLastUpdate] = [sot].[LastUpdate]
  , [ord].[SalesOrderLastUpdate] = [so].[LastUpdate]
  , [ord].[SalesOrderGuid] = [so].[SalesOrderGUID]
  , [ord].[ReferenceSalesOrderGuid] = [so].[RefundedSalesOrderGUID]
  , [ord].[SalesOrderTenderGuid] = [sot].[SalesOrderTenderGUID]
  , [ord].[GL] = CASE WHEN [so].[SalesOrderTypeID] = 3 THEN [GLFO].[GeneralLedgerDescriptionShort] ELSE [GLSO].[GeneralLedgerDescriptionShort] END
  , [ord].[GLName] = CASE WHEN [so].[SalesOrderTypeID] = 3 THEN [GLFO].[GeneralLedgerDescription] ELSE [GLSO].[GeneralLedgerDescription] END
  , [ord].[LastUpdate] = GETUTCDATE()
  , [ord].[LastUpdateUser] = 'DenormST-Update'
  , [ord].[DepositNumber] = [ed].[DepositNumber]
  , [ord].[SiebelID] = [c].[SiebelID]
  , [ord].[BosleyProcedureOffice] = [c].[BosleyProcedureOffice]
  , [ord].[BosleyConsultOffice] = [c].[BosleyConsultOffice]
  , [ord].[CreditCardLast4Digits] = [sot].[CreditCardLast4Digits]
  , [ord].[ApprovalCode] = [sot].[ApprovalCode]
FROM [dbo].[dbaOrder] AS [ord]
INNER JOIN [#UpdateOrders] AS [uo] ON [uo].[SalesOrderGuid] = [ord].[SalesOrderGuid]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrderTender] AS [sot] WITH( NOLOCK )ON [sot].[SalesOrderTenderGUID] = [ord].[SalesOrderTenderGuid] AND [sot].[SalesOrderGUID] = [ord].[SalesOrderGuid]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [so] WITH( NOLOCK )ON [sot].[SalesOrderGUID] = [so].[SalesOrderGUID]
LEFT JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [rso] WITH( NOLOCK )ON [so].[RefundedSalesOrderGUID] = [rso].[SalesOrderGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgCenter] AS [cent] WITH( NOLOCK )ON [cent].[CenterID] = [so].[CenterID]
INNER JOIN [HairClubCMS].[dbo].[lkpTimeZone] AS [tz] WITH( NOLOCK )ON [cent].[TimeZoneID] = [tz].[TimeZoneID]
LEFT JOIN [HairClubCMS].[dbo].[cfgCenter] AS [hcent] WITH( NOLOCK )ON [hcent].[CenterID] = [so].[ClientHomeCenterID]
INNER JOIN [HairClubCMS].[dbo].[datClient] AS [c] WITH( NOLOCK )ON [c].[ClientGUID] = [so].[ClientGUID]
INNER JOIN [HairClubCMS].[dbo].[datClientMembership] AS [cm] WITH( NOLOCK )ON [cm].[ClientMembershipGUID] = [so].[ClientMembershipGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [cm].[MembershipID]
INNER JOIN [HairClubCMS].[dbo].[lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
INNER JOIN [HairClubCMS].[dbo].[lkpTenderType] AS [tt] WITH( NOLOCK )ON [tt].[TenderTypeID] = [sot].[TenderTypeID]
LEFT OUTER JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [GLSO] WITH( NOLOCK )ON [tt].[GeneralLedgerID] = [GLSO].[GeneralLedgerID]
LEFT OUTER JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [GLFO] WITH( NOLOCK )ON [tt].[EFTGeneralLedgerID] = [GLFO].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpSalesOrderType] AS [ot] WITH( NOLOCK )ON [ot].[SalesOrderTypeID] = [so].[SalesOrderTypeID]
LEFT JOIN [HairClubCMS].[dbo].[lkpCreditCardType] AS [cct] WITH( NOLOCK )ON [cct].[CreditCardTypeID] = [sot].[CreditCardTypeID]
LEFT JOIN [HairClubCMS].[dbo].[lkpFinanceCompany] AS [fc] WITH( NOLOCK )ON [fc].[FinanceCompanyID] = [sot].[FinanceCompanyID]
LEFT JOIN [HairClubCMS].[dbo].[datEndOfDay] AS [ed] WITH( NOLOCK )ON [ed].[EndOfDayGUID] = [so].[EndOfDayGUID]
OPTION( RECOMPILE ) ;

--LEFT JOIN #UpdateOrders uo ON uo.SalesOrderGuid = ord.SalesOrderGuid
--WHERE so.LastUpdate > ord.SalesOrderLastUpdate OR uo.SalesOrderGuid IS NOT NULL

/************************************************************************/
/* --																	*/
/* -- Insert new records												*/
/* --																	*/
/************************************************************************/

-- Insert New Sales Order Detail Records
INSERT INTO [dbo].[dbaOrder]( [SalesOrderInvoiceNumber]
                            , [SalesOrderType]
                            , [SalesOrderlineID]
                            , [ReferenceSalesOrderInvoiceNumber]
                            , [TransactionCenterID]
                            , [TransactionCenterName]
                            , [ClientHomeCenterID]
                            , [ClientHomeCenterName]
                            , [OrderDate]
                            , [IsOrderInBalance]
                            , [IsOrderVoided]
                            , [IsOrderClosed]
                            , [ClientIdentifier]
                            , [LastName]
                            , [FirstName]
                            , [MembershipID]
                            , [MembershipDescription]
                            , [BusinessSegment]
                            , [ClientMembershipIdentifier]
                            , [GL]
                            , [GLName]
                            , [Division]
                            , [DivisionDescription]
                            , [Department]
                            , [DepartmentDescription]
                            , [Code]
                            , [SalesCodeDescription]
                            , [SalesCodeId]
                            , [UnitPrice]
                            , [Quantity]
                            , [QuantityPrice]
                            , [Discount]
                            , [NetPrice]
                            , [Tax1]
                            , [Tax2]
                            , [Price]
                            , [Tender]
                            , [DepositNumber]
                            , [RecordLastUpdate]
                            , [SalesOrderLastUpdate]
                            , [SalesOrderGuid]
                            , [ReferenceSalesOrderGuid]
                            , [SalesOrderDetailGuid]
                            , [SalesOrderTenderGuid]
                            , [CreateDate]
                            , [CreateUser]
                            , [LastUpdate]
                            , [LastUpdateUser]
                            , [SiebelID]
                            , [BosleyProcedureOffice]
                            , [BosleyConsultOffice]
                            , [CreditCardLast4Digits]
                            , [SalesCodeSerialNumber]
                            , [Gender]
                            , [HairSystemOrderNumber] )
SELECT
    [so].[InvoiceNumber]
  , ISNULL([ot].[SalesOrderTypeDescription], 'Not Defined')
  , [so].[InvoiceNumber] + '-' + CAST([sod].[EntrySortOrder] AS NVARCHAR(4))
  , [rso].[InvoiceNumber]
  , [cent].[CenterNumber]
  , [cent].[CenterDescription]
  , [hcent].[CenterNumber]
  , [hcent].[CenterDescription]
  , DATEADD(HOUR, CASE WHEN [tz].[UsesDayLightSavingsFlag] = 0 THEN ( [tz].[UTCOffset] )WHEN DATEPART(WK, [so].[OrderDate]) <= 10 OR DATEPART(WK, [so].[OrderDate]) >= 45 THEN ( [tz].[UTCOffset] )ELSE (( [tz].[UTCOffset] ) + 1 )END, [so].[OrderDate])
  , CASE WHEN ABS(( SELECT ISNULL(SUM(ISNULL([sod].[PriceTaxCalc], 0)), 0)
                    FROM [HairClubCMS].[dbo].[datSalesOrderDetail] AS [sod]
                    WHERE [sod].[SalesOrderGUID] = [so].[SalesOrderGUID] ) - ( SELECT ISNULL(SUM(ISNULL([sot].[Amount], 0)), 0)FROM [HairClubCMS].[dbo].[datSalesOrderTender] AS [sot] WHERE [sot].[SalesOrderGUID] = [so].[SalesOrderGUID] )) > 0.01 THEN 0
        ELSE 1
    END
  , [so].[IsVoidedFlag]
  , [so].[IsClosedFlag]
  , [c].[ClientIdentifier]
  , [c].[LastName]
  , ISNULL([c].[FirstName], 'N/A') AS [FirstName]
  , [m].[MembershipID]
  , [m].[MembershipDescription]
  , [bs].[BusinessSegmentDescription]
  , [cm].[ClientMembershipIdentifier]
  , CASE WHEN [m].[BusinessSegmentID] = 2 THEN [glext].[GeneralLedgerDescriptionShort]
        WHEN [m].[BusinessSegmentID] = 3 THEN [glsur].[GeneralLedgerDescriptionShort]
        WHEN [m].[BusinessSegmentID] = 6 THEN [glxtr].[GeneralLedgerDescriptionShort]
        ELSE [glbio].[GeneralLedgerDescriptionShort]
    END
  , CASE WHEN [m].[BusinessSegmentID] = 2 THEN [glext].[GeneralLedgerDescription]
        WHEN [m].[BusinessSegmentID] = 3 THEN [glsur].[GeneralLedgerDescription]
        WHEN [m].[BusinessSegmentID] = 6 THEN [glxtr].[GeneralLedgerDescription]
        ELSE [glbio].[GeneralLedgerDescription]
    END
  , [div].[SalesCodeDivisionID]
  , [div].[SalesCodeDivisionDescription]
  , [dep].[SalesCodeDepartmentID]
  , [dep].[SalesCodeDepartmentDescription]
  , [sc].[SalesCodeDescriptionShort]
  , [sc].[SalesCodeDescription]
  , [sc].[SalesCodeID]
  , ROUND(ISNULL([sod].[Price], 0), 2)
  , ISNULL([sod].[Quantity], 0)
  , ROUND(ISNULL([sod].[Price] * [sod].[Quantity], 0), 2)
  , ROUND(ISNULL([sod].[Discount], 0), 2)
  , ROUND(ISNULL([sod].[ExtendedPriceCalc], 0), 2)
  , ROUND(ISNULL([sod].[Tax1], 0), 2)
  , ROUND(ISNULL([sod].[Tax2], 0), 2)
  , ROUND(ISNULL([sod].[PriceTaxCalc], 0), 2)
  , NULL -- Tender
  , [ed].[DepositNumber]
  , [sod].[LastUpdate]
  , [so].[LastUpdate]
  , [so].[SalesOrderGUID]
  , [so].[RefundedSalesOrderGUID]
  , [sod].[SalesOrderDetailGUID]
  , NULL -- SalesOrderTenderGuid
  , GETUTCDATE()
  , 'DenormSD-Insert'
  , GETUTCDATE()
  , 'DenormSD-Insert'
  , [c].[SiebelID]
  , [c].[BosleyProcedureOffice]
  , [c].[BosleyConsultOffice]
  , NULL
  , [sod].[SalesCodeSerialNumber]
  , CASE WHEN ISNULL([c].[GenderID], 1) = 1 THEN 'Male' ELSE 'Female' END
  , ISNULL(LTRIM(RTRIM([hso].[HairSystemOrderNumber])), '')
FROM [HairClubCMS].[dbo].[datSalesOrder] AS [so]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrderDetail] AS [sod] WITH( NOLOCK )ON [sod].[SalesOrderGUID] = [so].[SalesOrderGUID]
LEFT JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [rso] WITH( NOLOCK )ON [so].[RefundedSalesOrderGUID] = [rso].[SalesOrderGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgCenter] AS [cent] WITH( NOLOCK )ON [cent].[CenterID] = [so].[CenterID]
INNER JOIN [HairClubCMS].[dbo].[lkpTimeZone] AS [tz] WITH( NOLOCK )ON [cent].[TimeZoneID] = [tz].[TimeZoneID]
LEFT JOIN [HairClubCMS].[dbo].[cfgCenter] AS [hcent] WITH( NOLOCK )ON [hcent].[CenterID] = [so].[ClientHomeCenterID]
INNER JOIN [HairClubCMS].[dbo].[datClient] AS [c] WITH( NOLOCK )ON [c].[ClientGUID] = [so].[ClientGUID]
INNER JOIN [HairClubCMS].[dbo].[datClientMembership] AS [cm] WITH( NOLOCK )ON [cm].[ClientMembershipGUID] = [so].[ClientMembershipGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [cm].[MembershipID]
INNER JOIN [HairClubCMS].[dbo].[lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
INNER JOIN [HairClubCMS].[dbo].[cfgSalesCode] AS [sc] WITH( NOLOCK )ON [sc].[SalesCodeID] = [sod].[SalesCodeID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [gl] ON [sc].[GLNumber] = [gl].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glbio] WITH( NOLOCK )ON [sc].[BIOGeneralLedgerID] = [glbio].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glext] WITH( NOLOCK )ON [sc].[EXTGeneralLedgerID] = [glext].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glsur] WITH( NOLOCK )ON [sc].[SURGeneralLedgerID] = [glsur].[GeneralLedgerID]
LEFT JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [glxtr] WITH( NOLOCK )ON [sc].[XTRGeneralLedgerID] = [glxtr].[GeneralLedgerID]
INNER JOIN [HairClubCMS].[dbo].[lkpSalesCodeDepartment] AS [dep] WITH( NOLOCK )ON [dep].[SalesCodeDepartmentID] = [sc].[SalesCodeDepartmentID]
INNER JOIN [HairClubCMS].[dbo].[lkpSalesCodeDivision] AS [div] WITH( NOLOCK )ON [div].[SalesCodeDivisionID] = [dep].[SalesCodeDivisionID]
LEFT OUTER JOIN [dbo].[dbaOrder] AS [ord] WITH( NOLOCK )ON [ord].[SalesOrderGuid] = [so].[SalesOrderGUID] AND [ord].[SalesOrderDetailGuid] = [sod].[SalesOrderDetailGUID]
LEFT JOIN [HairClubCMS].[dbo].[lkpSalesOrderType] AS [ot] WITH( NOLOCK )ON [ot].[SalesOrderTypeID] = [so].[SalesOrderTypeID]
LEFT JOIN [HairClubCMS].[dbo].[datEndOfDay] AS [ed] WITH( NOLOCK )ON [ed].[EndOfDayGUID] = [so].[EndOfDayGUID]
LEFT JOIN [HairClubCMS].[dbo].[datHairSystemOrder] AS [hso] ON [hso].[HairSystemOrderGUID] = [sod].[HairSystemOrderGUID]
WHERE [ord].[SalesOrderGuid] IS NULL AND [so].[CreateDate] < @MinCreateDate
OPTION( RECOMPILE ) ;

--	AND DATEDIFF ( minute , so.CreateDate , @ProcStartTime ) > 10
--ORDER BY so.CreateDate desc, so.InvoiceNumber, sod.EntrySortOrder

-- Insert New Sales Order Tender Records
INSERT INTO [dbo].[dbaOrder]( [SalesOrderInvoiceNumber]
                            , [SalesOrderType]
                            , [SalesOrderlineID]
                            , [ReferenceSalesOrderInvoiceNumber]
                            , [TransactionCenterID]
                            , [TransactionCenterName]
                            , [ClientHomeCenterID]
                            , [ClientHomeCenterName]
                            , [OrderDate]
                            , [IsOrderInBalance]
                            , [IsOrderVoided]
                            , [IsOrderClosed]
                            , [ClientIdentifier]
                            , [LastName]
                            , [FirstName]
                            , [MembershipID]
                            , [MembershipDescription]
                            , [BusinessSegment]
                            , [ClientMembershipIdentifier]
                            , [Division]
                            , [DivisionDescription]
                            , [Department]
                            , [DepartmentDescription]
                            , [Code]
                            , [SalesCodeDescription]
                            , [SalesCodeId]
                            , [UnitPrice]
                            , [Quantity]
                            , [QuantityPrice]
                            , [Discount]
                            , [NetPrice]
                            , [Tax1]
                            , [Tax2]
                            , [Price]
                            , [Tender]
                            , [DepositNumber]
                            , [RecordLastUpdate]
                            , [SalesOrderLastUpdate]
                            , [SalesOrderGuid]
                            , [ReferenceSalesOrderGuid]
                            , [SalesOrderDetailGuid]
                            , [SalesOrderTenderGuid]
                            , [GL]
                            , [GLName]
                            , [CreateDate]
                            , [CreateUser]
                            , [LastUpdate]
                            , [LastUpdateUser]
                            , [SiebelID]
                            , [BosleyProcedureOffice]
                            , [BosleyConsultOffice]
                            , [CreditCardLast4Digits]
                            , [ApprovalCode] )
SELECT
    [so].[InvoiceNumber]
  , ISNULL([ot].[SalesOrderTypeDescription], 'Not Defined')
  , [so].[InvoiceNumber] + '-T' + CAST([sot].[EntrySortOrder] AS NVARCHAR(4))
  , [rso].[InvoiceNumber]
  , [cent].[CenterNumber]
  , [cent].[CenterDescription]
  , [hcent].[CenterNumber]
  , [hcent].[CenterDescription]
  , DATEADD(HOUR, CASE WHEN [tz].[UsesDayLightSavingsFlag] = 0 THEN ( [tz].[UTCOffset] )WHEN DATEPART(WK, [so].[OrderDate]) <= 10 OR DATEPART(WK, [so].[OrderDate]) >= 45 THEN ( [tz].[UTCOffset] )ELSE (( [tz].[UTCOffset] ) + 1 )END, [so].[OrderDate])
  , CASE WHEN ABS(( SELECT ISNULL(SUM(ISNULL([sod].[PriceTaxCalc], 0)), 0)
                    FROM [HairClubCMS].[dbo].[datSalesOrderDetail] AS [sod]
                    WHERE [sod].[SalesOrderGUID] = [so].[SalesOrderGUID] ) - ( SELECT ISNULL(SUM(ISNULL([sot].[Amount], 0)), 0)FROM [HairClubCMS].[dbo].[datSalesOrderTender] AS [sot] WHERE [sot].[SalesOrderGUID] = [so].[SalesOrderGUID] )) > 0.01 THEN 0
        ELSE 1
    END
  , [so].[IsVoidedFlag]
  , [so].[IsClosedFlag]
  , [c].[ClientIdentifier]
  , [c].[LastName]
  , ISNULL([c].[FirstName], 'N/A') AS [FirstName]
  , [m].[MembershipID]
  , [m].[MembershipDescription]
  , [bs].[BusinessSegmentDescription]
  , [cm].[ClientMembershipIdentifier]
  , 99 -- Division for Tender
  , 'Tender'
  , CASE WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9980
        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9981
        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9982
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9983
        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9984
        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 9985
        WHEN [tt].[TenderTypeDescriptionShort] = 'CC' THEN 9990
        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' THEN 9991
        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' THEN 9992
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' THEN 9993
        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' THEN 9994
        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' THEN 9995
        WHEN [tt].[TenderTypeDescriptionShort] = 'FinanceAR' THEN 9996
        ELSE 9999
    END --Department
  , CASE WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Credit Card - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'ACH'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Cash - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Finance - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Inter Company - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'AR - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'CC' THEN 'Credit Card'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' THEN 'Check'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' THEN 'Cash'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' THEN 'Finance'
        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' THEN 'Inter Company'
        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' THEN 'AR'
        WHEN [tt].[TenderTypeDescriptionShort] = 'FincanceAR' THEN 'FinanceAR'
        ELSE 'Unknown'
    END --Department Description
  , CASE WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'ACH'
        WHEN [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN [tt].[TenderTypeDescriptionShort] + ' - EFT'
        ELSE [tt].[TenderTypeDescriptionShort]
    END -- Code
  , CASE WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' AND [cct].[CreditCardTypeDescription] IS NOT NULL THEN 'Credit Card - EFT (' + [cct].[CreditCardTypeDescription] + ')'
        WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Credit Card - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'ACH'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Cash - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' AND [fc].[FinanceCompanyDescription] IS NOT NULL THEN 'Finance - EFT (' + [fc].[FinanceCompanyDescription] + ')'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Finance - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'Inter Company - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' AND [ot].[SalesOrderTypeDescriptionShort] = 'FO' THEN 'AR - EFT'
        WHEN [tt].[TenderTypeDescriptionShort] = 'CC' AND [cct].[CreditCardTypeDescription] IS NOT NULL THEN 'Credit Card (' + [cct].[CreditCardTypeDescription] + ')'
        WHEN [tt].[TenderTypeDescriptionShort] = 'CC' THEN 'Credit Card'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Check' THEN 'Check'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Cash' THEN 'Cash'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' AND [fc].[FinanceCompanyDescription] IS NOT NULL THEN 'Finance (' + [fc].[FinanceCompanyDescription] + ')'
        WHEN [tt].[TenderTypeDescriptionShort] = 'FinanceAR' AND [fc].[FinanceCompanyDescription] IS NOT NULL THEN 'FinanceAR (' + [fc].[FinanceCompanyDescription] + ')'
        WHEN [tt].[TenderTypeDescriptionShort] = 'Finance' THEN 'Finance'
        WHEN [tt].[TenderTypeDescriptionShort] = 'InterCo' THEN 'Inter Company'
        WHEN [tt].[TenderTypeDescriptionShort] = 'AR' THEN 'AR'
        ELSE 'Unknown'
    END -- Sales Code Description
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , NULL
  , ROUND([sot].[Amount], 2)
  , [ed].[DepositNumber]
  , [sot].[LastUpdate]
  , [so].[LastUpdate]
  , [so].[SalesOrderGUID]
  , [so].[RefundedSalesOrderGUID]
  , NULL -- SalesOrderDetailGuid
  , [sot].[SalesOrderTenderGUID]
  , CASE WHEN [so].[SalesOrderTypeID] = 3 THEN [GLFO].[GeneralLedgerDescriptionShort] ELSE [GLSO].[GeneralLedgerDescriptionShort] END
  , CASE WHEN [so].[SalesOrderTypeID] = 3 THEN [GLFO].[GeneralLedgerDescription] ELSE [GLSO].[GeneralLedgerDescription] END
  , GETUTCDATE()
  , 'DenormST-Insert'
  , GETUTCDATE()
  , 'DenormST-Insert'
  , [c].[SiebelID]
  , [c].[BosleyProcedureOffice]
  , [c].[BosleyConsultOffice]
  , [sot].[CreditCardLast4Digits]
  , [sot].[ApprovalCode]
FROM [HairClubCMS].[dbo].[datSalesOrder] AS [so]
INNER JOIN [HairClubCMS].[dbo].[datSalesOrderTender] AS [sot] WITH( NOLOCK )ON [sot].[SalesOrderGUID] = [so].[SalesOrderGUID]
LEFT JOIN [HairClubCMS].[dbo].[datSalesOrder] AS [rso] WITH( NOLOCK )ON [so].[RefundedSalesOrderGUID] = [rso].[SalesOrderGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgCenter] AS [cent] WITH( NOLOCK )ON [cent].[CenterID] = [so].[CenterID]
INNER JOIN [HairClubCMS].[dbo].[lkpTimeZone] AS [tz] WITH( NOLOCK )ON [cent].[TimeZoneID] = [tz].[TimeZoneID]
LEFT JOIN [HairClubCMS].[dbo].[cfgCenter] AS [hcent] WITH( NOLOCK )ON [hcent].[CenterID] = [so].[ClientHomeCenterID]
INNER JOIN [HairClubCMS].[dbo].[datClient] AS [c] WITH( NOLOCK )ON [c].[ClientGUID] = [so].[ClientGUID]
INNER JOIN [HairClubCMS].[dbo].[datClientMembership] AS [cm] WITH( NOLOCK )ON [cm].[ClientMembershipGUID] = [so].[ClientMembershipGUID]
INNER JOIN [HairClubCMS].[dbo].[cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [cm].[MembershipID]
INNER JOIN [HairClubCMS].[dbo].[lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
INNER JOIN [HairClubCMS].[dbo].[lkpTenderType] AS [tt] WITH( NOLOCK )ON [tt].[TenderTypeID] = [sot].[TenderTypeID]
LEFT OUTER JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [GLSO] WITH( NOLOCK )ON [tt].[GeneralLedgerID] = [GLSO].[GeneralLedgerID]
LEFT OUTER JOIN [HairClubCMS].[dbo].[lkpGeneralLedger] AS [GLFO] WITH( NOLOCK )ON [tt].[EFTGeneralLedgerID] = [GLFO].[GeneralLedgerID]
LEFT OUTER JOIN [dbo].[dbaOrder] AS [ord] WITH( NOLOCK )ON [ord].[SalesOrderGuid] = [so].[SalesOrderGUID] AND [ord].[SalesOrderTenderGuid] = [sot].[SalesOrderTenderGUID]
LEFT JOIN [HairClubCMS].[dbo].[lkpSalesOrderType] AS [ot] WITH( NOLOCK )ON [ot].[SalesOrderTypeID] = [so].[SalesOrderTypeID]
LEFT JOIN [HairClubCMS].[dbo].[lkpCreditCardType] AS [cct] WITH( NOLOCK )ON [cct].[CreditCardTypeID] = [sot].[CreditCardTypeID]
LEFT JOIN [HairClubCMS].[dbo].[lkpFinanceCompany] AS [fc] WITH( NOLOCK )ON [fc].[FinanceCompanyID] = [sot].[FinanceCompanyID]
LEFT JOIN [HairClubCMS].[dbo].[datEndOfDay] AS [ed] WITH( NOLOCK )ON [ed].[EndOfDayGUID] = [so].[EndOfDayGUID]
WHERE [ord].[SalesOrderGuid] IS NULL AND ( SELECT COUNT(*)FROM [dbo].[dbaOrder] AS [ino] WHERE [ino].[SalesOrderTenderGuid] = [sot].[SalesOrderTenderGUID] ) = 0 AND [so].[CreateDate] < @MinCreateDate
OPTION( RECOMPILE ) ;

--AND DATEDIFF ( minute , so.CreateDate , @ProcStartTime ) > 10
--ORDER BY so.CreateDate desc, so.InvoiceNumber

-- Update Client Data
UPDATE
    [ord]
SET
    [ord].[SiebelID] = [c].[SiebelID]
  , [ord].[BosleyProcedureOffice] = [c].[BosleyProcedureOffice]
  , [ord].[BosleyConsultOffice] = [c].[BosleyConsultOffice]
  , [ord].[LastUpdate] = GETUTCDATE()
  , [ord].[LastUpdateUser] = 'Client-Update'
FROM [dbo].[dbaOrder] AS [ord]
INNER JOIN [HairClubCMS].[dbo].[datClient] AS [c] ON [c].[ClientIdentifier] = [ord].[ClientIdentifier]
WHERE( [ord].[SiebelID] IS NULL AND [c].[SiebelID] IS NOT NULL )
   OR ( [ord].[SiebelID] IS NOT NULL AND [ord].[SiebelID] <> [c].[SiebelID] )
   OR ( [ord].[BosleyConsultOffice] IS NULL AND [c].[BosleyConsultOffice] IS NOT NULL )
   OR ( [ord].[BosleyConsultOffice] IS NOT NULL AND [ord].[BosleyConsultOffice] <> [c].[BosleyConsultOffice] )
   OR ( [ord].[BosleyProcedureOffice] IS NULL AND [c].[BosleyProcedureOffice] IS NOT NULL )
   OR ( [ord].[BosleyProcedureOffice] IS NOT NULL AND [ord].[BosleyProcedureOffice] <> [c].[BosleyProcedureOffice] )
OPTION( RECOMPILE ) ;
GO
