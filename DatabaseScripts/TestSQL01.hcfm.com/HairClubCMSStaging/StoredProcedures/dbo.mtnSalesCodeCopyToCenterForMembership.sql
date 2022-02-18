/* CreateDate: 09/15/2014 14:36:28.540 , ModifyDate: 01/10/2022 12:03:24.403 */
GO
/*
======================================================================================
PROCEDURE:				mtnSalesCodeCopyToCenterForMembership

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		09/11/2014

LAST REVISION DATE: 	09/11/2014

======================================================================================
DESCRIPTION:	Copies a Sales Code From one to Center to Another, for a Membership
======================================================================================
NOTES:
		* 09/11/2014 SAL - Created Stored Proc
		* 05/18/2015 SAL - Updated SAMPLE EXECUTION comments to indicate that you can
							bulk copy all sales codes for a membership from one center
							to another

======================================================================================
SAMPLE EXECUTION:
EXEC mtnSalesCodeCopyToCenterForMembership 216, 220, 'XTRPROD', 'Xtrand', 'TFS3516'
EXEC mtnSalesCodeCopyToCenterForMembership 216, 220, NULL, 'Xtrand', 'TFS3516' - this will copy ALL sales codes for the membership
======================================================================================
*/
CREATE PROCEDURE [dbo].[mtnSalesCodeCopyToCenterForMembership]
    @FromCenterID               INT
  , @ToCenterID                 INT
  , @SalesCodeDescriptionShort  NVARCHAR(15)
  , @MembershipDescriptionShort NVARCHAR(10)
  , @User                       NVARCHAR(25)
AS
    BEGIN
        SET NOCOUNT ON ;

        DECLARE @SalesCodeID INT ;

        -- Get the SalesCodeID
        SELECT @SalesCodeID = [SalesCodeID]
        FROM [dbo].[cfgSalesCode]
        WHERE [SalesCodeDescriptionShort] = @SalesCodeDescriptionShort ;

        --Insert SalesCodeCenter record, if not already there
        INSERT INTO [dbo].[cfgSalesCodeCenter]( [CenterID], [SalesCodeID], [PriceRetail], [TaxRate1ID], [TaxRate2ID], [QuantityMaxLevel], [QuantityMinLevel], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
        SELECT
            @ToCenterID
          , [scc].[SalesCodeID]
          , [scc].[PriceRetail]
          , [ToTr1].[CenterTaxRateID]
          , [ToTr2].[CenterTaxRateID]
          , [scc].[QuantityMaxLevel]
          , [scc].[QuantityMinLevel]
          , [scc].[IsActiveFlag]
          , GETUTCDATE() AS [CreateDAte]
          , @User AS [CreateUser]
          , GETUTCDATE() AS [LastUpdate]
          , @User AS [LastUpdateUser]
        FROM [dbo].[cfgSalesCodeCenter] AS [scc]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr1] ON [scc].[TaxRate1ID] = [tr1].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr2] ON [scc].[TaxRate2ID] = [tr2].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr1] ON [tr1].[TaxTypeID] = [ToTr1].[TaxTypeID] AND @ToCenterID = [ToTr1].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr2] ON [tr2].[TaxTypeID] = [ToTr2].[TaxTypeID] AND @ToCenterID = [ToTr2].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [scc].[SalesCodeID] = [sccNew].[SalesCodeID] AND [sccNew].[CenterID] = @ToCenterID
        WHERE [scc].[CenterID] = @FromCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) AND [scc].[IsActiveFlag] = 1 AND [sccNew].[SalesCodeCenterID] IS NULL ;

        --this prevents a duplicate from being inserted into the SalesCodeCenter

        --Insert SalesCodeMembership record, if not already there
        INSERT INTO [dbo].[cfgSalesCodeMembership]( [SalesCodeCenterID], [MembershipID], [Price], [TaxRate1ID], [TaxRate2ID], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
        SELECT
            [sccNew].[SalesCodeCenterID]
          , [scm].[MembershipID]
          , [scm].[Price]
          , [ToTr1].[CenterTaxRateID]
          , [ToTr2].[CenterTaxRateID]
          , [scm].[IsActiveFlag]
          , GETUTCDATE() AS [CreateDate]
          , @User AS [CreateUser]
          , GETUTCDATE() AS [LastUpdate]
          , @User AS [LastUpateUser]
        FROM [dbo].[cfgSalesCodeCenter] AS [scc]
        INNER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [sccNew].[CenterID] = @ToCenterID AND [sccNew].[SalesCodeID] = [scc].[SalesCodeID]
        INNER JOIN [dbo].[cfgSalesCodeMembership] AS [scm] ON [scm].[SalesCodeCenterID] = [scc].[SalesCodeCenterID]
        INNER JOIN [dbo].[cfgMembership] AS [m] ON [scm].[MembershipID] = [m].[MembershipID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr1] ON [scm].[TaxRate1ID] = [tr1].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr2] ON [scm].[TaxRate2ID] = [tr2].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr1] ON [tr1].[TaxTypeID] = [ToTr1].[TaxTypeID] AND @ToCenterID = [ToTr1].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr2] ON [tr2].[TaxTypeID] = [ToTr2].[TaxTypeID] AND @ToCenterID = [ToTr2].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgSalesCodeMembership] AS [scmNew] ON [sccNew].[SalesCodeCenterID] = [scmNew].[SalesCodeCenterID] AND [scm].[MembershipID] = [scmNew].[MembershipID]
        WHERE [scc].[CenterID] = @FromCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) --this prevents it from inserted it its not a valid sales code for the center already
          AND [scc].[IsActiveFlag] = 1 AND [m].[MembershipDescriptionShort] = @MembershipDescriptionShort AND [scm].[IsActiveFlag] = 1 AND [scmNew].[SalesCodeMembershipID] IS NULL ; --this prevents a duplicate from being inserted into the SalesCodeMembership
    END ;
GO
