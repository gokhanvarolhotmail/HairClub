/* CreateDate: 07/20/2014 20:54:09.147 , ModifyDate: 07/20/2014 20:54:09.147 */
GO
CREATE PROC dbo.spGetSQLPerfStats
AS
SET NOCOUNT ON

CREATE TABLE #tFileList
(
	DatabaseName sysname,
	LogSize decimal(18,5),
	LogUsed decimal(18,5),
	Status INT
)

INSERT INTO #tFileList
       EXEC spSQLPerf

INSERT INTO LogSpaceStats (DatabaseName, LogSize, LogUsed)
SELECT DatabaseName, LogSize, LogUsed
FROM #tFileList
WHERE DatabaseName IN ('CMSInventory', 'HairClubCMS')

DROP TABLE #tFileList
GO
