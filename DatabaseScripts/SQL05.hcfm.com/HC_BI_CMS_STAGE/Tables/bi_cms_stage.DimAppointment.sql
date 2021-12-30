/* CreateDate: 05/22/2018 20:17:32.817 , ModifyDate: 05/22/2018 20:25:35.163 */
GO
CREATE TABLE [bi_cms_stage].[DimAppointment](
	[DataPkgKey] [int] NOT NULL,
	[AppointmentKey] [int] NULL,
	[AppointmentSSID] [uniqueidentifier] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientHomeCenterKey] [int] NULL,
	[ClientHomeCenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[AppointmentDate] [datetime] NULL,
	[ResourceSSID] [int] NULL,
	[ResourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationTypeSSID] [int] NULL,
	[ConfirmationTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentTypeSSID] [int] NULL,
	[AppointmentTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStartTime] [time](7) NULL,
	[AppointmentEndTime] [time](7) NULL,
	[CheckInTime] [time](7) NULL,
	[CheckOutTime] [time](7) NULL,
	[AppointmentSubject] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatusSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatusDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactActivitySSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactContactSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanPrintCommentFlag] [tinyint] NULL,
	[IsNonAppointmentFlag] [tinyint] NULL,
	[IsDeletedFlag] [tinyint] NULL,
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
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_DataPkgKey] ON [bi_cms_stage].[DimAppointment]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_CanPrinTCommentFlag]  DEFAULT ((0)) FOR [CanPrintCommentFlag]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsNonAppointmentFlag]  DEFAULT ((0)) FOR [IsNonAppointmentFlag]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsDeletedFlag]  DEFAULT ((0)) FOR [IsDeletedFlag]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimAppointment] ADD  CONSTRAINT [DF_DimAppointment_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
