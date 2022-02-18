/* CreateDate: 07/29/2013 11:53:20.433 , ModifyDate: 01/10/2022 12:04:28.023 */
GO
/*
==============================================================================
PROCEDURE:				mtnSalesCodeCopyToCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 7/24/2013

LAST REVISION DATE: 	 7/24/2013

==============================================================================
DESCRIPTION:	Copies a Sales Code From one to Center to Another
==============================================================================
NOTES:
		* 07/24/13 MLM - Created Stored Proc
		* 08/20/13 MLM - Fixed cfgSalesCodeMembership
==============================================================================
SAMPLE EXECUTION:
EXEC mtnSalesCodeCopyToCenter 207, 218, NULL
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnSalesCodeCopyToCenter]
    @FromCenterID              INT
  , @ToCenterID                INT
  , @SalesCodeDescriptionShort NVARCHAR(15)
AS
    BEGIN
        SET NOCOUNT ON ;

        DECLARE @SalesCodeID INT ;

        -- Get the SalesCodeID
        SELECT @SalesCodeID = [SalesCodeID]
        FROM [dbo].[cfgSalesCode]
        WHERE [SalesCodeDescriptionShort] = @SalesCodeDescriptionShort ;

        --Update Existing cfgSalesCodeCenter Records
        UPDATE [sccNew]
        SET
            [sccNew].[PriceRetail] = [scc].[PriceRetail]
          , [sccNew].[TaxRate1ID] = [ToTr1].[CenterTaxRateID]
          , [sccNew].[TaxRate2ID] = [ToTr2].[CenterTaxRateID]
          , [sccNew].[QuantityMaxLevel] = [scc].[QuantityMaxLevel]
          , [sccNew].[QuantityMinLevel] = [scc].[QuantityMinLevel]
          , [sccNew].[IsActiveFlag] = [scc].[IsActiveFlag]
          , [sccNew].[LastUpdate] = GETUTCDATE()
          , [sccNew].[LastUpdateUser] = 'sa'
        FROM [dbo].[cfgSalesCodeCenter] AS [scc]
        INNER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [scc].[SalesCodeID] = [sccNew].[SalesCodeID] AND [sccNew].[CenterID] = @ToCenterID
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr1] ON [scc].[TaxRate1ID] = [tr1].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr2] ON [scc].[TaxRate2ID] = [tr2].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr1] ON [tr1].[TaxTypeID] = [ToTr1].[TaxTypeID] AND @ToCenterID = [ToTr1].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr2] ON [tr2].[TaxTypeID] = [ToTr2].[TaxTypeID] AND @ToCenterID = [ToTr2].[CenterID]
        WHERE [scc].[CenterID] = @FromCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) ;

        -- Update Existing cfgSalesCodeMembership
        UPDATE [scmNew]
        SET
            [scmNew].[Price] = [scm].[Price]
          , [scmNew].[TaxRate1ID] = [ToTr1].[CenterTaxRateID]
          , [scmNew].[TaxRate2ID] = [ToTr2].[CenterTaxRateID]
          , [scmNew].[LastUpdate] = GETUTCDATE()
          , [scmNew].[LastUpdateUser] = 'sa'
        FROM [dbo].[cfgSalesCodeCenter] AS [scc]
        INNER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [sccNew].[CenterID] = @ToCenterID AND [sccNew].[SalesCodeID] = [scc].[SalesCodeID]
        INNER JOIN [dbo].[cfgSalesCodeMembership] AS [scm] ON [scm].[SalesCodeCenterID] = [scc].[SalesCodeCenterID]
        INNER JOIN [dbo].[cfgSalesCodeMembership] AS [scmNew] ON [sccNew].[SalesCodeCenterID] = [scmNew].[SalesCodeCenterID] AND [scm].[MembershipID] = [scmNew].[MembershipID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr1] ON [scm].[TaxRate1ID] = [tr1].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr2] ON [scm].[TaxRate2ID] = [tr2].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr1] ON [tr1].[TaxTypeID] = [ToTr1].[TaxTypeID] AND @ToCenterID = [ToTr1].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr2] ON [tr2].[TaxTypeID] = [ToTr2].[TaxTypeID] AND @ToCenterID = [ToTr2].[CenterID]
        WHERE [scc].[CenterID] = @FromCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) ;

        --Insert Missing cfgSalesCodeCenter Records
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
          , 'sa' AS [CreateUser]
          , GETUTCDATE() AS [LastUpdate]
          , 'sa' AS [LastUpdateUser]
        FROM [dbo].[cfgSalesCodeCenter] AS [scc]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr1] ON [scc].[TaxRate1ID] = [tr1].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr2] ON [scc].[TaxRate2ID] = [tr2].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr1] ON [tr1].[TaxTypeID] = [ToTr1].[TaxTypeID] AND @ToCenterID = [ToTr1].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr2] ON [tr2].[TaxTypeID] = [ToTr2].[TaxTypeID] AND @ToCenterID = [ToTr2].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [scc].[SalesCodeID] = [sccNew].[SalesCodeID] AND [sccNew].[CenterID] = @ToCenterID
        WHERE [scc].[CenterID] = @FromCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) AND [sccNew].[SalesCodeCenterID] IS NULL ;

        -- Insert Missing cfgSalesCodeMembership
        INSERT INTO [dbo].[cfgSalesCodeMembership]( [SalesCodeCenterID], [MembershipID], [Price], [TaxRate1ID], [TaxRate2ID], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
        SELECT
            [sccNew].[SalesCodeCenterID]
          , [scm].[MembershipID]
          , [scm].[Price]
          , [ToTr1].[CenterTaxRateID]
          , [ToTr2].[CenterTaxRateID]
          , [scm].[IsActiveFlag]
          , GETUTCDATE() AS [CreateDate]
          , 'sa' AS [CreateUser]
          , GETUTCDATE() AS [LastUpdate]
          , 'sa' AS [LastUpateUser]
        FROM [dbo].[cfgSalesCodeCenter] AS [scc]
        INNER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [sccNew].[CenterID] = @ToCenterID AND [sccNew].[SalesCodeID] = [scc].[SalesCodeID]
        INNER JOIN [dbo].[cfgSalesCodeMembership] AS [scm] ON [scm].[SalesCodeCenterID] = [scc].[SalesCodeCenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr1] ON [scm].[TaxRate1ID] = [tr1].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [tr2] ON [scm].[TaxRate2ID] = [tr2].[CenterTaxRateID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr1] ON [tr1].[TaxTypeID] = [ToTr1].[TaxTypeID] AND @ToCenterID = [ToTr1].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ToTr2] ON [tr2].[TaxTypeID] = [ToTr2].[TaxTypeID] AND @ToCenterID = [ToTr2].[CenterID]
        LEFT OUTER JOIN [dbo].[cfgSalesCodeMembership] AS [scmNew] ON [sccNew].[SalesCodeCenterID] = [scmNew].[SalesCodeCenterID] AND [scm].[MembershipID] = [scmNew].[MembershipID]
        WHERE [scc].[CenterID] = @FromCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) AND [scmNew].[SalesCodeMembershipID] IS NULL ;

        --Remove cfgSalesCodeMembership Records Which are not in copied Center
        DELETE FROM [dbo].[cfgSalesCodeMembership]
        WHERE [SalesCodeCenterID] IN( SELECT [scc].[SalesCodeCenterID]
                                      FROM [dbo].[cfgSalesCodeCenter] AS [scc]
                                      LEFT OUTER JOIN [dbo].[cfgSalesCodeCenter] AS [sccOld] ON [sccOld].[CenterID] = @FromCenterID AND [sccOld].[SalesCodeID] = [scc].[SalesCodeID]
                                      WHERE [scc].[CenterID] = @ToCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) AND [sccOld].[SalesCodeCenterID] IS NULL ) ;

        --Remove cfgSalesCodeCenter records where are not part of copied center
        DELETE FROM [dbo].[cfgSalesCodeCenter]
        WHERE [SalesCodeCenterID] IN( SELECT [scc].[SalesCodeCenterID]
                                      FROM [dbo].[cfgSalesCodeCenter] AS [scc]
                                      LEFT OUTER JOIN [dbo].[cfgSalesCodeCenter] AS [sccOld] ON [sccOld].[CenterID] = @FromCenterID AND [sccOld].[SalesCodeID] = [scc].[SalesCodeID]
                                      WHERE [scc].[CenterID] = @ToCenterID AND ( [scc].[SalesCodeID] = @SalesCodeID OR @SalesCodeID IS NULL ) AND [sccOld].[SalesCodeCenterID] IS NULL ) ;
    END ;
GO
