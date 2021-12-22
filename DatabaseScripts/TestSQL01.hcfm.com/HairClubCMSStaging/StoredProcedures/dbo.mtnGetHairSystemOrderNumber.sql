/* CreateDate: 10/04/2010 12:09:07.847 , ModifyDate: 02/27/2017 09:49:20.313 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnGetHairSystemOrderNumber

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		1/4/10

LAST REVISION DATE: 	1/4/10

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a unique Hair System Order Number for a hair system order
		* 5/31/13	MVT	Modified so that Update and Increment are done as a single operation.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnGetHairSystemOrderNumber 301

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetHairSystemOrderNumber]
@CenterID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRANSACTION

	DECLARE @CounterTable table (
		HairSystemOrderCounter int)

	----Grab the next Invoice Number
	--SELECT @Counter = (HairSystemOrderCounter + 1)
	--FROM cfgConfigurationApplication


	--Update Invoice Counter
	UPDATE cfgConfigurationApplication WITH (HOLDLOCK)
	SET HairSystemOrderCounter = (HairSystemOrderCounter + 1)
	OUTPUT inserted.HairSystemOrderCounter INTO @CounterTable


	SELECT TOP(1) CAST(HairSystemOrderCounter AS nvarchar) AS InvoiceNumber
		FROM @CounterTable

  COMMIT
END
GO
