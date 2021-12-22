/* CreateDate: 09/20/2013 10:17:58.227 , ModifyDate: 03/19/2014 09:51:28.623 */
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
	* 3/17/2014 MLM - Added Logic to Reset ARBalance
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnResetAccumulatorsForClientMembership '8F1817C3-EE1A-4B88-AABC-135E73F7D07C', 'TFS #2178'
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnResetAccumulatorsForClientMembership]
	  @ClientMembershipGuid uniqueidentifier
	, @User nvarchar(25)
	, @ResetARBalance bit

AS
BEGIN

	SET NOCOUNT ON;


	BEGIN TRAN

		DECLARE @ARBalance money = 0.00

		IF @ResetARBalance = 1
			BEGIN
				--Clear the ARBalance
				UPDATE c
					SET	ARBalance = @ARBalance,
						LastUpdate = GETUTCDATE(),
						LastUpdateUser = @User
					FROM datClientMembership cm
						INNER JOIN datClient c ON cm.ClientGuid = c.ClientGuid
					WHERE cm.ClientMembershipGuid = @ClientMembershipGuid

			END
		ELSE
			BEGIN
				SELECT @ARBalance = ARBalance
				FROM datClientMembership cm
					INNER JOIN datClient c ON cm.ClientGuid = c.ClientGuid
				WHERE cm.ClientMembershipGuid = @ClientMembershipGuid
			END

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
				,@OrderDate DateTime
				,@IsBeginningBalance bit

		DECLARE A_Cursor CURSOR FAST_FORWARD FOR
				-- Find all duplicate Accumulator Adjustments that are Replace
				SELECT DISTINCT so.SalesOrderGuid, so.OrderDate, CONVERT(bit, case When sc.SAlesCodeDescriptionShort = 'BegBal' THEN 1 ElSE 0 END) as IsBeginningBalance
				FROM datSalesOrder so
					inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
					inner join cfgSalesCode sc on sod.SalescodeID = sc.SalesCodeID
				WHERE so.ClientMembershipGuid = @ClientMembershipGUID
					AND so.IsClosedFlag = 1
					AND so.IsVoidedFlag = 0
				ORDER BY so.OrderDate asc

		OPEN A_Cursor
		FETCH NEXT FROM A_Cursor INTO @SalesOrderGuid, @OrderDate, @IsBeginningBalance

		WHILE (@@FETCH_STATUS = 0)
			BEGIN

				if @IsBeginningBalance = 1
					BEGIN
						-- Reset Client Membership Accum for AR to $0.00
						UPDATE cmaccum SET
							cmaccum.[AccumMoney] = 0.0
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = 'sa'
						FROM datClientMembershipAccum cmaccum
							INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
							INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = cmaccum.ClientMembershipGuid
							INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
						WHERE accum.AccumulatorDescriptionShort = 'ARBal'
							AND cm.ClientMembershipGuid = @ClientMembershipGuid

						--Clear the ARBalance
						UPDATE c
							SET	c.ARBalance = 0.00,
								c.LastUpdate = GETUTCDATE(),
								c.LastUpdateUser = @User
							FROM datClientMembership cm
								INNER JOIN datClient c ON cm.ClientGuid = c.ClientGuid
							WHERE cm.ClientMembershipGuid = @ClientMembershipGuid
					END

					EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGuid

				-- Get Next  Record.
				FETCH NEXT FROM A_Cursor INTO @SalesOrderGuid, @OrderDate, @IsBeginningBalance
			END
		CLOSE A_Cursor
		DEALLOCATE A_Cursor


		IF @ResetARBalance = 0
			BEGIN
				-- Reset Client AR Balance
				UPDATE c SET
					ARBalance = @ARBalance,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @User
				FROM datClientMembership cm
					INNER JOIN datClient c ON cm.ClientGuid = c.ClientGuid
				WHERE cm.ClientMembershipGuid = @ClientMembershipGuid
			END

	-- Commit Transaction
	IF (@@TRANCOUNT > 0) BEGIN
		COMMIT TRAN -- Never makes it here because of the ROLLBACK
	END

END
GO
