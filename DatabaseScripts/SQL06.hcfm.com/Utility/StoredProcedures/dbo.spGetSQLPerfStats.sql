/* CreateDate: 07/20/2014 22:13:36.080 , ModifyDate: 07/20/2014 22:13:36.080 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
WHERE DatabaseName IN ('HC_BI_CMS_DDS' ,'HC_BI_MKTG_DDS', 'HC_BI_ENT_DDS', 'HC_Accounting', 'HC_Commission', 'HC_DeferredRevenue')

DROP TABLE #tFileList
GO
