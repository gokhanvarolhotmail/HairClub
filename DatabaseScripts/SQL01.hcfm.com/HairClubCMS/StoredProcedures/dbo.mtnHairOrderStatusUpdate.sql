/* CreateDate: 05/24/2011 14:59:25.853 , ModifyDate: 02/27/2017 09:49:21.310 */
GO
/*
==============================================================================
PROCEDURE:				mtnHairOrderStatusUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 5/14/2011

LAST REVISION DATE: 	 10/5/2011

==============================================================================
DESCRIPTION:	Update Applied status from legacy system
==============================================================================
NOTES:
		* 5/14/11 MVT - Created Stored Proc
		* 5/26/11 MVT - Modified stored proc to populate applied date on the
							hair system order.
		* 10/5/11 KRM - Modified stored proc to exclude bvoided transactions
		* 01/5/12 KRM - Modified stored proc to exclude refunded transactions & Redos
		* 02/24/2012 MVT - updated insert into transaction to include CostFactoryShipped.
							- Renamed CostCenterWholesale to CenterPrice

==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairOrderStatusUpdate 287
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnHairOrderStatusUpdate]
	@CenterID int
AS
BEGIN


DECLARE @CMSUpdateUser as nvarchar(20)
SET @CMSUpdateUser = 'CMSUpdate'

/**************************************************************/
-- Select data to populate tmpCMSUpdate table from Infostore
/**************************************************************/

INSERT INTO [dbo].[tmpCMSUpdate]
       ([CenterId]
       ,[Client_no]
       ,[HairSystemOrderNumber]
       ,[CMS25Transact_no]
       ,[CMS25TransactionDate]
       ,[ProcessedDate]
       ,[IsSuccessful]
       ,[ErrorMessage]
       ,[ErrorCode]
       ,[CreateDate]
       ,[CreateUser]
       ,[LastUpdate]
       ,[LastUpdateUser])
  (SELECT
		t.center as CMS25Center,
		t.client_no as CMS25Client_no,
		t.factoryorderno as CMS25FactoryOrderNo,
		t.transact_no as CMS25Transact_no,
		t.[date] as 'CMS25TrxDate',
		null,
		null,
		null,
		null,
		GETUTCDATE(),
		@CMSUpdateUser,
		GETUTCDATE(),
		@CMSUpdateUser
	FROM [HCSQL2\SQL2005].Infostore.dbo.Transactions t
	WHERE t.code in ('nb1a', 'app')
		and t.Center = @CenterID
		and bvoided = 0
		and isnull(isrefund,0) = 0
		and t.transact_no > (SELECT ISNULL(MAX(CMS25Transact_no),0) FROM tmpCMSUpdate WHERE CenterId = @CenterID))


/**************************************************************/
-- Process each record that has not been processed
/**************************************************************/

DECLARE @CMSUpdateId as Int, @Client_no as Int, @HairSystemOrderNumber as Nvarchar(25),
	@CMS25TransactionDate as DateTime
DECLARE @AppliedStatusId as Int

SET @AppliedStatusId = (SELECT HairSystemOrderStatusID
							FROM lkpHairSystemOrderStatus
							WHERE HairSystemOrderStatusDescriptionShort = 'APPLIED')

DECLARE @CMSUpdate_Cursor cursor
SET @CMSUpdate_Cursor = CURSOR FAST_FORWARD FOR
		SELECT
			CMSUpdateId,
			Client_no,
			HairSystemOrderNumber,
			[CMS25TransactionDate]
		FROM  tmpCMSUpdate
		WHERE CenterId = @CenterID AND ProcessedDate is null

	OPEN @CMSUpdate_Cursor
	FETCH NEXT FROM @CMSUpdate_Cursor INTO @CMSUpdateId, @Client_no, @HairSystemOrderNumber, @CMS25TransactionDate

	WHILE @@FETCH_STATUS = 0
	BEGIN

	BEGIN TRANSACTION
	BEGIN TRY

		DECLARE @CurrentStatusId as Int, @CurrentStatusShortDesc as nvarchar(10), @CanApply Bit, @CurrentClientNo Int, @CurrentCenterNo Int

		-- Check the last character of the Hair System Order Number.  If the last character is not numeric,
		-- then it was generated by the scanner, remove it from the end of the number.
		IF (SELECT ISNUMERIC((select SUBSTRING(@HairSystemOrderNumber, LEN(@HairSystemOrderNumber), 1)))) = 0
		BEGIN
			SET @HairSystemOrderNumber = SUBSTRING(@HairSystemOrderNumber, 0, LEN(@HairSystemOrderNumber))
		END

		IF NOT EXISTS(SELECT * FROM datHairSystemOrder WHERE HairSystemOrderNumber = @HairSystemOrderNumber)
		BEGIN
			--- HSO not found
			UPDATE tmpCMSUpdate SET
				ProcessedDate = GETDATE(),
				IsSuccessful = 0,
				ErrorMessage = 'Hair Order # is not found',
				ErrorCode = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @CMSUpdateUser
			WHERE CMSUpdateId = @CMSUpdateId
		END
		ELSE
		BEGIN
			-- HSO found, select data
			SELECT
				@CurrentStatusId = h.HairSystemOrderStatusID,
				@CurrentStatusShortDesc = s.HairSystemOrderStatusDescriptionShort,
				@CanApply = s.CanApplyFlag,
				@CurrentCenterNo = h.CenterID,
				@CurrentClientNo = c.ClientNumber_Temp
			FROM datHairSystemOrder h
				INNER JOIN lkpHairSystemOrderStatus s
				ON h.HairSystemOrderStatusID = s.HairSystemOrderStatusID
				LEFT OUTER JOIN datClient c
				ON c.ClientGUID = h.ClientGUID
			WHERE h.HairSystemOrderNumber = @HairSystemOrderNumber

			---- Verify that HSO is not already applied
			--IF @CurrentStatusId = @AppliedStatusId
			--BEGIN
			--	-- Already Applied
			--	UPDATE tmpCMSUpdate SET
			--		ProcessedDate = GETUTCDATE(),
			--		IsSuccessful = 0,
			--		ErrorMessage = 'HSO already Applied in CMS 4.2.',
			--		LastUpdate = GETUTCDATE(),
			--		LastUpdateUser = @CMSUpdateUser
			--	WHERE CMSUpdateId = @CMSUpdateId
			--END

			-- Verify that HSO is in a status that can be Applied
			IF @CurrentStatusShortDesc not in ( 'Conversion', 'INVNS') AND (@CanApply is NULL OR @CanApply = 0)
			BEGIN
				-- HSO is in a status that cannot be applied.
				UPDATE tmpCMSUpdate SET
					ProcessedDate = GETDATE(),
					IsSuccessful = 0,
					ErrorMessage = 'Hair Order # is in [' + @CurrentStatusShortDesc + '] status and cannot be applied',
					ErrorCode = 2,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @CMSUpdateUser
				WHERE CMSUpdateId = @CMSUpdateId
			END
			-- Verify that the Center numbers match
			ELSE IF @CenterID <> @CurrentCenterNo
			BEGIN
				-- Client numbers do not match.
				UPDATE tmpCMSUpdate SET
					ProcessedDate = GETDATE(),
					IsSuccessful = 0,
					ErrorMessage = 'CMS 4.2 Center # [' + CAST(@CurrentCenterNo as varchar) + '] does not match CMS 2.5 Center # [' + CAST(@CenterID as varchar) + ']' ,
					ErrorCode = 3,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @CMSUpdateUser
				WHERE CMSUpdateId = @CMSUpdateId
			END
			-- Verify that Client numbers match
			ELSE IF @Client_no <> @CurrentClientNo
			BEGIN
				-- Client numbers do not match.
				UPDATE tmpCMSUpdate SET
					ProcessedDate = GETDATE(),
					IsSuccessful = 0,
					ErrorMessage = 'CMS 4.2 Client # [' + CAST(@CurrentClientNo as varchar) + '] does not match CMS 2.5 Client # [' + CAST(@Client_no as varchar) + ']' ,
					ErrorCode = 4,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @CMSUpdateUser
				WHERE CMSUpdateId = @CMSUpdateId
			END

			-- All Validations pass.  Update HSO and write out a transaction.
			ELSE
			BEGIN


				-- Convert Transaction date to UTC
				SET @CMS25TransactionDate =
					(SELECT DATEADD(Hour,
							CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
								THEN ( (tz.[UTCOffset] * -1) )
							WHEN DATEPART(WK, @CMS25TransactionDate) <= 10
											OR DATEPART(WK, @CMS25TransactionDate) >= 45
								THEN ( (tz.[UTCOffset] * -1) )
							ELSE ( ( (tz.[UTCOffset] * -1) ) - 1) END, @CMS25TransactionDate)
						FROM cfgCenter c
							INNER JOIN lkpTimeZone tz
							ON c.TimeZoneID = tz.TimeZoneID
						WHERE c.CenterID = @CenterID)

				-- Update Hair System Order status
				UPDATE datHairSystemOrder SET
					HairSystemOrderStatusID = @AppliedStatusId,
					AppliedDate = @CMS25TransactionDate,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @CMSUpdateUser
				WHERE HairSystemOrderNumber = @HairSystemOrderNumber

				-- Write Status changed transaction
				INSERT INTO [dbo].[datHairSystemOrderTransaction]
				   ([HairSystemOrderTransactionGUID]
				   ,[CenterID]
				   ,[ClientHomeCenterID]
				   ,[ClientGUID]
				   ,[ClientMembershipGUID]
				   ,[HairSystemOrderTransactionDate]
				   ,[HairSystemOrderProcessID]
				   ,[HairSystemOrderGUID]
				   ,[PreviousCenterID]
				   ,[PreviousClientMembershipGUID]
				   ,[PreviousHairSystemOrderStatusID]
				   ,[NewHairSystemOrderStatusID]
				   ,[InventoryShipmentDetailGUID]
				   ,[InventoryTransferRequestGUID]
				   ,[PurchaseOrderDetailGUID]
				   ,[CostContract]
				   ,[PreviousCostContract]
				   ,[CostActual]
				   ,[PreviousCostActual]
				   ,[CenterPrice]
				   ,[PreviousCenterPrice]
				   ,[CostFactoryShipped]
				   ,[PreviousCostFactoryShipped]
				   ,[EmployeeGUID]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
			 (SELECT
					NEWID(),
					h.CenterId,
					h.ClientHomeCenterId,
					h.ClientGUID,
					h.ClientMembershipGUID,
					@CMS25TransactionDate,
					(Select HairSystemOrderProcessID
							FROM lkpHairSystemOrderProcess
							WHERE HairSystemOrderProcessDescriptionShort = 'ORDERENTRY'),
					h.HairSystemOrderGUID,
					h.CenterID,
					h.ClientMembershipGUID,
					@CurrentStatusId,
					h.HairSystemOrderStatusID,
					NULL,
					NULL,
					NULL,
					h.CostContract,
					h.CostContract,
					h.CostActual,
					h.CostActual,
					h.CenterPrice,
					h.CenterPrice,
					h.CostFactoryShipped,
					h.CostFactoryShipped,
					NULL,
					GETUTCDATE(),
					@CMSUpdateUser,
					GETUTCDATE(),
					@CMSUpdateUser
				FROM datHairSystemOrder h
				WHERE h.HairSystemOrderNumber = @HairSystemOrderNumber)

				-- Update CMS Update table as successful
				UPDATE tmpCMSUpdate SET
					ProcessedDate = GETDATE(),
					IsSuccessful = 1,
					ErrorMessage = NULL,
					ErrorCode = NULL,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @CMSUpdateUser
				WHERE CMSUpdateId = @CMSUpdateId

			END
		END

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- Roll back if exception occured
		ROLLBACK TRANSACTION

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		-- Update CMS Update table
		UPDATE tmpCMSUpdate SET
			ProcessedDate = GETDATE(),
			IsSuccessful = 0,
			ErrorMessage = 'Exception occured! ErrorMessage: [' + @ErrorMessage + '], ErrorSeverity: [' +
								@ErrorSeverity + '], ErrorState: [' + @ErrorState + ']',
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @CMSUpdateUser
		WHERE CMSUpdateId = @CMSUpdateId

	END CATCH


	FETCH NEXT FROM @CMSUpdate_Cursor INTO @CMSUpdateId, @Client_no, @HairSystemOrderNumber, @CMS25TransactionDate
	END

CLOSE @CMSUpdate_Cursor
DEALLOCATE @CMSUpdate_Cursor

END
GO
