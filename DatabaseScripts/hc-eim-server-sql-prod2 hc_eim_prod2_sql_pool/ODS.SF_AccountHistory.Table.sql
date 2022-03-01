/****** Object:  Table [ODS].[SF_AccountHistory]    Script Date: 3/1/2022 8:53:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_AccountHistory]
(
	[Id] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[AccountId] [nvarchar](max) NULL,
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
