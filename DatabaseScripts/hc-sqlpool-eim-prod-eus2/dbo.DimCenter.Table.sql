/****** Object:  Table [dbo].[DimCenter]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCenter]
(
	[CenterKey] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NULL,
	[CenterPayGroupID] [int] NULL,
	[CenterDescription] [varchar](200) NULL,
	[Address1] [varchar](200) NULL,
	[Address2] [varchar](200) NULL,
	[Address3] [varchar](200) NULL,
	[CenterGeographykey] [int] NULL,
	[CenterPostalCode] [varchar](50) NULL,
	[CenterPhone1] [varchar](200) NULL,
	[CenterPhone2] [varchar](200) NULL,
	[CenterPhone3] [varchar](200) NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1PrimaryFlag] [bit] NULL,
	[IsPhone2PrimaryFlag] [bit] NULL,
	[IsPhone3PrimaryFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[UpdateStamp] [varchar](200) NULL,
	[CenterNumber] [int] NULL,
	[CenterOwnershipID] [int] NULL,
	[CenterOwnershipSortOrder] [int] NULL,
	[CenterOwnershipDescription] [varchar](100) NULL,
	[CenterOwnershipDescriptionShort] [varchar](100) NULL,
	[OwnerLastName] [varchar](50) NULL,
	[OwnerFirstName] [varchar](50) NULL,
	[CorporateName] [varchar](100) NULL,
	[OwnershipAddress1] [varchar](100) NULL,
	[OwnershipAddress2] [varchar](100) NULL,
	[OwnershipGeographykey] [int] NULL,
	[OwnershipPostalCode] [varchar](50) NULL,
	[CenterTypeID] [int] NULL,
	[CenterTypeSortOrder] [int] NULL,
	[CenterTypeDescription] [varchar](50) NULL,
	[CenterTypeDescriptionShort] [varchar](10) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](10) NOT NULL,
	[TimeZoneID] [int] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CenterKey] ASC
	)
)
GO
