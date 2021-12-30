/* CreateDate: 02/22/2019 15:30:10.890 , ModifyDate: 02/22/2019 15:30:10.890 */
GO
CREATE TABLE [dbo].[HankPrice](
	[SalesCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceDefault] [money] NULL,
	[Price Hank] [money] NULL,
	[Difference] [money] NULL
) ON [FG_CDC]
GO
