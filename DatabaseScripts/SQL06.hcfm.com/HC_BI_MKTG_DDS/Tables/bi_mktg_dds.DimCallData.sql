/* CreateDate: 09/03/2021 09:37:06.990 , ModifyDate: 09/03/2021 09:37:12.793 */
GO
CREATE TABLE [bi_mktg_dds].[DimCallData](
	[CallRecordKey] [int] NOT NULL,
	[CallRecordSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalCallRecordSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallDate] [date] NOT NULL,
	[CallTime] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallTypeSSID] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallTypeGroup] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InboundCampaignID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InboundSourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InboundSourceDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCampaignID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallStatusSSID] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallPhoneNo] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskCampaignID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskSourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskSourceDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UsedBy] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalCallStatusSSID] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalCallStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NobleUserSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsViableCall] [int] NULL,
	[CallLength] [int] NULL,
	[RowTimeStamp] [binary](8) NOT NULL,
	[TollFreeNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserFullName] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimCallData] ON [bi_mktg_dds].[DimCallData]
(
	[CallRecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
