/****** Object:  Table [ODS].[T_2093_86a5a7a8e556453fb6508857be3ffcd1]    Script Date: 2/7/2022 10:45:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2093_86a5a7a8e556453fb6508857be3ffcd1]
(
	[CenterID] [int] NULL,
	[CountryID] [int] NULL,
	[RegionID] [int] NULL,
	[CenterPayGroupID] [int] NULL,
	[CenterDescription] [nvarchar](max) NULL,
	[CenterTypeID] [int] NULL,
	[CenterOwnershipID] [int] NULL,
	[SurgeryHubCenterID] [int] NULL,
	[ReportingCenterID] [int] NULL,
	[AliasSurgeryCenterID] [int] NULL,
	[EmployeeDoctorGUID] [nvarchar](max) NULL,
	[DoctorRegionID] [int] NULL,
	[TimeZoneID] [int] NULL,
	[InvoiceCounter] [int] NULL,
	[Address1] [nvarchar](max) NULL,
	[Address2] [nvarchar](max) NULL,
	[Address3] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[StateID] [int] NULL,
	[PostalCode] [nvarchar](max) NULL,
	[Phone1] [nvarchar](max) NULL,
	[Phone2] [nvarchar](max) NULL,
	[Phone3] [nvarchar](max) NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1PrimaryFlag] [bit] NULL,
	[IsPhone2PrimaryFlag] [bit] NULL,
	[IsPhone3PrimaryFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[IsCorporateHeadquartersFlag] [bit] NULL,
	[RegionRSMNBConsultantGuid] [nvarchar](max) NULL,
	[RegionRSMMembershipAdvisorGuid] [nvarchar](max) NULL,
	[RegionRTMTechnicalManagerGuid] [nvarchar](max) NULL,
	[CenterManagementAreaID] [int] NULL,
	[CenterNumber] [int] NULL,
	[BusinessUnitBrandID] [int] NULL,
	[CenterDescriptionFullAlt1Calc] [nvarchar](max) NULL,
	[CenterDescriptionFullCalc] [nvarchar](max) NULL,
	[r53f0825f32994c689451cc1b473485a4] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
