/* CreateDate: 04/23/2014 15:18:41.580 , ModifyDate: 09/28/2021 16:35:03.340 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptHairOrderQuantitybyClient
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              04/21/2014
 Destination Server:        SQL01.HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
NOTES:
    --Memberships included in the report: (These are selected and passed into the report as a parameter.)
    SELECT MembershipID
    ,    MembershipDescription
    FROM dbo.cfgMembership
    WHERE BusinessSegmentID = 1 --BIO
    AND MembershipID NOT IN(1,2,11,12,14,15,16,17,18,19,49,50,57)

    This report pulls memeberships that began 18 months ago: cm.BeginDate >= DATEADD(MONTH,-18,GETUTCDATE())
================================================================================================
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
================================================================================================
Sample Execution:
EXEC [rptHairOrderQuantitybyClient] 100, '0'
EXEC [rptHairOrderQuantitybyClient] 241, '26,27,28,29,30,31,45,46,47,48'
================================================================================================
*/
CREATE PROCEDURE [dbo].[rptHairOrderQuantitybyClient]
(
    @CenterID INT,
    @MembershipList NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    --Split the string parameter that is entered for MembershipID's
    CREATE TABLE #membership(MembershipID  int)
    INSERT INTO #membership
    SELECT CAST(item AS int) FROM [dbo].[fnSplit](@MembershipList,',')
    declare @CenterIDs nvarchar(MAX)

    DECLARE @CorpCenterTypeID int
    DECLARE @FranchiseCenterTypeID int
    DECLARE @JointVentureCenterTypeID int

    SELECT @CorpCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'C'
    SELECT @FranchiseCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'F'
    SELECT @JointVentureCenterTypeID = CenterTypeID FROM lkpCenterType where CenterTypeDescriptionShort = 'JV'
    set @centerIds=@centerId
    IF  (@centerId = 1)
        BEGIN
            Select @CenterIDs = COALESCE(@CenterIDs  + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
    END
    -- Add Franchise CenterIDs to List
    IF (@centerid=2)
        BEGIN
            Select @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @FranchiseCenterTypeID
        END

    -- Add JointVenture CenterIDs to List
    IF ( @centerId = 3)
        BEGIN


            Select @CenterIDs = COALESCE(@CenterIDs + ',' + CONVERT(nvarchar,CenterID),'') FROM cfgCenter WHERE CenterTypeID = @JointVentureCenterTypeID
        END
    --SELECT * FROM #membership
        CREATE TABLE #hair(    HairSystemOrderNumber NVARCHAR(50)
    ,    CenterID INT
    ,    CenterDescriptionFullCalc NVARCHAR(103)
    ,    ClientFullNameCalc NVARCHAR(127)
    ,    ClientGUID UNIQUEIDENTIFIER
    ,    CurrentBioMatrixClientMembershipGUID UNIQUEIDENTIFIER
    ,    MembershipID INT
    ,    MembershipDescription NVARCHAR(50)
    ,    EndDate DATETIME
    ,    LastApplicationDate DATETIME
    ,    InCenter INT
    ,    OnOrder INT
    ,   QANEEDED INT
    ,    [Status]  NVARCHAR(10)
    ,    DueDate  DATETIME
    ,    HairSystemOrderDate  DATETIME
    ,    HairSystemOrderGUID UNIQUEIDENTIFIER
    )
    IF @MembershipList = '0' --ALL
    BEGIN
        INSERT INTO #hair
        SELECT hso.HairSystemOrderNumber
        ,    clt.CenterID
        ,    c.CenterDescriptionFullCalc
        ,    clt.ClientFullNameCalc AS 'ClientFullNameCalc'
        ,    clt.ClientGUID
        ,    clt.CurrentBioMatrixClientMembershipGUID
        ,    m.MembershipID
        ,    m.MembershipDescription AS 'MembershipDescription'
        ,    cm.EndDate
        ,    NULL AS 'LastApplicationDate'
        ,    CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('CENT') THEN 1 ELSE 0 END AS 'InCenter'
        ,    CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('NEW','ORDER','HQ-Recv','HQ-Ship','FAC-Ship') THEN 1 ELSE 0 END AS 'OnOrder'
        ,   CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('QANEEDED') THEN 1 ELSE 0 END AS 'QANEEDED'
        ,    hsos.HairSystemOrderStatusDescriptionShort AS 'Status'
        ,    hso.DueDate AS 'DueDate'
        ,    hso.HairSystemOrderDate
        ,    hso.HairSystemOrderGUID
        FROM datClient clt
            INNER JOIN dbo.datClientMembership cm ON cm.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
            INNER JOIN dbo.cfgMembership m ON m.MembershipID = cm.MembershipID
            LEFT JOIN datHairSystemOrder hso ON hso.ClientGUID = clt.ClientGUID
            LEFT JOIN dbo.lkpHairSystemOrderStatus hsos
                ON hsos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
                    AND hsos.HairSystemOrderStatusDescriptionShort IN ('CENT','NEW','ORDER','HQ-Recv','HQ-Ship','FAC-Ship','QANEEDED')
            --INNER JOIN dbo.datClient clt ON clt.ClientGUID = hso.ClientGUID
            INNER JOIN dbo.cfgCenter c ON c.CenterID = clt.CenterID
            LEFT JOIN dbo.cfgHairSystem hs ON hs.HairSystemID = hso.HairSystemID
        WHERE clt.CenterID in (SELECT item from fnSplit(@CenterIDs, ','))
        AND m.MembershipDescription <> 'CANCEL'
        AND cm.ClientMembershipStatusID = 1
        AND m.BusinessSegmentID = 1 --BIO
        AND m.MembershipID NOT IN(1,2,11,12,14,15,16,17,18,19,49,50,57)  --ALL except these
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
        AND cm.BeginDate >= DATEADD(MONTH,-18,GETUTCDATE())
    END
    ELSE
    BEGIN
        INSERT INTO #hair
        SELECT hso.HairSystemOrderNumber
        ,    clt.CenterID
        ,    c.CenterDescriptionFullCalc
        ,    clt.ClientFullNameCalc AS 'ClientFullNameCalc'
        ,    clt.ClientGUID
        ,    clt.CurrentBioMatrixClientMembershipGUID
        ,    m.MembershipID
        ,    m.MembershipDescription AS 'MembershipDescription'
        ,    cm.EndDate
        ,    NULL AS 'LastApplicationDate'
        ,    CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('CENT') THEN 1 ELSE 0 END AS 'InCenter'
        ,    CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('NEW','ORDER','HQ-Recv','HQ-Ship','FAC-Ship') THEN 1 ELSE 0 END AS 'OnOrder'
        ,   CASE WHEN hsos.HairSystemOrderStatusDescriptionShort IN ('QANEEDED') THEN 1 ELSE 0 END AS 'QANEEDED'
        ,    hsos.HairSystemOrderStatusDescriptionShort AS 'Status'
        ,    hso.DueDate AS 'DueDate'
        ,    hso.HairSystemOrderDate
        ,    hso.HairSystemOrderGUID
        FROM datClient clt
            INNER JOIN dbo.datClientMembership cm ON cm.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
            INNER JOIN dbo.cfgMembership m ON m.MembershipID = cm.MembershipID
            LEFT JOIN datHairSystemOrder hso ON hso.ClientGUID = clt.ClientGUID
            LEFT JOIN dbo.lkpHairSystemOrderStatus hsos
                ON hsos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
                    AND hsos.HairSystemOrderStatusDescriptionShort IN ('CENT','NEW','ORDER','HQ-Recv','HQ-Ship','FAC-Ship','QANEEDED')
            INNER JOIN dbo.cfgCenter c ON c.CenterID = clt.CenterID
            LEFT JOIN dbo.cfgHairSystem hs ON hs.HairSystemID = hso.HairSystemID
        WHERE clt.CenterID in (SELECT item from fnSplit(@CenterIDs, ','))
            AND cm.BeginDate >= DATEADD(MONTH,-18,GETUTCDATE())
            AND cm.MembershipID IN (SELECT MembershipID FROM #membership)
            AND m.MembershipDescription <> 'CANCEL'
            AND ClientMembershipStatusID = 1
    END

    CREATE CLUSTERED INDEX IDX_hair_CurrentBioMatrixClientMembershipGUID ON #hair(CurrentBioMatrixClientMembershipGUID)

    --Find Promo Systems
    SELECT ClientMembershipGUID, (SUM(ISNULL(Promo,0)) - SUM(ISNULL(Remove,0))) AS 'Promo'
    INTO #promo
    FROM
        (
        SELECT ClientMembershipGUID
        ,    so.OrderDate
        ,    CASE WHEN sod.SalesCodeID = 700 THEN sod.Quantity ELSE 0 END  AS 'Promo'
        ,    CASE WHEN sod.SalesCodeID = 705 THEN sod.Quantity ELSE 0 END  AS 'Remove'
        ,    sc.SalesCodeDescriptionShort
        FROM #hair
        INNER JOIN dbo.datSalesOrder so
            ON #hair.CurrentBioMatrixClientMembershipGUID = so.ClientMembershipGUID
        INNER JOIN dbo.datSalesOrderDetail sod
            ON so.SalesOrderGUID = sod.SalesOrderGUID
        INNER JOIN dbo.cfgSalesCode sc
            ON sod.SalesCodeID = sc.SalesCodeID
        WHERE sc.SalesCodeID IN (700,705)    --PROMOSYS, REMOVESYS
        GROUP BY ClientMembershipGUID
        ,    so.OrderDate
        ,    sod.Quantity
        ,    sc.SalesCodeDescriptionShort
        ,    sod.SalesCodeID
        )q
    GROUP BY q.ClientMembershipGUID

    --Find Last Applied Date
    SELECT lastapp.ClientGUID
    ,    lastapp.HairSystemOrderTransactionDate AS 'LastApplicationDate'
    INTO #LastAppliedDate
    FROM
        (SELECT ROW_NUMBER() OVER(PARTITION BY hair.ClientGUID ORDER BY hsot.HairSystemOrderTransactionDate DESC) AS LastRank
            ,    hair.ClientGUID
            ,    hsot.HairSystemOrderTransactionDate
            FROM #hair hair
            INNER JOIN dbo.datHairSystemOrderTransaction hsot
                ON hair.ClientGUID = hsot.ClientGUID
            INNER JOIN lkpHairSystemOrderStatus hsos
                ON hsot.NewHairSystemOrderStatusID = hsos.HairSystemOrderStatusID
            WHERE HairSystemOrderStatusDescriptionShort = 'APPLIED')lastapp
    WHERE lastapp.LastRank = 1

    --Find Next Due Date
    SELECT due.ClientGUID
    ,    due.DueDate
    INTO #NextDueDate
    FROM
        (SELECT ROW_NUMBER() OVER(PARTITION BY hair.ClientGUID ORDER BY hair.DueDate) AS NextDueDate
        , hair.ClientGUID
        , hair.DueDate
        FROM #hair hair
            INNER JOIN dbo.datHairSystemOrderTransaction hsot
                ON hsot.HairSystemOrderGUID = hair.HairSystemOrderGUID
            INNER JOIN lkpHairSystemOrderStatus hsos
                ON hsot.NewHairSystemOrderStatusID = hsos.HairSystemOrderStatusID
        WHERE hsos.HairSystemOrderStatusDescriptionShort  = 'ORDER'
            AND hair.DueDate >= GETUTCDATE()
        )due
    WHERE due.NextDueDate = 1

    --Find initial quantity for the membership
    SELECT M.MembershipDescription
        ,    ACCUM.MembershipID
        ,    CASE WHEN M.MembershipDescription LIKE '%Executive%' THEN 17
                WHEN M.MembershipDescription LIKE '%Presidential%' THEN 26
                WHEN M.MembershipDescription LIKE '%Premier%' THEN 52
            ELSE MIN(InitialQuantity)END AS 'InitialQuantity'
    INTO #initialquantity
    FROM dbo.cfgMembershipAccum ACCUM
        INNER JOIN dbo.cfgMembership M
            ON ACCUM.MembershipID = M.MembershipID
    WHERE BusinessSegmentID = 1 --BIO
        AND ACCUM.MembershipID NOT IN(1,2,11,12,14,15,16,17,18,19,49,50,57)
        AND ACCUM.IsActiveFlag = 1
        AND ACCUM.InitialQuantity <> 0
    GROUP BY M.MembershipDescription
        ,    ACCUM.MembershipID
    ORDER BY M.MembershipDescription

    DECLARE @groupedMemberships AS TABLE
                (
                membershipId int,
                membershipDescriptionShort nvarchar(max),
                membershipDescription nvarchar(max),
                membershipGroup nvarchar(max)
                )
                --- Insert membership values
        INSERT INTO @groupedMemberships (membershipId,membershipDescriptionShort,membershipDescription,membershipGroup)
            VALUES
            (22,'BASIC','Basic','Basic'),
            (30,'DIA','Diamond','Diamond'),
            (31,'DIASOL','Diamond Solutions','Diamond'),
            (24,'BRZ','Bronze', 'Bronze'),
            (12,'HCFK','Hair Club For Kids','HCFK'),
            (65,'EMRLD','Emerald','Emerald'),
            (290,'EMPLOYRET','Employee-Retail','EmployeeRetail'),
            (34,'EXE','Executive','Executive'),
            (28,'GLD','Gold','Gold'),
            (29,'GLDSOL','Gold Solutions','Gold'),
            (32,'PLA','Platinum','Platinum'),
            (33,'PLASOL','Platinum Solutions','Platinum'),
            (36,'PRS','Presidential','Presidential'),
            (63,'RUBY','Ruby','Ruby'),
            (95,'RUBY','Ruby Plus Transitional','Ruby'),
            (67,'SAPPHIRE','Sapphire','Sapphire'),
            (26,'SIL','Silver','Silver'),
            (10,'TRADITION','Xtrands+ Initial','Xtrands+'),
            (5,'GRADSOL12','Xtrands+ Initial 12 Solutions','Xtrands+'),
            (3,'GRAD','Xtrands+ Initial 6','Xtrands+'),
            (47,'GRDSV','Xtrands+ Initial 6','Xtrands+'),
            (285,'GRDSV','Xtrands+ Initial 6 EZPAY','Xtrands+'),
            (4,'GRDSV','Xtrands+ Initial 6 Solutions','Xtrands+'),
            (48,'GRDSVSOL','Xtrands+ Initial 6 Solutions','Xtrands+')
    SELECT ClientFullNameCalc
    ,    MembershipDescription
    ,   MembershipId
    ,    CenterDescriptionFullCalc as 'CenterID'
    ,    EndDate
    ,    LastApplicationDate
    ,    InCenter
    ,    OnOrder
    ,    DueDate
    ,    TotalAccumQuantity
    ,    Promo
    ,    InitialQuantity
    --,    Remaining = (InitialQuantity - OnOrder + Promo)
    ,    AccumQuantityRemainingCalc AS 'Remaining'
    ,    CASE WHEN q.Promo < 0 THEN 0 ELSE Promo END AS 'Overage'
    ,   (q.QANEEDED + InCenter + OnOrder) as 'QuantityAtCenterAndOrdered'
    ,   q.QANEEDED as 'QaNeeded'
    ,   CenterDescriptionFullCalc
    into #tmpHairOrderQuantitybyClient
    FROM (SELECT hair.ClientFullNameCalc
            ,    hair.MembershipDescription
            ,    hair.CenterID
            ,    hair.EndDate
            ,   hair.MembershipID
            ,    lad.LastApplicationDate
            ,    SUM(hair.InCenter) AS 'InCenter'
            ,    SUM(hair.OnOrder) AS 'OnOrder'
            ,    ndd.DueDate
            ,    ahs.TotalAccumQuantity
            ,    ahs.AccumQuantityRemainingCalc
            ,    ISNULL(pro.Promo,0) AS 'Promo'
            ,    iq.InitialQuantity
            ,   hair.CenterDescriptionFullCalc
            ,   SUM(hair.QANEEDED)  AS 'QANEEDED'
            FROM #hair hair
                LEFT JOIN datClientMembershipAccum ahs
                    ON hair.CurrentBioMatrixClientMembershipGUID = ahs.ClientMembershipGUID AND ahs.AccumulatorID = 8 --Hair Systems
                LEFT JOIN #promo pro
                    ON hair.CurrentBioMatrixClientMembershipGUID = pro.ClientMembershipGUID
                LEFT JOIN #LastAppliedDate lad
                    ON hair.ClientGUID = lad.ClientGUID
                LEFT JOIN #NextDueDate ndd
                    ON hair.ClientGUID = ndd.ClientGUID
                LEFT JOIN #initialquantity iq
                    ON hair.MembershipID = iq.MembershipID
                left join cfgcenter cent on cent.centerid=hair.centerid
            GROUP BY hair.CenterDescriptionFullCalc
            ,    hair.ClientFullNameCalc
            ,    hair.MembershipDescription
            ,    hair.CenterID
            ,    hair.EndDate
            ,    lad.LastApplicationDate
            ,    ndd.DueDate
            ,    ahs.TotalAccumQuantity
            ,    ahs.AccumQuantityRemainingCalc
            ,    pro.Promo
            ,    iq.InitialQuantity
            ,   hair.MembershipId
    )q
    select tmpData.*, gms.membershipGroup,
           case

            when (gms.MembershipGroup like '%Xtrands+%'  or  gms.MembershipGroup like '%EmployeeRetail%') and tmpData.QuantityAtCenterAndOrdered=0 then 0
            when (gms.MembershipGroup like '%Xtrands+%'  or  gms.MembershipGroup like '%EmployeeRetail%')  and tmpData.QuantityAtCenterAndOrdered=1 then 0
            when (gms.MembershipGroup like '%Xtrands+%'  or  gms.MembershipGroup like '%EmployeeRetail%') and tmpData.QuantityAtCenterAndOrdered=2  then  0
            when (gms.MembershipGroup like '%Basic%' or  gms.MembershipGroup like '%Ruby%' or gms.MembershipGroup like '%HCFK%') and tmpData.QuantityAtCenterAndOrdered=0 then 2
            when (gms.MembershipGroup like '%Basic%' or  gms.MembershipGroup like '%Ruby%' or gms.MembershipGroup like '%HCFK%') and tmpData.QuantityAtCenterAndOrdered=1 then 2
            when (gms.MembershipGroup like '%Basic%' or  gms.MembershipGroup like '%Ruby%' or gms.MembershipGroup like '%HCFK%') and tmpData.QuantityAtCenterAndOrdered=2 then 1
            when (gms.MembershipGroup like '%Bronze%' or  gms.MembershipGroup like '%Emerald%' or gms.MembershipGroup like '%Silver%') and tmpData.QuantityAtCenterAndOrdered=0 then 2
            when (gms.MembershipGroup like '%Bronze%' or  gms.MembershipGroup like '%Emerald%' or gms.MembershipGroup like '%Silver%') and tmpData.QuantityAtCenterAndOrdered=1 then 2
            when (gms.MembershipGroup like '%Bronze%' or  gms.MembershipGroup like '%Emerald%' or  gms.MembershipGroup like '%Silver%') and tmpData.QuantityAtCenterAndOrdered=2 then 2
            when (gms.MembershipGroup like '%Gold%' or  gms.MembershipGroup like '%Sapphire%') and tmpData.QuantityAtCenterAndOrdered=0 then 3
            when (gms.MembershipGroup like '%Gold%' or  gms.MembershipGroup like '%Sapphire%') and tmpData.QuantityAtCenterAndOrdered=1 then 3
            when (gms.MembershipGroup like '%Gold%' or  gms.MembershipGroup like '%Sapphire%') and tmpData.QuantityAtCenterAndOrdered=2 then 3
            when gms.MembershipGroup like '%Diamond%' and tmpData.QuantityAtCenterAndOrdered=0 then 4
            when gms.MembershipGroup like '%Diamond%' and tmpData.QuantityAtCenterAndOrdered=1 then 4
            when gms.MembershipGroup like '%Diamond%' and tmpData.QuantityAtCenterAndOrdered=2 then 3
            when (gms.MembershipGroup like '%Platinum%' or  gms.MembershipGroup like '%Executive%') and tmpData.QuantityAtCenterAndOrdered=0 then 6
            when (gms.MembershipGroup like '%Platinum%' or  gms.MembershipGroup like '%Executive%') and tmpData.QuantityAtCenterAndOrdered=1 then 6
            when (gms.MembershipGroup like '%Platinum%' or  gms.MembershipGroup like '%Executive%') and tmpData.QuantityAtCenterAndOrdered=2 then 5
            when gms.MembershipGroup like '%Presidential%' and tmpData.QuantityAtCenterAndOrdered=0 then 12
            when gms.MembershipGroup like '%Presidential%' and tmpData.QuantityAtCenterAndOrdered=1 then 12
            when gms.MembershipGroup like '%Presidential%' and tmpData.QuantityAtCenterAndOrdered=2 then 12
            when gms.MembershipGroup like '%Premier%' and tmpData.QuantityAtCenterAndOrdered=0 then 18
            when gms.MembershipGroup like '%Premier%' and tmpData.QuantityAtCenterAndOrdered=1 then 18
            when gms.MembershipGroup like '%Premier%' and tmpData.QuantityAtCenterAndOrdered=2 then 18

            else 0  -- if not any of this conditions the field should be 0

       END as SuggestedQuantityToOrder
    from #tmpHairOrderQuantitybyClient tmpData
    inner join  @groupedMemberships gms on tmpData.MembershipId=gms.MembershipID
END
GO
