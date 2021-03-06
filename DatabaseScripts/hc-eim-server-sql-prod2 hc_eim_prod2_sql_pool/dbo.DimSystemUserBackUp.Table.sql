/****** Object:  Table [dbo].[DimSystemUserBackUp]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSystemUserBackUp]
(
	[UserKey] [int] NULL,
	[UserId] [varchar](200) NULL,
	[UserLogin] [varchar](400) NULL,
	[UserName] [varchar](400) NULL,
	[CompanyName] [varchar](400) NULL,
	[Street] [varchar](400) NULL,
	[City] [varchar](400) NULL,
	[State] [varchar](400) NULL,
	[TeamName] [varchar](400) NULL,
	[cONEctUserLogin] [varchar](200) NULL,
	[cONEctGUID] [varchar](200) NULL,
	[CenterId] [varchar](50) NULL,
	[Hash] [varchar](256) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[SourceSystem] [varchar](100) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
