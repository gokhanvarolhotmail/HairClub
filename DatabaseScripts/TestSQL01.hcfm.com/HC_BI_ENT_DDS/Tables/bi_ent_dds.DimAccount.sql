/* CreateDate: 04/10/2012 10:57:22.467 , ModifyDate: 09/16/2019 09:25:18.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[Level4] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level4Sort] [int] NULL,
	[Level5] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level5Sort] [int] NULL,
	[Level6] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level6Sort] [int] NULL,
	[RevenueOrExpenses] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpenseType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CalculateGrossProfit] [int] NULL,
	[Description]  AS ((CONVERT([varchar](5),[AccountID],(0))+' - ')+[AccountDescription]),
PRIMARY KEY CLUSTERED
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
