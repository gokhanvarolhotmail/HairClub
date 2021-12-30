/* CreateDate: 01/10/2007 17:12:46.960 , ModifyDate: 01/10/2007 17:12:46.960 */
GO
CREATE TABLE [dbo].[tmpEmailConfirmHolding](
	[RecordId] [int] NULL,
	[MergeField01] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField02] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField03] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField04] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField05] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField06] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField07] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MergeField08] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timestamp] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sendcount] [int] NULL
) ON [PRIMARY]
GO
