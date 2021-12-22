/* CreateDate: 02/03/2014 08:50:45.010 , ModifyDate: 04/04/2016 08:27:52.207 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				mtnCreateInterCompanyTransaction
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		01/27/2014
LAST REVISION DATE: 	02/05/2014
--------------------------------------------------------------------------------------------------------
NOTES: 	If cONEct Franchise or JV Center and Inter-Company transaction does not already exist for appointment,
		creates a new transaction record.

		* 01/27/14 MVT - Created
		* 03/23/16 SAL - Added 'HCSL' and 'SOL' to the accumulators that will write an InterCompany Transaction
		* 03/24/16 SAL - Modified how we select what is inserted into the @InterCoSalesCodes temp table.  Changed
						 to account for the following two scenarios:
							1. If InterCompanyPrice <> 0 AND the sales code is associated with an accumulator
								with it's IsEligibleForInterCompanyTransaction flag set to true AND there was an
								accumulator adjustment record written for the client.  This scenario was already
								being accounted for, but the accums it was looking for were hardcoded.
							2. If InterCompanyPrice <> 0 AND the sales code is NOT associate with any accumulators
								with their IsEligibleForInterCompanyTransaction flag set to true AND the client was
								not charged for the item.  This scenario was not being accounted for and is new.
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC mtnCreateInterCompanyTransaction '7CCE1E97-CC00-4425-8B59-3B7081C60E3F', '12CCF58B-5D4F-4B39-8222-232BA6E99B33', 'mike'
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnCreateInterCompanyTransaction]
	@SalesOrderGUID uniqueidentifier,
	@AppointmentGUID uniqueidentifier,
	@User nvarchar(25) = 'sa-InterCo'

AS
BEGIN

	DECLARE @CenterBusinessTypeDescriptionShort nvarchar(10)

	SELECT @CenterBusinessTypeDescriptionShort = bt.CenterBusinessTypeDescriptionShort
		FROM datAppointment a
			INNER JOIN cfgConfigurationCenter cc ON a.CenterId = cc.CenterId
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeId = cc.CenterBusinessTypeId
		WHERE a.AppointmentGuid =  @AppointmentGUID

	-- Only create record if center is cONEct Franchise or cONEct JV
	IF (@CenterBusinessTypeDescriptionShort = 'cONEctFran' OR @CenterBusinessTypeDescriptionShort = 'cONEctJV')
	BEGIN

		-- Only insert an inter-company transaction if does not exist for the appointment.
		IF NOT EXISTS (SELECT * FROM datInterCompanyTransaction WHERE AppointmentGUID = @AppointmentGUID)
		BEGIN

			DECLARE @InterCoSalesCodes TABLE
			(
			  SalesOrderDetailGUID uniqueidentifier,
			  SalesCodeID int,
			  InerCompanyPrice money,
			  Quantity int
			)

			--******************************************************************************************
			--1.  Insert if InterCompanyPrice <> 0 AND the sales code is associated with an accumulator
			--with it's IsEligibleForInterCompanyTransaction flag set to true AND there was an
			--accumulator adjustment record written for the client.
			--******************************************************************************************
			INSERT INTO @InterCoSalesCodes
			(SalesOrderDetailGUID, SalesCodeID, InerCompanyPrice, Quantity)
			SELECT	sod.SalesOrderDetailGUID,
					sod.SalesCodeID,
					sc.InterCompanyPrice,
					aa.QuantityUsedAdjustment
			FROM datSalesOrder so
					INNER JOIN datSalesOrderDetail sod ON sod.SalesOrderGUID = so.SalesOrderGUID
					INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
					INNER JOIN cfgAccumulatorJoin aj on sc.SalesCodeID = aj.SalesCodeID
					INNER JOIN datAccumulatorAdjustment aa ON aa.SalesOrderDetailGUID = sod.SalesOrderDetailGUID
					INNER JOIN lkpAccumulatorActionType actType ON actType.AccumulatorActionTypeID = aa.AccumulatorActionTypeID
			WHERE so.SalesOrderGUID = @SalesOrderGUID
					AND sc.InterCompanyPrice > 0
					AND aj.IsEligibleForInterCompanyTransaction = 1
					AND actType.AccumulatorActionTypeDescriptionShort = 'Add'
					AND aa.QuantityUsedAdjustment > 0

			--*********************************************************************************************
			--2. Insert if InterCompanyPrice <> 0 AND the sales code is NOT associate with any accumulators
			--with their IsEligibleForInterCompanyTransaction flag set to true AND the client was not
			--charged for the item.
			--*********************************************************************************************
			INSERT INTO @InterCoSalesCodes
			(SalesOrderDetailGUID, SalesCodeID, InerCompanyPrice, Quantity)
			SELECT	sod.SalesOrderDetailGUID,
					sod.SalesCodeID,
					sc.InterCompanyPrice,
					sod.Quantity
			FROM datSalesOrder so
					INNER JOIN datSalesOrderDetail sod ON sod.SalesOrderGUID = so.SalesOrderGUID
					INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
			WHERE so.SalesOrderGUID = @SalesOrderGUID
					AND sc.InterCompanyPrice > 0
					AND sod.Price = 0
					AND sc.SalesCodeID not in (SELECT sc.SalesCodeID
												FROM datSalesOrder so
														INNER JOIN datSalesOrderDetail sod ON sod.SalesOrderGUID = so.SalesOrderGUID
														INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
														INNER JOIN cfgAccumulatorJoin aj on sc.SalesCodeID = aj.SalesCodeID
												WHERE so.SalesOrderGUID = @SalesOrderGUID
														AND sc.InterCompanyPrice > 0
														AND aj.IsActiveFlag = 1
														AND aj.IsEligibleForInterCompanyTransaction = 1)


			-- If inter-company sales codes exist, then create records.
			IF EXISTS (SELECT * FROM @InterCoSalesCodes)
			BEGIN
				DECLARE @InterCompanyTransactionId int

				INSERT INTO [dbo].[datInterCompanyTransaction]
					   ([CenterId]
					   ,[ClientHomeCenterId]
					   ,[TransactionDate]
					   ,[AppointmentGUID]
					   ,[SalesOrderGUID]
					   ,[ClientGUID]
					   ,[ClientMembershipGUID]
					   ,[IsClosed]
					   ,[CreateDate]
					   ,[CreateUser]
					   ,[LastUpdate]
					   ,[LastUpdateUser])
				 SELECT	a.CenterId
						,c.CenterId
						,GETUTCDATE()
						,@AppointmentGUID
						,@SalesOrderGUID
						,a.ClientGUID
						,a.ClientMembershipGUID
						,0
						,GETUTCDATE()
						,@User
						,GETUTCDATE()
						,@User
				 FROM datAppointment a
					INNER JOIN datClient c ON c.ClientGUID = a.ClientGUID
				 WHERE a.AppointmentGUID = @AppointmentGUID

				SELECT @InterCompanyTransactionId =SCOPE_IDENTITY()

				INSERT INTO [dbo].[datInterCompanyTransactionDetail]
					   ([InterCompanyTransactionId]
					   ,[SalesOrderDetailGUID]
					   ,[SalesCodeId]
					   ,[Quantity]
					   ,[Price]
					   ,[AmountCollected]
					   ,[CreateDate]
					   ,[CreateUser]
					   ,[LastUpdate]
					   ,[LastUpdateUser])
				 SELECT
						@InterCompanyTransactionId
						,SalesOrderDetailGUID
						,SalesCodeId
						,Quantity
						,InerCompanyPrice
						,0
						,GETUTCDATE()
						,@User
						,GETUTCDATE()
						,@User
					FROM @InterCoSalesCodes
			END
		END

	END
END
GO
