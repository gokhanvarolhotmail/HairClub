/* CreateDate: 07/20/2014 20:54:09.100 , ModifyDate: 07/20/2014 20:54:09.100 */
GO
CREATE PROC dbo.spSQLPerf
AS
DBCC SQLPERF(logspace)
GO
