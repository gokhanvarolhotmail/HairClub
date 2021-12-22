/***********************************************************************
PROCEDURE:				dbaFranchiseAcquisition
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
RELATED APPLICATION:	cONEct
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/14/2014
------------------------------------------------------------------------
NOTES:

10/14/2014 - DL - Created Stored Procedure for use in Franchise Acquisitions
11/03/2014 - DL - Created Stored Procedure on Live.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC dbaFranchiseAcquisition
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaFranchiseAcquisition]
(
	@CorporateCenterID INT,
    @FranchiseCenterID INT,
	@CenterDescription NVARCHAR(50),
	@IsActive BIT,
	@SurgeryHubCenterID INT,
	@ReportingCenterID INT,
	@RegionID INT,
	@CenterPayGroupID INT,
	@CenterTypeID INT,
	@OwnershipTypeID INT,
	@EmployeeDoctorGUID UNIQUEIDENTIFIER,
	@DoctorRegionID INT,

	@Address1 NVARCHAR(50),
	@Address2 NVARCHAR(50),
	@Address3 NVARCHAR(50),
	@City NVARCHAR(50),
	@StateID INT,
	@PostalCode NVARCHAR(10),
	@CountryID INT,
	@TimeZoneID INT,

	@Phone1 NVARCHAR(15),
	@Phone2 NVARCHAR(15),
	@Phone3 NVARCHAR(15),
	@Phone1TypeID INT,
	@Phone2TypeID INT,
	@Phone3TypeID INT,

	@SurgerySuiteCount INT,

	@TaxRate1 DECIMAL(6,5),
	@TaxRate2 DECIMAL(6,5),
	@TaxRate3 DECIMAL(6,5),
	@TaxRate4 DECIMAL(6,5),
	@TaxRate5 DECIMAL(6,5),
	@TaxRate6 DECIMAL(6,5),

	@SalesCodeCenterCopy INT,
	@IsSurgeryCenter BIT,
	@CopyCenterContractFrom_CenterID INT,
	@CopyFinanaceCompaniesFrom_CenterID INT,
	@CopyTrichoViewConfigurationFrom_CenterID INT,
	@CopyCenterMembershipsFrom_CenterID INT,

	@UseCreditCardProcessorFlag BIT,
	@GeneralLedgerID INT,
	@AccountingExportFreightBaseRate MONEY,
	@AccountingExportFreightPerItemRate MONEY,
	@FeeNotificationDays INT,
	@IsFeeProcessedCentrallyFlag BIT,
	@CenterBusinessTypeID INT,
	@HasFullAccess BIT,
	@IsSalesConsultationEnabled BIT,
	@IsSalesOrderRoundingEnabled BIT,
	@IsScheduleFeatureEnabled BIT,
	@IsFulfillmentEnabled BIT,
	@IsEnhSalesConsultEnabled BIT,

	@User NVARCHAR(25)
)
AS
BEGIN

SET IMPLICIT_TRANSACTIONS OFF;


DECLARE @Text NVARCHAR(1000)


BEGIN TRANSACTION

BEGIN TRY

SET @Text = 'Creating New cfgCenter Record: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

EXEC mtnCenterAdd
    @CorporateCenterID
,   @CenterDescription
,   @IsActive
,   @SurgeryHubCenterID
,   @ReportingCenterID
,   @RegionID
,   @CenterPayGroupID
,   @CenterTypeID
,   @OwnershipTypeID
,   @EmployeeDoctorGUID
,   @DoctorRegionID
,   @Address1
,   @Address2
,   @Address3
,   @City
,   @StateID
,   @PostalCode
,   @CountryID
,   @TimeZoneID
,   @Phone1
,   @Phone2
,   @Phone3
,   @Phone1TypeID
,   @Phone2TypeID
,   @Phone3TypeID
,   @SurgerySuiteCount
,   @TaxRate1
,   @TaxRate2
,   @TaxRate3
,   @TaxRate4
,   @TaxRate5
,   @TaxRate6
,   @SalesCodeCenterCopy
,   @IsSurgeryCenter
,   @CopyCenterContractFrom_CenterID
,   @CopyFinanaceCompaniesFrom_CenterID
,   @CopyTrichoViewConfigurationFrom_CenterID
,   @CopyCenterMembershipsFrom_CenterID
,   @UseCreditCardProcessorFlag
,   @GeneralLedgerID
,   @AccountingExportFreightBaseRate
,   @AccountingExportFreightPerItemRate
,   @FeeNotificationDays
,   @IsFeeProcessedCentrallyFlag
,   @CenterBusinessTypeID
,   @HasFullAccess
,   @IsSalesConsultationEnabled
,   @IsSalesOrderRoundingEnabled
,   @IsScheduleFeatureEnabled
,   @IsFulfillmentEnabled
,   @IsEnhSalesConsultEnabled
,   @User


SET @Text = 'Updating Old cfgCenter Record: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgCenter
SET     IsActiveFlag = 0
,		LastUpdate = GETUTCDATE()
,		LastUpdateUser = @User
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgCenterFeePayCycle Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgCenterFeePayCycle
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgCenterHoursException Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgCenterHoursException
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgConfigurationCenterPC Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgConfigurationCenterPC
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgHairSystemLocation Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgHairSystemLocation
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgRegister Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgRegister
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgResource Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgResource
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating cfgScheduleTemplate Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  cfgScheduleTemplate
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating CMSCreateClientLog Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSCreateClientLog
SET     CenterNumber = @CorporateCenterID
WHERE   CenterNumber = @FranchiseCenterID


SET @Text = 'Updating datAccountingExportBatchDetail Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datAccountingExportBatchDetail
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datAppointment Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datAppointment
SET     CenterID = @CorporateCenterID
,       ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID = @FranchiseCenterID


SET @Text = 'Updating datAppointment Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datAppointment
SET     ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ClientHomeCenterID = @FranchiseCenterID
        AND CenterID <> @FranchiseCenterID


SET @Text = 'Updating datAppointment Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datAppointment
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID <> @FranchiseCenterID


SET @Text = 'Updating datCenterFeeBatch Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datCenterFeeBatch
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datClient Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datClient
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datClientMembership Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datClientMembership
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datClientMembership_Temp Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datClientMembership_Temp
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datEmployee Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datEmployee
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datEmployeeCenter Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datEmployeeCenter
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datEmployeeVisitCenter Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datEmployeeVisitCenter
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datEndOfDay Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datEndOfDay
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrder Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrder
SET     CenterID = @CorporateCenterID
,       ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID = @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrder Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrder
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID <> @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrder Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrder
SET     ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ClientHomeCenterID = @FranchiseCenterID
        AND CenterID <> @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     CenterID = @CorporateCenterID
,       ClientHomeCenterID = @CorporateCenterID
,       PreviousCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID = @FranchiseCenterID
        AND PreviousCenterID = @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     CenterID = @CorporateCenterID
,       ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID = @FranchiseCenterID
        AND PreviousCenterID <> @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     CenterID = @CorporateCenterID
,       PreviousCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND PreviousCenterID = @FranchiseCenterID
        AND ClientHomeCenterID <> @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     ClientHomeCenterID = @CorporateCenterID
,       PreviousCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ClientHomeCenterID = @FranchiseCenterID
        AND PreviousCenterID = @FranchiseCenterID
        AND CenterID = @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID <> @FranchiseCenterID
        AND PreviousCenterID <> @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ClientHomeCenterID = @FranchiseCenterID
        AND CenterID <> @FranchiseCenterID
        AND PreviousCenterID <> @FranchiseCenterID


SET @Text = 'Updating datHairSystemOrderTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datHairSystemOrderTransaction
SET     PreviousCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   PreviousCenterID = @FranchiseCenterID
        AND ClientHomeCenterID <> @FranchiseCenterID
        AND CenterID <> @FranchiseCenterID


SET @Text = 'Updating datInterCompanyTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInterCompanyTransaction
SET     CenterID = @CorporateCenterID
,       ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID = @FranchiseCenterID


SET @Text = 'Updating datInterCompanyTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInterCompanyTransaction
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
        AND ClientHomeCenterID <> @FranchiseCenterID


SET @Text = 'Updating datInterCompanyTransaction Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInterCompanyTransaction
SET     ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ClientHomeCenterID = @FranchiseCenterID
		AND CenterID <> @FranchiseCenterID


SET @Text = 'Updating datInventoryShipment Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInventoryShipment
SET     ShipFromCenterID = @CorporateCenterID
,		ShipToCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ShipFromCenterID = @FranchiseCenterID
		AND ShipToCenterID = @FranchiseCenterID


SET @Text = 'Updating datInventoryShipment Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInventoryShipment
SET     ShipFromCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ShipFromCenterID = @FranchiseCenterID
		AND ShipToCenterID <> @FranchiseCenterID


SET @Text = 'Updating datInventoryShipment Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInventoryShipment
SET     ShipToCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ShipToCenterID = @FranchiseCenterID
		AND ShipFromCenterID <> @FranchiseCenterID


SET @Text = 'Updating datInventoryTransferRequest Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInventoryTransferRequest
SET     FromCenterID = @CorporateCenterID
,		ToCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   FromCenterID = @FranchiseCenterID
		AND ToCenterID = @FranchiseCenterID


SET @Text = 'Updating datInventoryTransferRequest Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInventoryTransferRequest
SET     ToCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ToCenterID = @FranchiseCenterID
		AND FromCenterID <> @FranchiseCenterID


SET @Text = 'Updating datInventoryTransferRequest Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datInventoryTransferRequest
SET     FromCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   FromCenterID = @FranchiseCenterID
		AND ToCenterID <> @FranchiseCenterID


SET @Text = 'Updating datNotification Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datNotification
SET     CenterID = @CorporateCenterID
,		VisitingCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
		AND VisitingCenterID = @FranchiseCenterID


SET @Text = 'Updating datNotification Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datNotification
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
		AND VisitingCenterID <> @FranchiseCenterID


SET @Text = 'Updating datNotification Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datNotification
SET     VisitingCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   VisitingCenterID = @FranchiseCenterID
		AND CenterID <> @FranchiseCenterID


SET @Text = 'Updating datSalesOrder Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSalesOrder
SET     CenterID = @CorporateCenterID
,		ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
		AND ClientHomeCenterID = @FranchiseCenterID


SET @Text = 'Updating datSalesOrder Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSalesOrder
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID
		AND ClientHomeCenterID <> @FranchiseCenterID


SET @Text = 'Updating datSalesOrder Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSalesOrder
SET     ClientHomeCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   ClientHomeCenterID = @FranchiseCenterID
		AND CenterID <> @FranchiseCenterID


SET @Text = 'Updating datSalesOrderDetail Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSalesOrderDetail
SET     NewCenterID = @CorporateCenterID
,		Center_Temp = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   NewCenterID = @FranchiseCenterID
		AND Center_Temp = @FranchiseCenterID


SET @Text = 'Updating datSalesOrderDetail Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSalesOrderDetail
SET     NewCenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   NewCenterID = @FranchiseCenterID
		AND Center_Temp <> @FranchiseCenterID


SET @Text = 'Updating datSalesOrderDetail Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSalesOrderDetail
SET     Center_Temp = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   Center_Temp = @FranchiseCenterID
		AND NewCenterID <> @FranchiseCenterID


SET @Text = 'Updating datSalesOrderTender Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE	DSOT
SET		MonetraTransactionId = NULL
,		LastUpdate = GETUTCDATE()
,		LastUpdateUser = DSOT.LastUpdateUser + '-ACQ'
FROM    datSalesOrderTender DSOT
        INNER JOIN datSalesOrder DSO
            ON DSOT.SalesOrderGUID = DSO.SalesOrderGUID
WHERE	DSO.CenterID = @FranchiseCenterID
		OR DSO.CenterID = @CorporateCenterID


SET @Text = 'Updating datSchedule Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datSchedule
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating datWaitingList Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  datWaitingList
SET     CenterID = @CorporateCenterID
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = LastUpdateUser + '-ACQ'
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails
SET     CenterID = @CorporateCenterID
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails
SET     ScannedCenterID = @CorporateCenterID
WHERE   ScannedCenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails
SET     ClientCenterID = @CorporateCenterID
WHERE   ClientCenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails_ARCHIVE Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails_ARCHIVE
SET     CenterID = @CorporateCenterID
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails_ARCHIVE Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails_ARCHIVE
SET     ScannedCenterID = @CorporateCenterID
WHERE   ScannedCenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails_ARCHIVE Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails_ARCHIVE
SET     ClientCenterID = @CorporateCenterID
WHERE   ClientCenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails_TEMP Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails_TEMP
SET     CenterID = @CorporateCenterID
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails_TEMP Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails_TEMP
SET     ScannedCenterID = @CorporateCenterID
WHERE   ScannedCenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryDetails_TEMP Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryDetails_TEMP
SET     ClientCenterID = @CorporateCenterID
WHERE   ClientCenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryHeader Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryHeader
SET     CenterID = @CorporateCenterID
WHERE   CenterID = @FranchiseCenterID


SET @Text = 'Updating HairSystemInventoryHeader_ARCHIVE Records: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
PRINT @Text

UPDATE  CMSInventory.dbo.HairSystemInventoryHeader_ARCHIVE
SET     CenterID = @CorporateCenterID
WHERE   CenterID = @FranchiseCenterID


COMMIT TRANSACTION

END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH

END
