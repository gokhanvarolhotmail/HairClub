/* CreateDate: 03/14/2013 23:16:13.430 , ModifyDate: 06/18/2015 11:05:40.170 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				mtnExecuteAccumulatorsOnBatch

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		03/12/2013

LAST REVISION DATE: 	03/12/2013

==============================================================================
DESCRIPTION:	Runs each sales order in the batch through the accumulator proc.
==============================================================================
NOTES:
		* 03/12/2013 MVT - Created
		* 06/17/2015 MVT - Modified to exclude Voided Orders

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnExecuteAccumulatorsOnBatch] '3026E54D-02C7-4F74-914E-42758BDD976A', 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnExecuteAccumulatorsOnBatch]
(
	@BatchGuid uniqueidentifier,
	@IsDeclineBatch bit
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
		WHERE cnt.HasFullAccess = 1
			AND so.IsVoidedFlag = 0
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

		EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGuid

		SET @RowCount = @RowCount + 1
	END

	IF (@@TRANCOUNT > 0) BEGIN
		COMMIT TRAN -- Never makes it here cause of the ROLLBACK
	END

END
GO
