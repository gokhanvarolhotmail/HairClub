/* CreateDate: 06/27/2011 16:44:15.750 , ModifyDate: 03/12/2014 16:17:14.930 */
GO
CREATE TABLE [bi_cms_stage].[FactAppointmentDetail](
	[DataPkgKey] [int] NOT NULL,
	[AppointmentDetailKey] [int] NULL,
	[AppointmentDetailSSID] [uniqueidentifier] NULL,
	[AppointmentKey] [int] NULL,
	[AppointmentSSID] [uniqueidentifier] NULL,
	[SalesCodeKey] [int] NULL,
	[SalesCodeSSID] [int] NULL,
	[AppointmentDetailDuration] [int] NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactAppointmentDetail_DataPkgKey] ON [bi_cms_stage].[FactAppointmentDetail]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
