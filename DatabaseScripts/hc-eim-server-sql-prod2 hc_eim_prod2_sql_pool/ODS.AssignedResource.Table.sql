/****** Object:  Table [ODS].[AssignedResource]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[AssignedResource]
(
	[Id] [nvarchar](18) NULL,
	[IsDeleted] [bit] NULL,
	[AssignedResourceNumber] [nvarchar](765) NULL,
	[CreatedDate] [datetime2](0) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime2](0) NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[SystemModstamp] [datetime2](0) NULL,
	[ServiceAppointmentId] [nvarchar](18) NULL,
	[ServiceResourceId] [nvarchar](18) NULL,
	[IsRequiredResource] [bit] NULL,
	[Role] [nvarchar](765) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
