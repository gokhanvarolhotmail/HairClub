/* CreateDate: 05/03/2010 12:09:20.223 , ModifyDate: 05/03/2010 12:09:20.370 */
GO
CREATE TABLE [bief_meta].[DS_DataStore](
	[DataStoreKey] [int] IDENTITY(1,1) NOT NULL,
	[DataStoreName] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DataStoreDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DBMS] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Collation] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentSize] [decimal](9, 2) NULL,
	[Growth] [decimal](9, 2) NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DS_DataStore] PRIMARY KEY CLUSTERED
(
	[DataStoreKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
