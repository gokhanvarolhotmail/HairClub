/****** Object:  Table [ODS].[CNCT_lkpSalutation]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpSalutation]
(
	[SalutationID] [int] NULL,
	[SalutationSortOrder] [int] NULL,
	[SalutationDescription] [nvarchar](max) NULL,
	[SalutationDescriptionShort] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[DescriptionResourceKey] [nvarchar](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
