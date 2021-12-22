/* CreateDate: 09/04/2012 13:36:18.933 , ModifyDate: 09/04/2012 13:36:18.933 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc Pr_View_Defragmentation (@database sysname, @Frag int)
as
Declare @dbid int
select @dbid = dbid from sys.sysdatabases where name = @database
select distinct xtype, name,object_name(object_id),* from sys.dm_db_index_physical_stats (@dbid,NULL,NULL,NULL,'SAMPLED')
a inner join sys.sysobjects b on a.object_id = id where xtype = 'u' and name not like '%sys%'
and avg_fragmentation_in_percent >= @frag
GO
