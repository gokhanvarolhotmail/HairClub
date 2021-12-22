/* CreateDate: 10/04/2010 12:09:07.857 , ModifyDate: 02/27/2017 09:49:21.237 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnGetVendorContractNumber

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		2/26/10

LAST REVISION DATE: 	2/26/10

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a unique Contract Number by Vendor
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnGetVendorContractNumber 1

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetVendorContractNumber]
@VendorID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRANSACTION

	DECLARE @Counter int
	DECLARE @VendorDescriptionShort nvarchar(10)

	--Grab the next Invoice Number
	SELECT @VendorDescriptionShort = VendorDescriptionShort, @Counter = (VendorContractCounter + 1)
	FROM cfgVendor
	WHERE VendorID = @VendorID


	--Update Invoice Counter
	UPDATE cfgVendor
	SET VendorContractCounter = @Counter
	WHERE VendorID = @VendorID


	SELECT @VendorDescriptionShort + '-' + CAST(@Counter AS nvarchar) AS ContractNumber

  COMMIT
END
GO
