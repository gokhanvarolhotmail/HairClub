/* CreateDate: 10/31/2019 20:53:42.427 , ModifyDate: 11/01/2019 09:57:48.967 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgCenter](
	[CenterID] [int] IDENTITY(1,1) NOT NULL,
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
	[IsCorporateHeadquartersFlag] [bit] NOT NULL,
	[RegionRSMNBConsultantGuid] [uniqueidentifier] NULL,
	[RegionRSMMembershipAdvisorGuid] [uniqueidentifier] NULL,
	[RegionRTMTechnicalManagerGuid] [uniqueidentifier] NULL,
	[CenterManagementAreaID] [int] NULL,
	[CenterNumber] [int] NOT NULL,
	[BusinessUnitBrandID] [int] NOT NULL
) ON [PRIMARY]
GO
