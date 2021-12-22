/***********************************************************************
PROCEDURE: 				[mtnInventorySnapshotCreateHeader]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Create snapshot header records
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventorySnapshotCreateHeader] 9, 2011, 15
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventorySnapshotCreateHeader](
	@Month INT
,	@Year INT
,	@Day INT
)
AS
BEGIN

	INSERT INTO [HairSystemInventoryHeader] (
		[InventoryID]
	,	[CenterID]
	,	[ScanMonth]
	,	[ScanYear]
	,	[CreateDate]
	,	[CreateUser]
	,	[ScanDay]
	,	[ScanLabel]
	)
	SELECT NEWID()
	,	CenterID
	,	@Month
	,	@Year
	,	GETDATE()
	,	'MIS'
	,	@Day
	, CAST(@Year AS VARCHAR) + ' ' + DATENAME(MONTH,DATEADD(MONTH,@Month-1,0)) + ' ' + CAST(@Day AS VARCHAR)
	FROM dbo.synHairClubCMS_dbo_cfgCenter [cfgCenter]
	WHERE CenterID LIKE '[1278]%'
		AND IsActiveFlag=1
	--WHERE CenterID IN ( 800, 801, 839, 855 )
	--	AND IsActiveFlag = 1

END
