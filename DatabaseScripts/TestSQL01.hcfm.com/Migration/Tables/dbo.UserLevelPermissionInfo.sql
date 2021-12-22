/* CreateDate: 05/14/2018 11:29:00.710 , ModifyDate: 05/14/2018 11:29:00.710 */
GO
CREATE TABLE [dbo].[UserLevelPermissionInfo](
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Object] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Member] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RoleSecurableClass] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchemaOwner] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Securable] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GranteeType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Grantee] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Permission] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Grantor] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GrantorType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceView] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
