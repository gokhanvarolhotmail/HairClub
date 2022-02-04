/* CreateDate: 09/03/2021 09:37:05.153 , ModifyDate: 01/12/2022 10:39:16.150 */
GO
CREATE TABLE [bi_mktg_dds].[DimActivity](
	[ActivityKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActivitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDueDate] [date] NOT NULL,
	[ActivityStartTime] [time](7) NOT NULL,
	[ActivityCompletionDate] [date] NOT NULL,
	[ActivityCompletionTime] [time](7) NOT NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivityTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivityTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GreenwichOffset] [float] NOT NULL,
	[PromotionCodeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsAppointment] [int] NOT NULL,
	[IsShow] [int] NOT NULL,
	[IsNoShow] [int] NOT NULL,
	[IsSale] [int] NOT NULL,
	[IsNoSale] [int] NOT NULL,
	[IsConsultation] [int] NOT NULL,
	[IsBeBack] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimActivity] PRIMARY KEY CLUSTERED
(
	[ActivityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimActivity_PromotionCodeSSID_CBB7E] ON [bi_mktg_dds].[DimActivity]
(
	[PromotionCodeSSID] ASC
)
INCLUDE([ActivityKey],[ActivitySSID],[ActivityDueDate],[ActivityStartTime],[ActivityCompletionDate],[ActivityCompletionTime],[ActionCodeSSID],[ActionCodeDescription],[ResultCodeSSID],[ResultCodeDescription],[SourceSSID],[SourceDescription],[CenterSSID],[ContactSSID],[SalesTypeSSID],[SalesTypeDescription],[ActivityTypeSSID],[ActivityTypeDescription],[TimeZoneSSID],[TimeZoneDescription],[GreenwichOffset],[PromotionCodeDescription],[IsAppointment],[IsShow],[IsNoShow],[IsSale],[IsNoSale],[IsConsultation],[IsBeBack],[RowIsCurrent],[RowStartDate],[RowEndDate],[RowChangeReason],[RowIsInferred],[InsertAuditKey],[UpdateAuditKey],[RowTimeStamp],[SFDC_TaskID],[SFDC_LeadID],[SFDC_PersonAccountID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
