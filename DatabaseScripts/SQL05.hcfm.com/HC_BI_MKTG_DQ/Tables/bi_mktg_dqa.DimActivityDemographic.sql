/* CreateDate: 05/03/2010 12:22:42.437 , ModifyDate: 09/10/2020 11:17:34.573 */
GO
CREATE TABLE [bi_mktg_dqa].[DimActivityDemographic](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ActivityDemographicKey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDemographicSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderSSID] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday] [date] NULL,
	[Age] [int] NULL,
	[AgeRangeSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [money] NULL,
	[SolutionOffered] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateSaved] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[DiscStyleSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimActivityDemographic_1] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
