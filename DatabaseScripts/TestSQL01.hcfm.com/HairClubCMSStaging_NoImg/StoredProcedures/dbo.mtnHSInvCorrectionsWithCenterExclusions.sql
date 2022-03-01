/* CreateDate: 01/31/2022 17:51:47.190 , ModifyDate: 02/28/2022 12:04:17.570 */
GO
/*

The Villages 279
Brooklyn 202
West Palm 212
Corpus 396
Corp 100
Virtual Corp 360
Cincinnati 283
Winnipeg 239


*/
CREATE procedure mtnHSInvCorrectionsWithCenterExclusions
(
@CentersNumbersToExclude varchar(500) = '279, 202, 212, 396, 100, 360, 283, 239'
)
as
Begin
/*
Created by: MKunchum
2022-02-28
exec dbo.mtnHSInvCorrectionsWithCenterExclusions '279, 202, 212, 396, 100, 360, 283, 239'
--
Last Run: 2022-01-31
CenterID to exclude: 279, 253, 202, 212, 396, 100, 360
--
exec dbo.mtnHSInvCorrectionsWithCenterExclusions '279, 253, 202, 212, 396, 100, 360'
*/
DECLARE @HairSystemInventorySnapshotID INT 
Declare @BatchID INT
Declare @CenterIDS TABLE(CenterID int not null);
insert into @CenterIDS(CenterID)
select centerid from cfgCenter
where CenterNumber in (select value from String_Split(@CentersNumbersToExclude,','))



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
