/* CreateDate: 05/03/2010 12:23:07.010 , ModifyDate: 05/03/2010 12:23:07.237 */
GO
CREATE TABLE [bief_meta].[DS_ColumnType](
	[ColumnTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[ColumnTypeDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DS_ColumnType] PRIMARY KEY CLUSTERED
(
	[ColumnTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
