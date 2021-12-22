/**************************************************************************************************************
PROCEDURE:                  mtnUpdateClientReferralRequirementsMetDate

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:       HairClubCMS

AUTHOR:                     Jeremy Miller

IMPLEMENTOR:                Jeremy Miller

DATE IMPLEMENTED:           11/20/2019

DESCRIPTION:                Select all of the datClientReferral records that do not have RequirementsMetDate
                            column set. For each of those determine if the referred client has met the
                            requirements to be a valid referral.

                            As of 11/20/2019 valid requirements are:
                            - Referred Client is in an active 'New Business' membership
                            - Referred Client has had at least one initial application, new style, or grafts
							- Retail clients must have had at least one paid sales order that includes a service
							  or product.
---------------------------------------------------------------------------------------------------------------
NOTES:          * 11/20/2019    JLM Created. (TFS#13475)
---------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC mtnUpdateClientReferralRequirementsMetDate
***************************************************************************************************************/


CREATE PROCEDURE mtnUpdateClientReferralRequirementsMetDate

AS

BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

    --Cursor Variables
    DECLARE @ReferredClientGUID UNIQUEIDENTIFIER
    DECLARE @ReferredClientMembershipGUID UNIQUEIDENTIFIER
    DECLARE @ClientReferralID INT
    DECLARE @MembershipDescriptionShort NVARCHAR(10)

    --CONSTANTS
	DECLARE @RetailMembershipDescriptionShort NVARCHAR(10) = N'Retail'
    DECLARE @InitialApplicationAccumulatorDescriptionShort NVARCHAR(10) = N'InitApp'
    DECLARE @ServicesAccumulatorDescriptionShort NVARCHAR(10) = N'SERV'
    DECLARE @GraftAccumulatorDescriptionShort NVARCHAR(10) = N'Grafts'
    DECLARE @SalesOrderSalesOrderTypeDescriptionShort NVARCHAR(10) = N'SO'

    DECLARE @UpdateUser NVARCHAR(25) = 'cmsRefReqMetDateUpdate'

    DECLARE @NewBusinessRevenueGroupID INT

    SELECT @NewBusinessRevenueGroupID = RevenueGroupID FROM lkpRevenueGroup WHERE RevenueGroupDescriptionShort = 'NB'

    DECLARE CUR CURSOR FAST_FORWARD FOR
        SELECT cr.ClientReferredGUID,
               cm.ClientMembershipGUID,
               cr.ClientReferralID,
               mem.MembershipDescriptionShort
        FROM datClientReferral cr
        INNER JOIN datClient c ON cr.ClientReferredGUID = c.ClientGUID
        INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
        INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
        WHERE cr.RequirementsMetDate IS NULL
        AND cm.IsActiveFlag = 1
        AND mem.RevenueGroupID = @NewBusinessRevenueGroupID

    OPEN CUR
    FETCH NEXT FROM CUR INTO @ReferredClientGUID, @ReferredClientMembershipGUID, @ClientReferralID, @MembershipDescriptionShort

    WHILE @@FETCH_STATUS = 0

    BEGIN

        IF (@MembershipDescriptionShort = @RetailMembershipDescriptionShort)
        BEGIN
        --Any Paid Sales Order with a Product or Service
            IF EXISTS(SELECT so.SalesOrderGUID, so.OrderDate, x_Tender.Amount, x_Detail.TotalProductsAndServices
                              FROM datSalesOrder so
                              INNER JOIN lkpSalesOrderType sot ON so.SalesOrderTypeID = sot.SalesOrderTypeID
                              CROSS APPLY (
                                    SELECT SUM(Amount) AS Amount FROM datSalesOrderTender
                                    WHERE SalesOrderGUID = so.SalesOrderGUID) x_Tender
                              CROSS APPLY (
                                    SELECT COUNT(sod.SalesOrderDetailGUID) AS TotalProductsAndServices
                                    FROM datSalesOrderDetail sod
                                    INNER JOIN cfgSalesCode sc ON sod.SalesCodeID = sc.SalesCodeID
                                    INNER JOIN lkpSalesCodeType sct ON sc.SalesCodeTypeID = sct.SalesCodeTypeID
                                    WHERE sod.SalesOrderGUID = so.SalesOrderGUID
                                    AND sct.SalesCodeTypeDescriptionShort IN ('Product', 'Service')
                              ) x_Detail
                            WHERE so.ClientMembershipGUID = @ReferredClientMembershipGUID
                            AND sot.SalesOrderTypeDescriptionShort = @SalesOrderSalesOrderTypeDescriptionShort
                            AND x_Tender.Amount > 0
                            AND x_Detail.TotalProductsAndServices > 0)
            BEGIN
                UPDATE cr
                SET cr.RequirementsMetDate = x_SO.OrderDate,
                    LastUpdateUser = @UpdateUser
                FROM datClientReferral cr
                CROSS APPLY (
                              SELECT TOP 1 so.SalesOrderGUID, so.OrderDate, x_Tender.Amount, x_Detail.TotalProductsAndServices
                              FROM datSalesOrder so
                              INNER JOIN lkpSalesOrderType sot ON so.SalesOrderTypeID = sot.SalesOrderTypeID
                              CROSS APPLY (
                                    SELECT SUM(Amount) AS Amount FROM datSalesOrderTender
                                    WHERE SalesOrderGUID = so.SalesOrderGUID) x_Tender
                              CROSS APPLY (
                                    SELECT COUNT(sod.SalesOrderDetailGUID) AS TotalProductsAndServices
                                    FROM datSalesOrderDetail sod
                                    INNER JOIN cfgSalesCode sc ON sod.SalesCodeID = sc.SalesCodeID
                                    INNER JOIN lkpSalesCodeType sct ON sc.SalesCodeTypeID = sct.SalesCodeTypeID
                                    WHERE sod.SalesOrderGUID = so.SalesOrderGUID
                                    AND sct.SalesCodeTypeDescriptionShort IN ('Product', 'Service')
                              ) x_Detail
                            WHERE so.ClientMembershipGUID = @ReferredClientMembershipGUID
                            AND sot.SalesOrderTypeDescriptionShort = @SalesOrderSalesOrderTypeDescriptionShort
                            AND x_Tender.Amount > 0
                            AND x_Detail.TotalProductsAndServices > 0
                            ORDER BY so.OrderDate) x_SO
                WHERE cr.ClientReferralID = @ClientReferralID
            END
        END
        ELSE
        BEGIN
            IF EXISTS(SELECT cma.ClientMembershipAccumGUID
            FROM datClientMembershipAccum cma
            LEFT JOIN cfgAccumulator intialAppAccum ON cma.AccumulatorID = intialAppAccum.AccumulatorID
                                                    AND intialAppAccum.AccumulatorDescriptionShort = @InitialApplicationAccumulatorDescriptionShort
            LEFT JOIN cfgAccumulator servicesAccum ON cma.AccumulatorID = servicesAccum.AccumulatorID
                                                AND servicesAccum.AccumulatorDescriptionShort = @ServicesAccumulatorDescriptionShort
            LEFT JOIN cfgAccumulator graftAccum ON cma.AccumulatorID = graftAccum.AccumulatorID
                                                AND graftAccum.AccumulatorDescriptionShort = @GraftAccumulatorDescriptionShort
            WHERE cma.ClientMembershipGUID = @ReferredClientMembershipGUID
            AND ( (intialAppAccum.AccumulatorID IS NOT NULL AND cma.UsedAccumQuantity > 0) OR
                    (servicesAccum.AccumulatorID IS NOT NULL AND cma.UsedAccumQuantity > 0) OR
                    (graftAccum.AccumulatorID IS NOT NULL AND cma.UsedAccumQuantity > 0)))
            BEGIN
                UPDATE cr
                SET cr.RequirementsMetDate = cma.LastUpdate,
                    cr.LastUpdate = GETUTCDATE(),
                    cr.LastUpdateUser = @UpdateUser
                FROM datClientReferral cr
                INNER JOIN datClientMembershipAccum cma ON cma.ClientMembershipGUID = @ReferredClientMembershipGUID
                LEFT JOIN cfgAccumulator initAppAccum ON cma.AccumulatorID = initAppAccum.AccumulatorID
                                                      AND initAppAccum.AccumulatorDescriptionShort = @InitialApplicationAccumulatorDescriptionShort
                LEFT JOIN cfgAccumulator servicesAccum ON cma.AccumulatorID = servicesAccum.AccumulatorID
                                                       AND servicesAccum.AccumulatorDescriptionShort = @ServicesAccumulatorDescriptionShort
                LEFT JOIN cfgAccumulator graftAccum ON cma.AccumulatorID = graftAccum.AccumulatorID
                                                    AND graftAccum.AccumulatorDescriptionShort = @GraftAccumulatorDescriptionShort
                WHERE cr.ClientReferralID = @ClientReferralID
                AND ( (initAppAccum.AccumulatorID IS NOT NULL AND cma.UsedAccumQuantity > 0) OR
                      (servicesAccum.AccumulatorID IS NOT NULL AND cma.UsedAccumQuantity > 0) OR
                      (graftAccum.AccumulatorID IS NOT NULL AND cma.UsedAccumQuantity > 0))
            END
        END

    FETCH NEXT FROM CUR INTO @ReferredClientGUID, @ReferredClientMembershipGUID, @ClientReferralID, @MembershipDescriptionShort
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

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

    END CATCH

END

SET ANSI_NULLS ON
