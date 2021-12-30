/* CreateDate: 03/30/2011 09:42:32.487 , ModifyDate: 12/28/2011 17:26:03.057 */
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryHeaderResetScan]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Start inventory scan
	2011-09-26 - HDu Parameterized the SP date parts
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryHeaderResetScan] 201, 'mburrell', 6, 2011
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryHeaderResetScan] (
	@CenterID INT
,	@User VARCHAR(50)
,@Month INT
,@Year INT
,@Day INT
)
AS
BEGIN

	UPDATE [HairSystemInventoryHeader]
	SET UpdateUser = @User
	,	UpdateDate = GETDATE()
	,	ScanCompleted = 0
	,	CompleteDate = NULL
	,	CompleteUser = NULL
	WHERE CenterID = @CenterID
		AND ScanMonth = @Month
		AND ScanYear = @Year
		AND ScanDay = @Day
END
GO
