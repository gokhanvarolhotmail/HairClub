/****** Object:  Table [dbo].[DimFormat]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimFormat]
(
	[FormatKey] [int] IDENTITY(1,1) NOT NULL,
	[FormatName] [nvarchar](50) NOT NULL,
	[FormatValue] [nvarchar](50) NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Source] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[FormatKey] ASC
	)
)
GO
