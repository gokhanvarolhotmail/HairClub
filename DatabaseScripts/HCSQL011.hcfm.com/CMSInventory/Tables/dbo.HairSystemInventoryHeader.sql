/* CreateDate: 03/30/2011 09:42:32.237 , ModifyDate: 07/12/2014 04:14:35.467 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HairSystemInventoryHeader](
	[InventoryID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[ScanMonth] [int] NULL,
	[ScanYear] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScanCompleted] [bit] NULL,
	[CompleteDate] [datetime] NULL,
	[CompleteUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScanDay] [int] NULL,
	[ScanLabel] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAdjustmentCompleted] [bit] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_HairSystemInventoryHeader] ON [dbo].[HairSystemInventoryHeader]
(
	[ScanYear] ASC,
	[ScanMonth] ASC,
	[ScanDay] ASC,
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HairSystemInventoryHeader] ADD  CONSTRAINT [DF_HairSystemInventoryHeader_IsAdjustmentCompleted]  DEFAULT ((0)) FOR [IsAdjustmentCompleted]
GO
