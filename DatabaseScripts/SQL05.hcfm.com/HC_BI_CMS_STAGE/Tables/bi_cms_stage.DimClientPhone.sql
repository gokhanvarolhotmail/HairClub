/* CreateDate: 06/28/2017 11:54:55.163 , ModifyDate: 06/28/2017 11:54:55.163 */
GO
CREATE TABLE [bi_cms_stage].[DimClientPhone](
	[DataPkgKey] [int] NULL,
	[StageKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientPhoneKey] [int] NULL,
	[ClientPhoneSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[PhoneTypeDescription] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanConfirmAppointmentByCall] [bit] NULL,
	[CanConfirmAppointmentByText] [bit] NULL,
	[CanContactForPromotionsByCall] [bit] NULL,
	[CanContactForPromotionsByText] [bit] NULL,
	[ClientPhoneSortOrder] [int] NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lkpClientKey_ClientSSID] [uniqueidentifier] NULL,
	[SourceSystemKey] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifiedDate] [datetime2](7) NOT NULL,
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
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_BIEF_CMS_STG_DimClientPhone] PRIMARY KEY CLUSTERED
(
	[StageKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [RuleKey]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [DataQualityAuditKey]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsLoaded]
GO
