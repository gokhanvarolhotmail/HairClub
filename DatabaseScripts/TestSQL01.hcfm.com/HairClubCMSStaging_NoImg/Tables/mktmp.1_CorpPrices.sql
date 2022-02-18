/* CreateDate: 02/15/2022 10:43:08.500 , ModifyDate: 02/15/2022 10:43:08.500 */
GO
CREATE TABLE [mktmp].[1_CorpPrices](
	[SalesCodeID] [int] NULL,
	[SalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Price] [money] NULL
) ON [PRIMARY]
GO
