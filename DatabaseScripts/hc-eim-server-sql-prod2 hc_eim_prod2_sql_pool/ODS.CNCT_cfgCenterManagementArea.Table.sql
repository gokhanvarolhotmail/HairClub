/****** Object:  Table [ODS].[CNCT_cfgCenterManagementArea]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_cfgCenterManagementArea]
(
	[CenterManagementAreaID] [int] NULL,
	[CenterManagementAreaSortOrder] [int] NULL,
	[CenterManagementAreaDescription] [nvarchar](max) NULL,
	[CenterManagementAreaDescriptionShort] [nvarchar](max) NULL,
	[OperationsManagerGUID] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
