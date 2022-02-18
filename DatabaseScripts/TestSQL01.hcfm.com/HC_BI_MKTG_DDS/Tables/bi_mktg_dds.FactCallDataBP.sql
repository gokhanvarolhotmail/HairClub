/* CreateDate: 09/08/2020 10:27:00.897 , ModifyDate: 09/08/2020 11:15:16.503 */
GO
CREATE TABLE [bi_mktg_dds].[FactCallDataBP](
	[Call_RecordKey] [int] NOT NULL,
	[Call_DateKey] [int] NOT NULL,
	[Call_TimeKey] [int] NOT NULL,
	[InboundSourceKey] [int] NOT NULL,
	[ContactKey] [int] NULL,
	[ActivityKey] [int] NULL,
	[Is_Viable_Call] [int] NULL,
	[Is_Productive_Call] [int] NULL,
	[Call_Length] [int] NULL,
	[IVR_Time] [int] NULL,
	[Queue_Time] [int] NULL,
	[Pending_Time] [int] NULL,
	[Talk_Time] [int] NULL,
	[Hold_Time] [int] NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_FactCallDataBP] PRIMARY KEY CLUSTERED
(
	[Call_RecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
