/***********************************************************************

PROCEDURE:				mtnGetInvoiceNumber

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a unique Invoice Number for a sales order for a specific center,
		assuming they will never have more than 9999 order in a day.

		* 05/31/13	MVT	Modified so that Update and Increment are done as a single operation.
		* 09/12/17	SAL Modified to use CenterNumber in place of CenterID as the first 3 characters of
							the Invoice Number.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnGetInvoiceNumber 301

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetInvoiceNumber]
@CenterID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRANSACTION

	--DECLARE @InvoiceCounter int

	----Grab the next Invoice Number
	--SELECT @InvoiceCounter = (InvoiceCounter + 1)
	--FROM cfgCenter
	--WHERE CenterID = @CenterID


	----Roll counter back to 1 if we go over 1000
	----   (this assumes a center will never have more than 1000 sales orders in a day
	--IF @InvoiceCounter >= 9999
	--	SET @InvoiceCounter = 1

	--Get Center's CenterNumber
	DECLARE @CenterNumber int
	SELECT @CenterNumber = CenterNumber FROM cfgCenter WHERE CenterID = @CenterID

	DECLARE @InvoiceCounterTable table (
		InvoiceCounter int)

	--Update Invoice Counter
	UPDATE cfgCenter WITH (HOLDLOCK)
		SET InvoiceCounter = CASE WHEN InvoiceCounter >= 9999 THEN 1
								ELSE InvoiceCounter + 1 END
		OUTPUT inserted.InvoiceCounter INTO @InvoiceCounterTable
	WHERE CenterID = @CenterID


	SELECT TOP(1) CAST(@CenterNumber AS nvarchar) +
			'-'	+ RIGHT(CAST(YEAR(GETDATE()) AS nvarchar), 2) +
					REPLICATE('0', (2 - LEN(CAST(MONTH(GETDATE()) AS nvarchar)))) + CAST(MONTH(GETDATE()) AS nvarchar) +
					REPLICATE('0', (2 - LEN(CAST(DAY(GETDATE()) AS nvarchar)))) + CAST(DAY(GETDATE()) AS nvarchar) +
			'-' + REPLICATE('0', (4 - LEN(CAST(InvoiceCounter AS nvarchar)))) + CAST(InvoiceCounter AS nvarchar) AS InvoiceNumber
	FROM @InvoiceCounterTable

  COMMIT
END
