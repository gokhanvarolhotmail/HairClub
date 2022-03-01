/****** Object:  Table [dbo].[DimAudience]    Script Date: 3/1/2022 8:53:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAudience]
(
	[AudienceKey] [int] IDENTITY(1,1) NOT NULL,
	[AudienceName] [nvarchar](50) NOT NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Source] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[AudienceKey] ASC
	)
)
GO
