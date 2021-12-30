/* CreateDate: 10/04/2010 12:08:45.710 , ModifyDate: 12/28/2021 09:20:54.610 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInventoryTransferRequestStatus] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
