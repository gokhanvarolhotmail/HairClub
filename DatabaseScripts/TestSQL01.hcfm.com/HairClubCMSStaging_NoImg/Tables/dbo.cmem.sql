/* CreateDate: 06/23/2017 12:36:56.513 , ModifyDate: 06/23/2017 12:36:56.513 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmem](
	[centerid] [int] NULL,
	[clientmembershipguid] [uniqueidentifier] NOT NULL,
	[membershipdescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clientguid] [uniqueidentifier] NULL,
	[enddate] [date] NULL,
	[MemStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[clientfullnamecalc] [nvarchar](127) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
