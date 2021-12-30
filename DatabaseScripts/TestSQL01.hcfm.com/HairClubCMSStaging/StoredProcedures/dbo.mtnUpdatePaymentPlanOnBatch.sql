/* CreateDate: 08/29/2016 07:23:55.560 , ModifyDate: 08/29/2016 07:23:55.560 */
GO
/*
==============================================================================
PROCEDURE:				mtnUpdatePaymentPlanOnBatch

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		08/16/2016

LAST REVISION DATE: 	08/16/2016

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
		* 08/16/2016 MLM - Created

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnUpdatePaymentPlanOnBatch] '3026E54D-02C7-4F74-914E-42758BDD976A', 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnUpdatePaymentPlanOnBatch]
(
	@BatchGuid uniqueidentifier,
	@IsDeclineBatch bit,
	@User nvarchar(25)
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRAN

	DECLARE @SalesOrders TABLE (
	 RowID int IDENTITY(1, 1) NOT NULL,
	 SalesOrderGuid uniqueidentifier NOT NULL,
	 PRIMARY KEY (RowID)
	)

	DECLARE @NumberRecords int, @RowCount int
	DECLARE @SalesOrderGuid uniqueidentifier

	-- Only insert sales orders if the Center is Live (has full access).
	INSERT INTO @SalesOrders (SalesOrderGuid)
		SELECT so.SalesOrderGuid
		FROM datSalesOrder so
			INNER JOIN cfgConfigurationCenter cnt ON so.CenterID = cnt.CenterID
			inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
			inner join cfgSalesCode sc on sod.SalesCodeId = sc.SalesCodeId
		WHERE cnt.HasFullAccess = 1
			AND so.IsVoidedFlag = 0
			AND sc.SalesCodeDescriptionShort in ('MTHPLANPMT','PAYPLANPMT')
			AND ((@IsDeclineBatch = 1 AND so.CenterDeclineBatchGUID = @BatchGuid)
				OR (@IsDeclineBatch = 0 AND so.CenterDeclineBatchGUID IS NULL AND so.CenterFeeBatchGUID = @BatchGuid))


	-- Get the number of records in the temporary table
	SET @NumberRecords = @@ROWCOUNT
	SET @RowCount = 1

	WHILE @RowCount <= @NumberRecords
	BEGIN
		SELECT @SalesOrderGuid = SalesOrderGuid
		FROM @SalesOrders
		WHERE RowID = @RowCount

		EXEC [dbo].[mtnPaymentPlanUpdate] @SalesOrderGUID, @User

		SET @RowCount = @RowCount + 1
	END

	IF (@@TRANCOUNT > 0) BEGIN
		COMMIT TRAN -- Never makes it here cause of the ROLLBACK
	END

END
GO
