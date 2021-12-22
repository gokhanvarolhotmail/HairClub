/* CreateDate: 01/17/2014 15:41:49.080 , ModifyDate: 01/17/2014 15:41:49.080 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CenterID] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[MethodName] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Thread] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Logger] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Message] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Exception] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HostName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
