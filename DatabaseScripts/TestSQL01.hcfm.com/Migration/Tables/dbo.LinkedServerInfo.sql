/* CreateDate: 05/13/2018 21:00:35.847 , ModifyDate: 05/13/2018 21:00:35.847 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LinkedServerInfo](
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Impersonate] [bit] NULL,
	[RemoteUser] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RemoteServer] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Publisher] [bit] NULL,
	[Parent] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Catalog] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CollationCompatible] [bit] NULL,
	[CollationName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConnectTimeout] [int] NULL,
	[DataAccess] [bit] NULL,
	[DataSource] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateLastModified] [datetime2](7) NULL,
	[DistPublisher] [bit] NULL,
	[Distributor] [bit] NULL,
	[ID] [int] NULL,
	[IsPromotionofDistributedTransactionsForRPCEnabled] [bit] NULL,
	[LazySchemaValidation] [bit] NULL,
	[Location] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProductName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProviderName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QueryTimeout] [int] NULL,
	[Rpc] [bit] NULL,
	[RpcOut] [bit] NULL,
	[Subscriber] [bit] NULL,
	[UseRemoteCollation] [bit] NULL,
	[Name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProviderString] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LinkedServerLogins] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Urn] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Properties] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseEngineType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DatabaseEngineEdition] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExecutionManager] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserData] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDesignMode] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
