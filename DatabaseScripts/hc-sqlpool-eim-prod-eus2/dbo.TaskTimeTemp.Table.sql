/****** Object:  Table [dbo].[TaskTimeTemp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskTimeTemp]
(
	[id] [varchar](200) NULL,
	[activitydate] [varchar](200) NULL,
	[startime] [varchar](200) NULL,
	[activitydatetime] [varchar](200) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
