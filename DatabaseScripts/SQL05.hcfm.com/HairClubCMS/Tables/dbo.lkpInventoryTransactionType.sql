/* CreateDate: 05/05/2020 17:42:51.003 , ModifyDate: 05/05/2020 17:43:11.780 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
