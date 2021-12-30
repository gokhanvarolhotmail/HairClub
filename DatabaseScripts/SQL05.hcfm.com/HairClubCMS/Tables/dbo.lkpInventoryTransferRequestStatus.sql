/* CreateDate: 05/05/2020 17:42:50.350 , ModifyDate: 05/05/2020 17:43:10.620 */
GO
CREATE TABLE [dbo].[lkpInventoryTransferRequestStatus](
	[InventoryTransferRequestStatusID] [int] NOT NULL,
	[InventoryTransferRequestStatusSortOrder] [int] NOT NULL,
	[InventoryTransferRequestStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryTransferRequestStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInventoryTransferRequestStatus] PRIMARY KEY CLUSTERED
(
	[InventoryTransferRequestStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
