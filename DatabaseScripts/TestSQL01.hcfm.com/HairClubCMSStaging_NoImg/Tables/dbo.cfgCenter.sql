/* CreateDate: 09/17/2017 18:28:21.947 , ModifyDate: 01/04/2022 10:56:36.727 */
GO
CREATE TABLE [dbo].[cfgCenter](
	[CenterID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CountryID] [int] NULL,
	[RegionID] [int] NULL,
	[CenterPayGroupID] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterTypeID] [int] NULL,
	[CenterOwnershipID] [int] NULL,
	[SurgeryHubCenterID] [int] NULL,
	[ReportingCenterID] [int] NULL,
	[AliasSurgeryCenterID] [int] NULL,
	[EmployeeDoctorGUID] [uniqueidentifier] NULL,
	[DoctorRegionID] [int] NULL,
	[TimeZoneID] [int] NULL,
	[InvoiceCounter] [int] NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateID] [int] NULL,
	[PostalCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1PrimaryFlag] [bit] NULL,
	[IsPhone2PrimaryFlag] [bit] NULL,
	[IsPhone3PrimaryFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsCorporateHeadquartersFlag] [bit] NOT NULL,
	[RegionRSMNBConsultantGuid] [uniqueidentifier] NULL,
	[RegionRSMMembershipAdvisorGuid] [uniqueidentifier] NULL,
	[RegionRTMTechnicalManagerGuid] [uniqueidentifier] NULL,
	[CenterManagementAreaID] [int] NULL,
	[CenterNumber] [int] NOT NULL,
	[BusinessUnitBrandID] [int] NOT NULL,
	[CenterDescriptionFullAlt1Calc]  AS ((isnull([CenterDescription],'')+' Center (')+(CONVERT([nvarchar](50),[CenterNumber],(0))+')')),
	[CenterDescriptionFullCalc]  AS ((([CenterDescription]+' (')+CONVERT([nvarchar](50),[CenterNumber],(0)))+')'),
	[WareHouseId] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgCenterNEW] PRIMARY KEY CLUSTERED
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenter] ADD  CONSTRAINT [DF_cfgCenter_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_cfgCenter_AliasSurgeryCenterID] FOREIGN KEY([AliasSurgeryCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_cfgCenter_AliasSurgeryCenterID]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_cfgCenter_SurgeryHubCenterID] FOREIGN KEY([SurgeryHubCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_cfgCenter_SurgeryHubCenterID]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_cfgCenterManagementArea] FOREIGN KEY([CenterManagementAreaID])
REFERENCES [dbo].[cfgCenterManagementArea] ([CenterManagementAreaID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_cfgCenterManagementArea]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_datEmployee] FOREIGN KEY([EmployeeDoctorGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_datEmployee]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_datEmployee1] FOREIGN KEY([RegionRSMMembershipAdvisorGuid])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_datEmployee1]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_datEmployee2] FOREIGN KEY([RegionRSMNBConsultantGuid])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_datEmployee2]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_datEmployee3] FOREIGN KEY([RegionRTMTechnicalManagerGuid])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_datEmployee3]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpBusinessUnit] FOREIGN KEY([CenterOwnershipID])
REFERENCES [dbo].[lkpCenterOwnership] ([CenterOwnershipID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpBusinessUnit]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpBusinessUnitBrand] FOREIGN KEY([BusinessUnitBrandID])
REFERENCES [dbo].[lkpBusinessUnitBrand] ([BusinessUnitBrandID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpBusinessUnitBrand]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpCenterPayGroup] FOREIGN KEY([CenterPayGroupID])
REFERENCES [dbo].[lkpCenterPayGroup] ([CenterPayGroupID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpCenterPayGroup]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpCenterType] FOREIGN KEY([CenterTypeID])
REFERENCES [dbo].[lkpCenterType] ([CenterTypeID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpCenterType]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpCountry]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpDoctorRegion] FOREIGN KEY([DoctorRegionID])
REFERENCES [dbo].[lkpDoctorRegion] ([DoctorRegionID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpDoctorRegion]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpPhoneType] FOREIGN KEY([Phone1TypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpPhoneType]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpPhoneType1] FOREIGN KEY([Phone2TypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpPhoneType1]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpPhoneType2] FOREIGN KEY([Phone3TypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpPhoneType2]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpRegion] FOREIGN KEY([RegionID])
REFERENCES [dbo].[lkpRegion] ([RegionID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpRegion]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpState] FOREIGN KEY([StateID])
REFERENCES [dbo].[lkpState] ([StateID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpState]
GO
ALTER TABLE [dbo].[cfgCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenter_lkpTimeZone] FOREIGN KEY([TimeZoneID])
REFERENCES [dbo].[lkpTimeZone] ([TimeZoneID])
GO
ALTER TABLE [dbo].[cfgCenter] CHECK CONSTRAINT [FK_cfgCenter_lkpTimeZone]
GO
