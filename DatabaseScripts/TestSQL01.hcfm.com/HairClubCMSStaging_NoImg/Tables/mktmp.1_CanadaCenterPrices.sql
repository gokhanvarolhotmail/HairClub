/* CreateDate: 02/15/2022 10:43:08.013 , ModifyDate: 02/15/2022 10:44:42.887 */
GO
CREATE TABLE [mktmp].[1_CanadaCenterPrices](
	[SalesCodeID] [int] NULL,
	[SalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Price] [money] NULL
) ON [PRIMARY]
GO
