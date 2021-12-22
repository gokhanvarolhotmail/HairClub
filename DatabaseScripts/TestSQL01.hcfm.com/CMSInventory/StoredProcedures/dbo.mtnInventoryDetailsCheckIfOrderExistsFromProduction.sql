/* CreateDate: 03/30/2011 09:42:32.740 , ModifyDate: 12/28/2011 17:27:03.943 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryDetailsCheckIfOrderExistsFromProduction]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Create snapshot header records
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryDetailsCheckIfOrderExistsFromProduction] 1334017
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryDetailsCheckIfOrderExistsFromProduction] (
	@HairSystemOrderNumber INT
)
AS
BEGIN
	IF EXISTS (
		SELECT HairSystemOrderNumber
		FROM [synHairClubCMS_dbo_datHairSystemOrder] [datHairSystemOrder]
		WHERE [HairSystemOrderNumber] = @HairSystemOrderNumber
	)
	SELECT 1 AS 'OrderExists'
	ELSE
	SELECT 0 AS 'OrderExists'
END
GO
