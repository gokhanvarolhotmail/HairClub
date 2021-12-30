/* CreateDate: 09/17/2012 13:45:37.397 , ModifyDate: 09/17/2012 13:45:37.397 */
GO
/*===============================================================================================
-- Procedure Name:                sprpt_Flash_NB1_Details
-- Procedure Description:
--
-- Created By:                           Dominic Leiba
-- Implemented By:                Marlon Burrell
-- Last Modified By:       Dominic Leiba
--
-- Date Created:
-- Date Implemented:
-- Date Last Modified:            06/24/2009
--
-- Destination Server:            HCSQL2\SQL2005
-- Destination Database:   INFOSTORE
-- Related Application:           New Business Flash Details Report
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 01/17/2007        --> Added CanadianConvresion to surgery dollars calculation.
--
-- 04/05/2007        --> Excluded bvoided transactions
--
--                                --> The following statement excludes the codes because the Transfer codes have
--                                --> variable department and divisions, and the Removal should be subtracted
--                                --> but wasn't accounted for in the old version:
--                                --> [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT' )
--
-- 11/03/2008 - AP   --> Include 'Member1' in the result set
--
-- 12/05/2008        --> Add functionality for report to group by Region instead of an individual center. If any
--                                --> RegionID's are passed to the @Center parameter (28, 29, 30, 31), the SP will group by region.
--
-- 02/02/2009 - DL   --> Changed the [dbo].[ISINVERSE_SIGN] function on INFOSTORE & Helios10 to include the following codes:
--                                --> 'SURTRANSX', 'POSTEXTX' as transactions with these codes were being added to the "Net Sales" count total
--                                --> instead of subtracted.
--
-- 02/02/2009 - DL   --> Changed [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT' ) to
--                                --> [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' ) in order to
--                                --> exclude 'POSTEXTX' transactions that were entered in CMS, which are not tracked and were being included.
--
-- 03/20/2009 - JH   --> Updated 'ISFLASH_SALE_ByDepartmentAndDivision' Function to take one more parameter which is
--                                -->    quantity.
--
-- 04/21/2009 - AP   -->    Do not include Cancel transactions in the output for Surgery #
--
-- 05/20/2009 - JH   -->    Changed Column Reference on vw_datSalesOrderDetail for Performer from 'Performer1' to
--                                --> 'ConsultantInitials'
--
-- 06/05/2009 - KM   -->    Changed Column Reference on vw_datSalesOrderDetail for Performer from 'MembershipDescription' to
--                                --> 'SalesCodeDescription'
--
-- 06/24/2009 - DL   --> Created a new section that handles Conversions (@Type = 11).
--                                --> Excluded EXT and POSTEXT conversions from the Conversions sub-query.
--                                --> The query should reflect conversions for Tradition and Gradual
--                                --> application conversions ONLY.
--
-- 06/24/2009 - DL   --> Ensured that ALL Region-Specific queries were pointed to the Sales Order Details view on Helios10
--
-- 06/25/2009 - DL   --> Totals on the Flash DrillDown were not tying to the Flash Summary Totals.
                                  --> Surgery Transactions were being displayed in categories they should not have been,
                                  --> and the query for each category had to be amended to only display surgery transactions for:
                                  --> 1 = Total NB1 Gross #
                                  --> 8 = Surgery #
                                  --> 9 = Surgery $
                                  --> 16 = Post Ext #
                                  --> 17 = Total NB1 Net #
                                  --> 18 = Total NB1 Net $
                                  --> 19 = Post Ext $
-- 07/09/2009 - DL   --> Removed department 1099 from Gross NB1 drilldown in both center and region sql
                                         Excluded Refunds (Because PostExt IS a SO rather than MO) FROM Gross Surgery Numbers
-- 09/08/2009 - MB --> Changed the calculation of the "QTY" for "Total NB1 Gross" from <=0 to <0
-- 09/16/2009 - MB --> Changed @SurgeryCenterNumber to get it from tblcenter
-- 01/25/2010 - JH --> Changed Qty for PostExt and Net NB1 to look at Price * Quantiy instead of ExtendedPriceCalc
						Dollars to see if less than or equal to zero before counting as -1 for count.
-- 08/16/2011 - MB --> Removed references to Helios10
-- 08/30/2011 - MB --> Removed section of query that was duplicating regional transactions (WO# 66251)
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC sprpt_Flash_NB1_Details 30, 17, '8/22/2011', '8/29/2011'
================================================================================================*/
CREATE PROCEDURE [dbo].[sprpt_Flash_NB1_Details]
(
       @Center INT,
       @Type INT,
       @BegDt SMALLDATETIME,
       @EndDt SMALLDATETIME
)
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

       DECLARE @SurgeryCenterNumber INT
       DECLARE @RegionID INT

       SET @SurgeryCenterNumber = (SELECT CenterSSID FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE ReportingCenterSSID <> CenterSSID AND ReportingCenterSSID = @Center)
       SET @EndDt = @EndDt + ' 23:59:59'

       IF ( @Center = 6 )
         BEGIN
              SET @RegionID = 1
         END

       IF ( @Center = 28 )
         BEGIN
              SET @RegionID = 2
         END

       IF ( @Center = 29 )
         BEGIN
              SET @RegionID = 3
         END

       IF ( @Center = 30 )
         BEGIN
              SET @RegionID = 4
         END

       IF ( @Center = 31 )
         BEGIN
              SET @RegionID = 5
         END

       /*
              @Type = Flash Heading

              1 = Total NB1 Gross #
              2 = Traditional #
              3 = Traditional $
              4 = Gradual #
              5 = Gradual $
              6 = Extreme #
              7 = Extreme $
              8 = Surgery #
              9 = Surgery $
              10 = Applications
              11 = Conversions (Excludes EXT Conversions)
              16 = Post Ext #
              17 = Total NB1 Net #
              18 = Total NB1 Net $
              19 = Post Ext $
              190 = Consultations
              200 = BeBacks
              300 = HairSales
       */


       CREATE TABLE [#TotalNB]
         (
              Center INT
         , Center_Name VARCHAR(60)
         , Region VARCHAR(60)
         , Client_no VARCHAR(50)
         , Last_Name VARCHAR(50)
         , First_Name VARCHAR(50)
         , Transact_No VARCHAR(20)
         , ticket_No VARCHAR(50)
         , Date SMALLDATETIME
         , Code VARCHAR(50)
         , Description VARCHAR(60)
         , Qty INT
         , Price MONEY
         , Tax_1 MONEY
         , Tax_2 MONEY
         , Performer VARCHAR(50)
         , CancelReasonDescription VARCHAR(50)
         , Department VARCHAR(50)
         , Performer2 VARCHAR(50)
         , Voided VARCHAR(10)
         , Member1 VARCHAR(40)
         )


       /*
              1 = Total NB1 Gross #
       */
       IF @Type IN ( 1 )
         BEGIN

              /* Center-Specific */
              IF ( @Center NOT IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       CONVERT(VARCHAR, [Transactions].[ticket_no]) AS 'ticket_no'
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                          THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                          ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                  END AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [Transactions].[Center] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                     UNION
                     SELECT  [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [RegionDescription] AS 'Region'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       '' AS 'transact_no'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Date]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [MembershipDescription] AS 'Description'
                     ,       CASE WHEN [ExtendedPriceCalc] < 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'CancelReasonDescription'
                     ,       [SalesCodeDepartmentID] AS 'Department'
                     ,       '' AS 'Performer2'
                     ,       '' AS 'Voided'
                     ,       [ClientMembershipStatusDescription] AS 'Member1'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 2025, 1010, 1075, 1090 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [ClientHomeCenterID] = @SurgeryCenterNumber
                                  AND [IsVoidedFlag] = 0
                                  AND [IsRefundedFlag] = 0
                END


              /* Region-Specific */
              IF ( @Center IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       CONVERT(VARCHAR, [Transactions].[client_no]) AS 'client_no'
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       CONVERT(VARCHAR, [Transactions].[ticket_no]) AS 'ticket_no'
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                          THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                          ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                  END AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [tblCenter].[RegionID] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                     [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                     UNION
                     SELECT  [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [RegionDescription] AS 'Region'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       '' AS 'transact_no'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Date]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [MembershipDescription] AS 'Description'
                     ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'CancelReasonDescription'
                     ,       [SalesCodeDepartmentID] AS 'Department'
                     ,       '' AS 'Performer2'
                     ,       '' AS 'Voided'
                     ,       [ClientMembershipStatusDescription] AS 'Member1'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 2025, 1010, 1075, 1090 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [RegionID] = @RegionID
                                  AND [IsVoidedFlag] = 0
                                  AND [IsRefundedFlag] = 0
                END

         END


       /*
              2 = Traditional #
              3 = Traditional $
              4 = Gradual #
              5 = Gradual $
              6 = Extreme #
              7 = Extreme $
       */
       IF @Type IN ( 2, 3, 4, 5, 6, 7 )
         BEGIN

              /* Center-Specific */
              IF ( @Center NOT IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       CONVERT(VARCHAR, [Transactions].[ticket_no]) AS 'ticket_no'
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                          THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                          ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                  END AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [Transactions].[Center] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                END


              /* Region-Specific */
              IF ( @Center IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       [Transactions].[ticket_no]
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                          THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                          ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                  END AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [tblCenter].[RegionID] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                END

         END


       /*
              8 = Surgery #
       */
       IF @Type IN ( 8 )
         BEGIN

              /* Center-Specific */
              IF @Center NOT IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     SELECT  [Date]
                     ,       [SalesOrderTypeDescription]
                     ,       [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [CenterTypeDescription]
                     ,       [RegionID]
                     ,       [RegionDescription]
                     ,       [SalesCodeID]
                     ,       [SalesCodeDescription]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [SalesCodeDepartmentID]
                     ,       [SalesCodeDepartmentDescription]
                     ,       [SalesCodeDepartmentDescriptionShort]
                     ,       [SalesCodeDivisionID]
                     ,       [SalesCodeDivisionDescription]
                     ,       [SalesCodeDivisionDescriptionShort]
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientMembershipStatusDescription]
                     ,       [SalesCodeDescription] AS 'Description'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Quantity]
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [PriceTaxCalc]
                     ,       '' AS 'transact_no'
                     ,       '' AS 'Member1'
                     ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'Voided'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 1010, 1075, 1090, 1099 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [ClientHomeCenterID] = @SurgeryCenterNumber
                                  AND [IsVoidedFlag] = 0
                     ORDER BY [ClientHomeCenterID]
                     ,       [Date]
                END

              /* Region-Specific */
              IF @Center IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     SELECT  [Date]
                     ,       [SalesOrderTypeDescription]
                     ,       [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [CenterTypeDescription]
                     ,       [RegionID]
                     ,       [RegionDescription]
                     ,       [SalesCodeID]
                     ,       [SalesCodeDescription]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [SalesCodeDepartmentID]
                     ,       [SalesCodeDepartmentDescription]
                     ,       [SalesCodeDepartmentDescriptionShort]
                     ,       [SalesCodeDivisionID]
                     ,       [SalesCodeDivisionDescription]
                     ,       [SalesCodeDivisionDescriptionShort]
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientMembershipStatusDescription]
                     ,       [SalesCodeDescription] AS 'Description'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Quantity]
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [PriceTaxCalc]
                     ,       '' AS 'transact_no'
                     ,       '' AS 'Member1'
                     ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'Voided'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 1010, 1075, 1090, 1099 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [RegionID] = @RegionID
                                  AND [IsVoidedFlag] = 0
                     ORDER BY [RegionDescription]
                     ,             [ClientHomeCenterID]
                     ,       [Date]
                END

         END


       /*
              9 = Surgery $
       */
       IF @Type IN ( 9 )
         BEGIN

              /* Center-Specific */
              IF @Center NOT IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     SELECT  [Date]
                     ,       [SalesOrderTypeDescription]
                     ,       [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [CenterTypeDescription]
                     ,       [RegionID]
                     ,       [RegionDescription]
                     ,       [SalesCodeID]
                     ,       [SalesCodeDescription]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [SalesCodeDepartmentID]
                     ,       [SalesCodeDepartmentDescription]
                     ,       [SalesCodeDepartmentDescriptionShort]
                     ,       [SalesCodeDivisionID]
                     ,       [SalesCodeDivisionDescription]
                     ,       [SalesCodeDivisionDescriptionShort]
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientMembershipStatusDescription]
                     ,       [SalesCodeDescription] AS 'Description'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Quantity]
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [PriceTaxCalc]
                     ,       '' AS 'transact_no'
                     ,       '' AS 'Member1'
                     ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'Voided'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 2020 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [ClientHomeCenterID] = @SurgeryCenterNumber
                                  AND [IsVoidedFlag] = 0
                     ORDER BY [ClientHomeCenterID]
                     ,       [Date]
                END

              /* Region-Specific */
              IF @Center IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     SELECT  [Date]
                     ,       [SalesOrderTypeDescription]
                     ,       [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [CenterTypeDescription]
                     ,       [RegionID]
                     ,       [RegionDescription]
                     ,       [SalesCodeID]
                     ,       [SalesCodeDescription]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [SalesCodeDepartmentID]
                     ,       [SalesCodeDepartmentDescription]
                     ,       [SalesCodeDepartmentDescriptionShort]
                     ,       [SalesCodeDivisionID]
                     ,       [SalesCodeDivisionDescription]
                     ,       [SalesCodeDivisionDescriptionShort]
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientMembershipStatusDescription]
                     ,       [SalesCodeDescription] AS 'Description'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Quantity]
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [PriceTaxCalc]
                     ,       '' AS 'transact_no'
                     ,       '' AS 'Member1'
                     ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'Voided'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 2020 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [RegionID] = @RegionID
                                  AND [IsVoidedFlag] = 0
                     ORDER BY [RegionDescription]
                     ,             [ClientHomeCenterID]
                     ,       [Date]
                END

         END


       /*
              10 = Applications
       */
       IF @Type IN ( 10 )
         BEGIN

              /* Center-Specific */
              IF ( @Center NOT IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       CONVERT(VARCHAR, [Transactions].[ticket_no]) AS 'ticket_no'
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       [dbo].CanadianConversion([Transactions].[Center], [Transactions].[Price], [Transactions].[Date]) AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [Transactions].[Center] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                END


              /* Region-Specific */
              IF ( @Center IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       [Transactions].[ticket_no]
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                          THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                          ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                  END AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [tblCenter].[RegionID] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND [Transactions].[Member1] NOT IN ( 'EXT', 'POSTEXT' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                END

         END


       /*
              11 = Conversions (Excludes EXT Conversions)
       */
       IF @Type IN ( 11 )
         BEGIN

              /* Center-Specific */
              IF ( @Center NOT IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       CONVERT(VARCHAR, [Transactions].[ticket_no]) AS 'ticket_no'
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date]) AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [Transactions].[Center] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND [Transactions].[Member1] NOT IN ( 'EXT', 'POSTEXT' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                END


              /* Region-Specific */
              IF ( @Center IN ( 28, 29, 30, 31, 6, 32 ) )
                BEGIN
                     SELECT  [Transactions].[Center]
                     ,       [tblCenter].[Center] AS 'Center_Name'
                     ,       [tblRegion].[Region]
                     ,       [Transactions].[client_no]
                     ,       [Clients].[Last_Name]
                     ,       [Clients].[First_Name]
                     ,       [Transactions].[transact_no]
                     ,       [Transactions].[ticket_no]
                     ,       [Transactions].[Date]
                     ,       [Transactions].[Code]
                     ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                     ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                          ELSE [Transactions].[Qty]
                                  END AS 'Qty'
                     ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                          THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                          ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                  END AS 'Price'
                     ,       [Transactions].[Tax_1]
                     ,       [Transactions].[Tax_2]
                     ,       [Transactions].[Performer]
                     ,       [CancelReason].[CancelReasonDescription]
                     ,       [Transactions].[Department]
                     ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                     ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                          ELSE ''
                                  END AS 'Voided'
                     ,       [Transactions].[Member1]
                     FROM    [INFOSTORE].[dbo].[Transactions]
                                  INNER JOIN [INFOSTORE].[dbo].[Clients]
                                    ON [Transactions].[Center] = [Clients].[Center]
                                          AND [Transactions].[client_no] = [Clients].[Client_no]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                    ON [Transactions].[Center] = [tblCenter].[Center_num]
                                  INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                    ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                  LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                    ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                     WHERE   [tblCenter].[RegionID] = @Center
                                  AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                  AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division], @Type,
                                                                                                                      [Transactions].[Member1]) = 1
                                  AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                  AND [Transactions].[Member1] NOT IN ( 'EXT', 'POSTEXT' )
                                  AND ISNULL([Transactions].[bVoided], 0) = 0
                END

         END


       /*
              16 = Post Ext #
              19 = Post Ext $
       */
       IF @Type IN ( 16, 19 )
         BEGIN

              /* Center-Specific */
              IF @Center NOT IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     SELECT  [Date]
                     ,       [SalesOrderTypeDescription]
                     ,       [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [CenterTypeDescription]
                     ,       [RegionID]
                     ,       [RegionDescription]
                     ,       [SalesCodeID]
                     ,       [SalesCodeDescription]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [SalesCodeDepartmentID]
                     ,       [SalesCodeDepartmentDescription]
                     ,       [SalesCodeDepartmentDescriptionShort]
                     ,       [SalesCodeDivisionID]
                     ,       [SalesCodeDivisionDescription]
                     ,       [SalesCodeDivisionDescriptionShort]
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientMembershipStatusDescription]
                     ,       [SalesCodeDescription] AS 'Description'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Quantity]
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [PriceTaxCalc]
                     ,       '' AS 'transact_no'
                     ,       '' AS 'Member1'
                     ,       CASE WHEN [Price] * [Quantity] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'Voided'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 2025 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [ClientHomeCenterID] = @SurgeryCenterNumber
                                  AND [IsVoidedFlag] = 0
                     ORDER BY [ClientHomeCenterID]
                     ,       [Date]
                END

              /* Region-Specific */
              IF @Center IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     SELECT  [Date]
                     ,       [SalesOrderTypeDescription]
                     ,       [ClientHomeCenterID] AS 'Center'
                     ,       [ClientHomeCenterDescription] AS 'Center_Name'
                     ,       [CenterTypeDescription]
                     ,       [RegionID]
                     ,       [RegionDescription]
                     ,       [SalesCodeID]
                     ,       [SalesCodeDescription]
                     ,       [SalesCodeDescriptionShort] AS 'Code'
                     ,       [SalesCodeDepartmentID]
                     ,       [SalesCodeDepartmentDescription]
                     ,       [SalesCodeDepartmentDescriptionShort]
                     ,       [SalesCodeDivisionID]
                     ,       [SalesCodeDivisionDescription]
                     ,       [SalesCodeDivisionDescriptionShort]
                     ,       [ClientFirstName] AS 'First_Name'
                     ,       [ClientLastName] AS 'Last_Name'
                     ,       [ClientIdentifier] AS 'client_no'
                     ,       [ClientMembershipStatusDescription]
                     ,       [SalesCodeDescription] AS 'Description'
                     ,       [InvoiceNumber] AS 'ticket_no'
                     ,       [Quantity]
                     ,       [ExtendedPriceCalc] AS 'Price'
                     ,       [Tax1] AS 'Tax_2'
                     ,       [Tax2] AS 'Tax_1'
                     ,       [PriceTaxCalc]
                     ,       '' AS 'transact_no'
                     ,       '' AS 'Member1'
                     ,       CASE WHEN [Price] * [Quantity] <= 0.0 THEN -1
                                          ELSE 1
                                  END AS 'Qty'
                     ,       [ConsultantInitials] AS 'Performer'
                     ,       '' AS 'Voided'
                     FROM    [dbo].[vw_datSalesOrderDetail]
                     WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                  AND [SalesCodeDepartmentID] IN ( 2025 )
                                  AND [CreateUser] NOT IN ( 'sa' )
                                  AND [RegionID] = @RegionID
                                  AND [IsVoidedFlag] = 0
                     ORDER BY [RegionDescription]
                     ,             [ClientHomeCenterID]
                     ,       [Date]
                END

         END


       /*
              17 = Total NB1 Net #
       */
       IF @Type IN ( 17 )
         BEGIN

              /* Center-Specific */
              IF @Center NOT IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                   , [Voided]
                                  , [Member1]
                                  )
                                  SELECT  [Transactions].[Center]
                                  ,       [tblCenter].[Center] AS 'Center_Name'
                                  ,       [tblRegion].[Region]
                                  ,       [Transactions].[client_no]
                                  ,       [Clients].[Last_Name]
                                  ,       [Clients].[First_Name]
                                  ,       [Transactions].[transact_no]
                                  ,       [Transactions].[ticket_no]
                                  ,       [Transactions].[Date]
                                  ,       [Transactions].[Code]
                                  ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                                  ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                                        ELSE [Transactions].[Qty]
                                                END AS 'Qty'
                                  ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                                        THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                                        ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                                END AS 'Price'
                                  ,       [Transactions].[Tax_1]
                                  ,       [Transactions].[Tax_2]
                                  ,       [Transactions].[Performer]
                                  ,       [CancelReason].[CancelReasonDescription]
                                  ,       [Transactions].[Department]
                                  ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                                  ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                                        ELSE ''
                                                END AS 'Voided'
                                  ,       [Transactions].[Member1]
                                  FROM    [INFOSTORE].[dbo].[Transactions]
                                                INNER JOIN [INFOSTORE].[dbo].[Clients]
                                                  ON [Transactions].[Center] = [Clients].[Center]
                                                        AND [Transactions].[client_no] = [Clients].[Client_no]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                                  ON [Transactions].[Center] = [tblCenter].[Center_num]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                                  ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                                LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                                  ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                                  WHERE   [Transactions].[Center] = @Center
                                                AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                                AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division],
                                                                                                                                   @Type, [Transactions].[Member1]) = 1
                                                AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                                AND ISNULL([Transactions].[bVoided], 0) = 0


                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                   , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                  SELECT  [ClientHomeCenterID] AS 'Center'
                                  ,       [ClientHomeCenterDescription] AS 'Center_Name'
                                  ,       [RegionDescription]
                                  ,       [ClientIdentifier] AS 'client_no'
                                  ,       [ClientLastName] AS 'Last_Name'
                                  ,       [ClientFirstName] AS 'First_Name'
                                  ,       '' AS 'transact_no'
                                  ,       [InvoiceNumber] AS 'ticket_no'
                                  ,       [Date]
                                  ,       [SalesCodeDescriptionShort] AS 'Code'
                                  ,       [SalesCodeDescription] AS 'Description'
                                  ,       CASE WHEN [Price] * [Quantity] <= 0.0 THEN -1
                                                        ELSE 1
                                                END AS 'Qty'
                                  ,       [ExtendedPriceCalc] AS 'Price'
                                  ,       [Tax2] AS 'Tax_1'
                                  ,       [Tax1] AS 'Tax_2'
                                  ,       [ConsultantInitials] AS 'Performer'
                                  ,       ''
                                  ,       [SalesCodeDepartmentDescriptionShort]
                                  ,       ''
                                  ,       ''
                                  ,       [ClientMembershipStatusDescription]
                                  FROM    [dbo].[vw_datSalesOrderDetail]
                                  WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                                AND [SalesCodeDepartmentID] IN ( 2025, 1010, 1075, 1090, 1099 )
                                                AND [CreateUser] NOT IN ( 'sa' )
                                                AND [ClientHomeCenterID] = @SurgeryCenterNumber
                                                AND [IsVoidedFlag] = 0
                                  ORDER BY [ClientHomeCenterID]
                                  ,       [Date]

                     SELECT  *
                     FROM    [#TotalNB]
                END

              /* Region-Specific */
              IF @Center IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                   SELECT  [Transactions].[Center]
                                  ,       [tblCenter].[Center] AS 'Center_Name'
                                  ,       [tblRegion].[Region]
                                  ,       [Transactions].[client_no]
                                  ,       [Clients].[Last_Name]
                                  ,       [Clients].[First_Name]
                                  ,       [Transactions].[transact_no]
                                  ,       [Transactions].[ticket_no]
                                  ,       [Transactions].[Date]
                                  ,       [Transactions].[Code]
                                  ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                                  ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                                        ELSE [Transactions].[Qty]
                                                END AS 'Qty'
                                  ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                                        THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                                        ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                                END AS 'Price'
                                  ,       [Transactions].[Tax_1]
                                  ,       [Transactions].[Tax_2]
                                  ,       [Transactions].[Performer]
                                  ,       [CancelReason].[CancelReasonDescription]
                                  ,       [Transactions].[Department]
                                  ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                                  ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                                        ELSE ''
                                                END AS 'Voided'
                                  ,       [Transactions].[Member1]
                                  FROM    [INFOSTORE].[dbo].[Transactions]
                                                INNER JOIN [INFOSTORE].[dbo].[Clients]
                                                  ON [Transactions].[Center] = [Clients].[Center]
                                                        AND [Transactions].[client_no] = [Clients].[Client_no]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                                  ON [Transactions].[Center] = [tblCenter].[Center_num]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                                  ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                                LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                                  ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                                  WHERE   [tblCenter].[RegionID] = @Center
                                                AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                                AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division],
                                                                                                                                   @Type, [Transactions].[Member1]) = 1
                                                AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                                AND ISNULL([Transactions].[bVoided], 0) = 0


                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                  SELECT  [ClientHomeCenterID] AS 'Center'
                                  ,       [ClientHomeCenterDescription] AS 'Center_Name'
                                  ,       [RegionDescription]
                                  ,       [ClientIdentifier] AS 'client_no'
                                  ,       [ClientLastName] AS 'Last_Name'
                                  ,       [ClientFirstName] AS 'First_Name'
                                  ,       '' AS 'transact_no'
                                  ,       [InvoiceNumber] AS 'ticket_no'
                                  ,       [Date]
                                  ,       [SalesCodeDescriptionShort] AS 'Code'
                                  ,       [SalesCodeDescription] AS 'Description'
                                  ,       CASE WHEN [Price] * [Quantity] <= 0.0 THEN -1
                                                        ELSE 1
                                                END AS 'Qty'
                                  ,       [ExtendedPriceCalc] AS 'Price'
                                  ,       [Tax2] AS 'Tax_1'
                                  ,       [Tax1] AS 'Tax_2'
                                  ,       [ConsultantInitials] AS 'Performer'
                                  ,       ''
                                  ,       [SalesCodeDepartmentDescriptionShort]
                                  ,       ''
                                  ,       ''
                                  ,       [ClientMembershipStatusDescription]
                                  FROM    [dbo].[vw_datSalesOrderDetail]
                                  WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                                AND [SalesCodeDepartmentID] IN ( 2025, 1010, 1075, 1090, 1099 )
                                                AND [CreateUser] NOT IN ( 'sa' )
                                                AND [RegionID] = @RegionID
                                                AND [IsVoidedFlag] = 0
                                  ORDER BY [ClientHomeCenterID]
                                  ,       [Date]

                     SELECT  *
                     FROM    [#TotalNB]
                END

         END


       /*
              18 = Total NB1 Net $
       */
       IF @Type IN ( 18 )
         BEGIN

              /* Center-Specific */
              IF @Center NOT IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                  SELECT  [Transactions].[Center]
                                  ,       [tblCenter].[Center] AS 'Center_Name'
                                  ,       [tblRegion].[Region]
                                  ,       [Transactions].[client_no]
                                  ,       [Clients].[Last_Name]
                                  ,       [Clients].[First_Name]
                                  ,       [Transactions].[transact_no]
                                  ,       [Transactions].[ticket_no]
                                  ,       [Transactions].[Date]
                                  ,       [Transactions].[Code]
                                  ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                                  ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                                        ELSE [Transactions].[Qty]
                                                END AS 'Qty'
                                  ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                                        THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                                        ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                                END AS 'Price'
                                  ,       [Transactions].[Tax_1]
                                  ,       [Transactions].[Tax_2]
                                  ,       [Transactions].[Performer]
                                  ,       [CancelReason].[CancelReasonDescription]
                                  ,       [Transactions].[Department]
                                  ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                                  ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                                        ELSE ''
                                                END AS 'Voided'
                                  ,       [Transactions].[Member1]
                                  FROM    [INFOSTORE].[dbo].[Transactions]
                                                INNER JOIN [INFOSTORE].[dbo].[Clients]
                                                  ON [Transactions].[Center] = [Clients].[Center]
                                                        AND [Transactions].[client_no] = [Clients].[Client_no]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                                  ON [Transactions].[Center] = [tblCenter].[Center_num]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                                  ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                                LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                                  ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                                  WHERE   [Transactions].[Center] = @Center
                                                AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                                AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division],
                                                                                                                                   @Type, [Transactions].[Member1]) = 1
                                                AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                                AND ISNULL([Transactions].[bVoided], 0) = 0


                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                  SELECT  [ClientHomeCenterID] AS 'Center'
                                  ,       [ClientHomeCenterDescription] AS 'Center_Name'
                                  ,       [RegionDescription]
                                  ,       [ClientIdentifier] AS 'client_no'
                                  ,       [ClientLastName] AS 'Last_Name'
                                  ,       [ClientFirstName] AS 'First_Name'
                                  ,       '' AS 'transact_no'
                                  ,       [InvoiceNumber] AS 'ticket_no'
                                  ,       [Date]
                                  ,       [SalesCodeDescriptionShort] AS 'Code'
                                  ,       [SalesCodeDescription] AS 'Description'
                                  ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                                        ELSE 1
                                                END AS 'Qty'
                                  ,       [ExtendedPriceCalc] AS 'Price'
                                  ,       [Tax2] AS 'Tax_1'
                                  ,       [Tax1] AS 'Tax_2'
                                  ,       [ConsultantInitials] AS 'Performer'
                                  ,       ''
                                  ,       [SalesCodeDepartmentDescriptionShort]
                                  ,       ''
                                  ,       ''
                                  ,       [ClientMembershipStatusDescription]
                                  FROM    [dbo].[vw_datSalesOrderDetail]
                                  WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                                AND [SalesCodeDepartmentID] IN ( 2025, 2020 )
                                                AND [CreateUser] NOT IN ( 'sa' )
                                                AND [ClientHomeCenterID] = @SurgeryCenterNumber
                                                AND [IsVoidedFlag] = 0
                                  ORDER BY [ClientHomeCenterID]
                                  ,       [Date]

                     SELECT  *
                     FROM    [#TotalNB]
                END

              /* Region-Specific */
              IF @Center IN ( 28, 29, 30, 31, 6, 32 )
                BEGIN
                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                   SELECT  [Transactions].[Center]
                                  ,       [tblCenter].[Center] AS 'Center_Name'
                                  ,       [tblRegion].[Region]
                                  ,       [Transactions].[client_no]
                                  ,       [Clients].[Last_Name]
                                  ,       [Clients].[First_Name]
                                  ,       [Transactions].[transact_no]
                                  ,       [Transactions].[ticket_no]
                                  ,       [Transactions].[Date]
                                  ,       [Transactions].[Code]
                                  ,       ISNULL([CancelReason].[CancelReasonDescription], [Transactions].[Description]) AS 'Description'
                                  ,       CASE WHEN [dbo].[ISINVERSE_SIGN]([Transactions].[Code]) = 1 THEN [Transactions].[Qty] * -1
                                                        ELSE [Transactions].[Qty]
                                                END AS 'Qty'
                                  ,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
                                                        THEN [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Member1_Price], [Transactions].[Date])
                                                        ELSE [dbo].[CanadianConversion]([Transactions].[Center], [Transactions].[Price], [Transactions].[Date])
                                                END AS 'Price'
                                  ,       [Transactions].[Tax_1]
                                  ,       [Transactions].[Tax_2]
                                  ,       [Transactions].[Performer]
                                  ,       [CancelReason].[CancelReasonDescription]
                                  ,       [Transactions].[Department]
                                  ,       ISNULL([Transactions].[Performer2], '') AS 'Performer2'
                                  ,       CASE WHEN ISNULL([Transactions].[bVoided], 0) = 1 THEN 'v'
                                                        ELSE ''
                                                END AS 'Voided'
                                  ,       [Transactions].[Member1]
                                  FROM    [INFOSTORE].[dbo].[Transactions]
                                                INNER JOIN [INFOSTORE].[dbo].[Clients]
                                                  ON [Transactions].[Center] = [Clients].[Center]
                                                        AND [Transactions].[client_no] = [Clients].[Client_no]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblCenter]
                                                  ON [Transactions].[Center] = [tblCenter].[Center_num]
                                                INNER JOIN [HCFMDirectory].[dbo].[tblRegion]
                                                  ON [tblCenter].[RegionID] = [tblRegion].[RegionID]
                                                LEFT OUTER JOIN [INFOSTORE].[dbo].[CancelReason]
                                                  ON [Transactions].[CancelReasonID] = [CancelReason].[CancelReasonID]
                                  WHERE   [tblCenter].[RegionID] = @Center
                                                AND [Transactions].[Date] BETWEEN @BegDt AND @EndDt
                                                AND [dbo].[ISFLASH_SALE_ByDepartmentAndDivision](@Center, [Transactions].[Code], [Transactions].[Department], [Transactions].[Division],
                                                                                                                                   @Type, [Transactions].[Member1]) = 1
                                                AND [Transactions].[Code] NOT IN ( 'TXFR', 'NB1TXFR', 'NB1REM', 'TXFRIN', 'TXFROUT', 'POSTEXTX' )
                                                AND ISNULL([Transactions].[bVoided], 0) = 0

                     INSERT  INTO [#TotalNB]
                                  (
                                    [Center]
                                  , [Center_Name]
                                  , [Region]
                                  , [Client_no]
                                  , [Last_Name]
                                  , [First_Name]
                                  , [Transact_No]
                                  , [Ticket_No]
                                  , [Date]
                                  , [Code]
                                  , [Description]
                                  , [Qty]
                                  , [Price]
                                  , [Tax_1]
                                  , [Tax_2]
                                  , [Performer]
                                  , [CancelReasonDescription]
                                  , [Department]
                                  , [Performer2]
                                  , [Voided]
                                  , [Member1]
                                  )
                                  SELECT  [ClientHomeCenterID] AS 'Center'
                                  ,       [ClientHomeCenterDescription] AS 'Center_Name'
                                  ,       [RegionDescription]
                                  ,       [ClientIdentifier] AS 'client_no'
                                  ,       [ClientLastName] AS 'Last_Name'
                                  ,       [ClientFirstName] AS 'First_Name'
                                  ,       '' AS 'transact_no'
                                  ,       [InvoiceNumber] AS 'ticket_no'
                                  ,       [Date]
                                  ,       [SalesCodeDescriptionShort] AS 'Code'
                                  ,       [SalesCodeDescription] AS 'Description'
                                  ,       CASE WHEN [ExtendedPriceCalc] <= 0.0 THEN -1
                                                        ELSE 1
                                                END AS 'Qty'
                                  ,       [ExtendedPriceCalc] AS 'Price'
                                  ,       [Tax2] AS 'Tax_1'
                                  ,       [Tax1] AS 'Tax_2'
                                  ,       [ConsultantInitials] AS 'Performer'
                                  ,       ''
                                  ,       [SalesCodeDepartmentDescriptionShort]
                                  ,       ''
                                  ,       ''
                                  ,       [ClientMembershipStatusDescription]
                                  FROM    [dbo].[vw_datSalesOrderDetail]
                                  WHERE   [Date] BETWEEN @BegDt AND @EndDt
                                                AND [SalesCodeDepartmentID] IN ( 2025, 2020 )
                                                AND [CreateUser] NOT IN ( 'sa' )
                                                AND [RegionID] = @RegionID
                                                AND [IsVoidedFlag] = 0
                                  ORDER BY [ClientHomeCenterID]
                                  ,       [Date]

                     SELECT  *
                     FROM    [#TotalNB]
                END
         END
END
GO
