/* CreateDate: 11/08/2012 13:50:23.357 , ModifyDate: 11/08/2012 13:50:23.357 */
GO
CREATE TABLE [dbo].[oncv_candidate_foreign_key](
	[foreign_table_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[foreign_column_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_table_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[primary_column_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quality_rank] [int] NOT NULL
) ON [PRIMARY]
GO
