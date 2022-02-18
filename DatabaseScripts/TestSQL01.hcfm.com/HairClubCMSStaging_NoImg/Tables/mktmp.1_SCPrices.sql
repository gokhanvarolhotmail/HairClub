/* CreateDate: 02/15/2022 10:43:08.613 , ModifyDate: 02/15/2022 10:49:34.263 */
GO
CREATE TABLE [mktmp].[1_SCPrices](
	[SalesCodeID] [int] NULL,
	[SalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceDefault] [money] NULL
) ON [PRIMARY]
GO
