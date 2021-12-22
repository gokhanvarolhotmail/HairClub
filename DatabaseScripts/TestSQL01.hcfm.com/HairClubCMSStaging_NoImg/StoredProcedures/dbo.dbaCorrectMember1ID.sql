/* CreateDate: 09/30/2011 14:54:24.803 , ModifyDate: 02/27/2017 09:49:15.927 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaCorrectMember1ID

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 09/21/2011

LAST REVISION DATE: 	 02/17/2012

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used to import Sales Transactions into CMS.
		* 09/21/2011 MLM - Created stored proc
		* 03/02/2015 MVT - Updated proc for Xtrands Business Segment
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbaCorrectMember1ID] 281
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaCorrectMember1ID] (
	@Center int
) AS
BEGIN

	SET NOCOUNT ON


	/*******************************************/
	--Audit the procedure start time
	/*******************************************/
	DECLARE @AuditID TABLE (AuditRecordID INT)

	INSERT INTO INFOSTORECONV.dbo.ConversionStatistics (
		CenterID
	,	ProcedureName
	,	BeginTime
	,	ExecutedBy)
	OUTPUT INSERTED.RecordID INTO @AuditID
	VALUES(
		@Center  --CenterID
	,	OBJECT_NAME(@@PROCID) --ProcedureName
	,	GETDATE() --BeginTime
	,	SUSER_NAME() --ExecutedBy
	)
	/*******************************************/


	--/***** Drop datClientMembership Constraints ******/
		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClientMembership_Client]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembership]'))
		ALTER TABLE [dbo].[datClientMembership] DROP CONSTRAINT [FK_ClientMembership_Client]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClientMembership_cfgCenter]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembership]'))
		ALTER TABLE [dbo].[datClientMembership] DROP CONSTRAINT [FK_datClientMembership_cfgCenter]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClientMembership_cfgMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembership]'))
		ALTER TABLE [dbo].[datClientMembership] DROP CONSTRAINT [FK_datClientMembership_cfgMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClientMembership_datClient]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembership]'))
		ALTER TABLE [dbo].[datClientMembership] DROP CONSTRAINT [FK_datClientMembership_datClient]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClientMembership_lkpClientMembershipStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembership]'))
		ALTER TABLE [dbo].[datClientMembership] DROP CONSTRAINT [FK_datClientMembership_lkpClientMembershipStatus]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClientMembership_lkpMembershipCancelReason]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembership]'))
		ALTER TABLE [dbo].[datClientMembership] DROP CONSTRAINT [FK_datClientMembership_lkpMembershipCancelReason]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datHairSystemOrderTransaction_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datHairSystemOrderTransaction]'))
		ALTER TABLE [dbo].[datHairSystemOrderTransaction] DROP CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datHairSystemOrderTransaction_datClientMembership_PreviousClientMembershipGUID]') AND parent_object_id = OBJECT_ID(N'[dbo].[datHairSystemOrderTransaction]'))
		ALTER TABLE [dbo].[datHairSystemOrderTransaction] DROP CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership_PreviousClientMembershipGUID]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datHairSystemOrder_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datHairSystemOrder]'))
		ALTER TABLE [dbo].[datHairSystemOrder] DROP CONSTRAINT [FK_datHairSystemOrder_datClientMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datHairSystemOrder_datClientMembership1]') AND parent_object_id = OBJECT_ID(N'[dbo].[datHairSystemOrder]'))
		ALTER TABLE [dbo].[datHairSystemOrder] DROP CONSTRAINT [FK_datHairSystemOrder_datClientMembership1]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClient_datClientMembership_CurrentBioMatrixClientMembershipGUID]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClient]'))
		ALTER TABLE [dbo].[datClient] DROP CONSTRAINT [FK_datClient_datClientMembership_CurrentBioMatrixClientMembershipGUID]


		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClient_datClientMembership_CurrentExtremeTherapyClientMembershipGUID]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClient]'))
		ALTER TABLE [dbo].[datClient] DROP CONSTRAINT [FK_datClient_datClientMembership_CurrentExtremeTherapyClientMembershipGUID]


		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClient_datClientMembership_CurrentSurgeryClientMembershipGUID]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClient]'))
		ALTER TABLE [dbo].[datClient] DROP CONSTRAINT [FK_datClient_datClientMembership_CurrentSurgeryClientMembershipGUID]


		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datClientMembershipAccum_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datClientMembershipAccum]'))
		ALTER TABLE [dbo].[datClientMembershipAccum] DROP CONSTRAINT [FK_datClientMembershipAccum_datClientMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datNotesClient_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datNotesClient]'))
		ALTER TABLE [dbo].[datNotesClient] DROP CONSTRAINT [FK_datNotesClient_datClientMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datAccumulatorAdjustment_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datAccumulatorAdjustment]'))
		ALTER TABLE [dbo].[datAccumulatorAdjustment] DROP CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datAppointment_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datAppointment]'))
		ALTER TABLE [dbo].[datAppointment] DROP CONSTRAINT [FK_datAppointment_datClientMembership]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datInventoryTransferRequest_datClientMembership_FromClientMembershipGUID]') AND parent_object_id = OBJECT_ID(N'[dbo].[datInventoryTransferRequest]'))
		ALTER TABLE [dbo].[datInventoryTransferRequest] DROP CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_FromClientMembershipGUID]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datInventoryTransferRequest_datClientMembership_ToClientMembershipGUID]') AND parent_object_id = OBJECT_ID(N'[dbo].[datInventoryTransferRequest]'))
		ALTER TABLE [dbo].[datInventoryTransferRequest] DROP CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_ToClientMembershipGUID]

		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_datSalesOrder_datClientMembership]') AND parent_object_id = OBJECT_ID(N'[dbo].[datSalesOrder]'))
		ALTER TABLE [dbo].[datSalesOrder] DROP CONSTRAINT [FK_datSalesOrder_datClientMembership]


	--/******  Drop datClientMembership Contraints ******/




      -- Cursor Variables
      DECLARE @ClientGUID char(36),
			@PrevClientGUID char(36),
			@CenterID int,
			@PrevCenterID int

	 Set @PrevClientGUID = NEWID()
	 SET @PrevCenterID = 0


            DECLARE @Client_Cursor cursor
            SET @Client_Cursor = CURSOR FAST_FORWARD FOR
				Select DISTINCT ClientGUID, CenterId
				from datClientMembership_Temp
				WHERE CenterId = @Center OR @Center IS NULL
				order by CenterId, ClientGUID

                  OPEN @Client_Cursor
                  FETCH NEXT FROM @Client_Cursor INTO @ClientGUID, @CenterId
            WHILE @@FETCH_STATUS = 0
              BEGIN
					IF( @PrevCenterId <> @CenterId OR @PrevClientGUID <> @ClientGUID )
					BEGIN

						-- Correct the Existing Records
						;With CM_Temp as
						(
							Select Row_number() over (Partition by CenterID, ClientGUID Order by CenterID, ClientGUID, BeginDate, EndDate) as rowNumber
								,*
							From datClientMembership_Temp cm
							Where cm.ClientGUID = @ClientGUID AND cm.CenterID = @CenterID
						)
						,ClientMembership AS
						(
							Select Row_number() over (Partition by CenterID, ClientGUID Order by CenterID, ClientGUID, BeginDate, EndDate) as rowNumber
								,*
							From datClientMembership cm
							Where cm.ClientGUID = @ClientGUID AND cm.CenterID = @CenterID
						)
						Update datClientMembership
							Set Member1_ID_Temp = cmt.Member1_ID_Temp
								,MembershipID = cmt.MembershipID
								,ClientMembershipStatusID = cmt.ClientMembershipStatusID
								,ContractPrice = cmt.ContractPrice
								,ContractPaidAmount = cmt.ContractPaidAmount
								,MonthlyFee = cmt.MonthlyFee
								,BeginDate = cmt.BeginDate
								,EndDate = cmt.EndDate
								,MembershipCancelReasonID = cmt.MembershipCancelReasonID
								,CancelDate = cmt.CancelDate
								,IsGuaranteeFlag = cmt.IsGuaranteeFlag
								,IsRenewalFlag = cmt.IsRenewalFlag
								,IsMultipleSurgeryFlag = cmt.IsMultipleSurgeryFlag
								,RenewalCount = cmt.RenewalCount
								,IsActiveFlag = cmt.IsActiveFlag
								,LastUpdate = GETDATE()
								,LastUpdateUser = 'sa-correct'
						From datClientMembership
							inner join ClientMembership cm on datClientMembership.ClientMembershipGUID = cm.ClientMembershipGUID
							inner join CM_Temp cmt on cm.ClientGUID = cmt.ClientGUID AND cm.CenterId = cmt.CenterId AND cm.rowNumber = cmt.rowNumber
						WHERE cm.Member1_ID_Temp <> cmt.Member1_ID_Temp
								OR cm.MembershipID <> cmt.MembershipID
								or cm.BeginDate <> cmt.BeginDate
								or cm.EndDate <> cmt.EndDate
								OR cm.ClientMembershipStatusID <> cmt.ClientMembershipStatusID


						--Insert Missing Records
						;With CM_Temp as
						(
							Select Row_number() over (Partition by CenterID, ClientGUID Order by CenterID, ClientGUID, BeginDate, EndDate) as rowNumber
								,*
							From datClientMembership_Temp cm
							Where cm.ClientGUID = @ClientGUID AND cm.CenterID = @CenterID
						)
						,ClientMembership AS
						(
							Select Row_number() over (Partition by CenterID, ClientGUID Order by CenterID, ClientGUID, BeginDate, EndDate) as rowNumber
								,*
							From datClientMembership cm
							Where cm.ClientGUID = @ClientGUID AND cm.CenterID = @CenterID
						)

						INSERT INTO datClientMembership(ClientMembershipGUID
										  ,Member1_ID_Temp
										  ,ClientGUID
										  ,CenterID
										  ,MembershipID
										  ,ClientMembershipStatusID
										  ,ContractPrice
										  ,ContractPaidAmount
										  ,MonthlyFee
										  ,BeginDate
										  ,EndDate
										  ,MembershipCancelReasonID
										  ,CancelDate
										  ,IsGuaranteeFlag
										  ,IsRenewalFlag
										  ,IsMultipleSurgeryFlag
										  ,RenewalCount
										  ,IsActiveFlag
										  ,CreateDate
										  ,CreateUser
										  ,LastUpdate
										  ,LastUpdateUser)
						Select cmt.ClientMembershipGUID
							,cmt.Member1_ID_Temp
							,cmt.ClientGUID
							,cmt.CenterID
							,cmt.MembershipID
							,cmt.ClientMembershipStatusID
							,cmt.ContractPrice
							,cmt.ContractPaidAmount
							,cmt.MonthlyFee
							,cmt.BeginDate
							,cmt.EndDate
							,cmt.MembershipCancelReasonID
							,cmt.CancelDate
							,cmt.IsGuaranteeFlag
							,cmt.IsRenewalFlag
							,cmt.IsMultipleSurgeryFlag
							,cmt.RenewalCount
							,cmt.IsActiveFlag
							,cmt.CreateDate
							,cmt.CreateUser
							,cmt.LastUpdate
							,cmt.LastUpdateUser
						From CM_Temp cmt
							left outer join ClientMembership cm on cm.ClientGUID = cmt.ClientGUID AND cm.CenterId = cmt.CenterId AND cm.rowNumber = cmt.rowNumber
							left outer join datClientMembership on cmt.ClientMembershipGUID  = datClientMembership.ClientMembershipGUID
						Where cm.ClientMembershipGUID IS NULL AND datClientMembership.ClientMembershipGUID IS NULL

						--Reassign Duplicates & Remove

						DECLARE @ClientMembershipGUID char(36)
						DECLARE @PrimaryMembershipGUID char(36)
						DECLARE @RowNumber int

						DECLARE @ClientMembership_Cursor cursor
						SET @ClientMembership_Cursor = CURSOR FAST_FORWARD FOR
							Select Row_number() over (Partition by CenterID, ClientGUID, Member1_ID_Temp Order by Member1_ID_Temp, CenterId, ClientGUID, MembershipId, ClientMembershipSTatusId, beginDate, EndDate) as rowNumber
									,ClientMembershipGUID
								From datClientMembership cm
							Where ISNULL(Member1_ID_Temp,0) <> 0
								AND cm.ClientGUID = @ClientGUID AND cm.CenterID = @CenterID

							  OPEN @ClientMembership_Cursor
							  FETCH NEXT FROM @ClientMembership_Cursor INTO @RowNumber, @ClientMembershipGUID
						WHILE @@FETCH_STATUS = 0
						  BEGIN
							IF (@RowNumber = 1)
							  BEGIN
								SET @PrimaryMembershipGUID = @ClientMembershipGUID
							  END
							ELSE
							  BEGIN
								--Reassign ClientMemberships
								Update datAppointment
									SET ClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datAppointment
								WHERE ClientMembershipGUID = @ClientMembershipGUID

								UPDATE datClient
									SET CurrentBioMatrixClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datClient
								Where CurrentBioMatrixClientMembershipGUID = @ClientMembershipGUID

								UPDATE datClient
									SET CurrentExtremeTherapyClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datClient
								Where CurrentExtremeTherapyClientMembershipGUID  = @ClientMembershipGUID

								UPDATE datClient
									SET CurrentXtrandsClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datClient
								Where CurrentXtrandsClientMembershipGUID  = @ClientMembershipGUID

								UPDATE datClient
									SET CurrentSurgeryClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datClient
								Where CurrentSurgeryClientMembershipGUID = @ClientMembershipGUID

								Update datClientEFT
									SET ClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datClientEFT
								Where ClientMembershipGUID = @ClientMembershipGUID

								Update datHairSystemOrder
									SET ClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datHairSystemOrder
								Where ClientMembershipGUID = @ClientMembershipGUID

								Update datHairSystemOrder
									SET OriginalClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datHairSystemOrder
								Where OriginalClientMembershipGUID = @ClientMembershipGUID

								Update datClientMembershipAccum
									SET ClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datClientMembershipAccum
								Where ClientMembershipGUID = @ClientMembershipGUID

								Update datHairSystemOrderTransaction
									SET ClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datHairSystemOrderTransaction
								Where ClientMembershipGUID = @ClientMembershipGUID

								Update datHairSystemOrderTransaction
									SET PreviousClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datHairSystemOrderTransaction
								Where PreviousClientMembershipGUID = @ClientMembershipGUID

								UPDATE datInventoryTransferRequest
									SET ToClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datInventoryTransferRequest
								Where ToClientMembershipGUID = @ClientMembershipGUID

								UPDATE datInventoryTransferRequest
									SET FromClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datInventoryTransferRequest
								Where FromClientMembershipGUID = @ClientMembershipGUID

								UPDATE datNotesClient
									SET ClientMembershipGUID = @PrimaryMembershipGUID
										,LastUpdate = GETDATE()
										,LastUpdateUser = 'sa'
								FROM datNotesClient
								Where ClientMembershipGUID = @ClientMembershipGUID

								--Remove ClientMembership
								DELETE FROM datClientMembership
								Where ClientMembershipGUID = @ClientMembershipGUID

								--Remove ClientMembership
								DELETE FROM datClientMembership_Temp
								Where ClientMembershipGUID = @ClientMembershipGUID

							  END

						  FETCH NEXT FROM @ClientMembership_Cursor INTO @RowNumber, @ClientMembershipGUID
						  END

						CLOSE @ClientMembership_Cursor
						DEALLOCATE @ClientMembership_Cursor


					END

					SET @PrevCenterId = @CenterId
					SEt @PrevClientGUID = @ClientGUID

                  FETCH NEXT FROM @Client_Cursor INTO @ClientGUID, @CenterId
              END

            CLOSE @Client_Cursor
            DEALLOCATE @Client_Cursor


		/**** Add Contraints to datClientMembership
		ALTER TABLE [dbo].[datClientMembership]  WITH CHECK ADD  CONSTRAINT [FK_ClientMembership_Client] FOREIGN KEY([ClientGUID])
		REFERENCES [dbo].[datClient] ([ClientGUID])


		ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_ClientMembership_Client]


		ALTER TABLE [dbo].[datClientMembership]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembership_cfgCenter] FOREIGN KEY([CenterID])
		REFERENCES [dbo].[cfgCenter] ([CenterID])


		ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_cfgCenter]


		ALTER TABLE [dbo].[datClientMembership]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembership_cfgMembership] FOREIGN KEY([MembershipID])
		REFERENCES [dbo].[cfgMembership] ([MembershipID])


		ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_cfgMembership]


		ALTER TABLE [dbo].[datClientMembership]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembership_datClient] FOREIGN KEY([ClientGUID])
		REFERENCES [dbo].[datClient] ([ClientGUID])


		ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_datClient]


		ALTER TABLE [dbo].[datClientMembership]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembership_lkpClientMembershipStatus] FOREIGN KEY([ClientMembershipStatusID])
		REFERENCES [dbo].[lkpClientMembershipStatus] ([ClientMembershipStatusID])


		ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_lkpClientMembershipStatus]


		ALTER TABLE [dbo].[datClientMembership]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembership_lkpMembershipCancelReason] FOREIGN KEY([MembershipCancelReasonID])
		REFERENCES [dbo].[lkpMembershipCancelReason] ([MembershipCancelReasonID])


		ALTER TABLE [dbo].[datClientMembership] CHECK CONSTRAINT [FK_datClientMembership_lkpMembershipCancelReason]


		ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership]


		ALTER TABLE [dbo].[datHairSystemOrderTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership_PreviousClientMembershipGUID] FOREIGN KEY([PreviousClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datHairSystemOrderTransaction] CHECK CONSTRAINT [FK_datHairSystemOrderTransaction_datClientMembership_PreviousClientMembershipGUID]


		ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datClientMembership]


		ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datClientMembership1] FOREIGN KEY([OriginalClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datClientMembership1]


		ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentBioMatrixClientMembershipGUID] FOREIGN KEY([CurrentBioMatrixClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentBioMatrixClientMembershipGUID]


		ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentExtremeTherapyClientMembershipGUID] FOREIGN KEY([CurrentExtremeTherapyClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentExtremeTherapyClientMembershipGUID]


		ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentSurgeryClientMembershipGUID] FOREIGN KEY([CurrentSurgeryClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentSurgeryClientMembershipGUID]


		ALTER TABLE [dbo].[datClientMembershipAccum]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAccum_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])


		ALTER TABLE [dbo].[datClientMembershipAccum] CHECK CONSTRAINT [FK_datClientMembershipAccum_datClientMembership]

		ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])

		ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datClientMembership]

		ALTER TABLE [dbo].[datAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])

		ALTER TABLE [dbo].[datAccumulatorAdjustment] CHECK CONSTRAINT [FK_datAccumulatorAdjustment_datClientMembership]

		ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])

		ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_datClientMembership]

		ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_FromClientMembershipGUID] FOREIGN KEY([FromClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])

		ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_FromClientMembershipGUID]

		ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_ToClientMembershipGUID] FOREIGN KEY([ToClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])

		ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_ToClientMembershipGUID]

		ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
		REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])

		ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datClientMembership]

		--Add Contraints to datClientMembership *****/


	/*******************************************/
	--Audit the procedure end time
	/*******************************************/
	UPDATE INFOSTORECONV.dbo.ConversionStatistics
	SET EndTime = GETDATE()
	,	ExecutedBY = SUSER_NAME()
	,	DBName = 'HairClubCMS'
	,	islatest = 1
	WHERE RecordID = (SELECT AuditRecordID FROM @AuditID)
	/*******************************************/

END
GO
