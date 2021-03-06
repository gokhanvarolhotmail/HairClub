/****** Object:  Table [ODS].[CNCT_ConnectLogs]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_ConnectLogs]
(
	[ID] [int] NULL,
	[Date] [datetime2](7) NULL,
	[CenterID] [int] NULL,
	[ClientGUID] [nvarchar](max) NULL,
	[ClientMembershipGUID] [nvarchar](max) NULL,
	[SalesOrderGUID] [nvarchar](max) NULL,
	[HairSystemOrderGUID] [nvarchar](max) NULL,
	[MethodName] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL,
	[Thread] [nvarchar](max) NULL,
	[Level] [nvarchar](max) NULL,
	[Logger] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
	[Exception] [nvarchar](max) NULL,
	[HostName] [nvarchar](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
