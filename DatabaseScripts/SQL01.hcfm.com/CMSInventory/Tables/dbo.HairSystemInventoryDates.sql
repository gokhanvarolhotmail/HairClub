/* CreateDate: 03/30/2011 09:42:32.330 , ModifyDate: 12/28/2011 17:27:37.237 */
GO
CREATE TABLE [dbo].[HairSystemInventoryDates](
	[InventoryDateID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryMonth] [int] NULL,
	[InventoryYear] [int] NULL,
	[ActiveInventory] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InventoryDay] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HairSystemInventoryDates] ADD  CONSTRAINT [DF__HairSyste__Inven__3E52440B]  DEFAULT ((1)) FOR [InventoryDay]
GO
