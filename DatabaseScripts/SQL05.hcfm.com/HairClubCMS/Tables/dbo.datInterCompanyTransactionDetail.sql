/* CreateDate: 05/05/2020 17:42:50.960 , ModifyDate: 05/05/2020 17:43:11.783 */
GO
CREATE TABLE [dbo].[datInterCompanyTransactionDetail](
	[InterCompanyTransactionDetailId] [int] NOT NULL,
	[InterCompanyTransactionId] [int] NOT NULL,
	[SalesOrderDetailGUID] [uniqueidentifier] NOT NULL,
	[SalesCodeId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[TotalCost]  AS ([Price]*[Quantity]),
	[AmountCollected] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datInterCompanyTransactionDetail] PRIMARY KEY CLUSTERED
(
	[InterCompanyTransactionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
