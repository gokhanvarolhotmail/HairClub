/* CreateDate: 02/18/2014 14:56:52.753 , ModifyDate: 02/18/2014 14:56:52.753 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnResetAccumulatorsForClientMembership

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		09/18/2013

LAST REVISION DATE: 	09/18/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Resets accumulators for the client membership.
	* 9/18/2013	MVT - Created

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnResetAccumulatorsForClientMembership '8F1817C3-EE1A-4B88-AABC-135E73F7D07C', 'TFS #2178'
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnResetAccumulatorsForClientMembership2]
	  @ClientMembershipGuid uniqueidentifier
	, @SalesOrder_BeginningBalance uniqueidentifier
	, @ARBalance money
	, @User nvarchar(25)

AS
BEGIN

	SET NOCOUNT ON;


	BEGIN TRAN


		PRINT 'Processing Client Membership: ' + CAST(@ClientMembershipGuid AS varchar(50))
		PRINT 'AR Balance: ' + CAST(@ARBalance AS varchar(50))
		PRINT ''

		-- Delete all accumulator transactions for the membership
		DELETE FROM datAccumulatorAdjustment WHERE ClientMembershipGuid = @ClientMembershipGuid

		-- Clear Contract Paid Amount
		UPDATE datClientMembership SET
			ContractPaidAmount = 0.00,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE ClientMembershipGuid = @ClientMembershipGuid

		UPDATE datClientMembershipAccum SET
			UsedAccumQuantity = 0,
			AccumMoney = 0.00,
			AccumDate = NULL,
			TotalAccumQuantity = 0,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE ClientMembershipGuid = @ClientMembershipGuid

		--Create Client Membership Accumulator records if missing
		INSERT INTO [datClientMembershipAccum]
			([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],
				[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
		SELECT NEWID(), @ClientMembershipGUID, ma.AccumulatorID, 0, 0.00, NULL, ma.InitialQuantity,
			GETUTCDATE(),@User,GETUTCDATE(),@User
		FROM datClientMembership cm
			INNER JOIN cfgMembershipAccum ma ON cm.MembershipID = ma.MembershipID
			LEFT JOIN datClientMembershipAccum cma ON cma.ClientMembershipGuid = cm.ClientMembershipGuid AND cma.AccumulatorID = ma.AccumulatorID
		WHERE cm.ClientMembershipGUID = @ClientMembershipGuid
			AND cma.ClientMembershipAccumGuid IS NULL
			AND ma.IsActiveFlag = 1


		-- Update initial Quantity
		UPDATE cma SET
			TotalAccumQuantity = ma.InitialQuantity,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		FROM datClientMembershipAccum cma
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = cma.ClientMembershipGuid
			INNER JOIN cfgMembershipAccum ma ON ma.MembershipID = cm.MembershipID AND cma.AccumulatorID = ma.AccumulatorID
		WHERE cma.ClientMembershipGUID = @ClientMembershipGuid

		-- Run all SO's through accumulators.

		--CURSOR VARIABLES
		DECLARE @SalesOrderGuid uniqueidentifier

		DECLARE A_Cursor CURSOR FAST_FORWARD FOR
				-- Find all duplicate Accumulator Adjustments that are Replace
				SELECT so.SalesOrderGuid
				FROM datSalesOrder so
				WHERE so.ClientMembershipGuid = @ClientMembershipGUID
					AND so.IsClosedFlag = 1
					AND so.IsVoidedFlag = 0
				ORDER BY so.OrderDate asc

		OPEN A_Cursor
		FETCH NEXT FROM A_Cursor INTO @SalesOrderGuid

		WHILE (@@FETCH_STATUS = 0)
			BEGIN

				EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGuid

				IF @SalesOrderGUID = @SalesOrder_BeginningBalance
					BEGIN
								Update c
									SET ARBalance = 0
										,Lastupdate = GETUTCDATE()
										,LastupdateUser = 'TFS2683'
								FROM datClientMembership cm
									INNER JOIN datClient c ON cm.ClientGuid = c.ClientGuid
								WHERE cm.ClientMembershipGuid = @ClientMembershipGuid
					END

				-- Get Next  Record.
				FETCH NEXT FROM A_Cursor INTO @SalesOrderGuid
			END
		CLOSE A_Cursor
		DEALLOCATE A_Cursor


		-- Reset Client AR Balance
		UPDATE c SET
			ARBalance = @ARBalance + ISNULL(ARBalance,0),
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		FROM datClientMembership cm
			INNER JOIN datClient c ON cm.ClientGuid = c.ClientGuid
		WHERE cm.ClientMembershipGuid = @ClientMembershipGuid


	-- Commit Transaction
	IF (@@TRANCOUNT > 0) BEGIN
		COMMIT TRAN -- Never makes it here because of the ROLLBACK
	END

END
GO
