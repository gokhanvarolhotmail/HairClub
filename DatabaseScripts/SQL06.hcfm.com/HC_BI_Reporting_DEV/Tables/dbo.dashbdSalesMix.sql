/* CreateDate: 07/02/2014 12:42:08.720 , ModifyDate: 07/02/2014 12:42:08.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dashbdSalesMix](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MonthDate] [datetime] NULL,
	[CenterKey] [int] NULL,
	[CenterDescriptionNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionKey] [int] NULL,
	[RegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionSortOrder] [int] NULL,
	[BIO_SalesMix] [float] NULL,
	[EXT_SalesMix] [float] NULL,
	[Surgery_SalesMix] [float] NULL
) ON [PRIMARY]
GO
