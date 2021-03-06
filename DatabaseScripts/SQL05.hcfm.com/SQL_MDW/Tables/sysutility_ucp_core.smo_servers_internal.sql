/* CreateDate: 01/03/2014 07:07:53.887 , ModifyDate: 01/03/2014 07:07:53.887 */
GO
CREATE TABLE [sysutility_ucp_core].[smo_servers_internal](
	[urn] [nvarchar](320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[powershell_path] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processing_time] [datetimeoffset](7) NOT NULL,
	[batch_time] [datetimeoffset](7) NULL,
	[AuditLevel] [smallint] NULL,
	[BackupDirectory] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrowserServiceAccount] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrowserStartMode] [smallint] NULL,
	[BuildClrVersionString] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BuildNumber] [int] NULL,
	[Collation] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CollationID] [int] NULL,
	[ComparisonStyle] [int] NULL,
	[ComputerNamePhysicalNetBIOS] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultFile] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultLog] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Edition] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EngineEdition] [smallint] NULL,
	[ErrorLogPath] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FilestreamShareName] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstallDataDirectory] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstallSharedDirectory] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsCaseSensitive] [bit] NULL,
	[IsClustered] [bit] NULL,
	[IsFullTextInstalled] [bit] NULL,
	[IsSingleUser] [bit] NULL,
	[Language] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailProfile] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MasterDBLogPath] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MasterDBPath] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaxPrecision] [tinyint] NULL,
	[Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NamedPipesEnabled] [bit] NULL,
	[NetName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberOfLogFiles] [int] NULL,
	[OSVersion] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PerfMonMode] [smallint] NULL,
	[PhysicalMemory] [int] NULL,
	[Platform] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Processors] [smallint] NULL,
	[ProcessorUsage] [int] NULL,
	[Product] [nvarchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProductLevel] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResourceVersionString] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RootDirectory] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServerType] [smallint] NULL,
	[ServiceAccount] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceInstanceId] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceName] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceStartMode] [smallint] NULL,
	[SqlCharSet] [smallint] NULL,
	[SqlCharSetName] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlDomainGroup] [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlSortOrder] [smallint] NULL,
	[SqlSortOrderName] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [smallint] NULL,
	[TapeLoadWaitTime] [int] NULL,
	[TcpEnabled] [bit] NULL,
	[VersionMajor] [int] NULL,
	[VersionMinor] [int] NULL,
	[VersionString] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_smo_servers_internal] PRIMARY KEY CLUSTERED
(
	[processing_time] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'DIMENSION' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_core', @level1type=N'TABLE',@level1name=N'smo_servers_internal'
GO
