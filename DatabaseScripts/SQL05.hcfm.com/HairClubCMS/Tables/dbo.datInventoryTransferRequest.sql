/* CreateDate: 05/05/2020 17:42:50.410 , ModifyDate: 05/05/2020 17:43:10.833 */
GO
CREATE TABLE [dbo].[datInventoryTransferRequest](
	[InventoryTransferRequestGUID] [uniqueidentifier] NOT NULL,
	[InventoryTransferRequestDate] [datetime] NOT NULL,
	[InventoryTransferRequestStatusID] [int] NOT NULL,
	[InventoryTransferRequestRejectReasonID] [int] NULL,
	[IsRejectedFlag] [bit] NOT NULL,
	[OriginalHairSystemOrderStatusID] [int] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[FromCenterID] [int] NOT NULL,
	[ToCenterID] [int] NOT NULL,
	[FromClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[ToClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[InventoryTransferRequestNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastStatusChangeDate] [datetime] NULL,
	[CompleteDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datInventoryTransferRequest] PRIMARY KEY CLUSTERED
(
	[InventoryTransferRequestGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
