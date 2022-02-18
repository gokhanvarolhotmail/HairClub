/* CreateDate: 06/08/2020 18:20:38.810 , ModifyDate: 01/27/2022 09:18:11.860 */
GO
CREATE TABLE [bi_mktg_dds].[DimCallData](
	[CallRecordKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[RowTimeStamp] [timestamp] NOT NULL,
	[TollFreeNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserFullName] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimCallData] PRIMARY KEY CLUSTERED
(
	[CallRecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
