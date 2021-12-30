/* CreateDate: 07/20/2014 22:13:36.070 , ModifyDate: 07/20/2014 22:13:36.070 */
GO
CREATE PROC dbo.spSQLPerf
AS
DBCC SQLPERF(logspace)
GO
