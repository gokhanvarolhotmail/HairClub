/* CreateDate: 05/03/2010 12:09:20.193 , ModifyDate: 05/03/2010 12:09:20.360 */
GO
CREATE TABLE [bief_meta].[DS_Column](
	[ColumnKey] [int] IDENTITY(1,1) NOT NULL,
	[TableKey] [int] NOT NULL,
	[ColumnName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DataType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Is_PK] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Is_FK] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Is_Null] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Is_Identity] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DS_Column] PRIMARY KEY CLUSTERED
(
	[ColumnKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
