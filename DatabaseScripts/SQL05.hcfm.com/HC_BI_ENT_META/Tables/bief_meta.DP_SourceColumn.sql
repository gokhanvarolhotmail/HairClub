/* CreateDate: 05/03/2010 12:09:20.163 , ModifyDate: 05/03/2010 12:09:20.353 */
GO
CREATE TABLE [bief_meta].[DP_SourceColumn](
	[ColumnKey] [int] IDENTITY(1,1) NOT NULL,
	[TableKey] [int] NOT NULL,
	[UniqueValues] [bigint] NULL,
	[MinValue] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaxValue] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AvgValue] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaxLength] [int] NULL,
	[Nulls] [bigint] NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DP_SourceColumn] PRIMARY KEY CLUSTERED
(
	[ColumnKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
