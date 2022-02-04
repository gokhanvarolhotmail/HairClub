/* CreateDate: 05/05/2020 17:42:44.733 , ModifyDate: 01/12/2022 19:00:29.833 */
GO
CREATE TABLE [dbo].[cfgSalesCodeCenter](
	[SalesCodeCenterID] [int] NOT NULL,
	[CenterID] [int] NULL,
	[SalesCodeID] [int] NULL,
	[PriceRetail] [money] NULL,
	[TaxRate1ID] [int] NULL,
	[TaxRate2ID] [int] NULL,
	[QuantityMaxLevel] [int] NULL,
	[QuantityMinLevel] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[AgreementID] [int] NULL,
	[CenterCost] [money] NULL,
 CONSTRAINT [PK_cfgSalesCodeCenter] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeCenter_CenterID_INCL] ON [dbo].[cfgSalesCodeCenter]
(
	[CenterID] ASC
)
INCLUDE([SalesCodeCenterID],[SalesCodeID],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
