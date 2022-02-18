/* CreateDate: 01/31/2022 17:51:47.190 , ModifyDate: 01/31/2022 17:55:35.843 */
GO
CREATE procedure mtnHSInvCorrectionsWithCenterExclusions
(
@CentersToExclude varchar(500) = '279, 253, 202, 212, 396, 100, 360'
)
as
Begin
/*
Created by: MKunchum
Last Run: 2022-01-31
CenterID to exclude: 279, 253, 202, 212, 396, 100, 360
--
exec dbo.mtnHSInvCorrectionsWithCenterExclusions '279, 253, 202, 212, 396, 100, 360'
*/
DECLARE @HairSystemInventorySnapshotID INT 
Declare @BatchID INT
Declare @CenterIDS TABLE(CenterID int not null);
insert into @CenterIDS(CenterID)
select value from String_Split(@CentersToExclude,',')

SELECT TOP 1 @HairSystemInventorySnapshotID = hsis.HairSystemInventorySnapshotID
FROM datHairSystemInventorySnapshot hsis
ORDER BY hsis.CreateDate DESC

print 'HSInventorySnapshotID = ' +  str(@HairSystemInventorySnapshotID)

declare cur_hsib cursor for
SELECT hsib.HairSystemInventoryBatchID
FROM datHairSystemInventoryBatch hsib
WHERE hsib.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
AND hsib.CenterID in (select centerid from @CenterIDS)
open cur_hsib
fetch next from cur_hsib into @BatchID
while @@FETCH_STATUS = 0
BEGIN

	print 'Processing Batch: ' + str(@BatchID)

	UPDATE hsit
	SET hsit.IsExcludedFromCorrections = 1
	, hsit.ExclusionReason = 'This location is unable to perform any inventory this month.'
	, hsit.LastUpdate = GETUTCDATE()
	, hsit.LastUpdateUser = 'mkunchum'
	FROM datHairSystemInventoryTransaction hsit
	WHERE hsit.HairSystemInventoryBatchID = @BatchID

	fetch next from cur_hsib into @BatchID
END
close cur_hsib
deallocate cur_hsib
Print 'All batches processed'
Print ' -- '
Print 'Processing stored procedure - mtnHairSystemInventoryCorrection'
EXEC mtnHairSystemInventoryCorrection NULL, @HairSystemInventorySnapshotID
Print 'All stored procedures run'
END
GO
