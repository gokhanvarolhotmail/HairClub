/* CreateDate: 04/24/2017 08:10:29.223 , ModifyDate: 12/03/2021 10:24:48.710 */
GO
CREATE TABLE [dbo].[cfgAddOn](
	[AddOnID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddOnSortOrder] [int] NOT NULL,
	[AddOnDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddOnDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddOnTypeID] [int] NOT NULL,
	[PriceDefault] [money] NOT NULL,
	[PriceMinimum] [money] NOT NULL,
	[PriceMaximum] [money] NOT NULL,
	[QuantityMinimum] [int] NOT NULL,
	[QuantityMaximum] [int] NOT NULL,
	[CarryOverToNewMembership] [bit] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsMultipleAddAllowed] [bit] NOT NULL,
	[PaymentSalesCodeID] [int] NOT NULL,
	[MonthlyFeeSalesCodeID] [int] NULL,
	[CarryOverRemainingBenefitsToNewMembership] [bit] NOT NULL,
	[QuantityIntervalMultiplier] [int] NOT NULL,
 CONSTRAINT [PK_cfgAddOnID] PRIMARY KEY CLUSTERED
(
	[AddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgAddOn] ADD  CONSTRAINT [DF_cfgAddOn_IsMultipleAddAllowed]  DEFAULT ((0)) FOR [IsMultipleAddAllowed]
GO
ALTER TABLE [dbo].[cfgAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgAddOn_cfgSalesCode] FOREIGN KEY([PaymentSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgAddOn] CHECK CONSTRAINT [FK_cfgAddOn_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgAddOn_cfgSalesCode1] FOREIGN KEY([MonthlyFeeSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgAddOn] CHECK CONSTRAINT [FK_cfgAddOn_cfgSalesCode1]
GO
ALTER TABLE [dbo].[cfgAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgAddOn_lkpAddOnType] FOREIGN KEY([AddOnTypeID])
REFERENCES [dbo].[lkpAddOnType] ([AddOnTypeID])
GO
ALTER TABLE [dbo].[cfgAddOn] CHECK CONSTRAINT [FK_cfgAddOn_lkpAddOnType]
GO
