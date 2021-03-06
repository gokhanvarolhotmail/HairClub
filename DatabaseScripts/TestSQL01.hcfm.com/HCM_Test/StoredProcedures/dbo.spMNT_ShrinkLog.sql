/* CreateDate: 10/28/2007 04:25:47.377 , ModifyDate: 05/01/2010 14:48:10.310 */
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
