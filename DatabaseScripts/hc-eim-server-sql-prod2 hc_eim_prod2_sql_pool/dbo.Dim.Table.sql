/****** Object:  Table [dbo].[Dim]    Script Date: 3/4/2022 8:28:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim]
(
	[Key] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Hash] [varchar](256) NULL,
	[DWH_CreatedDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Key] ASC
	)
)
GO
