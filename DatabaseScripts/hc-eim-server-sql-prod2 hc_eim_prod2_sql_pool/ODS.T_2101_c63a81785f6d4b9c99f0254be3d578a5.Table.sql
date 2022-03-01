/****** Object:  Table [ODS].[T_2101_c63a81785f6d4b9c99f0254be3d578a5]    Script Date: 3/1/2022 8:53:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2101_c63a81785f6d4b9c99f0254be3d578a5]
(
	[GenderID] [int] NULL,
	[GenderSortOrder] [int] NULL,
	[GenderDescription] [nvarchar](max) NULL,
	[GenderDescriptionShort] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[DescriptionResourceKey] [nvarchar](max) NULL,
	[DescriptionShortResourceKey] [nvarchar](max) NULL,
	[r56c63499cf6b4aedbab3be7151bf5ece] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
