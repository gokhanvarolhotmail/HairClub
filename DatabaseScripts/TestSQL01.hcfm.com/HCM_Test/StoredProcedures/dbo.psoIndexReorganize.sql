/* CreateDate: 12/03/2014 14:31:34.673 , ModifyDate: 08/08/2017 11:27:32.337 */
GO
CREATE PROCEDURE [dbo].[psoIndexReorganize]
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

       DECLARE @SQL                      NVARCHAR(MAX)
	   DECLARE @StatSQL					 NVARCHAR(MAX)
       DECLARE @TableName                NVARCHAR(128)
       DECLARE @IndexName                NVARCHAR(128)
	   DECLARE @Text					 NVARCHAR(MAX)
       DECLARE @PercentFragmented		 DECIMAL(15,12)
	   DECLARE @startDate				 datetime

	   SET @Text = 'Started: ' + CONVERT(nchar(24),GETDATE(),121)
	   RAISERROR(@Text,0,1) WITH NOWAIT

       DECLARE IndexCursor CURSOR FOR
              SELECT TOP 20
              'ALTER INDEX ' + ind.name + ' ON ' +  OBJECT_NAME(ind.OBJECT_ID) + ' REORGANIZE ;',
              OBJECT_NAME(ind.OBJECT_ID) AS TableName,
              ind.name AS IndexName,
              indexstats.avg_fragmentation_in_percent
              FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
              INNER JOIN sys.indexes ind
              ON ind.object_id = indexstats.object_id
              AND ind.index_id = indexstats.index_id
              WHERE ind.name IS NOT NULL AND
                     indexstats.avg_fragmentation_in_percent > 30 AND
                     ind.name NOT IN (SELECT index_name FROM cstd_index_maintenance WHERE DATEADD(DAY, 7, process_date) >= GETDATE())
              ORDER BY indexstats.avg_fragmentation_in_percent DESC

       OPEN IndexCursor

       FETCH NEXT FROM IndexCursor
       INTO @SQL, @TableName, @IndexName, @PercentFragmented

       WHILE @@FETCH_STATUS = 0
       BEGIN
			SET @startDate = GETDATE()
			SET @Text = 'Table: ' + @TableName + ' Index: ' + @IndexName + ' Pct Frag: ' + CONVERT(nvarchar(15),@PercentFragmented) + ' Started: ' + CONVERT(nchar(24),@startDate,121)
			RAISERROR(@Text,0,1) WITH NOWAIT

            EXEC (@SQL)

            INSERT INTO cstd_index_maintenance (table_name, index_name, percent_fragmented, start_date)
             VALUES (@TableName, @IndexName, @PercentFragmented, @startDate)

			SET @Text = 'Table: ' + @TableName + ' Index: ' + @IndexName + ' Pct Frag: ' + CONVERT(nvarchar(15),@PercentFragmented) + ' Ended:   ' + CONVERT(nchar(24),GETDATE(),121)
			RAISERROR(@Text,0,1) WITH NOWAIT


			SET @StatSQL = 'UPDATE STATISTICS ' + @TableName + ' ' + @IndexName + ' WITH FULLSCAN'

			SET @startDate = GETDATE()
			SET @Text = 'Table: ' + @TableName + ' Statistics: ' + @IndexName + ' Started: ' + CONVERT(nchar(24),@startDate,121)
			RAISERROR(@Text,0,1) WITH NOWAIT

            EXEC (@StatSQL)

            INSERT INTO cstd_index_maintenance (table_name, index_name, percent_fragmented, start_date)
             VALUES (@TableName, @IndexName, -1, @startDate)

			SET @Text = 'Table: ' + @TableName + ' Statistics: ' + @IndexName + ' Ended:   ' + CONVERT(nchar(24),GETDATE(),121)
			RAISERROR(@Text,0,1) WITH NOWAIT


            FETCH NEXT FROM IndexCursor
             INTO @SQL, @TableName, @IndexName, @PercentFragmented
       END

       CLOSE IndexCursor
       DEALLOCATE IndexCursor

	   SET @Text = 'Ended:   ' + CONVERT(nchar(24),GETDATE(),121)
	   RAISERROR(@Text,0,1) WITH NOWAIT
END
GO
