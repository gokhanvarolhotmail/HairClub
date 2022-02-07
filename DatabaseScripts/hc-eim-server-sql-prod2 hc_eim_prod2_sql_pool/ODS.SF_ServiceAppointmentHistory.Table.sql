/****** Object:  Table [ODS].[SF_ServiceAppointmentHistory]    Script Date: 2/7/2022 10:45:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_ServiceAppointmentHistory]
(
	[Id] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[ServiceAppointmentId] [nvarchar](max) NULL,
	[CreatedById] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[Field] [nvarchar](max) NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
