/* CreateDate: 01/12/2014 01:25:25.917 , ModifyDate: 01/12/2014 01:25:25.917 */
GO
CREATE TABLE [dbo].[EFTLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CenterID] [int] NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NULL,
	[CenterDeclineBatchGUID] [uniqueidentifier] NULL,
	[UserName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Thread] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Logger] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Message] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Exception] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MethodName] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HostName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
