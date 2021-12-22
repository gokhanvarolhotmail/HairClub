/***********************************************************************

PROCEDURE:				mtnGetAccountingExportBatchNumber

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		10/13/2010

LAST REVISION DATE: 	10/13/2010

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a unique AccountingExportBatch Number for an Accounting Export Batch
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnGetAccountingExportBatchNumber

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetAccountingExportBatchNumber]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRANSACTION

	DECLARE @Counter int

	--Grab the next Invoice Number
	SELECT @Counter = (AccountingExportBatchCounter + 1)
	FROM cfgConfigurationApplication


	--Update Invoice Counter
	UPDATE cfgConfigurationApplication
	SET AccountingExportBatchCounter = @Counter


	SELECT CAST(@Counter AS nvarchar) AS InvoiceNumber

  COMMIT
END
