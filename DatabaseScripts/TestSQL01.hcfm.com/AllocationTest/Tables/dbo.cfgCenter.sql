/* CreateDate: 11/01/2019 09:34:53.337 , ModifyDate: 11/01/2019 09:34:53.533 */
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
 CONSTRAINT [PK_cfgCenterNEW] PRIMARY KEY CLUSTERED
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenter] ADD  CONSTRAINT [DF_cfgCenter_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
