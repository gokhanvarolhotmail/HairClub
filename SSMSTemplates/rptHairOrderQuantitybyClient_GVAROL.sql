/* https://hairclub.zendesk.com/agent/tickets/7944 */
GO
/*
===============================================================================================
 Procedure Name:            rptHairOrderQuantitybyClient
 Procedure Description:     
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              04/21/2014
 Destination Server:        SQL01.HairclubCMS
 Related Application:       Hairclub CMS
===============================================================================================
NOTES:
    --Memberships included in the report: (These are selected and passed into the report as a parameter.)
    SELECT MembershipID
    ,    MembershipDescription
    FROM dbo.cfgMembership 
    WHERE BusinessSegmentID = 1 --BIO
    AND MembershipID NOT IN(1,2,11,12,14,15,16,17,18,19,49,50,57)
    
    This report pulls memeberships that began 18 months ago: cm.BeginDate >= DATEADD(MONTH,-18,GETUTCDATE())
===============================================================================================
Change History:
04/28/2014 - RH - Changed the CenterID and Description to the Home Center for the client.
04/20/2015 - RH - Added TotalAccumQuantity, AccumQuantityRemainingCalc, QtyDifference, QtyOver (Ordered Hair Systems over the allotment in red lettering.)
07/14/2015 - RH - Added Promo Systems
07/17/2015 - RH - Added Remove REMOVESYS SalesCodeID = 705 to the Promo section
08/31/2015 - RH - Added code to find the Initial Quantity per membership
12/21/2016 - MVT- Tuned proc to run quicker. Changed MembershipID's to be stored as int's in the #membership temp, 
                    modified #hair select to run quicker, modified Due Date calculation query to no longer join back to datHairSystemOrder table.
05/10/2017 - RH - Changed Remaining from (InitialQuantity - OnOrder + Promo) to ahs.AccumQuantityRemainingCalc to match cONEct
09/27/2021 - AP - Include clients without hairOrders.
===============================================================================================
Sample Execution:
EXEC [rptHairOrderQuantitybyClient] 100, '0'
EXEC [rptHairOrderQuantitybyClient] 241, '26,27,28,29,30,31,45,46,47,48'
===============================================================================================
*/
ALTER PROCEDURE [dbo].[rptHairOrderQuantitybyClient_GVAROL]
    @CenterID       INT
  , @MembershipList NVARCHAR(MAX)
AS
SET NOCOUNT ON ;

--Split the string parameter that is entered for MembershipID's
CREATE TABLE [#membership] ( [MembershipID] INT ) ;

INSERT INTO [#membership]
SELECT CAST([item] AS INT)
FROM [dbo].[fnSplit](@MembershipList, ',') ;

DECLARE
    @CenterIDs                NVARCHAR(MAX)
  , @CorpCenterTypeID         INT
  , @FranchiseCenterTypeID    INT
  , @JointVentureCenterTypeID INT ;

SELECT @CorpCenterTypeID = [CenterTypeID]
FROM [dbo].[lkpCenterType]
WHERE [CenterTypeDescriptionShort] = 'C' ;

SELECT @FranchiseCenterTypeID = [CenterTypeID]
FROM [dbo].[lkpCenterType]
WHERE [CenterTypeDescriptionShort] = 'F' ;

SELECT @JointVentureCenterTypeID = [CenterTypeID]
FROM [dbo].[lkpCenterType]
WHERE [CenterTypeDescriptionShort] = 'JV' ;

SET @CenterIDs = @CenterID ;

IF( @CenterID = 1 )
    BEGIN
        SELECT @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(NVARCHAR, [CenterID]), '')
        FROM [dbo].[cfgCenter]
        WHERE [CenterTypeID] = @CorpCenterTypeID AND [IsCorporateHeadquartersFlag] = 0 ;
    END ;

-- Add Franchise CenterIDs to List    
IF( @CenterID = 2 )
    BEGIN
        SELECT @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(NVARCHAR, [CenterID]), '')
        FROM [dbo].[cfgCenter]
        WHERE [CenterTypeID] = @FranchiseCenterTypeID ;
    END ;

-- Add JointVenture CenterIDs to List    
IF( @CenterID = 3 )
    BEGIN
        SELECT @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(NVARCHAR, [CenterID]), '')
        FROM [dbo].[cfgCenter]
        WHERE [CenterTypeID] = @JointVentureCenterTypeID ;
    END ;

CREATE TABLE [#hair]
(
    [HairSystemOrderNumber]                NVARCHAR(50)
  , [CenterID]                             INT
  , [CenterDescriptionFullCalc]            NVARCHAR(103)
  , [ClientFullNameCalc]                   NVARCHAR(127)
  , [ClientGUID]                           UNIQUEIDENTIFIER
  , [CurrentBioMatrixClientMembershipGUID] UNIQUEIDENTIFIER
  , [MembershipID]                         INT
  , [MembershipDescription]                NVARCHAR(50)
  , [EndDate]                              DATETIME
  , [LastApplicationDate]                  DATETIME
  , [InCenter]                             INT
  , [OnOrder]                              INT
  , [QaNeeded]                             INT
  , [Status]                               NVARCHAR(10)
  , [DueDate]                              DATETIME
  , [HairSystemOrderDate]                  DATETIME
  , [HairSystemOrderGUID]                  UNIQUEIDENTIFIER
  , [MembershipStartDate]                  DATE
  , [NextAppointmentDate]                  DATE
) ;

IF @MembershipList = '0' --ALL
    BEGIN
        INSERT INTO [#hair]
        SELECT
            [hso].[HairSystemOrderNumber]
          , [clt].[CenterID]
          , [c].[CenterDescriptionFullCalc]
          , [clt].[ClientFullNameCalc]
          , [clt].[ClientGUID]
          , [clt].[CurrentBioMatrixClientMembershipGUID]
          , [m].[MembershipID]
          , [m].[MembershipDescription]
          , [cm].[EndDate]
          , NULL AS [LastApplicationDate]
          , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT') THEN 1 ELSE 0 END AS [InCenter]
          , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship', 'FAC-Ship') THEN 1 ELSE 0 END AS [OnOrder]
          , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('QANEEDED') THEN 1 ELSE 0 END AS [QaNeeded]
          , [hsos].[HairSystemOrderStatusDescriptionShort] AS [Status]
          , [hso].[DueDate]
          , [hso].[HairSystemOrderDate]
          , [hso].[HairSystemOrderGUID]
          , [cm].[BeginDate] AS [MembershipStartDate]
          , NULL AS [NextAppointmentDate]
        FROM [dbo].[datClient] AS [clt]
        INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [clt].[CurrentBioMatrixClientMembershipGUID]
        INNER JOIN [dbo].[cfgMembership] AS [m] ON [m].[MembershipID] = [cm].[MembershipID]
        --OUTER APPLY( SELECT [k].[NextAppointmentDate]
        --             FROM( SELECT
        --                       DATEADD(DAY, ( [b].[digit] - 1 ) * [k].[Application Cadence Days], [cm].[BeginDate]) AS [NextAppointmentDate]
        --                     , ROW_NUMBER() OVER ( PARTITION BY [m].[MembershipID], [k].[MembershipAccumulatorID] ORDER BY [b].[digit] ASC ) AS [rw]
        --                     , [k].*
        --                   FROM( SELECT TOP( 1 )
        --                                [m].[DurationMonths] * 30 / [ca].[InitialQuantity] AS [Application Cadence Days]
        --                              , [ca].[InitialQuantity]
        --                              , [ca].[MembershipAccumulatorID]
        --                         FROM [dbo].[cfgMembershipAccum] AS [ca]
        --                         WHERE [ca].[MembershipID] = [m].[MembershipID]
        --                           AND [ca].[IsActiveFlag] = 1
        --                           AND [ca].[AccumulatorID] = 8
        --                           AND [m].[IsActiveFlag] = 1
        --                           AND [m].[BusinessSegmentID] = 1 ) AS [k]
        --                   CROSS APPLY [dbo].GetNumbers(1, [k].[InitialQuantity]) AS [b]
        --                   WHERE DATEADD(DAY, ( [b].[digit] - 1 ) * [k].[Application Cadence Days], [cm].[BeginDate]) > CAST(GETDATE() AS DATE)) AS [k]
        --             WHERE [k].[rw] = 1 ) AS [nad]
        LEFT JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
        LEFT JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsos].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
                                                            AND [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship'
                                                                                                                   , 'FAC-Ship', 'QANEEDED')
        --INNER JOIN dbo.datClient clt ON clt.ClientGUID = hso.ClientGUID        
        INNER JOIN [dbo].[cfgCenter] AS [c] ON [c].[CenterID] = [clt].[CenterID]
        LEFT JOIN [dbo].[cfgHairSystem] AS [hs] ON [hs].[HairSystemID] = [hso].[HairSystemID]
        WHERE [clt].[CenterID] IN( SELECT [item] FROM [dbo].[fnSplit](@CenterIDs, ',') )
          AND [m].[MembershipDescription] <> 'CANCEL'
          AND [cm].[ClientMembershipStatusID] = 1
          AND [m].[BusinessSegmentID] = 1 --BIO
          AND [m].[MembershipID] NOT IN (1, 2, 11, 12, 14, 15, 16, 17, 18, 19, 49, 50, 57) --ALL except these 
          /*Elite (New)
                        Elite (New) Solutions
                        Cancel
                        Hair Club For Kids
                        Retail
                        Non Program
                        Designer
                        EMERALD-OLD
                        ACQUIRED
                        IEG
                        Model - BioMatrix
                        Employee - BioMatrix
                        New Client (ShowNoSale)
                    */
          AND [cm].[BeginDate] >= DATEADD(MONTH, -18, GETUTCDATE()) ;
    END ;
ELSE
    BEGIN




        INSERT INTO [#hair]
        SELECT
            [hso].[HairSystemOrderNumber]
          , [clt].[CenterID]
          , [c].[CenterDescriptionFullCalc]
          , [clt].[ClientFullNameCalc]
          , [clt].[ClientGUID]
          , [clt].[CurrentBioMatrixClientMembershipGUID]
          , [m].[MembershipID]
          , [m].[MembershipDescription]
          , [cm].[EndDate]
          , NULL AS [LastApplicationDate]
          , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT') THEN 1 ELSE 0 END AS [InCenter]
          , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship', 'FAC-Ship') THEN 1 ELSE 0 END AS [OnOrder]
          , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('QANEEDED') THEN 1 ELSE 0 END AS [QaNeeded]
          , [hsos].[HairSystemOrderStatusDescriptionShort] AS [Status]
          , [hso].[DueDate] AS [DueDate]
          , [hso].[HairSystemOrderDate]
          , [hso].[HairSystemOrderGUID]
          , [cm].[BeginDate] AS [MembershipStartDate]
          , NULL AS [NextAppointmentDate]
        FROM [dbo].[datClient] AS [clt]
        INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [clt].[CurrentBioMatrixClientMembershipGUID]
        INNER JOIN [dbo].[cfgMembership] AS [m] ON [m].[MembershipID] = [cm].[MembershipID]
        --OUTER APPLY( SELECT [k].[NextAppointmentDate]
        --             FROM( SELECT
        --                       DATEADD(DAY, ( [b].[digit] - 1 ) * [k].[Application Cadence Days], [cm].[BeginDate]) AS [NextAppointmentDate]
        --                     , ROW_NUMBER() OVER ( PARTITION BY [m].[MembershipID], [k].[MembershipAccumulatorID] ORDER BY [b].[digit] ASC ) AS [rw]
        --                     , [k].*
        --                   FROM( SELECT TOP( 1 )
        --                                [m].[DurationMonths] * 30 / [ca].[InitialQuantity] AS [Application Cadence Days]
        --                              , [ca].[InitialQuantity]
        --                              , [ca].[MembershipAccumulatorID]
        --                         FROM [dbo].[cfgMembershipAccum] AS [ca]
        --                         WHERE [ca].[MembershipID] = [m].[MembershipID]
        --                           AND [ca].[IsActiveFlag] = 1
        --                           AND [ca].[AccumulatorID] = 8
        --                           AND [m].[IsActiveFlag] = 1
        --                           AND [m].[BusinessSegmentID] = 1 ) AS [k]
        --                   CROSS APPLY [dbo].GetNumbers(1, [k].[InitialQuantity]) AS [b]
        --                   WHERE DATEADD(DAY, ( [b].[digit] - 1 ) * [k].[Application Cadence Days], [cm].[BeginDate]) > CAST(GETDATE() AS DATE)) AS [k]
        --             WHERE [k].[rw] = 1 ) AS [nad]
        LEFT JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
        LEFT JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsos].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
                                                            AND [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship'
                                                                                                                   , 'FAC-Ship', 'QANEEDED')
        INNER JOIN [dbo].[cfgCenter] AS [c] ON [c].[CenterID] = [clt].[CenterID]
        LEFT JOIN [dbo].[cfgHairSystem] AS [hs] ON [hs].[HairSystemID] = [hso].[HairSystemID]
        WHERE [clt].[CenterID] IN( SELECT [item] FROM [dbo].[fnSplit](@CenterIDs, ',') )
          AND [cm].[BeginDate] >= DATEADD(MONTH, -18, GETUTCDATE())
          AND [cm].[MembershipID] IN( SELECT [MembershipID] FROM [#membership] )
          AND [m].[MembershipDescription] <> 'CANCEL'
          AND [cm].[ClientMembershipStatusID] = 1 ;
    END ;

CREATE CLUSTERED INDEX [IDX_hair_CurrentBioMatrixClientMembershipGUID] ON [#hair]( [CurrentBioMatrixClientMembershipGUID] ) ;

--Find Promo Systems
SELECT
    [q].[ClientMembershipGUID]
  , ( SUM(ISNULL([q].[Promo], 0)) - SUM(ISNULL([q].[Remove], 0))) AS [Promo]
INTO [#promo]
FROM( SELECT
          [so].[ClientMembershipGUID]
        , [so].[OrderDate]
        , CASE WHEN [sod].[SalesCodeID] = 700 THEN [sod].[Quantity] ELSE 0 END AS [Promo]
        , CASE WHEN [sod].[SalesCodeID] = 705 THEN [sod].[Quantity] ELSE 0 END AS [Remove]
        , [sc].[SalesCodeDescriptionShort]
      FROM [#hair]
      INNER JOIN [dbo].[datSalesOrder] AS [so] ON [CurrentBioMatrixClientMembershipGUID] = [so].[ClientMembershipGUID]
      INNER JOIN [dbo].[datSalesOrderDetail] AS [sod] ON [so].[SalesOrderGUID] = [sod].[SalesOrderGUID]
      INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sod].[SalesCodeID] = [sc].[SalesCodeID]
      WHERE [sc].[SalesCodeID] IN (700, 705) --PROMOSYS, REMOVESYS
      GROUP BY [so].[ClientMembershipGUID]
             , [so].[OrderDate]
             , [sod].[Quantity]
             , [sc].[SalesCodeDescriptionShort]
             , [sod].[SalesCodeID] ) AS [q]
GROUP BY [q].[ClientMembershipGUID] ;

--Find Last Applied Date
SELECT
    [lastapp].[ClientGUID]
  , [lastapp].[HairSystemOrderTransactionDate] AS [LastApplicationDate]
INTO [#LastAppliedDate]
FROM( SELECT
          ROW_NUMBER() OVER ( PARTITION BY [hair].[ClientGUID] ORDER BY [hsot].[HairSystemOrderTransactionDate] DESC ) AS [LastRank]
        , [hair].[ClientGUID]
        , [hsot].[HairSystemOrderTransactionDate]
      FROM [#hair] AS [hair]
      INNER JOIN [dbo].[datHairSystemOrderTransaction] AS [hsot] ON [hair].[ClientGUID] = [hsot].[ClientGUID]
      INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsot].[NewHairSystemOrderStatusID] = [hsos].[HairSystemOrderStatusID]
      WHERE [hsos].[HairSystemOrderStatusDescriptionShort] = 'APPLIED' ) AS [lastapp]
WHERE [lastapp].[LastRank] = 1 ;

--Find Next Due Date
SELECT
    [due].[ClientGUID]
  , [due].[DueDate]
INTO [#NextDueDate]
FROM( SELECT
          ROW_NUMBER() OVER ( PARTITION BY [hair].[ClientGUID] ORDER BY [hair].[DueDate] ) AS [NextDueDate]
        , [hair].[ClientGUID]
        , [hair].[DueDate]
      FROM [#hair] AS [hair]
      INNER JOIN [dbo].[datHairSystemOrderTransaction] AS [hsot] ON [hsot].[HairSystemOrderGUID] = [hair].[HairSystemOrderGUID]
      INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsot].[NewHairSystemOrderStatusID] = [hsos].[HairSystemOrderStatusID]
      WHERE [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' AND [hair].[DueDate] >= GETUTCDATE()) AS [due]
WHERE [due].[NextDueDate] = 1 ;

--Find initial quantity for the membership
SELECT
    [M].[MembershipDescription]
  , [ACCUM].[MembershipID]
  , CASE WHEN [M].[MembershipDescription] LIKE '%Executive%' THEN 17 WHEN [M].[MembershipDescription] LIKE '%Presidential%' THEN 26 WHEN [M].[MembershipDescription] LIKE '%Premier%' THEN
                                                                                                                                    52 ELSE
                                                                                                                                       MIN(
                                                                                                                                       [ACCUM].[InitialQuantity])END AS [InitialQuantity]
INTO [#initialquantity]
FROM [dbo].[cfgMembershipAccum] AS [ACCUM]
INNER JOIN [dbo].[cfgMembership] AS [M] ON [ACCUM].[MembershipID] = [M].[MembershipID]
WHERE [M].[BusinessSegmentID] = 1 --BIO
  AND [ACCUM].[MembershipID] NOT IN (1, 2, 11, 12, 14, 15, 16, 17, 18, 19, 49, 50, 57) AND [ACCUM].[IsActiveFlag] = 1 AND [ACCUM].[InitialQuantity] <> 0
GROUP BY [M].[MembershipDescription]
       , [ACCUM].[MembershipID]
ORDER BY [M].[MembershipDescription] ;

CREATE TABLE [#groupedMemberships] ( [membershipId] INT, [membershipDescriptionShort] NVARCHAR(MAX), [membershipDescription] NVARCHAR(MAX), [membershipGroup] NVARCHAR(MAX), [MaxVal] INT ) ;

--- Insert membership values
INSERT INTO [#groupedMemberships]( [membershipId], [membershipDescriptionShort], [membershipDescription], [membershipGroup], [MaxVal] )
VALUES( 22, 'BASIC', 'Basic', 'Basic', 1 )
    , ( 30, 'DIA', 'Diamond', 'Diamond', 2 )
    , ( 31, 'DIASOL', 'Diamond Solutions', 'Diamond', 2 )
    , ( 24, 'BRZ', 'Bronze', 'Bronze', 1 )
    , ( 12, 'HCFK', 'Hair Club For Kids', 'HCFK', 1 )
    , ( 65, 'EMRLD', 'Emerald', 'Emerald', 1 )
    , ( 290, 'EMPLOYRET', 'Employee-Retail', 'EmployeeRetail', 1 )
    , ( 34, 'EXE', 'Executive', 'Executive', 3 )
    , ( 28, 'GLD', 'Gold', 'Gold', 2 )
    , ( 29, 'GLDSOL', 'Gold Solutions', 'Gold', 2 )
    , ( 32, 'PLA', 'Platinum', 'Platinum', 3 )
    , ( 33, 'PLASOL', 'Platinum Solutions', 'Platinum', 3 )
    , ( 36, 'PRS', 'Presidential', 'Presidential', 4 )
    , ( 63, 'RUBY', 'Ruby', 'Ruby', 1 )
    , ( 95, 'RUBY', 'Ruby Plus Transitional', 'Ruby', 1 )
    , ( 67, 'SAPPHIRE', 'Sapphire', 'Sapphire', 2 )
    , ( 26, 'SIL', 'Silver', 'Silver', 1 )
    , ( 10, 'TRADITION', 'Xtrands+ Initial', 'Xtrands+', 1 )
    , ( 5, 'GRADSOL12', 'Xtrands+ Initial 12 Solutions', 'Xtrands+', 1 )
    , ( 3, 'GRAD', 'Xtrands+ Initial 6', 'Xtrands+', 1 )
    , ( 47, 'GRDSV', 'Xtrands+ Initial 6', 'Xtrands+', 1 )
    , ( 285, 'GRDSV', 'Xtrands+ Initial 6 EZPAY', 'Xtrands+', 1 )
    , ( 4, 'GRDSV', 'Xtrands+ Initial 6 Solutions', 'Xtrands+', 1 )
    , ( 48, 'GRDSVSOL', 'Xtrands+ Initial 6 Solutions', 'Xtrands+', 1 ) ;

SELECT
    [q].[ClientFullNameCalc]
  , [q].[MembershipDescription]
  , [q].[MembershipID]
  , [q].[CenterDescriptionFullCalc] AS [CenterID]
  , [q].[EndDate]
  , [q].[LastApplicationDate]
  , [q].[InCenter]
  , [q].[OnOrder]
  , [q].[DueDate]
  , [q].[TotalAccumQuantity]
  , [q].[Promo]
  , [q].[InitialQuantity]
  --,    Remaining = (InitialQuantity - OnOrder + Promo)
  , [q].[AccumQuantityRemainingCalc] AS [Remaining]
  , CASE WHEN [q].[Promo] < 0 THEN 0 ELSE [q].[Promo] END AS [Overage]
  , ( [q].[QaNeeded] + [q].[InCenter] + [q].[OnOrder] ) AS [QuantityAtCenterAndOrdered]
  , [q].[QaNeeded] AS [QaNeeded]
  , [q].[CenterDescriptionFullCalc]
  , [q].[MembershipStartDate]
  --, [q].[OrderAvailForNextApp]
INTO [#tmpHairOrderQuantitybyClient]
FROM( SELECT
          [hair].[ClientFullNameCalc]
        , [hair].[MembershipDescription]
        , [hair].[CenterID]
        , [hair].[EndDate]
        , [hair].[MembershipID]
        , [lad].[LastApplicationDate]
        , SUM([hair].[InCenter]) AS [InCenter]
        , SUM([hair].[OnOrder]) AS [OnOrder]
        , [ndd].[DueDate]
        , [ahs].[TotalAccumQuantity]
        , [ahs].[AccumQuantityRemainingCalc]
        , ISNULL([pro].[Promo], 0) AS [Promo]
        , [iq].[InitialQuantity]
        , [hair].[CenterDescriptionFullCalc]
        , SUM([hair].[QaNeeded]) AS [QaNeeded]
        , MAX([hair].[MembershipStartDate]) AS [MembershipStartDate]
        --, MAX(CASE WHEN [hair].[HairSystemOrderDate] = [hair].[NextAppointmentDate] AND [hair].[InCenter] = 1 THEN 1 ELSE 0 END) AS [OrderAvailForNextApp]
      FROM [#hair] AS [hair]
      LEFT JOIN [dbo].[datClientMembershipAccum] AS [ahs] ON [hair].[CurrentBioMatrixClientMembershipGUID] = [ahs].[ClientMembershipGUID]
                                                         AND [ahs].[AccumulatorID] = 8 --Hair Systems
      LEFT JOIN [#promo] AS [pro] ON [hair].[CurrentBioMatrixClientMembershipGUID] = [pro].[ClientMembershipGUID]
      LEFT JOIN [#LastAppliedDate] AS [lad] ON [hair].[ClientGUID] = [lad].[ClientGUID]
      LEFT JOIN [#NextDueDate] AS [ndd] ON [hair].[ClientGUID] = [ndd].[ClientGUID]
      LEFT JOIN [#initialquantity] AS [iq] ON [hair].[MembershipID] = [iq].[MembershipID]
      LEFT JOIN [dbo].[cfgCenter] AS [cent] ON [cent].[CenterID] = [hair].[CenterID]
      GROUP BY [hair].[CenterDescriptionFullCalc]
             , [hair].[ClientFullNameCalc]
             , [hair].[MembershipDescription]
             , [hair].[CenterID]
             , [hair].[EndDate]
             , [lad].[LastApplicationDate]
             , [ndd].[DueDate]
             , [ahs].[TotalAccumQuantity]
             , [ahs].[AccumQuantityRemainingCalc]
             , [pro].[Promo]
             , [iq].[InitialQuantity]
             , [hair].[MembershipID] ) AS [q] ;

SELECT
    [tmpData].[ClientFullNameCalc]
  , [tmpData].[MembershipDescription]
  , [tmpData].[MembershipID]
  , [tmpData].[CenterDescriptionFullCalc] AS [CenterID]
  , [tmpData].[EndDate]
  , [tmpData].[LastApplicationDate]
  , [tmpData].[InCenter]
  , [tmpData].[OnOrder]
  , [tmpData].[DueDate]
  , [tmpData].[TotalAccumQuantity]
  , [tmpData].[Promo]
  , [tmpData].[InitialQuantity]
  , [tmpData].[Remaining]
  , [tmpData].[Overage]
  , [tmpData].[QuantityAtCenterAndOrdered]
  , [tmpData].[QaNeeded]
  , [tmpData].[CenterDescriptionFullCalc]
  , [gms].[membershipGroup]
  --, CASE WHEN ( [gms].[membershipGroup] LIKE '%Xtrands+%' OR [gms].[membershipGroup] LIKE '%EmployeeRetail%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 0
  --      WHEN ( [gms].[membershipGroup] LIKE '%Xtrands+%' OR [gms].[membershipGroup] LIKE '%EmployeeRetail%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 0
  --      WHEN ( [gms].[membershipGroup] LIKE '%Xtrands+%' OR [gms].[membershipGroup] LIKE '%EmployeeRetail%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 0
  --      WHEN ( [gms].[membershipGroup] LIKE '%Basic%' OR [gms].[membershipGroup] LIKE '%Ruby%' OR [gms].[membershipGroup] LIKE '%HCFK%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 2
  --      WHEN ( [gms].[membershipGroup] LIKE '%Basic%' OR [gms].[membershipGroup] LIKE '%Ruby%' OR [gms].[membershipGroup] LIKE '%HCFK%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 2
  --      WHEN ( [gms].[membershipGroup] LIKE '%Basic%' OR [gms].[membershipGroup] LIKE '%Ruby%' OR [gms].[membershipGroup] LIKE '%HCFK%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 1
  --      WHEN ( [gms].[membershipGroup] LIKE '%Bronze%' OR [gms].[membershipGroup] LIKE '%Emerald%' OR [gms].[membershipGroup] LIKE '%Silver%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 2
  --      WHEN ( [gms].[membershipGroup] LIKE '%Bronze%' OR [gms].[membershipGroup] LIKE '%Emerald%' OR [gms].[membershipGroup] LIKE '%Silver%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 2
  --      WHEN ( [gms].[membershipGroup] LIKE '%Bronze%' OR [gms].[membershipGroup] LIKE '%Emerald%' OR [gms].[membershipGroup] LIKE '%Silver%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 2
  --      WHEN ( [gms].[membershipGroup] LIKE '%Gold%' OR [gms].[membershipGroup] LIKE '%Sapphire%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 3
  --      WHEN ( [gms].[membershipGroup] LIKE '%Gold%' OR [gms].[membershipGroup] LIKE '%Sapphire%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 3
  --      WHEN ( [gms].[membershipGroup] LIKE '%Gold%' OR [gms].[membershipGroup] LIKE '%Sapphire%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 3
  --      WHEN [gms].[membershipGroup] LIKE '%Diamond%' AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 4
  --      WHEN [gms].[membershipGroup] LIKE '%Diamond%' AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 4
  --      WHEN [gms].[membershipGroup] LIKE '%Diamond%' AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 3
  --      WHEN ( [gms].[membershipGroup] LIKE '%Platinum%' OR [gms].[membershipGroup] LIKE '%Executive%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 6
  --      WHEN ( [gms].[membershipGroup] LIKE '%Platinum%' OR [gms].[membershipGroup] LIKE '%Executive%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 6
  --      WHEN ( [gms].[membershipGroup] LIKE '%Platinum%' OR [gms].[membershipGroup] LIKE '%Executive%' ) AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 5
  --      WHEN [gms].[membershipGroup] LIKE '%Presidential%' AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 12
  --      WHEN [gms].[membershipGroup] LIKE '%Presidential%' AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 12
  --      WHEN [gms].[membershipGroup] LIKE '%Presidential%' AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 12
  --      WHEN [gms].[membershipGroup] LIKE '%Premier%' AND [tmpData].[QuantityAtCenterAndOrdered] = 0 THEN 18
  --      WHEN [gms].[membershipGroup] LIKE '%Premier%' AND [tmpData].[QuantityAtCenterAndOrdered] = 1 THEN 18
  --      WHEN [gms].[membershipGroup] LIKE '%Premier%' AND [tmpData].[QuantityAtCenterAndOrdered] = 2 THEN 18
  --      ELSE 0 -- if not any of this conditions the field should be 0
  --  END AS [SuggestedQuantityToOrder]

  --,0 AS [SuggestedQuantityToOrder]
  , 'Total Systems available on the membership divided by 12 months' AS [“Membership System Qty to Apply per month]
  , 'How long it current takes to receive a new order (currently 10 months)' AS [System Order Lead Time]
  , 'Maximum monthly quantity to order based on application interval and existing orders In Center and On Order' AS [Membership Maximum]
  , CASE WHEN [tmpData].[SuggestedQuantityToOrder] > [gms].[MaxVal] THEN [gms].[MaxVal] WHEN [tmpData].[SuggestedQuantityToOrder] > 0 THEN
                                                                                        [tmpData].[SuggestedQuantityToOrder] ELSE 0 END AS [SuggestedQuantityToOrder]
  , CEILING(( [tmpData].[QaNeeded] + [tmpData].[InCenter] + [tmpData].[OnOrder] ) / 12.0) AS [MonthsInCenterAndOnOrder]
  , [tmpData].[LastApplicationDate]
FROM( SELECT
          *
        , CEILING(( ISNULL([tmpData].[InitialQuantity], 0) / 12.0 * 8 ) - ( [tmpData].[QaNeeded] + [tmpData].[InCenter] + [tmpData].[OnOrder] )) AS [SuggestedQuantityToOrder]
      FROM [#tmpHairOrderQuantitybyClient] AS [tmpData] ) AS [tmpData]
INNER JOIN [#groupedMemberships] AS [gms] ON [tmpData].[MembershipID] = [gms].[membershipId] ;
GO

EXEC [dbo].[rptHairOrderQuantitybyClient_GVAROL] 201, '0' ;
GO
RETURN ;

SELECT
    QUOTENAME([s].[name]) + '.' + QUOTENAME([t].[name]) AS [FQN]
  , [s].[name] AS [SchemaName]
  , [t].[name] AS [TableName]
  , [c].[name] AS [ColumnName]
  , [y].[name] AS [DataType]
  , CAST(CASE WHEN [y].[name] = 'timestamp' THEN 'rowversion'
             WHEN [y].[name] IN ('char', 'varchar') THEN
                 CONCAT(
                     [y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')'
                   , CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('nchar', 'nvarchar') THEN
                 CONCAT(
                     [y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] / 2 AS VARCHAR)END, ')'
                   , CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('binary', 'varbinary') THEN
                 CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')')
             WHEN [y].[name] IN ('bigint', 'int', 'smallint', 'tinyint') THEN [y].[name]
             WHEN [y].[name] IN ('datetime2', 'time', 'datetimeoffset') THEN CONCAT([y].[name], '(', [c].[scale], ')')
             WHEN [y].[name] IN ('numeric', 'decimal') THEN CONCAT([y].[name], '(', [c].[precision], ', ', [c].[scale], ')')
             ELSE [y].[name]
         END AS VARCHAR(256)) AS [ColumnDef]
  , [c].[is_nullable]
FROM [sys].[tables] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id]
INNER JOIN [sys].[types] AS [y] ON [y].[user_type_id] = [c].[user_type_id]
LEFT JOIN [sys].[databases] AS [d] ON [d].[name] = DB_NAME() AND [t].[name] LIKE '%tran%history%' ;

--WHERE [c].[name] LIKE REPLACE('Last Application Date', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Scheduled Next App Date', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Order Avail for Next App', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Oldest Order Placed Date', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Oldest Order Placed Due Date', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Newest Order System Type', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Remaining Qty to Order', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Priority Hair Needed', ' ', '%')
--   OR [c].[name] LIKE REPLACE('Last%App%Date', ' ', '%')
--GO

-- Last Application Date
IF OBJECT_ID('[tempdb]..[#LastApplication]') IS NOT NULL
    DROP TABLE [#LastApplication] ;

SELECT
    MAX([c].[ClientGUID]) AS [ClientGUID]
  , [c].[ClientIdentifier]
  , MAX([sod].[CreateDate]) AS [CreateDate]
INTO [#LastApplication]
FROM [dbo].[datClient] AS [c]
INNER JOIN [dbo].[datSalesOrder] AS [so] ON [so].[ClientGUID] = [c].[ClientGUID]
INNER JOIN [dbo].[datSalesOrderDetail] AS [sod] ON [so].[SalesOrderGUID] = [sod].[SalesOrderGUID]
INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sod].[SalesCodeID] = [sc].[SalesCodeID]
WHERE [sc].[SalesCodeDepartmentID] IN (5010, 5020)
GROUP BY [c].[ClientIdentifier] ;
GO
IF OBJECT_ID('[tempdb]..[#ScheduledNextAppDate]') IS NOT NULL
    DROP TABLE [#ScheduledNextAppDate] ;

DECLARE @Date DATE = CONVERT(VARCHAR(30), GETDATE(), 112) ;

-- Scheduled Next App Date
SELECT
    [k].[ClientGUID]
  , [k].[ClientIdentifier]
  , [k].[AppointmentDate]
INTO [#ScheduledNextAppDate]
FROM( SELECT
          [c].[ClientGUID]
        , [c].[ClientIdentifier]
        , [a].[AppointmentDate]
        , ROW_NUMBER() OVER ( PARTITION BY [c].[ClientIdentifier] ORDER BY [a].[AppointmentDate] ASC ) AS [rw]
      FROM [dbo].[datClient] AS [c]
      INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientGUID] = [c].[ClientGUID]
      INNER JOIN [dbo].[cfgMembership] AS [m] ON [cm].[MembershipID] = [m].[MembershipID]
      INNER JOIN [dbo].[datAppointment] AS [a] ON [cm].[ClientMembershipGUID] = [a].[ClientMembershipGUID]
      INNER JOIN [dbo].[cfgCenter] AS [apptctr] ON [a].[CenterID] = [apptctr].[CenterID]
      WHERE( [a].[IsDeletedFlag] IS NULL OR [a].[IsDeletedFlag] = 0 )
        AND [a].[AppointmentDate] >= @Date
        AND EXISTS ( SELECT 1 FROM [#LastApplication] AS [l] WHERE [l].[ClientIdentifier] = [c].[ClientIdentifier] )) AS [k]
WHERE [k].[rw] = 1
OPTION( RECOMPILE ) ;

-- Order Avail for Next App
-- If Cent exists true

-- Oldest Order Placed Date
-- [MinOrderCreateDate]

-- Oldest Order Placed Due Date
-- [MinOrderCreateDateAdd8Months]
SELECT
    [clt].[ClientIdentifier]
  , MAX([clt].[ClientGUID]) AS [ClientGUID]
  , MAX(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'CENT' THEN 1 ELSE 0 END) AS [CENT]
  , MAX(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' THEN 1 ELSE 0 END) AS [ORDER]
  , MIN(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' THEN [clt].[CreateDate] ELSE 0 END) AS [MinOrderCreateDate]
  , MIN(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' THEN DATEADD(MONTH, 8, [clt].[CreateDate])ELSE 0 END) AS [MinOrderCreateDateAdd8Months]
FROM [dbo].[datClient] AS [clt]
INNER JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsos].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
                                                     AND [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'ORDER')
GROUP BY [clt].[ClientIdentifier] ;

-- Newest Order System Type
-- [HairSystemDescriptionShort]
SELECT
    [k].[HairSystemDescription]
  , [k].[HairSystemDescriptionShort]
  , [k].[ClientGUID]
  , [k].[ClientIdentifier]
  , [k].[CreateDate]
FROM( SELECT
          [hs].[HairSystemDescription]
        , [hs].[HairSystemDescriptionShort]
        , [clt].[ClientGUID]
        , [clt].[ClientIdentifier]
        , [hso].[CreateDate]
        , ROW_NUMBER() OVER ( PARTITION BY [clt].[ClientIdentifier] ORDER BY [hso].[CreateDate] DESC ) AS [rw]
      FROM [dbo].[datClient] AS [clt]
      INNER JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
      INNER JOIN [dbo].[cfgHairSystem] AS [hs] ON [hso].[HairSystemID] = [hs].[HairSystemID]
      INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsos].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
                                                           AND [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' ) AS [k]
WHERE [k].[rw] = 1 ;
