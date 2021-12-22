/* CreateDate: 01/09/2007 14:02:05.273 , ModifyDate: 05/08/2010 02:30:11.653 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpEmailConfirm](
	[ConfirmID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[RecordID] [int] NULL,
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
 CONSTRAINT [PK_tmpEmailConfirm] PRIMARY KEY CLUSTERED
(
	[ConfirmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpEmailConfirm] ADD  CONSTRAINT [DF_tmpEmailConfirm_ConfirmID]  DEFAULT (newid()) FOR [ConfirmID]
GO
