/* CreateDate: 03/01/2012 07:54:45.773 , ModifyDate: 02/27/2017 09:49:17.063 */
GO
/*
==============================================================================
PROCEDURE:                  mtnActivateVendorContracts

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           02/27/2012

LAST REVISION DATE:			02/27/2012

==============================================================================
DESCRIPTION:    Run nightly to activate Vendor contracts.

==============================================================================
NOTES:
            * 02/27/2012 MVT - Created Stored Proc

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnActivateVendorContracts]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnActivateVendorContracts]
AS
BEGIN


	-- SET the active Flag for the Contracts
	Update cfgHairSystemVendorContract
		SET IsActiveContract = 0,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = 'sa'

	UPDATE cfgHairSystemVendorContract
		SET IsActiveContract = 1,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = 'sa'
	FROM cfgHairSystemVendorContract
	WHERE GETUTCDATE() BETWEEN ContractBeginDate AND ContractEndDate

	UPDATE hsvc
		SET IsActiveContract = 1,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = 'sa'
	FROM cfgHairSystemVendorContract hsvc
		INNER JOIN (SELECT VendorID, MAX(ContractEndDate) as ContractEndDate
					FROM cfgHairSystemVendorContract
					WHERE VendorID  NOT IN
						(SELECT DISTINCT VendorID FROM cfgHairSystemVendorContract WHERE IsActiveContract = 1)
					GROUP BY VendorID) hsvc2 on hsvc.VendorID = hsvc2.VendorID AND hsvc.ContractEndDate = hsvc2.ContractEndDate


END
GO
