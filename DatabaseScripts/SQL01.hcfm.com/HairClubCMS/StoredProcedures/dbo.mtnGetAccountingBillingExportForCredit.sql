/*
==============================================================================
PROCEDURE:				mtnGetAccountingBillingExportForCredit

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR:

DATE IMPLEMENTED:

LAST REVISION DATE:

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
		* ? ? - Created
		* 10/27/2011 MVT - Modified to use cost at the time of Credit Request
		* 02/24/2012 MVT - Changed CostCenterWholesale to CenterPrice
		* 06/19/2012 MVT - Added a check for Priority Hair Credit.  Check for
							last Ship From Corp Transaction and Inventory Shipment
							Detail attached to the transaction.  If Inventory Shipment
							Detail has a Priority Transfer Fee, use the Fee, otherwise
							use the Center Price.
		* 04/11/2013 MLM - Modified proc not to use the Allocation record for CenterPricing
							CenterPricing is no longer done during allocation it is done
							when the hairsystem is shipped.
		* 09/17/2017 SAL - Updated to return CenterNumber As CenterID.
		* 06/18/2018 SAL - Modified to allow executing for Hans Wiemann Type/CenterType (TFS #10928).
==============================================================================
SAMPLE EXECUTION:
	EXEC [mtnGetAccountingBillingExportForCredit] '1/1/2013', '4/11/2013', 'Franchise', '4/11/2013', 'test', NULL, 'mmaass', 0, 100
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnGetAccountingBillingExportForCredit]
	@BeginDate datetime,
	@EndDate datetime,
	@Type nvarchar(25),
	@InvoiceDate datetime, -- informational, only written to batch record
	@ExportFileName nvarchar(200),
	@BatchGUID uniqueidentifier,
	@User nvarchar(25),
	@SkipCount int,
	@PageSize int

AS
	DECLARE @CenterType as char

	/**********************************************/
	-- CONSTANTS
	/**********************************************/
	DECLARE @CorpBatchTypeConst as nvarchar(15)  = 'HSCorpBill'
	DECLARE @FranchiseBatchTypeConst as nvarchar(15) = 'HSFranBill'
	DECLARE @HairSystemOrderProcessDescription as nvarchar(15) = 'SHIPFCORP'
	DECLARE @CorpCenter as integer = 100
	DECLARE @CorpCenterType as char = 'C'
	DECLARE @FranchiseCenterType as char = 'F'
	DECLARE @JointCenterType as nvarchar(2) = 'JV'
	DECLARE @HansWiemannCenterType as nvarchar(2) = 'HW'
	DECLARE @CorpType as nvarchar(20) = 'Corporate'
	DECLARE @FranchiseType as nvarchar(20) = 'Franchise'
	DECLARE @HansWiemannType as nvarchar(20) = 'HansWiemann'
	DECLARE @ReceiveFromFactoryShipmentType as nvarchar(20) = 'HSVen2Corp'
	DECLARE @HairClubForKidsMembershipShortDesc as nvarchar(10) = 'HCFK'
	DECLARE @EmployeeMembershipShortDesc as nvarchar(10) = 'EMPLOYEE'
	DECLARE @EmployeeExtMembershipShortDesc as nvarchar(10) = 'EMPLOYEXT'
	DECLARE @ModelMembershipShortDesc as nvarchar(10) = 'MODEL'
	DECLARE @ModelExtMembershipShortDesc as nvarchar(10) = 'MODELEXT'

	SET @EndDate = DATEADD(Second, -1, DATEADD(Day, 1, @EndDate))

BEGIN TRANSACTION

BEGIN TRY
	-------------------------------------------
	-- Select for Export
	-------------------------------------------
	SELECT r.ShippingMenifest,
		r.BatchGUID,
		r.BatchId,
		r.ShipmentMethod,
		r.CenterId,
		r.InvoiceDate,
		r.ShipDate,
		r.RecieveDate,
		r.Membership,
		r.ClientNumber,
		r.ClientName,
		r.SystemType,
		r.FactoryOrderNumber,
		r.Price,
		r.Quantity,
		r.Freight
	FROM
	(
		SELECT Row_Number() OVER(Order by hso.HairSystemOrderNumber desc) as RowNumber,
				0 as ShippingMenifest,
				CONVERT(uniqueidentifier, '00000000-0000-0000-0000-000000000000') AS BatchGUID,
				CONVERT(NVarChar, @EndDate, 101) + ' Prod_Inv' as BatchId,
				NULL as ShipmentMethod,
				cntr.CenterNumber AS CenterId,
				--hso.ClientHomeCenterID AS CenterId,
				@InvoiceDate as InvoiceDate,
				NULL AS ShipDate, -- Ship to Center From Corporate date
				NULL As RecieveDate,
				mem.MembershipDescriptionShort as Membership,
				c.ClientIdentifier as ClientNumber,
				c.ClientFullNameAlt2Calc as ClientName,
				hs.HairSystemDescriptionShort as SystemType,
				hso.HairSystemOrderNumber as FactoryOrderNumber,
				-- if last Ship From Corp Inventory Shipment Detail has a transfer fee, then use transfer fee, otherwise user the price
				ISNULL(shd.PriorityTransferFee, ISNULL(pt.CenterPrice, hso.CenterPrice)) * -1 as Price,
				1 as Quantity,
				0.0 AS Freight
			 FROM dbo.datHairSystemOrder hso
				INNER JOIN dbo.cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
				INNER JOIN dbo.datClient c ON hso.ClientGUID = c.ClientGUID
				INNER JOIN dbo.datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN dbo.cfgMembership mem ON cm.MembershipID = mem.MembershipID
				INNER JOIN cfgCenter cntr ON cntr.CenterID = hso.ClientHomeCenterID
				--INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
				INNER JOIN lkpCenterType ct ON cntr.CenterTypeID = ct.CenterTypeID
				LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
				--LEFT OUTER JOIN datHairSystemOrderTransaction t ON t.HairSystemOrderGUID = hso.HairSystemOrderGUID
				--			AND t.HairSystemOrderTransactionGUID = (SELECT TOP 1 tr.HairSystemOrderTransactionGUID
				--															FROM datHairSystemOrderTransaction tr
				--																INNER JOIN lkpHairSystemOrderProcess p
				--																	ON tr.HairSystemOrderProcessID = p.HairSystemOrderProcessID
				--															WHERE tr.HairSystemOrderGUID = hso.HairSystemOrderGUID AND
				--																	p.HairSystemOrderProcessDescriptionShort = 'ALLOC'
				--															ORDER BY tr.CreateDate desc)
				-- Determine last Shiped From Corp transaction
				LEFT OUTER JOIN datHairSystemOrderTransaction pt ON pt.HairSystemOrderGUID = hso.HairSystemOrderGUID
							AND pt.HairSystemOrderTransactionGUID = (SELECT TOP 1 tr.HairSystemOrderTransactionGUID
																			FROM datHairSystemOrderTransaction tr
																				INNER JOIN lkpHairSystemOrderProcess p
																					ON tr.HairSystemOrderProcessID = p.HairSystemOrderProcessID
																			WHERE tr.HairSystemOrderGUID = hso.HairSystemOrderGUID AND
																					p.HairSystemOrderProcessDescriptionShort = 'SHIPFCORP'
																			ORDER BY tr.CreateDate desc)
				-- Determine Shipment Detail for last Shipped From Corp Transaction
				LEFT OUTER JOIN datInventoryShipmentDetail shd ON pt.InventoryShipmentDetailGUID = shd.InventoryShipmentDetailGUID
			WHERE
				hso.RequestForCreditAcceptedDate IS NOT NULL AND
				hso.RequestForCreditAcceptedDate >= @BeginDate AND
				hso.RequestForCreditAcceptedDate <= @EndDate AND
				isnull(hso.IsRepairOrderFlag, 0) = 0 AND
					(
						(@Type = @CorpType AND ct.CenterTypeDescriptionShort = @CorpCenterType)
						OR (@Type = @HansWiemannType AND ct.CenterTypeDescriptionShort = @HansWiemannCenterType)
						OR (@Type = @FranchiseType
								AND (ct.CenterTypeDescriptionShort = @FranchiseCenterType
										OR ct.CenterTypeDescriptionShort = @JointCenterType))
					)
				AND m.MembershipDescriptionShort <> @HairClubForKidsMembershipShortDesc
				AND (@Type = @FranchiseType OR @Type = @HansWiemannType OR
						(
							@Type = @CorpType
							AND m.MembershipDescriptionShort <> @EmployeeMembershipShortDesc
							AND m.MembershipDescriptionShort <> @EmployeeExtMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelExtMembershipShortDesc
						)
					)
	) r
	WHERE RowNumber BETWEEN (@SkipCount+1) AND (@SkipCount + @PageSize)


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
