/* CreateDate: 05/31/2016 07:50:08.517 , ModifyDate: 08/28/2020 17:01:48.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnCreateHairOrderInventorySnapshot

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		03/23/2015

LAST REVISION DATE: 	03/23/2015

--------------------------------------------------------------------------------------------------------
NOTES:  Creates an Hair Order Inventory Snapshot for all centers for current date

		* 03/23/2015	MVT	Created
		* 04/13/2015	MVT Changed column ScannerCenterID to ScannedCenterID
		* 05/26/2016	MVT Updated to use the Snapshot table. Removed parameters and used current date.
		* 09/29/2017	DSL Updated to include Franchise centers.
		* 11/13/2019	DSL Updated to include cONEct Aderans-Europe centers.
		* 11/25/2019	SAL Updated to remove the hardcoded line for AND c.CenterNumber = 341 in the
								where statement to create the batch. (TFS #13505)
		* 04/21/2020	SAL	Added center exclusions for April, 2020 inventory snapshot (TFS #14384)
		* 04/24/2020	SAL	Remove center exclusions put in place for April, 2020 inventory snapshot (TFS #14386)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnCreateHairOrderInventorySnapshot

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnCreateHairOrderInventorySnapshot]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY
	 BEGIN TRANSACTION

	---- Check if batch exists and throw an exception
	--IF EXISTS (SELECT * FROM datHairSystemInventoryBatch WHERE ScanMonth = @Month AND ScanDay = @Day AND ScanYear = @Year)
	--BEGIN
	--	RAISERROR(N'Hair Inventory Batch for Month: %d, Day: %d, Year: %d already exists.', 16, 1, @Month, @Day, @Year)
	--END


	DECLARE @NotStartedBatchStatusID int,
			@HairSystemInventorySnapshotID int,
			@User nvarchar(25)

	SET @User = 'Inv_Snapshot'

	INSERT INTO [dbo].[datHairSystemInventorySnapshot]
           ([SnapshotDate]
           ,[SnapshotLabel]
           ,[IsAdjustmentCompleted]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
     VALUES
           (GETUTCDATE()
           ,CAST(DATEPART(YEAR, GETUTCDATE()) AS varchar) + ' ' + DATENAME(MONTH, GETUTCDATE()) + ' ' + CAST(DATEPART(DAY, GETUTCDATE()) AS varchar)
           ,0
           ,GETUTCDATE()
           ,@User
           ,GETUTCDATE()
           ,@User)

	SELECT @HairSystemInventorySnapshotID = SCOPE_IDENTITY()

	SELECT @NotStartedBatchStatusID = HairSystemInventoryBatchStatusID FROM lkpHairSystemInventoryBatchStatus WHERE HairSystemInventoryBatchStatusDescriptionShort = 'NotStarted'

	-- Create a batch records
	INSERT INTO [dbo].[datHairSystemInventoryBatch]
           ([HairSystemInventorySnapshotID]
           ,[CenterID]
           ,[HairSystemInventoryBatchStatusID]
           ,[ScanCompleteDate]
           ,[ScanCompleteEmployeeGUID]
           ,[IsAdjustmentCompleted]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
		SELECT
			@HairSystemInventorySnapshotID
			, c.CenterID
			, @NotStartedBatchStatusID
			, NULL -- Scan Complete Date
			, NULL -- Scan Complete Employee
			, 0 -- Set to true when correction script fixes the order
			, GETUTCDATE()
			, @User
			, GETUTCDATE()
			, @User
		FROM cfgCenter c
			INNER JOIN cfgConfigurationCenter cc ON cc.CenterID = c.CenterID
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
		WHERE c.IsActiveFlag = 1
			AND bt.CenterBusinessTypeDescriptionShort IN ('cONEctCorp','cONEctJV','cONEctHQ','cONEctFran','HW','AEU')
			AND c.CenterNumber NOT IN ( 901, 902, 903, 904, 103 ) -- Exclude Virtual Centers
		ORDER BY c.CenterID

	-- Create Transaction records for the batch
	INSERT INTO [dbo].[datHairSystemInventoryTransaction]
           ([HairSystemInventoryBatchID]
           ,[HairSystemOrderGUID]
           ,[HairSystemOrderNumber]
           ,[HairSystemOrderStatusID]
           ,[IsInTransit]
           ,[ClientGUID]
           ,[ClientMembershipGUID]
           ,[ClientIdentifier]
           ,[ClientHomeCenterID]
           ,[ScannedDate]
           ,[ScannedEmployeeGUID]
           ,[ScannedCenterID]
		   ,[ScannedHairSystemInventoryBatchID]
           ,[IsExcludedFromCorrections]
		   ,[ExclusionReason]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
		SELECT
			batch.HairSystemInventoryBatchID
			, hso.HairSystemOrderGUID
			, hso.HairSystemOrderNumber
			, hso.HairSystemOrderStatusID
			, hstat.IsInTransitFlag
			, hso.ClientGUID
			, hso.ClientMembershipGUID
			, c.ClientIdentifier
			, c.CenterID
			, NULL -- Scanned Date
			, NULL -- Scanned Employee
			, NULL -- Scanner Center ID
			, NULL -- Scanned Batch
			, 0  -- Is Excluded from Corrections
			, NULL
			, GETUTCDATE()
			, @User
			, GETUTCDATE()
			, @User
		FROM datHairSystemOrder hso
			INNER JOIN datHairSystemInventoryBatch batch ON batch.CenterID = hso.CenterID
			INNER JOIN datClient c ON c.ClientGUID = hso.ClientGUID
			--INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = hso.ClientMembershipGUID
			--INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
			INNER JOIN lkpHairSystemOrderStatus hstat ON hstat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		WHERE hstat.IncludeInInventorySnapshotFlag = 1
			AND batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID

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
GO
