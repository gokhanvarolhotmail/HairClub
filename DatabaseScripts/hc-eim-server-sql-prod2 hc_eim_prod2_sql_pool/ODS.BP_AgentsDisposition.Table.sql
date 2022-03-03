/****** Object:  Table [ODS].[BP_AgentsDisposition]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[BP_AgentsDisposition]
(
	[disposition_name] [varchar](8000) NULL,
	[start_time] [datetime2](7) NULL,
	[end_time] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
