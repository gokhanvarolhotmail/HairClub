/* CreateDate: 05/05/2020 17:42:38.533 , ModifyDate: 05/05/2020 17:42:58.457 */
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
	[UpdateStamp] [binary](8) NULL,
	[IsMultipleAddAllowed] [bit] NOT NULL,
	[PaymentSalesCodeID] [int] NOT NULL,
	[MonthlyFeeSalesCodeID] [int] NULL,
	[CarryOverRemainingBenefitsToNewMembership] [bit] NOT NULL,
	[QuantityIntervalMultiplier] [int] NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgAddOnID] ON [dbo].[cfgAddOn]
(
	[AddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
