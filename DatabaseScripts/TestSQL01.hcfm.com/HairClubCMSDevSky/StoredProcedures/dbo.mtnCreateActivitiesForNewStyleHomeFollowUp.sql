/* CreateDate: 11/04/2019 08:20:44.013 , ModifyDate: 11/04/2019 08:20:44.013 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************************************************
PROCEDURE:                  mtnCreateActivitiesForNewStyleHomeFollowUp

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:       HairClubCMS

AUTHOR:                     Jeremy Miller

IMPLEMENTOR:                Jeremy Miller

DATE IMPLEMENTED:           10/16/2019

DESCRIPTION:                10/16/2019
---------------------------------------------------------------------------------------------------------------
NOTES:          * 10/16/2019    JLM Created. (TFS#13184)
---------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC mtnCreateActivitiesForNewStyleHomeFollowUp
***************************************************************************************************************/
CREATE PROCEDURE [dbo].[mtnCreateActivitiesForNewStyleHomeFollowUp]

AS

BEGIN

SET NOCOUNT ON;

    BEGIN TRY

        DECLARE @StartDate DATETIME
        DECLARE @EndDate DATETIME
        DECLARE @CenterID INT
        DECLARE @ClientGUID UNIQUEIDENTIFIER
        DECLARE @ActivityNote VARCHAR(MAX)
        DECLARE @ActivitySubCategoryID INT
        DECLARE @ActivityActionID INT
        DECLARE @DueDate DATETIME
        DECLARE @ActivityPriorityID INT
        DECLARE @ActivityStatusID INT
        DECLARE @EmployeeGUID UNIQUEIDENTIFIER
        DECLARE @CorporateCenterBusinessTypeID INT

        DECLARE @CRMEmployeePositionDescriptionShort NVARCHAR(10) = 'CRM'
        DECLARE @CenterManagerEmployeePositionDescriptionShort NVARCHAR(10) = 'Manager'
        DECLARE @CSCEmployeePositionDescriptionShort NVARCHAR(10) = 'CSC'
        DECLARE @StylistEmployeePositionDescritpionShort NVARCHAR(10) = 'Stylist'

        DECLARE @SalesCodeTypeDescriptionShort NVARCHAR(10) = 'Service'
        DECLARE @SalesCodeDepartmentDescriptionShort NVARCHAR(10) = 'SVApp'

        DECLARE @User NVARCHAR(25) = 'Nightly_NewStyleHomeFollowUpActivity'

        SELECT @ActivitySubCategoryID = ActivitySubCategoryID FROM lkpActivitySubCategory WHERE ActivitySubCategoryDescriptionShort = 'UCE'
        SELECT @ActivityActionID = ActivityActionID FROM lkpActivityAction WHERE ActivityActionDescriptionShort = 'NSHMEFLWUP'
        SELECT @DueDate = DATEADD(dd, 7, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
        SELECT @ActivityPriorityID = ActivityPriorityID FROM lkpActivityPriority WHERE ActivityPriorityDescriptionShort = 'MED'
        SELECT @ActivityStatusID = ActivityStatusID FROM lkpActivityStatus WHERE ActivityStatusDescriptionShort = 'OPEN'
        SET @StartDate = DATEADD(ww, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
        SET @EndDate = DATEADD(ww, 0, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))

        SELECT @CorporateCenterBusinessTypeID = CenterBusinessTypeID FROM lkpCenterBusinessType WHERE CenterBusinessTypeDescriptionShort = 'cONEctCorp'

        DECLARE @NewStyleSalesCodes TABLE
        ( SalesCodeID INT )

        INSERT INTO @NewStyleSalesCodes
        (SalesCodeID)
        SELECT sc.SalesCodeID FROM cfgSalesCode sc
        INNER JOIN lkpSalesCodeType sct ON sc.SalesCodeTypeID = sct.SalesCodeTypeID
        INNER JOIN lkpSalesCodeDepartment scd ON sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
        WHERE sct.SalesCodeTypeDescriptionShort = 'Service'
        AND scd.SalesCodeDepartmentDescriptionShort = 'SVApp'

        DECLARE @UTCDates TABLE
        ( TimeZoneID INT,
        UTCOffset INT NULL,
        UsesDayLightSavingsFlag BIT NULL,
        IsActiveFlag BIT NULL,
        UTCStartDate DATETIME NULL,
        UTCEndDate DATETIME NULL )

        DECLARE @NewStyleClients TABLE
        ( ClientGUID UNIQUEIDENTIFIER,
        CenterID INT,
        ClientFullName NVARCHAR(103),
        OrderDate DATETIME,
        EmployeeFullName NVARCHAR(102),
        MembershipDescription NVARCHAR(100),
        SalesOrderDetailGUID UNIQUEIDENTIFIER )


        DECLARE @DistinctClients TABLE
        (ClientGUID UNIQUEIDENTIFIER)

        DECLARE @DistinctCenters TABLE
        (CenterID INT)

        DECLARE @ActivityDetails TABLE
        (ClientGUID UNIQUEIDENTIFIER,
        CenterID INT,
        ActivityNote VARCHAR(MAX))

        /********************************** Convert @StartDate and @EndDate to UTC ***********************************************/
        INSERT INTO @UTCDates (TimeZoneID, UTCOffset, UsesDayLightSavingsFlag, IsActiveFlag, UTCStartDate, UTCEndDate)
        SELECT  tz.TimeZoneID
        ,       tz.UTCOffset
        ,       tz.UsesDayLightSavingsFlag
        ,       tz.IsActiveFlag
        ,       dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate'
        ,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
        FROM    lkpTimeZone tz
        WHERE   tz.IsActiveFlag = 1


        INSERT INTO @NewStyleClients(ClientGUID, CenterID, ClientFullName, OrderDate, EmployeeFullName, MembershipDescription, SalesOrderDetailGUID)
        SELECT so.ClientGUID,
            c.CenterID,
            c.ClientFullNameAltCalc AS 'ClientFullName',
            so.OrderDate,
            emp2.EmployeeFullNameCalc AS 'EmployeeFullName',
            mem.MembershipDescription,
            sod.SalesOrderDetailGUID
        FROM datSalesOrderDetail sod
            INNER JOIN datSalesOrder so
                ON sod.SalesOrderGUID = so.SalesOrderGUID
            INNER JOIN datClient c
                ON so.ClientGUID = c.ClientGUID
            INNER JOIN datClientMembership cm
                ON so.ClientMembershipGUID = cm.ClientMembershipGUID
            INNER JOIN cfgMembership mem
                ON cm.MembershipID = mem.MembershipID
            INNER JOIN @NewStyleSalesCodes nssc
                ON sod.SalesCodeID = nssc.SalesCodeID
            INNER JOIN cfgCenter ctr
                ON so.CenterID = ctr.CenterID
            INNER JOIN cfgConfigurationCenter cc
                ON ctr.CenterID = cc.CenterID
            INNER JOIN lkpTimeZone tz
                ON ctr.TimeZoneID = tz.TimeZoneID
            INNER JOIN @UTCDates u
                ON tz.TimeZoneID = u.TimeZoneID
            LEFT OUTER JOIN datActivity a WITH ( NOLOCK )
                ON a.ClientGUID = c.ClientGUID
                AND a.ActivityActionID = @ActivityActionID
                AND DATEDIFF(dd, a.CreateDate, GETDATE()) <= 30
            LEFT OUTER JOIN datEmployee emp2 ON sod.Employee2GUID = emp2.EmployeeGUID
                LEFT OUTER JOIN cfgEmployeePositionJoin emp2epj ON emp2.EmployeeGUID = emp2epj.EmployeeGUID
                LEFT OUTER JOIN lkpEmployeePosition emp2ep ON emp2epj.EmployeePositionID = emp2ep.EmployeePositionID
                                                        AND emp2ep.EmployeePositionDescriptionShort = @StylistEmployeePositionDescritpionShort
        WHERE cm.IsActiveFlag = 1
        AND (c.DoNotCallFlag IS NULL OR c.DoNotCallFlag = 0)
        AND (c.DoNotContactFlag IS NULL OR c.DoNotContactFlag = 0)
        AND so.OrderDate BETWEEN u.UTCStartDate AND u.UTCEndDate
        AND a.ActivityID IS NULL
        AND cc.CenterBusinessTypeID = @CorporateCenterBusinessTypeID
        AND (emp2.EmployeeGUID IS NOT NULL AND emp2epj.EmployeeGUID IS NOT NULL AND emp2ep.EmployeePositionID IS NOT NULL)

        --Get distinct list of clients in the event that any clients have had multiple cancels. We are only interested in the last cancel

        INSERT INTO @DistinctClients (ClientGUID)
        SELECT  DISTINCT
            c.ClientGUID
        FROM    @NewStyleClients c

        INSERT INTO @DistinctCenters (CenterID)
        SELECT  DISTINCT
            c.CenterID
        FROM    @NewStyleClients c

        INSERT INTO @ActivityDetails (ClientGUID, CenterID, ActivityNote)
        SELECT  dc.ClientGUID,
                x_C.CenterID,
                'Stylist: ' + x_C.EmployeeFullName + ', Membership: ' + x_C.MembershipDescription + ', New Style Date: ' + FORMAT(x_C.OrderDate, 'dd/MM/yyyy') AS 'ActivityNote'
        FROM    @DistinctClients dc
            CROSS APPLY ( SELECT TOP 1
                                    c.CenterID
                            ,         c.ClientGUID
                            ,         c.ClientFullName
                            ,         c.MembershipDescription
                            ,         c.EmployeeFullName
                            ,         c.OrderDate
                            FROM      @NewStyleClients c
                            WHERE     c.ClientGUID = dc.ClientGUID
                            ORDER BY  CAST(c.OrderDate AS DATE) DESC
                        ) x_C

        DECLARE CUR CURSOR FAST_FORWARD FOR
        SELECT  x_A.CenterID
        ,       x_A.ClientGUID
        ,       x_A.ActivityNote
        FROM    @DistinctCenters c
            CROSS APPLY ( SELECT TOP 5
                                    *
                            FROM      @ActivityDetails ad
                            WHERE     ad.CenterID = c.CenterID
                            ORDER BY  NEWID()
                        ) x_A

        OPEN CUR
        FETCH NEXT FROM CUR INTO @CenterID, @ClientGUID, @ActivityNote
        WHILE @@FETCH_STATUS = 0
        BEGIN
        --Initialize EmployeeGUID
        SET @EmployeeGUID = NULL
        --Get the CRM for the Center.
        --If no CRM for the Center, then get the Center Manager for the Center.
        --If no Center Manager for the Center, assign to the CSC.
        SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
                                FROM datEmployee e
                                    INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
                                    INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
                                    INNER JOIN datEmployeeCenter ec on (e.EmployeeGUID = ec.EmployeeGUID and e.CenterID = ec.CenterID)
                                WHERE ep.EmployeePositionDescriptionShort = @CRMEmployeePositionDescriptionShort
                                    and ec.CenterID = @CenterID
                                    and e.IsActiveFlag = 1
                                    and e.FirstName <> 'Test'
                                    and epj.IsActiveFlag = 1
                                    and ec.IsActiveFlag = 1
                                ORDER BY e.EmployeeFullNameCalc)
        If @EmployeeGUID is NULL
        BEGIN
            SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
                                    FROM datEmployee e
                                        INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
                                        INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
                                        INNER JOIN datEmployeeCenter ec on (e.EmployeeGUID = ec.EmployeeGUID and e.CenterID = ec.CenterID)
                                    WHERE ep.EmployeePositionDescriptionShort = @CenterManagerEmployeePositionDescriptionShort
                                        and ec.CenterID = @CenterID
                                        and e.IsActiveFlag = 1
                                        and e.FirstName <> 'Test'
                                        and epj.IsActiveFlag = 1
                                        and ec.IsActiveFlag = 1
                                    ORDER BY e.EmployeeFullNameCalc)
        END

        If @EmployeeGUID is NULL
        BEGIN
            SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
                                    FROM datEmployee e
                                        INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
                                        INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
                                        INNER JOIN datEmployeeCenter ec on e.EmployeeGUID = ec.EmployeeGUID
                                    WHERE ep.EmployeePositionDescriptionShort =  @CSCEmployeePositionDescriptionShort
                                        and ec.CenterID = @CenterID
                                        and e.IsActiveFlag = 1
                                        and e.FirstName <> 'Test'
                                        and epj.IsActiveFlag = 1
                                        and ec.IsActiveFlag = 1
                                    ORDER BY e.EmployeeFullNameCalc)
        END
        If    @ClientGUID is not NULL
            and @ActivitySubCategoryID is not NULL
            and @ActivityActionID is not NULL
            and @ActivityActionID is not NULL
            and @ActivityPriorityID is not null
            and @EmployeeGUID is not null
            and @User is not null
            and @ActivityStatusID is not null
        BEGIN
                --Create Activity
                EXEC mtnActivityAdd null, @ClientGUID, @ActivitySubCategoryID, @ActivityActionID, null, @DueDate, @ActivityPriorityID, @ActivityNote, @EmployeeGUID, @EmployeeGUID, null, null, @User, @ActivityStatusID
        END
        FETCH NEXT FROM CUR INTO @CenterID, @ClientGUID, @ActivityNote
        END
        CLOSE CUR
        DEALLOCATE CUR

    END TRY

    BEGIN CATCH
    CLOSE CUR
    DEALLOCATE CUR

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

    END CATCH
END
SET ANSI_NULLS ON
GO
