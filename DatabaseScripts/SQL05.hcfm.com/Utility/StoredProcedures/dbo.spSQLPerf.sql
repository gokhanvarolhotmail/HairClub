/* CreateDate: 07/20/2014 22:04:21.887 , ModifyDate: 07/20/2014 22:04:21.887 */
GO
CREATE PROC dbo.spSQLPerf
AS
DBCC SQLPERF(logspace)
GO
