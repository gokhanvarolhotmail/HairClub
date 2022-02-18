/* CreateDate: 01/11/2022 15:51:13.943 , ModifyDate: 02/07/2022 11:04:00.150 */
GO
CREATE TABLE [mktmp].[cfgSalesCodeCenter_bak_2](
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
