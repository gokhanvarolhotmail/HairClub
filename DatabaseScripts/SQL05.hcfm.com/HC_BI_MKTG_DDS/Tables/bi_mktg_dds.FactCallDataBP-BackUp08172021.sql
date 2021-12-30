/* CreateDate: 08/17/2021 14:10:06.380 , ModifyDate: 08/17/2021 14:10:06.380 */
GO
CREATE TABLE [bi_mktg_dds].[FactCallDataBP-BackUp08172021](
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
	[RowTimeStamp] [timestamp] NOT NULL
) ON [FG1]
GO
