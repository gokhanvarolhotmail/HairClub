/* CreateDate: 06/28/2017 11:49:29.030 , ModifyDate: 06/28/2017 11:49:29.030 */
GO
CREATE TABLE [bi_cms_dqa].[DimClientPhone](
	[DataPkgKey] [int] NULL,
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_BIEF_CMS_DQ_ClientPhoneKey] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimClientPhone] ADD  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
