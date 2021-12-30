/* CreateDate: 12/31/2010 13:21:06.827 , ModifyDate: 02/27/2017 09:49:23.493 */
GO
/***********************************************************************

PROCEDURE:				mtnUpdatePurchaseOrderToSent

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 10/27/2010

LAST REVISION DATE: 	 10/27/2010

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used at the end of the allocation process (SSIS package) to mark POs as Sent
		* 10/27/2010 MTV - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnUpdatePurchaseOrderToSent '27EC303A-A8B0-4C7B-AEC4-0BF8D65F0D18'

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnUpdatePurchaseOrderToSent]
	@PurchaseOrderGUID nvarchar(100)
AS
BEGIN
	--Note: GUID parameter is intentially passed in as an nvarchar because uniqueidentifiers cause an issue in SSIS (MVT isn't an as dumb as you think)
	SET NOCOUNT ON

	DECLARE @SentStatus as nvarchar(15)  = 'Sent'

	DECLARE @SentStatusId as int

	SET @SentStatusId = (SELECT PurchaseOrderStatusID FROM dbo.lkpPurchaseOrderStatus WHERE PurchaseOrderStatusDescriptionShort = @SentStatus)

	UPDATE dbo.datPurchaseOrder SET
		PurchaseOrderStatusID = @SentStatusId,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'Allocation Process'
	WHERE PurchaseOrderGUID = @PurchaseOrderGUID

END
GO
