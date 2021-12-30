/* CreateDate: 06/27/2011 16:39:44.653 , ModifyDate: 05/22/2018 20:25:51.843 */
GO
CREATE TABLE [bi_cms_dqa].[DimAppointment](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
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
	[CheckInTime] [datetime] NULL,
	[CheckOutTime] [datetime] NULL,
	[AppointmentSubject] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatusSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatusDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactActivitySSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactContactSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanPrinTCommentFlag] [tinyint] NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_FactAppointment] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
