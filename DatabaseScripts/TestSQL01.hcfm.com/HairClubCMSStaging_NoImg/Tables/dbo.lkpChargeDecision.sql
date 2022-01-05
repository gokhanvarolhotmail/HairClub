/* CreateDate: 02/07/2011 21:37:20.663 , ModifyDate: 01/04/2022 10:56:36.793 */
GO
CREATE TABLE [dbo].[lkpChargeDecision](
	[ChargeDecisionID] [int] NOT NULL,
	[ChargeDecisionSortOrder] [int] NOT NULL,
	[ChargeDecisionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ChargeDecisionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsCreditApproved] [bit] NULL,
	[VendorID] [int] NULL,
 CONSTRAINT [PK_lkpCreditDecision] PRIMARY KEY CLUSTERED
(
	[ChargeDecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpChargeDecision] ADD  CONSTRAINT [DF_lkpCreditDecision_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpChargeDecision] ADD  CONSTRAINT [DF_lkpCreditDecision_IsCreditApproved]  DEFAULT ((0)) FOR [IsCreditApproved]
GO
ALTER TABLE [dbo].[lkpChargeDecision]  WITH CHECK ADD  CONSTRAINT [FK_lkpChargeDecision_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[lkpChargeDecision] CHECK CONSTRAINT [FK_lkpChargeDecision_cfgVendor]
GO
