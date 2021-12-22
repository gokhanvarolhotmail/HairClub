/* CreateDate: 12/31/2010 13:23:30.703 , ModifyDate: 02/27/2017 09:49:28.723 */
GO
/***********************************************************************

PROCEDURE:				[rptMEATemplate]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		2/26/10

LAST REVISION DATE: 	2/26/10

--------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptMEATemplate] NULL, '682EC8A4-03B7-4305-92FB-00000B4D4D63', NULL

***********************************************************************/


CREATE PROCEDURE [dbo].[rptMEATemplate]
	@PurchaseOrderGUID as uniqueidentifier = NULL,
	@HairSystemOrderGUID as uniqueidentifier = NULL,
	@HairSystemAllocationGUID as uniqueidentifier = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF ( @PurchaseOrderGUID IS NULL AND @HairSystemOrderGUID IS NULL AND @HairSystemAllocationGUID IS NULL )
	BEGIN
		SELECT 	NULL AS HairSystemOrderNumber,
				NULL AS HairSystemOrderGUID,
				NULL AS VendorDescriptionShort, --aka factory
				NULL AS CenterID,
				NULL AS CenterDescription,
				NULL AS ClientFullName,
				NULL AS MembershipDescriptionShort,
				NULL AS HairSystemOrderDate,

				--MEA
				NULL AS HairSystemOrderMeasurementGUID,
				NULL AS StartingPointMeasurement,
				NULL AS CircumferenceMeasurement,
				NULL AS FrontToBackMeasurement,
				NULL AS EarToEarOverFrontMeasurement,
				NULL AS EarToEarOverTopMeasurement,
				NULL AS SideburnToSideburnMeasurement,
				NULL AS TempleToTempleMeasurement,
				NULL AS NapeAreaMeasurement,
				NULL AS MEAHairSystemRecessionDescription,
				NULL AS AreSideburnsAndTemplesLaceFlag,
				NULL AS FrontLaceMeasurement,
				0 AS SideburnTemplateDiagram,
				NULL AS MeasurementsBy

	END
	ELSE
	BEGIN
		SELECT  hso.HairSystemOrderNumber,
				hso.HairSystemOrderGUID,
				v.VendorDescriptionShort, --aka factory
				hso.CenterID,
				ctr.CenterDescription,
				COALESCE(CONVERT(nvarchar,c.ClientIdentifier) + '  ','  ') + c.ClientFullNameAltCalc AS ClientFullName,
				m.MembershipDescriptionShort,
				hso.HairSystemOrderDate,

				--MEA
				hsom.HairSystemOrderMeasurementGUID,
				hsom.StartingPointMeasurement,
				hsom.CircumferenceMeasurement,
				hsom.FrontToBackMeasurement,
				hsom.EarToEarOverFrontMeasurement,
				hsom.EarToEarOverTopMeasurement,
				hsom.SideburnToSideburnMeasurement,
				hsom.TempleToTempleMeasurement,
				hsom.NapeAreaMeasurement,
				hsr2.HairSystemRecessionDescriptionShort AS MEAHairSystemRecessionDescription,
				hsom.AreSideburnsAndTemplesLaceFlag,
				hsom.FrontLaceMeasurement,
				ISNULL(hsom.SideburnTemplateDiagram,0) AS SideburnTemplateDiagram,
				emp.EmployeeInitials AS MeasurementsBy


		FROM datHairSystemOrder hso
			LEFT JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID
			LEFT JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
			LEFT JOIN cfgVendor v ON po.VendorID = v.VendorID
			LEFT JOIN cfgCenter ctr ON hso.CenterID = ctr.CenterID
			LEFT JOIN datClient c ON hso.ClientGUID = c.ClientGUID
			LEFT JOIN datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
			LEFT JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
			LEFT JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			LEFT JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			LEFT JOIN lkpHairSystemDesignTemplate hsdt ON hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID
			LEFT JOIN datHairSystemOrderMeasurement hsom ON hso.HairSystemOrderGUID = hsom.HairSystemOrderGUID
			LEFT JOIN lkpHairSystemRecession hsr2 on hsom.HairSystemRecessionID = hsr2.HairSystemRecessionID
			LEFT JOIN datEmployee emp on hso.MeasurementEmployeeGUID = emp.EmployeeGUID


		WHERE (hso.HairSystemOrderGUID = @HairSystemOrderGUID) AND
				(@PurchaseOrderGUID IS NULL OR po.PurchaseOrderGUID = @PurchaseOrderGUID) AND
			 (@HairSystemAllocationGUID IS NULL OR po.HairSystemAllocationGUID = @HairSystemAllocationGUID)
		ORDER BY hso.HairSystemOrderNumber DESC
	END
END
GO
