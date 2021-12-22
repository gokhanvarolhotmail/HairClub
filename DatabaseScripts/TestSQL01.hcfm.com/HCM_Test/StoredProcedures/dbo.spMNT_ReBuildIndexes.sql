/* CreateDate: 10/18/2007 14:44:39.197 , ModifyDate: 05/01/2010 14:48:10.367 */
GO
CREATE PROCEDURE [dbo].[spMNT_ReBuildIndexes]

AS

/***********************************************************************

PROCEDURE:	spMNT_ReBuildIndexes

DESTINATION SERVER:	   HCSQL3\SQL2005

DESTINATION DATABASE: HCM

RELATED APPLICATION:  OnContact

AUTHOR: Brian Kellman

IMPLEMENTOR: Brian Kellman

DATE IMPLEMENTED: 10/05/2007

LAST REVISION DATE: --/--/----

--------------------------------------------------------------------------------------------------------
NOTES:  This will reindex all the table in the HCM database that have fragmentation greater than 10 percent.
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec spMNT_ReBuildIndexes

***********************************************************************/



SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname sysname;
DECLARE @objectname sysname;
DECLARE @indexname sysname;
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command varchar(8000);
-- ensure the temporary table does not exist
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'work_to_do')
    DROP TABLE work_to_do;
-- conditionally select from the function, converting object and index IDs to names.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') I
INNER JOIN sysobjects S ON  s.id = I.object_id
WHERE avg_fragmentation_in_percent > 1.0 AND index_id > 0;
-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
FETCH NEXT
   FROM partitions
   INTO @objectid, @indexid, @partitionnum, @frag;

WHILE @@FETCH_STATUS = 0
    BEGIN;
        SELECT @objectname = o.name, @schemaname = s.name
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;

        SELECT @indexname = name
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;

        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;


    SELECT @command = 'ALTER INDEX ' + @indexname +' ON ' + @schemaname + '.' + @objectname + ' REBUILD WITH (ONLINE = OFF)';
    IF @partitioncount > 1
        SELECT @command = @command + ' PARTITION=' + CONVERT (CHAR, @partitionnum);
    EXEC (@command);

--PRINT 'Executed ' + @command;

FETCH NEXT FROM partitions INTO @objectid, @indexid, @partitionnum, @frag;
END;
-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- drop the temporary table
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'work_to_do')
    DROP TABLE work_to_do;


-- Update the statistics
EXEC sp_updatestats
GO
