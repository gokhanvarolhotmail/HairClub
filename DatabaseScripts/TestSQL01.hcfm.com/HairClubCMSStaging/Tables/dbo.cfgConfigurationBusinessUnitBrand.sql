/* CreateDate: 09/17/2017 18:31:04.007 , ModifyDate: 11/25/2018 15:50:52.160 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgConfigurationBusinessUnitBrand](
	[ConfigurationBusinessUnitBrandID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessUnitBrandID] [int] NOT NULL,
	[IsSalesOrderEnabled] [bit] NOT NULL,
	[IsSchedulerEnabled] [bit] NOT NULL,
	[IsReportingEnabled] [bit] NOT NULL,
	[IsAppointmentManagementEnabled] [bit] NOT NULL,
	[IsHairSystemOrderEnabled] [bit] NOT NULL,
	[IsHairInventoryAuditEnabled] [bit] NOT NULL,
	[IsPriorityHairSearchEnabled] [bit] NOT NULL,
	[IsManualHairAppicationEnabled] [bit] NOT NULL,
	[IsActivityManagementEnabled] [bit] NOT NULL,
	[IsCenterAdministrationEnabled] [bit] NOT NULL,
	[IsMembershipWizardEnabled] [bit] NOT NULL,
	[IsClientReferralEnabled] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsVendorOrderNumberSearchEnabled] [bit] NOT NULL,
	[IsInventoryEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_cfgConfigurationBusinessUnitBrand] PRIMARY KEY CLUSTERED
(
	[ConfigurationBusinessUnitBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_cfgConfigurationBusinessUnitBrand_BusinessUnitBrandID] ON [dbo].[cfgConfigurationBusinessUnitBrand]
(
	[BusinessUnitBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgConfigurationBusinessUnitBrand] ADD  DEFAULT ((0)) FOR [IsVendorOrderNumberSearchEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationBusinessUnitBrand] ADD  DEFAULT ((0)) FOR [IsInventoryEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationBusinessUnitBrand]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationBusinessUnitBrand_lkpBusinessUnitBrand] FOREIGN KEY([BusinessUnitBrandID])
REFERENCES [dbo].[lkpBusinessUnitBrand] ([BusinessUnitBrandID])
GO
ALTER TABLE [dbo].[cfgConfigurationBusinessUnitBrand] CHECK CONSTRAINT [FK_cfgConfigurationBusinessUnitBrand_lkpBusinessUnitBrand]
GO
