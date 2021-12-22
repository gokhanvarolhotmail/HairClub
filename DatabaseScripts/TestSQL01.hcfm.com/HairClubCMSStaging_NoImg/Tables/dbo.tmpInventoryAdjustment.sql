/* CreateDate: 07/10/2020 14:18:35.427 , ModifyDate: 07/10/2020 14:18:35.427 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpInventoryAdjustment](
	[CenterNumber] [int] NULL,
	[CenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSize] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeID] [int] NULL,
	[DefaultQuantityAdjustment] [int] NULL
) ON [PRIMARY]
GO
