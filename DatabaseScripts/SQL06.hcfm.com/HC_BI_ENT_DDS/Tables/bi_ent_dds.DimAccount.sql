/* CreateDate: 01/08/2021 15:21:53.220 , ModifyDate: 01/08/2021 15:21:54.663 */
GO
CREATE TABLE [bi_ent_dds].[DimAccount](
	[AccountID] [int] NOT NULL,
	[LedgerGroup] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EBIDA] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level0] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level0Sort] [int] NULL,
	[Level1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level1Sort] [int] NULL,
	[Level2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level2Sort] [int] NULL,
	[Level3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level3Sort] [int] NULL,
	[Level4] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level4Sort] [int] NULL,
	[Level5] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level5Sort] [int] NULL,
	[Level6] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level6Sort] [int] NULL,
	[RevenueOrExpenses] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpenseType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CalculateGrossProfit] [int] NULL,
	[Description]  AS ((CONVERT([varchar](5),[AccountID],(0))+' - ')+[AccountDescription]),
 CONSTRAINT [PK__DimAccou__349DA5861EF99443] PRIMARY KEY CLUSTERED
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
