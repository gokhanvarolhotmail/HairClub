/* CreateDate: 01/29/2009 15:31:30.030 , ModifyDate: 12/07/2021 16:20:16.117 */
GO
CREATE TABLE [dbo].[lkpSalesCodeType](
	[SalesCodeTypeID] [int] NOT NULL,
	[SalesCodeTypeSortOrder] [int] NOT NULL,
	[SalesCodeTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsInventory] [bit] NULL,
	[IsSerialized] [bit] NULL,
	[IsHairSystem] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpSalesCodeType] PRIMARY KEY CLUSTERED
(
	[SalesCodeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpSalesCodeType] ADD  CONSTRAINT [DF_lkpSalesCodeType_IsInventory]  DEFAULT ((0)) FOR [IsInventory]
GO
ALTER TABLE [dbo].[lkpSalesCodeType] ADD  CONSTRAINT [DF_lkpSalesCodeType_IsSerialized]  DEFAULT ((0)) FOR [IsSerialized]
GO
ALTER TABLE [dbo].[lkpSalesCodeType] ADD  CONSTRAINT [DF_lkpSalesCodeType_IsHairSystem]  DEFAULT ((0)) FOR [IsHairSystem]
GO
ALTER TABLE [dbo].[lkpSalesCodeType] ADD  CONSTRAINT [DF_lkpSalesCodeType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
