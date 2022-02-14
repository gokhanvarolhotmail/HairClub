/****** Object:  Table [dbo].[DimLossReason]    Script Date: 2/14/2022 11:44:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimLossReason]
(
	[LossReasonKey] [int] IDENTITY(1,1) NOT NULL,
	[LossReasonName] [nvarchar](50) NULL,
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
		[LossReasonKey] ASC
	)
)
GO
