/****** Object:  Table [ODS].[CNCT_lkpEthnicity]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpEthnicity]
(
	[EthnicityID] [int] NULL,
	[BOSEthnicityCode] [nvarchar](max) NULL,
	[EthnicitySortOrder] [int] NULL,
	[EthnicityDescription] [nvarchar](max) NULL,
	[EthnicityDescriptionShort] [nvarchar](max) NULL,
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
