/* CreateDate: 09/04/2007 09:40:45.430 , ModifyDate: 06/21/2012 10:12:51.977 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailConfirm](
	[ConfirmID] [uniqueidentifier] NOT NULL,
	[MergeField01] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField02] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField03] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField04] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField05] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField06] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField07] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField08] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField09] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField10] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timestamp] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sendcount] [int] NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_EmailConfirm] PRIMARY KEY CLUSTERED
(
	[ConfirmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailConfirm] ADD  CONSTRAINT [DF_EmailConfirm_ConfrimID]  DEFAULT (newid()) FOR [ConfirmID]
GO
ALTER TABLE [dbo].[EmailConfirm] ADD  CONSTRAINT [DF_EmailConfirm_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
ALTER TABLE [dbo].[EmailConfirm] ADD  CONSTRAINT [DF_EmailConfirm_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
