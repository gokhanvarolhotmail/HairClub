/* CreateDate: 07/15/2014 13:16:24.150 , ModifyDate: 07/15/2014 13:16:24.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dashbdCenter](
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[RegionKey] [int] NULL,
	[TimeZoneKey] [int] NULL,
	[TimeZoneSSID] [int] NULL,
	[CenterTypeKey] [int] NULL,
	[CenterTypeSSID] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterDescriptionNumber] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionRSMNBConsultantSSID] [uniqueidentifier] NULL,
	[RegionRSMMembershipAdvisorSSID] [uniqueidentifier] NULL,
	[RegionRTMTechnicalManagerSSID] [uniqueidentifier] NULL,
	[RegionConsolidated] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortRegionConsolidated] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionCenterDescription] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
