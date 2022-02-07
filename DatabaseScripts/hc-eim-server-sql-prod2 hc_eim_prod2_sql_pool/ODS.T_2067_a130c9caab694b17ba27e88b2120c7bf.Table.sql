/****** Object:  Table [ODS].[T_2067_a130c9caab694b17ba27e88b2120c7bf]    Script Date: 2/7/2022 10:45:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2067_a130c9caab694b17ba27e88b2120c7bf]
(
	[GeneralLedgerID] [int] NULL,
	[GeneralLedgerSortOrder] [int] NULL,
	[GeneralLedgerDescription] [nvarchar](max) NULL,
	[GeneralLedgerDescriptionShort] [nvarchar](max) NULL,
	[QuickBooksDescription] [nvarchar](max) NULL,
	[QuickBooksAccountType] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[r2a34562009304984ad3ae393ccfc766e] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
