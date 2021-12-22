/* CreateDate: 06/23/2017 12:36:57.203 , ModifyDate: 06/23/2017 12:36:57.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Renewals](
	[previousclientmembershipguid] [uniqueidentifier] NULL,
	[orderdate] [datetime] NULL,
	[salescodedescriptionshort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clientguid] [uniqueidentifier] NULL,
	[centerid] [int] NULL,
	[clientfullnamecalc] [nvarchar](127) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clientmembershipguid] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
