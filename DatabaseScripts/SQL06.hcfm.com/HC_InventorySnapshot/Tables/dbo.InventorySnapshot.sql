/* CreateDate: 12/07/2020 16:29:29.913 , ModifyDate: 12/07/2020 16:29:29.913 */
GO
CREATE TABLE [dbo].[InventorySnapshot](
	[SnapshotID] [int] NULL,
	[SnapshotDate] [date] NOT NULL,
	[SnapshotTime] [time](7) NOT NULL,
	[SnapshotCenterNumber] [int] NULL,
	[SnapshotCenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HSOCenterNumber] [int] NULL,
	[HSOCenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderDate] [date] NOT NULL,
	[SnapshotHairSystemOrderStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScannedDate] [datetime] NULL,
	[IsScannedEntry] [bit] NULL,
	[ClientIdentifier] [int] NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RevenueGroup] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegment] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Membership] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeginDate] [date] NULL,
	[EndDate] [date] NULL,
	[MembershipStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CostContract] [money] NOT NULL,
	[CostActual] [money] NOT NULL,
	[CostFactoryShipped] [money] NOT NULL
) ON [PRIMARY]
GO
