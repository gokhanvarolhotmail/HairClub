/* CreateDate: 05/03/2010 12:19:26.583 , ModifyDate: 05/03/2010 12:19:26.787 */
GO
CREATE TABLE [bief_meta].[DP_SourceTable](
	[TableKey] [int] IDENTITY(1,1) NOT NULL,
	[Rows] [bigint] NULL,
	[RowSize] [int] NULL,
	[Columns] [int] NULL,
	[HasTimestamp] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DP_SourceTable] PRIMARY KEY CLUSTERED
(
	[TableKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
