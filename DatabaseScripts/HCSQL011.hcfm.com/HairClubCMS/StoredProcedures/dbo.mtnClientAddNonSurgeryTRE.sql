/* CreateDate: 02/20/2013 15:54:22.100 , ModifyDate: 05/21/2017 22:19:14.687 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnClientAddNonSurgeryTRE

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dan Lorenz

IMPLEMENTOR: 			Dan Lorenz

DATE IMPLEMENTED: 		3/20/09

LAST REVISION DATE: 	3/30/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds a new employee to the database.  USED BY TRE
	* 06/16/2010    PRM     Copied the original mtnClientAdd and created a non-surgery version for the demo,
						    I don't think this will be the long term solution, it should be incorporated into the application (remove proc) and create the membership dynamically
	* 04/12/2013    MVT     Added a check for "Is Active" when adding client membership accum records.
	* 04/27/2017    PRM     Updated to reference new datClientPhone table

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnClientAddNonSurgeryTRE '001', 301, 'Mr.', 'John', 'William', 'Smith', '100 Easy St', NULL, 'Madison', 'WI', '54321', '1/1/1970', 'M', 'email@somewhere.com', '123-456-7890'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnClientAddNonSurgeryTRE]
	  @ContactID nvarchar(50)
	, @CenterID as int
	, @Salutation nvarchar(10)
	, @FirstName nvarchar(50)
	, @MiddleName nvarchar(20)
	, @LastName nvarchar(50)
	, @Address1 nvarchar(50)
	, @Address2 nvarchar(50)
	, @City nvarchar(50)
	, @State nvarchar(2)
	, @Zip nvarchar(10)
	, @BirthDate datetime
	, @Gender nchar(1)
	, @Email nvarchar(100)
	, @PrimaryPhone nvarchar(15)
AS
BEGIN

	SET NOCOUNT ON;

	IF NOT EXISTS ( SELECT  *
					FROM    [datClient]
					WHERE   [ContactID] = @ContactID )
	  BEGIN
		DECLARE @ClientGUID uniqueidentifier
		DECLARE @ClientMembershipGUID uniqueidentifier
		DECLARE @NewMembershipID int
		DECLARE @ActiveClientMembershipStatusID int
		DECLARE @SalesOrderGUID uniqueidentifier
		DECLARE @SalesCodeID int
		DECLARE @TempInvoiceTable table
				(
					InvoiceNumber nvarchar(50)
				)
		DECLARE @InvoiceNumber nvarchar(50)


		SET @ClientGUID = NEWID()
		SET @ClientMembershipGUID = NEWID()
		SET @SalesOrderGUID = NEWID()
		SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'INITASG' --New Membership
		SELECT @NewMembershipID = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = 'TRADITION' --Traditional
		SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'

		--create an invoice #
		INSERT INTO @TempInvoiceTable
			EXEC ('mtnGetInvoiceNumber ' + @CenterID)

		SELECT TOP 1 @InvoiceNumber = InvoiceNumber
		FROM @TempInvoiceTable

		DELETE FROM @TempInvoiceTable


		--INSERT Client record
		INSERT INTO datClient (ClientGUID, ContactID, ClientNumber_Temp, CenterID, SalutationID, FirstName, MiddleName, LastName,  Address1, Address2, Address3, City, StateID, PostalCode, CountryID,
								ARBalance, DateOfBirth, GenderID, DoNotCallFlag, DoNotContactFlag, IsHairModelFlag, IsTaxExemptFlag, EMailAddress, TextMessageAddress, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT
			@ClientGUID AS ClientGUID,
			@ContactID AS ContactID,
			NULL AS ClientNumber_Temp,
			@CenterID AS CenterID,
			(SELECT s.SalutationID FROM lkpSalutation s WHERE s.SalutationDescription = @Salutation) AS SalutationID,
			@FirstName AS FirstName,
			@MiddleName AS MiddleName,
			@LastName AS LastName,
			@Address1 AS Address1,
			@Address2 AS Address2,
			NULL AS Address3,
			@City AS City,
			(SELECT s.StateID FROM lkpState s WHERE s.StateDescriptionShort = @State) AS StateID,
			@Zip AS PostalCode,
			(SELECT TOP 1 CountryID FROM cfgCenter WHERE CenterID = @CenterID) AS CountryID,
			0 AS ARBalance,
			CAST(@BirthDate AS date) AS DateOfBirth,
			CASE WHEN @Gender = 'F' THEN 2
				 ELSE 1	-- Default to male
			END AS GenderID,
			0 AS DoNotCallFlag, 0 AS DoNotContactFlag, 0 AS IsHairModelFlag, 0 AS IsTaxExemptFlag,
			@Email AS EMailAddress, NULL AS TextMessageAddress,
			GETUTCDATE() AS CreateDate, 'sa' AS CreateUser, GETUTCDATE() AS LastUpdate, 'sa' AS LastUpdateUser

			IF @PrimaryPhone IS NOT NULL AND RTRIM(LTRIM(@PrimaryPhone)) <> ''
			  BEGIN
				INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
					(@ClientGUID, 1, @PrimaryPhone, NULL, NULL, NULL, NULL, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa')
			  END

		--INSERT Client Membership record
		INSERT INTO datClientMembership (
			ClientMembershipGUID,
			Member1_ID_Temp,
			ClientGUID,
			CenterID,
			MembershipID,
			ClientMembershipStatusID,
			ContractPrice,
			ContractPaidAmount,
			MonthlyFee,
			BeginDate,
			EndDate,
			MembershipCancelReasonID,
			CancelDate,
			IsGuaranteeFlag,
			IsRenewalFlag,
			IsMultipleSurgeryFlag,
			RenewalCount,
			IsActiveFlag,
			CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT
			@ClientMembershipGUID AS  ClientMembershipGUID,
			NULL AS  Member1_ID_Temp,
			@ClientGUID AS  ClientGUID,
			@CenterID AS  CenterID,
			@NewMembershipID AS  MembershipID,
			@ActiveClientMembershipStatusID AS  ClientMembershipStatusID,
			0 AS  ContractPrice,
			0 AS  ContractPaidAmount,
			0 AS  MonthlyFee,
			GETDATE() AS  BeginDate,
			DATEADD(YEAR, 1, GETDATE())  AS  EndDate,
			NULL AS  MembershipCancelReasonID,
			NULL AS  CancelDate,
			0 AS  IsGuaranteeFlag,
			0 AS  IsRenewalFlag,
			0 AS  IsMultipleSurgeryFlag,
			0 AS  RenewalCount,
			1 AS  IsActiveFlag,
			GETUTCDATE() AS CreateDate, 'sa' AS CreateUser, GETUTCDATE() AS LastUpdate, 'sa' AS LastUpdateUser

		--hack, this is hardcoded to biomatrix for the demo
		UPDATE datClient
		SET CurrentBioMatrixClientMembershipGUID = @ClientMembershipGUID
		WHERE ClientGUID = @ClientGUID

		--Create Client Membership Accumulator records
		INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
		SELECT NEWID(), @ClientMembershipGUID, AccumulatorID, 0, 0.00, NULL, InitialQuantity,
			GETUTCDATE(),'sa',GETUTCDATE(),'sa'
		FROM cfgMembershipAccum
		WHERE MembershipID = @NewMembershipID
			AND IsActiveFlag = 1


		--INSERT Sales Order record
		INSERT INTO datSalesOrder (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID,
			SalesOrderTypeID, ClientGUID, ClientMembershipGUID, AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber,
			IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, RegisterCloseGUID, EmployeeGUID, FulfillmentNumber, IsWrittenOffFlag,
			IsRefundedFlag, RefundedSalesOrderGUID,
			CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT
			@SalesOrderGUID AS SalesOrderGUID,
			NULL AS TenderTransactionNumber_Temp, NULL AS TicketNumber_Temp,
			cm.CenterID AS CenterID, cm.CenterID AS ClientHomeCenterID,
			2 AS SalesOrderTypeID, --Membership
			cm.ClientGUID AS ClientGUID,
			cm.ClientMembershipGUID,
			NULL AS AppointmentGUID, NULL AS FactoryOrderGUID,
			GETUTCDATE() AS OrderDate,
			@InvoiceNumber AS InvoiceNumber,
			0 AS IsTaxExemptFlag, 0 AS IsVoidedFlag, 1 AS IsClosedFlag,
			NULL AS RegisterCloseGUID, c.EmployeeDoctorGUID AS EmployeeGUID, NULL AS FulfillmentNumber,
			0 AS IsWrittenOffFlag, 0 AS IsRefundedFlag, NULL AS RefundedSalesOrderGUID,
			GETUTCDATE() AS CreateDate, 'sa' AS CreateUser, GETUTCDATE() AS LastUpdate, 'sa' AS LastUpdateUser
		FROM datClientMembership cm
			INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
		WHERE cm.ClientMembershipGUID = @ClientMembershipGUID


		--INSERT Sales Order Detail record
		INSERT INTO datSalesOrderDetail ([SalesOrderDetailGUID],[TransactionNumber_Temp],[SalesOrderGUID],[SalesCodeID],
			[Quantity],[Price],[Discount],[Tax1],[Tax2],[TaxRate1],[TaxRate2],
			[IsRefundedFlag],[RefundedSalesOrderDetailGUID],[RefundedTotalQuantity],[RefundedTotalPrice],
			[Employee1GUID],[Employee2GUID],[Employee3GUID],[Employee4GUID],
			[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
		SELECT
			  NEWID() AS SalesOrderDetailGUID, NULL AS TransactionNumber_Temp
			, @SalesOrderGUID AS SalesOrderGUID
			, @SalesCodeID AS SalesCodeID
			, 0 AS [Quantity], 0 AS [Price], 0 AS [Discount]
			, 0 AS [Tax1], 0 AS [Tax2], 0 AS [TaxRate1], 0 AS [TaxRate2]
			, 0 AS [IsRefundedFlag], NULL AS [RefundedSalesOrderDetailGUID], 0 AS [RefundedTotalQuantity], 0 AS [RefundedTotalPrice]
			, c.EmployeeDoctorGUID AS [Employee1GUID], NULL AS [Employee2GUID], NULL AS [Employee3GUID], NULL AS [Employee4GUID]
			, GETUTCDATE() AS CreateDate, 'sa' AS CreateUser, GETUTCDATE() AS LastUpdate, 'sa' AS LastUpdateUser
		FROM datClientMembership cm
			INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
		WHERE cm.ClientMembershipGUID = @ClientMembershipGUID
	END
END
GO
