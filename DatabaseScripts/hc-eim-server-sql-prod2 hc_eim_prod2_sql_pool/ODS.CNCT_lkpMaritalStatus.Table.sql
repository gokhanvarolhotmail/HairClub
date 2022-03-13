/****** Object:  Table [ODS].[CNCT_lkpMaritalStatus]    Script Date: 3/12/2022 7:09:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpMaritalStatus]
(
	[MaritalStatusID] [int] NULL,
	[BOSMaritalStatusCode] [nvarchar](max) NULL,
	[MaritalStatusSortOrder] [int] NULL,
	[MaritalStatusDescription] [nvarchar](max) NULL,
	[MaritalStatusDescriptionShort] [nvarchar](max) NULL,
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
