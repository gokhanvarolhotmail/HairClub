/* CreateDate: 05/03/2010 12:09:20.250 , ModifyDate: 05/03/2010 12:09:20.377 */
GO
CREATE TABLE [bief_meta].[DS_TableType](
	[TableTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[TableType] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TableTypeDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DS_TableType] PRIMARY KEY CLUSTERED
(
	[TableTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
