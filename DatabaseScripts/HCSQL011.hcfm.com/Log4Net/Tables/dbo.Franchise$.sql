/* CreateDate: 04/11/2019 11:30:08.017 , ModifyDate: 04/11/2019 11:30:08.017 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Franchise$](
	[F1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Line] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[New _Bottle Size] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Old Franchise Pricing] [money] NULL,
	[New Franchise Pricing] [money] NULL,
	[PriceDefault] [money] NULL,
	[15Off] [money] NULL,
	[20Off] [money] NULL,
	[F11] [float] NULL
) ON [PRIMARY]
GO
