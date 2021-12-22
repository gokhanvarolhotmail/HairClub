/* CreateDate: 04/22/2011 14:35:33.130 , ModifyDate: 04/22/2011 14:35:33.130 */
GO
CREATE TABLE [dbo].[HairSystemInventoryDetails_ARCHIVE](
	[InventoryDetailsID] [uniqueidentifier] NULL,
	[InventoryID] [uniqueidentifier] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [int] NULL,
	[HairSystemOrderStatusID] [int] NULL,
	[InTransit] [bit] NULL,
	[CostContract] [money] NULL,
	[CostActual] [money] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[ClientIdentifier] [int] NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembership] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScannedDate] [datetime] NULL,
	[ScannedUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScannedCenterID] [int] NULL,
	[Exception] [bit] NULL,
	[HairSystemOrderDate] [datetime] NULL,
	[HairSystemContractName] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemFactory] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[HairSystemOrderStatus] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientCenterID] [int] NULL
) ON [PRIMARY]
GO
