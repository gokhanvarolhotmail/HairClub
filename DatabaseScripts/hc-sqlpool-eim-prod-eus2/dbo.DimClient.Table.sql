/****** Object:  Table [dbo].[DimClient]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimClient]
(
	[ClientKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [uniqueidentifier] NULL,
	[ClientNumber_Temp] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[ClientFirstName] [nvarchar](50) NULL,
	[ClientMiddleName] [nvarchar](20) NULL,
	[ClientLastName] [nvarchar](50) NULL,
	[SalutationID] [int] NULL,
	[ClientSalutationDescription] [nvarchar](50) NULL,
	[ClientSalutationDescriptionShort] [nvarchar](10) NULL,
	[ClientFullName] [nvarchar](10) NULL,
	[ClientAddress1] [nvarchar](50) NULL,
	[ClientAddress2] [nvarchar](50) NULL,
	[ClientAddress3] [nvarchar](50) NULL,
	[CountryRegionDescription] [nvarchar](50) NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) NULL,
	[StateProvinceDescription] [nvarchar](50) NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) NULL,
	[City] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[ClientDateOfBirth] [datetime] NULL,
	[GenderID] [int] NULL,
	[ClientGenderDescription] [nvarchar](50) NULL,
	[ClientGenderDescriptionShort] [nvarchar](10) NULL,
	[MaritalStatusID] [int] NULL,
	[ClientMaritalStatusDescription] [nvarchar](50) NULL,
	[ClientMaritalStatusDescriptionShort] [nvarchar](10) NULL,
	[OccupationID] [int] NULL,
	[ClientOccupationDescription] [nvarchar](50) NULL,
	[ClientOccupationDescriptionShort] [nvarchar](10) NULL,
	[EthinicityID] [int] NULL,
	[ClientEthinicityDescription] [nvarchar](50) NULL,
	[ClientEthinicityDescriptionShort] [nvarchar](10) NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[ClientEMailAddress] [nvarchar](100) NULL,
	[ClientTextMessageAddress] [nvarchar](100) NULL,
	[ClientPhone1] [nvarchar](15) NULL,
	[Phone1TypeID] [int] NULL,
	[ClientPhone1TypeDescription] [nvarchar](50) NULL,
	[ClientPhone1TypeDescriptionShort] [nvarchar](10) NULL,
	[ClientPhone2] [nvarchar](15) NULL,
	[Phone2TypeID] [int] NULL,
	[ClientPhone2TypeDescription] [nvarchar](50) NULL,
	[ClientPhone2TypeDescriptionShort] [nvarchar](10) NULL,
	[ClientPhone3] [nvarchar](15) NULL,
	[Phone3TypeID] [int] NULL,
	[ClientPhone3TypeDescription] [nvarchar](50) NULL,
	[ClientPhone3TypeDescriptionShort] [nvarchar](10) NULL,
	[CurrentBioMatrixClientMembershipID] [uniqueidentifier] NULL,
	[CurrentSurgeryClientMembershipID] [uniqueidentifier] NULL,
	[CurrentExtremeTherapyClientMembershipID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[ClientARBalance] [money] NULL,
	[contactID] [nvarchar](10) NULL,
	[contactKey] [int] NULL,
	[CurrentXtrandsClientMembershipID] [uniqueidentifier] NULL,
	[BosleyProcedureOffice] [nvarchar](50) NULL,
	[BosleyConsultOffice] [nvarchar](50) NULL,
	[BosleySiebelID] [nvarchar](50) NULL,
	[ExpectedConversionDate] [datetime] NULL,
	[SFDC_Leadid] [nvarchar](18) NULL,
	[CurrentMDPClientMembershipID] [uniqueidentifier] NULL,
	[SourceSystem] [varchar](10) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[ClientID] ASC
	)
)
GO
