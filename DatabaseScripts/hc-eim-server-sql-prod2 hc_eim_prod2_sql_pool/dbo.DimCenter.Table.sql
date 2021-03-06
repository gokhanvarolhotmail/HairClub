/****** Object:  Table [dbo].[DimCenter]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCenter]
(
	[CenterKey] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NULL,
	[CenterPayGroupID] [int] NULL,
	[CenterDescription] [varchar](500) NULL,
	[Address1] [varchar](500) NULL,
	[Address2] [varchar](500) NULL,
	[Address3] [varchar](500) NULL,
	[CenterGeographykey] [int] NULL,
	[CenterPostalCode] [varchar](500) NULL,
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
	[OwnerLastName] [varchar](100) NULL,
	[OwnerFirstName] [varchar](500) NULL,
	[CorporateName] [varchar](500) NULL,
	[OwnershipAddress1] [varchar](500) NULL,
	[OwnershipAddress2] [varchar](100) NULL,
	[OwnershipGeographykey] [int] NULL,
	[OwnershipPostalCode] [varchar](50) NULL,
	[CenterTypeID] [int] NULL,
	[CenterTypeSortOrder] [int] NULL,
	[CenterTypeDescription] [varchar](50) NULL,
	[CenterTypeDescriptionShort] [varchar](10) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NULL,
	[SourceSystem] [varchar](10) NOT NULL,
	[TimeZoneID] [int] NULL,
	[ServiceTerritoryId] [varchar](100) NULL,
	[IsDeleted] [bit] NULL,
	[Region1] [varchar](50) NULL,
	[Region2] [varchar](50) NULL,
	[RegioAM] [nvarchar](100) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CenterID] ASC
	)
)
GO
