/* CreateDate: 01/09/2008 12:54:24.750 , ModifyDate: 04/09/2008 12:11:57.313 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Will Beaton
-- Create date: 01/09/2008
-- Description:	Index Defrag
-- =============================================


CREATE  Procedure [dbo].[spMNT_INDEXDEFRAG]
as
    DECLARE @TableName sysname
    DECLARE @indid int
    DECLARE cur_tblfetch CURSOR
        FOR SELECT  table_name
            FROM    information_schema.tables
            WHERE   table_type = 'base table'
    OPEN cur_tblfetch
    FETCH NEXT FROM cur_tblfetch INTO @TableName
    WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE cur_indfetch CURSOR
                FOR SELECT  indid
                    FROM    sysindexes
                    WHERE   id = OBJECT_ID(@TableName)
                            and keycnt > 0
                            AND groupid > 0
            OPEN cur_indfetch
            FETCH NEXT FROM cur_indfetch INTO @indid
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    SELECT  'Defragmenting index_id = '
                            + convert(char(3), @indid) + 'of the '
                            + rtrim(@TableName) + ' table'
                    IF @indid <> 255
                        DBCC INDEXDEFRAG (BOS, @TableName, @indid)
                    FETCH NEXT FROM cur_indfetch INTO @indid
                END
            CLOSE cur_indfetch
            DEALLOCATE cur_indfetch
            FETCH NEXT FROM cur_tblfetch INTO @TableName

        END
	CLOSE cur_tblfetch
	DEALLOCATE cur_tblfetch
GO
