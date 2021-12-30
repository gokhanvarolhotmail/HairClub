/* CreateDate: 05/03/2010 12:21:09.590 , ModifyDate: 09/03/2021 09:35:32.990 */
GO
CREATE TABLE [bi_mktg_dds].[DimContactSource](
	[ContactSourceKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContactSourceSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SourceCode] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediaCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AssignmentDate] [date] NOT NULL,
	[AssignmentTime] [time](0) NOT NULL,
	[PrimaryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DNIS_Number] [int] NOT NULL,
	[SubSourceCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactSource] PRIMARY KEY CLUSTERED
(
	[ContactSourceKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactSource_ContactSourceKey] ON [bi_mktg_dds].[DimContactSource]
(
	[ContactSourceKey] ASC
)
INCLUDE([ContactSourceSSID],[ContactSSID],[SourceCode],[MediaCode],[AssignmentDate],[PrimaryFlag],[DNIS_Number],[SubSourceCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactSource_RowIsCurrent_ContactSourceSSID_ContactSourceKey] ON [bi_mktg_dds].[DimContactSource]
(
	[ContactSourceSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ContactSourceKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_dds].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
