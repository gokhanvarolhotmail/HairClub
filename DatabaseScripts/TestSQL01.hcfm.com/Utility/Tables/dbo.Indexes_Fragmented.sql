/* CreateDate: 01/12/2022 11:30:57.853 , ModifyDate: 01/12/2022 11:30:57.853 */
GO
CREATE TABLE [dbo].[Indexes_Fragmented](
	[DBname] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[tablename] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [int] NOT NULL,
	[avg_fragmentation_in_percent] [float] NULL,
	[index_type_desc] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
