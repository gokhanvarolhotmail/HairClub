/* CreateDate: 05/28/2018 22:15:34.370 , ModifyDate: 11/29/2018 22:41:55.350 */
GO
CREATE TABLE [dbo].[lkpDistributorPurchaseOrderStatus](
	[DistributorPurchaseOrderStatusID] [int] IDENTITY(1,1) NOT NULL,
	[DistributorPurchaseOrderStatusSortOrder] [int] NOT NULL,
	[DistributorPurchaseOrderStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DistributorPurchaseOrderStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveAtDistributor] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpDistributorPurchaseOrderStatus] PRIMARY KEY CLUSTERED
(
	[DistributorPurchaseOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
