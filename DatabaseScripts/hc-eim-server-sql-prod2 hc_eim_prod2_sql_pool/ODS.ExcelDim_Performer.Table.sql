/****** Object:  Table [ODS].[ExcelDim_Performer]    Script Date: 3/15/2022 2:11:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[ExcelDim_Performer]
(
	[displayName] [varchar](250) NULL,
	[countryCode] [varchar](250) NULL,
	[department] [varchar](250) NULL,
	[mail] [varchar](250) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
