/* CreateDate: 05/28/2018 22:15:34.530 , ModifyDate: 10/29/2018 17:11:00.300 */
GO
CREATE TABLE [dbo].[lkpInventoryAdjustmentType](
	[InventoryAdjustmentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryAdjustmentTypeSortOrder] [int] NOT NULL,
	[InventoryAdjustmentTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryAdjustmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDistributorAdjustment] [bit] NOT NULL,
	[IsNegativeAdjustment] [bit] NOT NULL,
	[IsNoteRequired] [bit] NOT NULL,
	[IsSerializedAdjustmentAllowed] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsCenterType] [bit] NOT NULL,
	[IsAdminType] [bit] NOT NULL,
 CONSTRAINT [PK_lkpInventoryAdjustmentType] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInventoryAdjustmentType] ADD  DEFAULT ((0)) FOR [IsCenterType]
GO
ALTER TABLE [dbo].[lkpInventoryAdjustmentType] ADD  DEFAULT ((0)) FOR [IsAdminType]
GO
