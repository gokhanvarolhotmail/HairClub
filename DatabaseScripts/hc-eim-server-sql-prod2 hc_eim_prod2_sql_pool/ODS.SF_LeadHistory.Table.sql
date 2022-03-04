/****** Object:  Table [ODS].[SF_LeadHistory]    Script Date: 3/4/2022 8:28:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_LeadHistory]
(
	[Id] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[LeadId] [nvarchar](max) NULL,
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
