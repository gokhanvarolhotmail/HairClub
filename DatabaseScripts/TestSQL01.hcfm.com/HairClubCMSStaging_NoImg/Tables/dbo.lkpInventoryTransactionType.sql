/* CreateDate: 08/27/2008 12:26:52.253 , ModifyDate: 12/03/2021 10:24:48.560 */
GO
CREATE TABLE [dbo].[lkpInventoryTransactionType](
	[InventoryTransactionTypeID] [int] NOT NULL,
	[InventoryTransactionTypeSortOrder] [int] NULL,
	[InventoryTransactionTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InventoryTransactionTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResetQuantityFlag] [bit] NULL,
	[IsProductSaleFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInventoryTransactionType] PRIMARY KEY CLUSTERED
(
	[InventoryTransactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInventoryTransactionType] ADD  CONSTRAINT [DF_lkpInventoryTransactionType_ResetQuantityFlag]  DEFAULT ((0)) FOR [ResetQuantityFlag]
GO
ALTER TABLE [dbo].[lkpInventoryTransactionType] ADD  CONSTRAINT [DF_lkpInventoryTransactionType_IsProductSaleFlag]  DEFAULT ((0)) FOR [IsProductSaleFlag]
GO
ALTER TABLE [dbo].[lkpInventoryTransactionType] ADD  CONSTRAINT [DF_lkpInventoryTransactionType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
