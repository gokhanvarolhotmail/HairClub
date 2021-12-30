/* CreateDate: 05/03/2010 12:19:26.640 , ModifyDate: 05/03/2010 12:19:26.803 */
GO
CREATE TABLE [bief_meta].[DS_Table](
	[TableKey] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TableType] [int] NOT NULL,
	[DataStore] [int] NOT NULL,
	[TableDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DS_Table] PRIMARY KEY CLUSTERED
(
	[TableKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
