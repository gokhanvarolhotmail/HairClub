/* CreateDate: 05/03/2010 12:21:09.557 , ModifyDate: 09/03/2021 09:35:32.913 */
GO
CREATE TABLE [bi_mktg_dds].[DimContactEmail](
	[ContactEmailKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContactEmailSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailTypeCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PrimaryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadEmailID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactEmailHashed] [varbinary](128) NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactEmail] PRIMARY KEY CLUSTERED
(
	[ContactEmailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactEmail_ContactEmailKey] ON [bi_mktg_dds].[DimContactEmail]
(
	[ContactEmailKey] ASC
)
INCLUDE([SFDC_LeadEmailID],[SFDC_LeadID],[Email],[EmailTypeCode],[PrimaryFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactEmail_RowIsCurrent_SFDCLeadID_ContactEmailKey] ON [bi_mktg_dds].[DimContactEmail]
(
	[SFDC_LeadEmailID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ContactEmailKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_dds].[DimContactEmail] ADD  CONSTRAINT [DF_DimContactEmail_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContactEmail] ADD  CONSTRAINT [DF_DimContactEmail_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContactEmail] ADD  CONSTRAINT [DF_DimContactEmail_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
