/****** Object:  Table [ODS].[CNCT_lkpGeneralLedger]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpGeneralLedger]
(
	[GeneralLedgerID] [int] NULL,
	[GeneralLedgerSortOrder] [int] NULL,
	[GeneralLedgerDescription] [varchar](8000) NULL,
	[GeneralLedgerDescriptionShort] [varchar](8000) NULL,
	[QuickBooksDescription] [varchar](8000) NULL,
	[QuickBooksAccountType] [varchar](8000) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
