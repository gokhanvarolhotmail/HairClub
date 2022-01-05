/* CreateDate: 12/30/2021 15:59:01.137 , ModifyDate: 12/30/2021 15:59:01.137 */
GO
CREATE TABLE [dbo].[cfgSalesCodeCenter_bak](
	[SalesCodeCenterID] [int] IDENTITY(1,1) NOT NULL,
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
	[CenterCost] [money] NULL
) ON [PRIMARY]
GO
