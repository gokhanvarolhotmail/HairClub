/* CreateDate: 02/11/2022 15:30:57.193 , ModifyDate: 03/17/2022 11:40:03.247 */
GO
/*
===============================================================================================
 Procedure Name:            rptHairOrderQuantitybyClient_V2
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

    This report pulls memberships that began 18 months ago: cm.BeginDate >= DATEADD(MONTH,-18,GETUTCDATE())
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
02/11/2022 - GV - https://hairclub.zendesk.com/agent/tickets/7944 ( GVarol Worked with APtak to change this report )
===============================================================================================
Sample Execution:
EXEC [rptHairOrderQuantitybyClient] 100, '0'
EXEC [rptHairOrderQuantitybyClient] 241, '26,27,28,29,30,31,45,46,47,48'
===============================================================================================
*/
CREATE PROCEDURE [dbo].[rptHairOrderQuantitybyClient_V2]
    @CenterID            INT
  , @MembershipList      NVARCHAR(MAX) = NULL
  , @NoHairInCenter      NVARCHAR(30)  = '<ALL>'
  , @NoHairOnOrder       NVARCHAR(30)  = '<ALL>'
  , @PriorityOrderNeeded NVARCHAR(30)  = '<ALL>'
AS
SET NOCOUNT ON ;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

DECLARE
    @GetDate    DATE     = CONVERT(VARCHAR(30), GETDATE(), 112)
  , @Tomorrow   DATE     = CONVERT(VARCHAR(30), DATEADD(DAY, 1, GETDATE()), 112)
  , @BeginDate  DATETIME = DATEADD(MONTH, -18, GETUTCDATE())
  , @GetUTCDate DATETIME = GETUTCDATE() ;

--Split the string parameter that is entered for MembershipID's
CREATE TABLE [#membership] ( [MembershipID] INT ) ;

INSERT INTO [#membership]
SELECT CAST(NULLIF([value], '') AS INT)
FROM STRING_SPLIT(@MembershipList, ',')
WHERE @MembershipList NOT IN ('0', '')
OPTION( RECOMPILE ) ;

DECLARE @MembershipCount INT = @@ROWCOUNT ;

IF EXISTS ( SELECT 1 FROM [#membership] WHERE [MembershipID] = 0 )
    SET @MembershipCount = 0 ;

DECLARE
    @CorpCenterTypeID         INT
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

DROP TABLE IF EXISTS [#CenterId] ;

CREATE TABLE [#CenterId] ( [CenterId] INT NOT NULL PRIMARY KEY CLUSTERED ) ;

IF( @CenterID = 1 )
    BEGIN
        INSERT [#CenterId]( [CenterId] )
        SELECT [CenterID]
        FROM [dbo].[cfgCenter]
        WHERE [CenterTypeID] = @CorpCenterTypeID AND [IsCorporateHeadquartersFlag] = 0 ;
    END ;

-- Add Franchise CenterIDs to List
ELSE IF( @CenterID = 2 )
    BEGIN
        INSERT [#CenterId]( [CenterId] )
        SELECT [CenterID]
        FROM [dbo].[cfgCenter]
        WHERE [CenterTypeID] = @FranchiseCenterTypeID ;
    END ;

-- Add JointVenture CenterIDs to List
ELSE IF( @CenterID = 3 )
    BEGIN
        INSERT [#CenterId]( [CenterId] )
        SELECT [CenterID]
        FROM [dbo].[cfgCenter]
        WHERE [CenterTypeID] = @JointVentureCenterTypeID ;
    END ;
ELSE
    INSERT [#CenterId]( [CenterId] )
    SELECT @CenterID AS [CenterId] ;

IF OBJECT_ID('[tempdb]..[#hair]') IS NOT NULL
    DROP TABLE [#hair] ;

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
  , [InCenter]                             INT
  , [OnOrder]                              INT
  , [QaNeeded]                             INT
  , [Status]                               NVARCHAR(10)
  , [DueDate]                              DATETIME
  , [HairSystemOrderDate]                  DATETIME
  , [HairSystemOrderGUID]                  UNIQUEIDENTIFIER
  , [MembershipStartDate]                  DATE
  , [Region]                               NVARCHAR(100)
  , [MembershipExpiration]                 DATE
  , [FrozenEFTEndDate]                     DATE
  , [EstNextApp]                           DATE
  , [LastApplicationDate]                  DATE
) ;

-- Last Application Date
IF OBJECT_ID('[tempdb]..[#LastApplication]') IS NOT NULL
    DROP TABLE [#LastApplication] ;

SELECT
    [c].[ClientGUID]
  , MAX([sod].[LocalDate]) AS [LastApplicationDate]
INTO [#LastApplication]
FROM [dbo].[datClient] AS [c]
INNER JOIN [dbo].[datSalesOrder] AS [so] ON [so].[ClientGUID] = [c].[ClientGUID]
INNER JOIN( SELECT *, ( SELECT [OutVal] FROM [dbo].[GetLocalDateFromUTC]([CreateDate]) ) AS [LocalDate] FROM [dbo].[datSalesOrderDetail] ) AS [sod] ON [so].[SalesOrderGUID] = [sod].[SalesOrderGUID]
INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sod].[SalesCodeID] = [sc].[SalesCodeID]
WHERE [sc].[SalesCodeDepartmentID] IN (5010, 5020)
GROUP BY [c].[ClientGUID] ;

IF OBJECT_ID('[tempdb]..[#ScheduledNextAppDate]') IS NOT NULL
    DROP TABLE [#ScheduledNextAppDate] ;

-- Scheduled Next App Date
SELECT
    [k].[ClientGUID]
  , [k].[AppointmentDate]
INTO [#ScheduledNextAppDate]
FROM( SELECT
          [c].[ClientGUID]
        , [a].[AppointmentDate]
        , ROW_NUMBER() OVER ( PARTITION BY [c].[ClientGUID] ORDER BY [a].[AppointmentDate] ASC ) AS [rw]
      FROM [dbo].[datClient] AS [c]
      INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientGUID] = [c].[ClientGUID]
      INNER JOIN [dbo].[cfgMembership] AS [m] ON [cm].[MembershipID] = [m].[MembershipID]
      INNER JOIN [dbo].[datAppointment] AS [a] ON [cm].[ClientMembershipGUID] = [a].[ClientMembershipGUID]
      INNER JOIN [dbo].[datAppointmentDetail] AS [ad] ON [ad].[AppointmentGUID] = [a].[AppointmentGUID]
      INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [ad].[SalesCodeID]
      INNER JOIN [dbo].[cfgCenter] AS [apptctr] ON [a].[CenterID] = [apptctr].[CenterID]
      WHERE( [a].[IsDeletedFlag] IS NULL OR [a].[IsDeletedFlag] = 0 ) AND [a].[AppointmentDate] >= @GetDate AND [sc].[SalesCodeDepartmentID] IN (5010, 5020) AND EXISTS ( SELECT 1 FROM [#LastApplication] AS [l] WHERE [l].[ClientGUID] = [c].[ClientGUID] )) AS [k]
WHERE [k].[rw] = 1
OPTION( RECOMPILE ) ;

/*
IF OBJECT_ID('[tempdb]..[#LastAppointmentDate]') IS NOT NULL
    DROP TABLE [#LastAppointmentDate] ;

SELECT
    [k].[ClientGUID]
  , [k].[AppointmentDate]
INTO [#LastAppointmentDate]
FROM( SELECT
          [c].[ClientGUID]
        , [a].[AppointmentDate]
        , ROW_NUMBER() OVER ( PARTITION BY [c].[ClientGUID] ORDER BY [a].[AppointmentDate] DESC ) AS [rw]
      FROM [dbo].[datClient] AS [c]
      INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientGUID] = [c].[ClientGUID]
      INNER JOIN [dbo].[cfgMembership] AS [m] ON [cm].[MembershipID] = [m].[MembershipID]
      INNER JOIN [dbo].[datAppointment] AS [a] ON [cm].[ClientMembershipGUID] = [a].[ClientMembershipGUID]
      INNER JOIN [dbo].[datAppointmentDetail] AS [ad] ON [ad].[AppointmentGUID] = [a].[AppointmentGUID]
      INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [ad].[SalesCodeID]
      INNER JOIN [dbo].[cfgCenter] AS [apptctr] ON [a].[CenterID] = [apptctr].[CenterID]
      WHERE( [a].[IsDeletedFlag] IS NULL OR [a].[IsDeletedFlag] = 0 ) AND [a].[AppointmentDate] < @GetDate AND [sc].[SalesCodeDepartmentID] IN (5010, 5020)) AS [k]
WHERE [k].[rw] = 1
OPTION( RECOMPILE ) ;
*/
INSERT INTO [#hair]( [HairSystemOrderNumber]
                   , [CenterID]
                   , [CenterDescriptionFullCalc]
                   , [ClientFullNameCalc]
                   , [ClientGUID]
                   , [CurrentBioMatrixClientMembershipGUID]
                   , [MembershipID]
                   , [MembershipDescription]
                   , [InCenter]
                   , [OnOrder]
                   , [QaNeeded]
                   , [Status]
                   , [DueDate]
                   , [HairSystemOrderDate]
                   , [HairSystemOrderGUID]
                   , [MembershipStartDate]
                   , [Region]
                   , [MembershipExpiration]
                   , [FrozenEFTEndDate]
                   , [EstNextApp]
                   , [LastApplicationDate] )
SELECT
    [hso].[HairSystemOrderNumber]
  , [clt].[CenterID]
  , [c].[CenterDescriptionFullCalc]
  , [clt].[ClientFullNameCalc]
  , [clt].[ClientGUID]
  , [clt].[CurrentBioMatrixClientMembershipGUID]
  , [m].[MembershipID]
  , [m].[MembershipDescription]
  , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT') THEN 1 ELSE 0 END AS [InCenter]
  , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship', 'FAC-Ship') THEN 1 ELSE 0 END AS [OnOrder]
  , CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] IN ('QANEEDED') THEN 1 ELSE 0 END AS [QaNeeded]
  , [hsos].[HairSystemOrderStatusDescriptionShort] AS [Status]
  , [hso].[DueDate]
  , [hso].[HairSystemOrderDate]
  , [hso].[HairSystemOrderGUID]
  , [cm].[BeginDate] AS [MembershipStartDate]
  , [r].[RegionDescription]
  , [cm].[EndDate]
  , [eft].[FrozenEFTEndDate]
  , [nad].[EstNextApp]
  , [sna].[LastApplicationDate]
FROM [dbo].[datClient] AS [clt]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [clt].[CurrentBioMatrixClientMembershipGUID]
INNER JOIN [dbo].[cfgCenter] AS [c] ON [c].[CenterID] = [clt].[CenterID]
LEFT JOIN [#LastApplication] AS [sna] ON [sna].[ClientGUID] = [clt].[ClientGUID]
LEFT JOIN( SELECT [ClientMembershipGUID], MAX([Freeze_End]) AS [FrozenEFTEndDate] FROM [dbo].[datClientEFT] GROUP BY [ClientMembershipGUID] ) AS [eft] ON [eft].[ClientMembershipGUID] = [cm].[ClientMembershipGUID]
INNER JOIN [dbo].[cfgMembership] AS [m] ON [m].[MembershipID] = [cm].[MembershipID]
OUTER APPLY( SELECT [k].[NextAppointmentDate] AS [EstNextApp]
             FROM( SELECT
                       DATEADD(DAY, ( [b].[digit] ) * [k].[Application Cadence Days], [sna].[LastApplicationDate]) AS [NextAppointmentDate]
                     , ROW_NUMBER() OVER ( PARTITION BY [m].[MembershipID], [k].[MembershipAccumulatorID] ORDER BY [b].[digit] ASC ) AS [rw]
                     , [k].*
                   FROM( SELECT TOP( 1 )
                                [m].[DurationMonths] * 30 / [ca].[InitialQuantity] AS [Application Cadence Days]
                              , [ca].[InitialQuantity]
                              , [ca].[MembershipAccumulatorID]
                         FROM [dbo].[cfgMembershipAccum] AS [ca]
                         WHERE [ca].[MembershipID] = [m].[MembershipID] AND [ca].[AccumulatorID] = 8 AND [m].[BusinessSegmentID] = 1 ) AS [k]
                   CROSS APPLY [dbo].GetNumbers(1, [k].[InitialQuantity]) AS [b]
             /* WHERE DATEADD(DAY, ( [b].[digit] ) * [k].[Application Cadence Days], [sna].[AppointmentDate]) > @GetDate */ ) AS [k]
             WHERE [k].[rw] = 1 ) AS [nad]
LEFT JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
LEFT JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsos].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID] AND [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'NEW', 'ORDER', 'HQ-Recv', 'HQ-Ship', 'FAC-Ship', 'QANEEDED')
LEFT JOIN [dbo].[lkpRegion] AS [r] ON [r].[RegionID] = [c].[RegionID]
LEFT JOIN [dbo].[cfgHairSystem] AS [hs] ON [hs].[HairSystemID] = [hso].[HairSystemID]
WHERE EXISTS ( SELECT 1 FROM [#CenterId] AS [c] WHERE [c].[CenterId] = [clt].[CenterID] )
  AND [m].[MembershipDescription] NOT IN ('CANCEL', 'Employee - Retail')
  AND [cm].[ClientMembershipStatusID] = 1
  AND [m].[BusinessSegmentID] = 1 --BIO
  AND [m].[MembershipID] NOT IN (1, 2, 11, 12, 14, 15, 16, 17, 18, 19, 49, 50, 57) --ALL except these
  AND ( @MembershipCount = 0 OR EXISTS ( SELECT 1 FROM [#membership] AS [m2] WHERE [m2].[MembershipID] = [cm].[MembershipID] ))
  AND ISNULL([cm].[EndDate], @Tomorrow) >= @GetDate
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
  AND [cm].[BeginDate] >= @BeginDate
OPTION( RECOMPILE ) ;

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
      INNER JOIN( SELECT
                      [ClientGUID]
                    , [NewHairSystemOrderStatusID]
                    , ( SELECT [OutVal] FROM [dbo].[GetLocalDateFromUTC]([HairSystemOrderTransactionDate]) ) AS [HairSystemOrderTransactionDate]
                  FROM [dbo].[datHairSystemOrderTransaction] ) AS [hsot] ON [hair].[ClientGUID] = [hsot].[ClientGUID]
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
      WHERE [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' AND [hair].[DueDate] >= @GetUTCDate ) AS [due]
WHERE [due].[NextDueDate] = 1
OPTION( RECOMPILE ) ;

--Find initial quantity for the membership
SELECT
    [M].[MembershipDescription]
  , [ACCUM].[MembershipID]
  , CASE WHEN [M].[MembershipDescription] LIKE '%Executive%' THEN 17 WHEN [M].[MembershipDescription] LIKE '%Presidential%' THEN 26 WHEN [M].[MembershipDescription] LIKE '%Premier%' THEN 52 ELSE MIN([ACCUM].[InitialQuantity])END AS [InitialQuantity]
INTO [#initialquantity]
FROM [dbo].[cfgMembershipAccum] AS [ACCUM]
INNER JOIN [dbo].[cfgMembership] AS [M] ON [ACCUM].[MembershipID] = [M].[MembershipID]
WHERE [M].[BusinessSegmentID] = 1 --BIO
  AND [ACCUM].[MembershipID] NOT IN (1, 2, 11, 12, 14, 15, 16, 17, 18, 19, 49, 50, 57) AND [ACCUM].[IsActiveFlag] = 1 AND [ACCUM].[InitialQuantity] <> 0
GROUP BY [M].[MembershipDescription]
       , [ACCUM].[MembershipID]
ORDER BY [M].[MembershipDescription] ;

CREATE TABLE [#groupedMemberships] ( [membershipId] INT, [membershipDescriptionShort] NVARCHAR(128), [membershipDescription] NVARCHAR(128), [MaxVal] INT ) ;

--- Insert membership values
INSERT INTO [#groupedMemberships]( [membershipId], [membershipDescriptionShort], [membershipDescription], [MaxVal] )
SELECT
    CAST([t].[membershipId] AS INT) AS [membershipId]
  , CAST([t].[membershipDescriptionShort] AS NVARCHAR(MAX)) AS [membershipDescriptionShort]
  , CAST([t].[membershipDescription] AS NVARCHAR(MAX)) AS [membershipDescription]
  , CAST([t].[MaxVal] AS INT) AS [MaxVal]
FROM( VALUES( 22, N'BASIC', N'Basic', 1 )
          , ( 30, N'DIA', N'Diamond', 2 )
          , ( 31, N'DIASOL', N'Diamond Solutions', 2 )
          , ( 24, N'BRZ', N'Bronze', 1 )
          , ( 12, N'HCFK', N'Hair Club For Kids', 1 )
          , ( 65, N'EMRLD', N'Emerald', 1 )
          , ( 290, N'EMPLOYRET', N'Employee-Retail', 1 )
          , ( 34, N'EXE', N'Executive', 3 )
          , ( 28, N'GLD', N'Gold', 2 )
          , ( 29, N'GLDSOL', N'Gold Solutions', 2 )
          , ( 32, N'PLA', N'Platinum', 3 )
          , ( 33, N'PLASOL', N'Platinum Solutions', 3 )
          , ( 36, N'PRS', N'Presidential', 4 )
          , ( 63, N'RUBY', N'Ruby', 1 )
          , ( 95, N'RUBY', N'Ruby Plus Transitional', 1 )
          , ( 67, N'SAPPHIRE', N'Sapphire', 2 )
          , ( 26, N'SIL', N'Silver', 1 )
          , ( 10, N'TRADITION', N'Xtrands+ Initial', 1 )
          , ( 5, N'GRADSOL12', N'Xtrands+ Initial 12 Solutions', 1 )
          , ( 3, N'GRAD', N'Xtrands+ Initial 6', 1 )
          , ( 47, N'GRDSV', N'Xtrands+ Initial 6', 1 )
          , ( 285, N'GRDSV', N'Xtrands+ Initial 6 EZPAY', 1 )
          , ( 4, N'GRDSV', N'Xtrands+ Initial 6 Solutions', 1 )
          , ( 48, N'GRDSVSOL', N'Xtrands+ Initial 6 Solutions', 1 )
          , ( 18, N'ACQUIRED', N'ACQUIRED', 2 )
          , ( 77, N'ACQSOL', N'ACQUIRED Solutions', 2 )) AS [t]( [membershipId], [membershipDescriptionShort], [membershipDescription], [MaxVal] ) ;

-- Order Avail for Next App
-- If Cent exists true

-- Priority Hair Needed
-- If Cent exists false

-- Oldest Order Placed Date
-- [OldestOrderPlacedDate]

-- Oldest Order Placed Due Date
-- [OldestOrderPlacedDueDate]
IF OBJECT_ID('[tempdb]..[#Calc01]') IS NOT NULL
    DROP TABLE [#Calc01] ;

SELECT
    [clt].[ClientGUID]
  , MAX(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'CENT' THEN 1 ELSE 0 END) AS [CENT]
  , MAX(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' THEN 1 ELSE 0 END) AS [ORDER]
  , MIN(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' THEN NULLIF([hso].[CreateDate], '19000101')END) AS [OldestOrderPlacedDate]
  , MIN(CASE WHEN [hsos].[HairSystemOrderStatusDescriptionShort] = 'ORDER' THEN DATEADD(MONTH, 8, NULLIF([hso].[CreateDate], '19000101'))END) AS [OldestOrderPlacedDueDate]
INTO [#Calc01]
FROM [dbo].[datClient] AS [clt]
INNER JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [hsos] ON [hsos].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID] AND [hsos].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'ORDER')
WHERE EXISTS ( SELECT 1 FROM [#hair] AS [l] WHERE [l].[ClientGUID] = [clt].[ClientGUID] )
GROUP BY [clt].[ClientGUID] ;

-- Newest Order System Type
-- [NewestOrderSystemType]
IF OBJECT_ID('[tempdb]..[#Calc02]') IS NOT NULL
    DROP TABLE [#Calc02] ;

SELECT
    [k].[HairSystemDescription]
  , [k].[NewestOrderSystemType]
  , [k].[ClientGUID]
  , [k].[NewestOrderDate]
INTO [#Calc02]
FROM( SELECT
          [hs].[HairSystemDescription]
        , [hs].[HairSystemDescriptionShort] AS [NewestOrderSystemType]
        , [clt].[ClientGUID]
        , [hso].[CreateDate] AS [NewestOrderDate]
        , ROW_NUMBER() OVER ( PARTITION BY [clt].[ClientGUID] ORDER BY [hso].[CreateDate] DESC ) AS [rw]
      FROM [dbo].[datClient] AS [clt]
      INNER JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[ClientGUID] = [clt].[ClientGUID]
      INNER JOIN [dbo].[cfgHairSystem] AS [hs] ON [hso].[HairSystemID] = [hs].[HairSystemID]
      WHERE EXISTS ( SELECT 1 FROM [#hair] AS [l] WHERE [l].[ClientGUID] = [clt].[ClientGUID] )) AS [k]
WHERE [k].[rw] = 1 ;

-- Remaining Qty to Order
IF OBJECT_ID('[tempdb]..[#Calc03]') IS NOT NULL
    DROP TABLE [#Calc03] ;

SELECT
    [clt].[ClientGUID]
  , [b].[Cnt]
INTO [#Calc03]
FROM [dbo].[datClient] AS [clt]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [clt].[CurrentBioMatrixClientMembershipGUID]
OUTER APPLY( SELECT COUNT(1) AS [Cnt] FROM [dbo].[datHairSystemOrder] AS [hso] WHERE [hso].[ClientGUID] = [clt].[ClientGUID] AND [hso].[CreateDate] >= [cm].[BeginDate] ) AS [b]
WHERE EXISTS ( SELECT 1 FROM [#hair] AS [l] WHERE [l].[ClientGUID] = [clt].[ClientGUID] ) ;

SELECT
    [q].[ClientFullNameCalc] AS [Client]
  , [q].[MembershipDescription] AS [CurrentMembership]
  , [q].[MembershipID]
  , [q].[CenterDescriptionFullCalc] AS [Center]
  --, [lad].[LastApplicationDate]
  , [q].[LastApplicationDate]
  , [q].[InCenter]
  , [q].[OnOrder]
  , [ndd].[DueDate]
  , [q].[TotalAccumQuantity]
  , [q].[Promo]
  , [q].[InitialQuantity]
  --,    Remaining = (InitialQuantity - OnOrder + Promo)
  , [q].[AccumQuantityRemainingCalc] AS [Remaining]
  , CASE WHEN [q].[Promo] < 0 THEN 0 ELSE [q].[Promo] END AS [Overage]
  , ( [q].[QaNeeded] + [q].[InCenter] + [q].[OnOrder] ) AS [QuantityAtCenterAndOrdered]
  , [q].[QaNeeded] AS [QaNeeded]
  , [q].[MembershipStartDate]
  , [sad].[AppointmentDate] AS [ScheduledNextAppDate]
  , ISNULL([c1].[CENT], 0) AS [OrderAvailableForNextAppointment]
  --  , ISNULL(1 - [c1].[CENT], 0) AS [PriorityHairNeeded]
  , [c1].[OldestOrderPlacedDate]
  , [c1].[OldestOrderPlacedDueDate]
  , [c2].[NewestOrderSystemType]
  , [c3].[Cnt] AS [RemainingQuantityToOrder]
  , [q].[Region]
  , [c2].[NewestOrderDate]
  , [q].[MembershipExpiration]
  , [q].[FrozenEFTEndDate]
  , [q].[EstNextApp]
--, [q].[OrderAvailForNextApp]
INTO [#tmpHairOrderQuantitybyClient]
FROM( SELECT
          [hair].[ClientGUID]
        , [hair].[ClientFullNameCalc]
        , [hair].[MembershipDescription]
        , [hair].[CenterID]
        , [hair].[MembershipID]
        , SUM([hair].[InCenter]) AS [InCenter]
        , SUM([hair].[OnOrder]) AS [OnOrder]
        , [ahs].[TotalAccumQuantity]
        , [ahs].[AccumQuantityRemainingCalc]
        , ISNULL([pro].[Promo], 0) AS [Promo]
        , [iq].[InitialQuantity]
        , [hair].[CenterDescriptionFullCalc]
        , SUM([hair].[QaNeeded]) AS [QaNeeded]
        , MAX([hair].[MembershipStartDate]) AS [MembershipStartDate]
        , MAX([hair].[Region]) AS [Region]
        , MAX([hair].[MembershipExpiration]) AS [MembershipExpiration]
        , MAX([hair].[FrozenEFTEndDate]) AS [FrozenEFTEndDate]
        , MAX([hair].[EstNextApp]) AS [EstNextApp]
        , MAX([hair].[LastApplicationDate]) AS [LastApplicationDate]
      --, MAX(CASE WHEN [hair].[HairSystemOrderDate] = [hair].[NextAppointmentDate] AND [hair].[InCenter] = 1 THEN 1 ELSE 0 END) AS [OrderAvailForNextApp]
      FROM [#hair] AS [hair]
      LEFT JOIN [dbo].[datClientMembershipAccum] AS [ahs] ON [hair].[CurrentBioMatrixClientMembershipGUID] = [ahs].[ClientMembershipGUID] AND [ahs].[AccumulatorID] = 8 --Hair Systems
      LEFT JOIN [#initialquantity] AS [iq] ON [hair].[MembershipID] = [iq].[MembershipID]
      LEFT JOIN [#promo] AS [pro] ON [hair].[CurrentBioMatrixClientMembershipGUID] = [pro].[ClientMembershipGUID]
      LEFT JOIN [dbo].[cfgCenter] AS [cent] ON [cent].[CenterID] = [hair].[CenterID]
      GROUP BY [hair].[ClientGUID]
             , [hair].[CenterDescriptionFullCalc]
             , [hair].[ClientFullNameCalc]
             , [hair].[MembershipDescription]
             , [hair].[CenterID]
             , [ahs].[TotalAccumQuantity]
             , [ahs].[AccumQuantityRemainingCalc]
             , [pro].[Promo]
             , [iq].[InitialQuantity]
             , [hair].[MembershipID] ) AS [q]
--LEFT JOIN [#LastApplication] AS [lad] ON [q].[ClientGUID] = [lad].[ClientGUID]
LEFT JOIN [#ScheduledNextAppDate] AS [sad] ON [q].[ClientGUID] = [sad].[ClientGUID]
LEFT JOIN [#Calc01] AS [c1] ON [c1].[ClientGUID] = [q].[ClientGUID]
LEFT JOIN [#Calc02] AS [c2] ON [c2].[ClientGUID] = [q].[ClientGUID]
LEFT JOIN [#Calc03] AS [c3] ON [c3].[ClientGUID] = [q].[ClientGUID]
LEFT JOIN [#NextDueDate] AS [ndd] ON [ndd].[ClientGUID] = [q].[ClientGUID] ;

SELECT
    [k].[Region]
  , [k].[Center]
  , [k].[Client]
  , [k].[Current Membership]
  , [k].[Membership Expiration]
  , [k].[Membership Qty]
  , CASE WHEN [k].[Frozen EFT End Date] > @GetDate THEN [k].[Frozen EFT End Date] END AS [Frozen EFT End Date]
  , [k].[QA Needed]
  , [k].[In Center]
  , [k].[On Order]
  , [k].[In Center + On Order]
  , [k].[Months In Center And On Order]
  , [k].[Last App Date]
  , [k].[Est Next App Date]
  , [k].[Scheduled Next App Date]
  , [k].[Oldest Order Placed Date]
  , [k].[Oldest Order Placed Due Date]
  , [k].[Newest Order Date]
  , [k].[Newest Order System Type]
  , [k].[Remaining to Order]
  , [k].[Order Avail for Next App]
  , [k].[Priority Order Needed]
  , [k].[Suggested Qty to Order]
FROM( SELECT
          [t].[Region]
        , [t].[Center]
        , [t].[Client]
        , [t].[CurrentMembership] AS [Current Membership]
        , [t].[MembershipExpiration] AS [Membership Expiration]
        , ISNULL([t].[InitialQuantity], 0) AS [Membership Qty]
        , [t].[FrozenEFTEndDate] AS [Frozen EFT End Date]
        , ISNULL([t].[QaNeeded], 0) AS [QA Needed]
        , ISNULL([t].[InCenter], 0) AS [In Center]
        , ISNULL([t].[OnOrder], 0) AS [On Order]
        , [t].[In Center + On Order]
        , CAST(FLOOR(12.0 / [t].[InitialQuantity] * [t].[In Center + On Order]) AS INT) AS [Months In Center And On Order]
        , CAST([t].[LastApplicationDate] AS DATE) AS [Last App Date]
        , [t].[EstNextApp] AS [Est Next App Date]
        , [t].[ScheduledNextAppDate] AS [Scheduled Next App Date]
        , CAST([t].[OldestOrderPlacedDate] AS DATE) AS [Oldest Order Placed Date]
        , CAST([t].[OldestOrderPlacedDueDate] AS DATE) AS [Oldest Order Placed Due Date]
        , CAST([t].[NewestOrderDate] AS DATE) AS [Newest Order Date]
        , [t].[NewestOrderSystemType] AS [Newest Order System Type]
        , ISNULL([t].[RemainingQuantityToOrder], 0) AS [Remaining to Order]
        , CASE WHEN [t].[OrderAvailableForNextAppointment] = 1 THEN 'Yes' ELSE 'No' END AS [Order Avail for Next App]
        , CASE WHEN [t].[Calc01] > [t].[Calc02] THEN CONCAT('Yes; ', [t].[Calc01] - [t].[Calc02])ELSE 'No' END AS [Priority Order Needed]
        --, CASE WHEN [t].[PriorityHairNeeded] = 1 THEN 'Yes' ELSE 'No' END AS [Priority Order Needed]
        , CAST(CASE WHEN [t].[SuggestedQuantityToOrder] > [gms].[MaxVal] THEN [gms].[MaxVal] WHEN [t].[SuggestedQuantityToOrder] > 0 THEN [t].[SuggestedQuantityToOrder] ELSE 0 END AS INT) AS [Suggested Qty to Order]

      --, CAST([t].[DueDate] AS DATE) AS [Due Date]
      --, [t].[TotalAccumQuantity] AS [Total Accum Qty]
      --, [t].[Promo]
      --, [t].[Remaining]
      --, [t].[Overage]
      --, [t].[QuantityAtCenterAndOrdered] AS [Qty At Center And Ordered]
      --, [gms].[membershipGroup] AS [Membership Group]

      --, CAST([t].[InitialQuantity] / 12.0 AS NUMERIC(12, 4)) AS [Membership System Qty To Apply Per Month]
      --, 8 AS [System Order Lead Time]
      --, [gms].[MaxVal] AS [Membership Maximum]
      FROM( SELECT
                *
              , ISNULL([t].[InCenter], 0) + ISNULL([t].[OnOrder], 0) AS [In Center + On Order]
              , ISNULL([t].[QaNeeded], 0) + ISNULL([t].[InCenter], 0) + ISNULL([t].[OnOrder], 0) AS [Calc02]
              , [t].[Calc01] - ( ISNULL([t].[QaNeeded], 0) + ISNULL([t].[InCenter], 0) + ISNULL([t].[OnOrder], 0)) AS [SuggestedQuantityToOrder]
            FROM( SELECT *, CEILING(( ISNULL([t].[InitialQuantity], 0) / 12.0 * 8 )) AS [Calc01] FROM [#tmpHairOrderQuantitybyClient] AS [t] ) AS [t] ) AS [t]
      INNER JOIN [#groupedMemberships] AS [gms] ON [t].[MembershipID] = [gms].[membershipId]
      WHERE( ISNULL(@PriorityOrderNeeded, '') <> '<ALL>' AND [t].[Calc01] > [t].[Calc02] OR ISNULL(@PriorityOrderNeeded, '<ALL>') = '<ALL>' )
        AND ( ISNULL(@NoHairOnOrder, '') <> '<ALL>' AND ISNULL([t].[OnOrder], 0) <= 0 OR ISNULL(@NoHairOnOrder, '<ALL>') = '<ALL>' )
        AND ( ISNULL(@NoHairInCenter, '') <> '<ALL>' AND ISNULL([t].[InCenter], 0) <= 0 OR ISNULL(@NoHairInCenter, '<ALL>') = '<ALL>' )) AS [k]
ORDER BY [k].[Region]
       , [k].[Center]
       , [k].[Suggested Qty to Order] DESC
       , [k].[Client]
OPTION( RECOMPILE ) ;
GO
