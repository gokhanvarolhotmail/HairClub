/* CreateDate: 01/10/2018 16:09:59.783 , ModifyDate: 08/17/2020 09:11:34.290 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:                mtnCreateActivitiesForNationalPricing
DESTINATION SERVER:        SQL01
DESTINATION DATABASE:     HairClubCMS
RELATED APPLICATION:      CMS
AUTHOR:                 Sue Lemery
IMPLEMENTOR:             Sue Lemery
DATE IMPLEMENTED:         01/03/2018
--------------------------------------------------------------------------------------------------------
NOTES:  Creates an activity for each client who is under National Pricing (Membership Price > Client
        Membership Price) and is 90 days out from their renewal
        * 01/03/2018    SAL    Created (TFS#10087)
        * 08/06/2018    SAL Updated to initialize EmployeeGUID on each loop (TFS#11203)
        * 12/17/2018    JLM Updated to use National Monthly Fees (TFS#11764 and #11778)
        * 07/28/2020    AO Updated  to include datTechnicalProfile validation  (TFS #14449)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC mtnCreateActivitiesForNationalPricing
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnCreateActivitiesForNationalPricing]
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    DECLARE @CenterID int
    DECLARE @ClientGUID uniqueidentifier
    DECLARE @ActivitySubCategoryID int
    DECLARE @ActivityActionID int
    DECLARE @DueDate datetime
    DECLARE @ActivityPriorityID int
    DECLARE @ActivityNote varchar(max)
    DECLARE @ActivityStatusID int
    DECLARE @EmployeeGUID uniqueidentifier
    DECLARE @User nvarchar(25) = 'Nightly_NationalPricing'
    DECLARE @CRMEmployeePositionDescriptionShort nvarchar(10) = 'CRM'
    DECLARE @CenterManagerEmployeePositionDescriptionShort nvarchar(10) = 'Manager'
    DECLARE @DaysOutFromRenewal int = 90
    DECLARE @DaysOutDate date
    SELECT @ActivitySubCategoryID = ActivitySubCategoryID FROM lkpActivitySubCategory WHERE ActivitySubCategoryDescriptionShort = 'FEE'
    SELECT @ActivityActionID = ActivityActionID FROM lkpActivityAction WHERE ActivityActionDescriptionShort = 'NATPRICING'
    SELECT @ActivityPriorityID = ActivityPriorityID FROM lkpActivityPriority WHERE ActivityPriorityDescriptionShort = 'MED'
    SELECT @ActivityNote = 'Client is under National Pricing. Communication with client should occur regarding a change to the National Rate at, or before, their membership renewal date.'
    SELECT @ActivityStatusID = ActivityStatusID FROM lkpActivityStatus WHERE ActivityStatusDescriptionShort = 'OPEN'
    SELECT @DaysOutDate = DATEADD(day, @DaysOutFromRenewal, GETDATE())
    SELECT @DueDate = CONVERT(DATE, GETDATE())
    DECLARE CUR CURSOR FAST_FORWARD FOR
        --Get Clients who are under National Pricing and 90 Days out from their Renewal
        SELECT DISTINCT c.ClientGUID, c.CenterID
        FROM datClient c
            inner join lkpGender g on g.GenderID = c.GenderID
            inner join cfgCenter ctr on c.CenterID = ctr.CenterID
            inner join cfgConfigurationCenter configctr on ctr.CenterID = configctr.CenterID
            RIGHT JOIN datTechnicalProfile ON datTechnicalProfile.ClientGUID = c.ClientGUID
            left join datClientMembership cmBIO on c.CurrentBioMatrixClientMembershipGUID = cmBIO.ClientMembershipGUID
                left join cfgCenterMembership cenMemBio ON cenMemBio.MembershipID = cmBIO.MembershipID AND cenMemBio.CenterID = c.CenterID
                left join cfgMembership mBIO on cmBIO.MembershipID = mBIO.MembershipID
                left join lkpClientMembershipStatus cmsBIO on cmBIO.ClientMembershipStatusID = cmsBIO.ClientMembershipStatusID
            left join datClientMembership cmEXT on c.CurrentExtremeTherapyClientMembershipGUID = cmEXT.ClientMembershipGUID
                left join cfgCenterMembership cenMemEXT ON cenMemEXT.MembershipID = cmEXT.MembershipID AND cenMemEXT.CenterID = c.CenterID
                left join cfgMembership mEXT on cmEXT.MembershipID = mEXT.MembershipID
                left join lkpClientMembershipStatus cmsEXT on cmEXT.ClientMembershipStatusID = cmsEXT.ClientMembershipStatusID
            left join datClientMembership cmXTR on c.CurrentXtrandsClientMembershipGUID = cmXTR.ClientMembershipGUID
                left join cfgCenterMembership cenMemXTR ON cenMemXTR.MembershipID = cmXTR.MembershipID AND cenMemXTR.CenterID = c.CenterID
                left join cfgMembership mXTR on cmXTR.MembershipID = mXTR.MembershipID
                left join lkpClientMembershipStatus cmsXTR on cmXTR.ClientMembershipStatusID = cmsXTR.ClientMembershipStatusID
        WHERE configctr.IncludeInNationalPricingRenewal = 1 -- ctr.CenterTypeID = 1 --Corporate Centers Only
           and (c.DoNotCallFlag is null or c.DoNotCallFlag = 0) --Client can be called
           and (c.DoNotContactFlag is null or c.DoNotContactFlag = 0) --Client can be contacted
           and (
                    (
                        cmsBIO.ClientMembershipStatusDescriptionShort = 'A'
                        and cmBIO.EndDate = @DaysOutDate
                        and
                            (
                                (g.GenderDescriptionShort = 'M' AND (cenMemBio.ContractPriceMale / mBIO.DurationMonths) <> cmBIO.MonthlyFee)
                                or (g.GenderDescriptionShort = 'F' AND (cenMemBio.ContractPriceFemale / mBIO.DurationMonths) <> cmBIO.MonthlyFee)
                            )
                    )
                or
                    (
                        cmsEXT.ClientMembershipStatusDescriptionShort = 'A'
                        and cmEXT.EndDate = @DaysOutDate
                        and
                            (
                                (g.GenderDescriptionShort = 'M' AND (cenMemEXT.ContractPriceMale / mEXT.DurationMonths) <> cmEXT.MonthlyFee)
                                or (g.GenderDescriptionShort = 'F' AND (cenMemEXT.ContractPriceFemale / mEXT.DurationMonths) <> cmEXT.MonthlyFee)
                            )
                    )
                or
                    (
                        cmsXTR.ClientMembershipStatusDescriptionShort = 'A'
                        and cmXTR.EndDate = @DaysOutDate
                        and
                            (
                                (g.GenderDescriptionShort = 'M' AND (cenMemXTR.ContractPriceMale / mXTR.DurationMonths) <> cmXTR.MonthlyFee)
                                or (g.GenderDescriptionShort = 'F' AND (cenMemXTR.ContractPriceFemale / mXTR.DurationMonths) <> cmXTR.MonthlyFee)
                            )
                    )
                )

    OPEN CUR
    FETCH NEXT FROM CUR INTO @ClientGUID, @CenterID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        --Initialize EmployeeGUID
        SET @EmployeeGUID = NULL
        --Get the CRM for the Center.
        --If no CRM for the Center, then get the Center Manager for the Center.
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
        FETCH NEXT FROM CUR INTO @ClientGUID, @CenterID
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
