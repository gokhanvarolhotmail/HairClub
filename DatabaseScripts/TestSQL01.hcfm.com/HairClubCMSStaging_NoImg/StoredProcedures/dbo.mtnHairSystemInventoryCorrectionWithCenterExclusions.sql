/* CreateDate: 02/28/2022 13:22:29.747 , ModifyDate: 02/28/2022 13:37:39.470 */
GO
CREATE procedure mtnHairSystemInventoryCorrectionWithCenterExclusions
(
@CenterNumbersToExclude varchar(500) = '279, 253, 202, 212, 396, 100, 360'
)
as
Begin
/*
Execution sample: exec dbo.mtnHairSystemInventoryCorrectionWithCenterExclusions '279, 253, 202, 212, 396, 100, 360'
*/
DECLARE @HairSystemInventorySnapshotID INT, @BatchID INT, @CenterID INT
Declare @CenterDesc varchar(50)
Declare @CenterIDS TABLE(CenterID int not null);

/* get center ids for centers to be excluded from center numbers */
insert into @CenterIDS(CenterID)
select centerid from cfgCenter
where centernumber in (select value from String_Split(@CenterNumbersToExclude,','))


/* get latest Hair System Inventory Snapshot ID */
SELECT TOP 1 @HairSystemInventorySnapshotID = hsis.HairSystemInventorySnapshotID
FROM datHairSystemInventorySnapshot hsis
ORDER BY hsis.CreateDate DESC

print 'Hair System Inventory Snapshot Id =' + trim(str(@HairSystemInventorySnapshotID))

/* for each center id to be excluded, get batch id and set exclusion flag */
declare cur_hsib cursor for
SELECT hsib.HairSystemInventoryBatchID, hsib.CenterID
FROM datHairSystemInventoryBatch hsib
WHERE hsib.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
AND hsib.CenterID in (select centerid from @CenterIDS)
open cur_hsib
fetch next from cur_hsib into @BatchID, @CenterID
while @@FETCH_STATUS = 0
BEGIN
	select @CenterDesc = CenterDescription from cfgCenter where CenterID= @CenterID

	print 'Marking Batch to exclude: ' + trim(str(@BatchID)) + ' for center :' + @CenterDesc + ' - ' + trim(str(@CenterID))

	UPDATE hsit
	SET hsit.IsExcludedFromCorrections = 1
	, hsit.ExclusionReason = 'This location is unable to perform any inventory this month.'
	, hsit.LastUpdate = GETUTCDATE()
	, hsit.LastUpdateUser = 'mkunchum'
	FROM datHairSystemInventoryTransaction hsit
	WHERE hsit.HairSystemInventoryBatchID = @BatchID

	fetch next from cur_hsib into @BatchID, @CenterID
END
close cur_hsib
deallocate cur_hsib
Print 'All centers with batch ids in list excluded'

/* Run inventory correction procedure */
Print 'Processing stored procedure - mtnHairSystemInventoryCorrection for snapshotid: ' + trim(str(@HairSystemInventorySnapshotID))
EXEC mtnHairSystemInventoryCorrection NULL, @HairSystemInventorySnapshotID

/* complete message */
Print 'All stored procedures run and Inventory Correction completed'
END
GO
