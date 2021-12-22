/* CreateDate: 05/10/2018 17:42:06.650 , ModifyDate: 05/10/2018 17:42:06.650 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginInfo](
	[LastLogin] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ComputerName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstanceName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SqlInstance] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AsymmetricKey] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Certificate] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime2](7) NULL,
	[Credential] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateLastModified] [datetime2](7) NULL,
	[DefaultDatabase] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DenyWindowsLogin] [bit] NULL,
	[HasAccess] [bit] NULL,
	[ID] [int] NULL,
	[IsDisabled] [bit] NULL,
	[IsLocked] [bit] NULL,
	[IsPasswordExpired] [bit] NULL,
	[IsSystemObject] [bit] NULL,
	[Language] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageAlias] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MustChangePassword] [bit] NULL,
	[PasswordExpirationEnabled] [bit] NULL,
	[PasswordHashAlgorithm] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PasswordPolicyEnforced] [bit] NULL,
	[Sid] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WindowsLoginAccessType] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Events] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
