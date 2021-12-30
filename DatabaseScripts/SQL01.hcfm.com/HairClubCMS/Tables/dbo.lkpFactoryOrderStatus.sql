/* CreateDate: 08/27/2008 12:00:38.273 , ModifyDate: 05/26/2020 10:49:42.203 */
GO
CREATE TABLE [dbo].[lkpFactoryOrderStatus](
	[FactoryOrderStatusID] [int] NOT NULL,
	[FactoryOrderStatusSortOrder] [int] NULL,
	[FactoryOrderDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FactoryOrderDescriptionShort] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAvailableForOrderFlag] [bit] NULL,
	[IsOrderUsedStatusFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpFactoryOrderStatus] PRIMARY KEY CLUSTERED
(
	[FactoryOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpFactoryOrderStatus] ADD  CONSTRAINT [DF_lkpFactoryOrderStatus_IsAvailableForOrderFlag]  DEFAULT ((0)) FOR [IsAvailableForOrderFlag]
GO
ALTER TABLE [dbo].[lkpFactoryOrderStatus] ADD  CONSTRAINT [DF_lkpFactoryOrderStatus_IsOrderUsedStatusFlag]  DEFAULT ((0)) FOR [IsOrderUsedStatusFlag]
GO
ALTER TABLE [dbo].[lkpFactoryOrderStatus] ADD  CONSTRAINT [DF_lkpFactoryOrderStatus_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
