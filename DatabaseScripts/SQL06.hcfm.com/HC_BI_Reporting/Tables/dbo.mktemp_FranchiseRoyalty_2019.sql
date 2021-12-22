/* CreateDate: 12/20/2021 10:48:30.047 , ModifyDate: 12/20/2021 10:48:30.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mktemp_FranchiseRoyalty_2019](
	[center] [int] NULL,
	[CenterName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CMS_Date] [int] NULL,
	[ticket_no] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[transact_no] [int] NULL,
	[date] [datetime] NULL,
	[client_no] [int] NULL,
	[client_name] [nvarchar](135) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Division] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Revenue] [money] NULL,
	[Tax] [money] NULL,
	[Net] [money] NULL,
	[Royalty] [money] NULL,
	[RoyaltyPercentage] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last_Transact] [datetime] NULL
) ON [PRIMARY]
GO
