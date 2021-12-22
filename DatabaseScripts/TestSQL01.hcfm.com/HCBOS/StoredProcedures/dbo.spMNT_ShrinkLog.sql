/* CreateDate: 10/28/2007 04:27:15.110 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
CREATE  Procedure [dbo].[spMNT_ShrinkLog]
as

IF NOT EXISTS (Select * From sysobjects where name = 't1' and xtype = 'u')
CREATE TABLE t1 (char1 char(4000))

DECLARE @dbName as nvarchar(100), @sqlWork as nvarchar(400)
SET @dbName =  db_name()
SET @sqlWork = N'backup log ' + @dbName  + ' with truncate_only'

DECLARE @i int, @j int
SELECT @i = 0
SET @j= 0
WHILE (@j <= 5)
BEGIN
	WHILE (@i < 10)
	BEGIN
		INSERT INTO t1 values ('a')
		SELECT @i = @i +1
	END
	checkpoint
	TRUNCATE TABLE t1
	exec sp_executeSQL @sqlWork
	DBCC shrinkfile(2,notruncate)
	DBCC shrinkfile(2,truncateonly)
	SET @j = @j +1

END
GO
