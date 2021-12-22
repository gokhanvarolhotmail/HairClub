/* CreateDate: 09/03/2021 09:37:05.640 , ModifyDate: 09/03/2021 10:02:56.920 */
GO
CREATE TABLE [bi_mktg_dds].[DimContactAppend](
	[ContactAppendKey] [int] NOT NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[HouseholdMosaicGroupID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HouseholdMosaicGroup] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HouseholdMosaicTypeID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HouseholdMosaicType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCodeMosaicGroupID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCodeMosaicGroup] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCodeMosaicTypeID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCodeMosaicType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Combined_Age] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Education_Model] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation_Group] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Match_Level_for_GEOData] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Est_HouseHold_Income] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NCOA_Move_Update_Code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mail_Responder] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR_Bank_Upscale_Merchandise_Buyer] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MOR_Bank_HealthandFitness_Magazine] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_Ethnic_Pop_White_Only] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_Ethnic_Pop_Black_Only] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_Ethnic_Pop_Asian_Only] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_Ethnic_Pop_Hispanic] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_Lang_HH_Spanish_Speaking] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CAPE_Income_HH_Median_Family] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MatchStatus] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Ethnicity_Code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Ethnic_Group_Code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CE_Selected_Individual_Vendor_Spoken_Language_Code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Longitude] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadMatchStatus] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadScore] [int] NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimContactAppend] ON [bi_mktg_dds].[DimContactAppend]
(
	[ContactAppendKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactAppend_CenterSSID_CenterKey] ON [bi_mktg_dds].[DimContactAppend]
(
	[CenterSSID] ASC
)
INCLUDE([CenterKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactAppend_ContactSSID_ContactKey] ON [bi_mktg_dds].[DimContactAppend]
(
	[ContactSSID] ASC
)
INCLUDE([ContactKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
