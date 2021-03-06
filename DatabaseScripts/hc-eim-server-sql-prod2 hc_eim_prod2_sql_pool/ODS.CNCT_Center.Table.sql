/****** Object:  Table [ODS].[CNCT_Center]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_Center]
(
	[CenterID] [int] NULL,
	[CountryID] [int] NULL,
	[RegionID] [int] NULL,
	[CenterPayGroupID] [int] NULL,
	[CenterDescription] [varchar](8000) NULL,
	[CenterTypeID] [int] NULL,
	[CenterOwnershipID] [int] NULL,
	[SurgeryHubCenterID] [int] NULL,
	[ReportingCenterID] [int] NULL,
	[AliasSurgeryCenterID] [int] NULL,
	[EmployeeDoctorGUID] [varchar](8000) NULL,
	[DoctorRegionID] [int] NULL,
	[TimeZoneID] [int] NULL,
	[InvoiceCounter] [int] NULL,
	[Address1] [varchar](8000) NULL,
	[Address2] [varchar](8000) NULL,
	[Address3] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[StateID] [int] NULL,
	[PostalCode] [varchar](8000) NULL,
	[Phone1] [varchar](8000) NULL,
	[Phone2] [varchar](8000) NULL,
	[Phone3] [varchar](8000) NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1PrimaryFlag] [bit] NULL,
	[IsPhone2PrimaryFlag] [bit] NULL,
	[IsPhone3PrimaryFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[IsCorporateHeadquartersFlag] [bit] NULL,
	[RegionRSMNBConsultantGuid] [varchar](8000) NULL,
	[RegionRSMMembershipAdvisorGuid] [varchar](8000) NULL,
	[RegionRTMTechnicalManagerGuid] [varchar](8000) NULL,
	[CenterManagementAreaID] [int] NULL,
	[CenterNumber] [int] NULL,
	[BusinessUnitBrandID] [int] NULL,
	[CenterDescriptionFullAlt1Calc] [varchar](8000) NULL,
	[CenterDescriptionFullCalc] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
