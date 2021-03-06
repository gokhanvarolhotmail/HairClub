/****** Object:  Table [ODS].[CNCT_CenterType]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_CenterType]
(
	[CenterTypeID] [int] NULL,
	[CenterTypeSortOrder] [int] NULL,
	[CenterTypeDescription] [varchar](8000) NULL,
	[CenterTypeDescriptionShort] [varchar](8000) NULL,
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
