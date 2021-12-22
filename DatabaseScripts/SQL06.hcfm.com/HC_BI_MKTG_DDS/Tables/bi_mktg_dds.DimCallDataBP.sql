/* CreateDate: 09/03/2021 09:37:07.283 , ModifyDate: 09/03/2021 09:37:13.407 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_mktg_dds].[DimCallDataBP](
	[Call_RecordKey] [int] NOT NULL,
	[BPpk_ID] [int] NULL,
	[Media_Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Call_Date] [date] NOT NULL,
	[Call_Time] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Caller_Phone_Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Callee_Phone_Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Call_Type_Group] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InboundSourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Inbound_Campaign_ID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Inbound_Campaign_Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Campaign_ID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Campaign_Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agent_Disposition] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agent_Disposition_Notes] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[System_Disposition] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Phone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Inbound_Phone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaskSourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Task_Campaign_ID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Task_Campaign_Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[User_Login_ID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[User_Login_Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Is_Viable_Call] [int] NULL,
	[Is_Productive_Call] [int] NULL,
	[Call_Length] [int] NULL,
	[IVR_Time] [int] NULL,
	[Queue_Time] [int] NULL,
	[Pending_Time] [int] NULL,
	[Talk_Time] [int] NULL,
	[Hold_Time] [int] NULL,
	[RowTimeStamp] [binary](8) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimCallDataBP] ON [bi_mktg_dds].[DimCallDataBP]
(
	[Call_RecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
