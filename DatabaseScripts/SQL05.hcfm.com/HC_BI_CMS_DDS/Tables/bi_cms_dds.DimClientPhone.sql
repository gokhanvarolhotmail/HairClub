/* CreateDate: 06/28/2017 11:42:11.590 , ModifyDate: 06/28/2017 11:42:12.857 */
GO
CREATE TABLE [bi_cms_dds].[DimClientPhone](
	[ClientPhoneKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientPhoneSSID] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[PhoneTypeDescription] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanConfirmAppointmentByCall] [bit] NULL,
	[CanConfirmAppointmentByText] [bit] NULL,
	[CanContactForPromotionsByCall] [bit] NULL,
	[CanContactForPromotionsByText] [bit] NULL,
	[ClientPhoneSortOrder] [int] NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceSystem] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_BIEF_DDS_ClientPhoneKey] PRIMARY KEY CLUSTERED
(
	[ClientPhoneKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientPhone_SSID] ON [bi_cms_dds].[DimClientPhone]
(
	[ClientPhoneSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimClientPhone] ADD  CONSTRAINT [DF_DimClientPhone_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimClientPhone] ADD  CONSTRAINT [DF_DimClientPhone_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimClientPhone] ADD  CONSTRAINT [DF_DimClientPhone_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
