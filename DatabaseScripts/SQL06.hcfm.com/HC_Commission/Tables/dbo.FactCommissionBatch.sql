CREATE TABLE [dbo].[FactCommissionBatch](
	[BatchKey] [int] IDENTITY(1,1) NOT NULL,
	[CenterSSID] [int] NULL,
	[PayPeriodKey] [int] NULL,
	[BatchStatusID] [int] NULL,
	[CreatedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_FactCommissionBatch] PRIMARY KEY CLUSTERED
(
	[BatchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
