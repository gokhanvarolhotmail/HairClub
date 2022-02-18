/* CreateDate: 09/08/2020 10:49:23.567 , ModifyDate: 01/27/2022 09:18:11.930 */
GO
CREATE TABLE [bi_mktg_dds].[DimCallDataBP](
	[Call_RecordKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimCallDataBP] PRIMARY KEY CLUSTERED
(
	[Call_RecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1] TEXTIMAGE_ON [FG1]
GO
