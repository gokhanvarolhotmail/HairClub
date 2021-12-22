/* CreateDate: 06/15/2018 10:09:45.357 , ModifyDate: 06/15/2018 10:09:45.483 */
GO
CREATE TABLE [dbo].[lkpHansWiemannSalesCodeCosts](
	[HWSalesCodeCostID] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeSSID] [int] NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterCost] [decimal](18, 4) NULL,
 CONSTRAINT [PK_lkpHansWiemannSalesCodeCosts] PRIMARY KEY CLUSTERED
(
	[HWSalesCodeCostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180615-094445] ON [dbo].[lkpHansWiemannSalesCodeCosts]
(
	[SalesCodeDescriptionShort] ASC
)
INCLUDE([CenterCost],[SalesCodeSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
