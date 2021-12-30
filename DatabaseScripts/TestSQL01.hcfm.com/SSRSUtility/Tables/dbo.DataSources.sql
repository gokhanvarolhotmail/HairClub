/* CreateDate: 03/12/2019 09:24:30.000 , ModifyDate: 03/12/2019 09:24:30.000 */
GO
CREATE TABLE [dbo].[DataSources](
	[ItemID] [uniqueidentifier] NOT NULL,
	[Path] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ParentID] [uniqueidentifier] NULL,
	[Type] [int] NOT NULL,
	[TypeDesc] [nvarchar](37) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hidden] [bit] NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DataSourceName] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DataProvider] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConnectionString] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DataSourceReference] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
