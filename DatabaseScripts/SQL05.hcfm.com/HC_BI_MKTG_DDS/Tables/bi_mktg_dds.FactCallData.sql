/* CreateDate: 04/14/2020 12:48:55.860 , ModifyDate: 09/03/2021 09:35:33.387 */
GO
CREATE TABLE [bi_mktg_dds].[FactCallData](
	[CallRecordKey] [int] NOT NULL,
	[CallDateKey] [int] NOT NULL,
	[CallTimeKey] [int] NOT NULL,
	[InboundSourceKey] [int] NOT NULL,
	[ContactKey] [int] NULL,
	[ActivityKey] [int] NULL,
	[IsViableCall] [int] NOT NULL,
	[CallLength] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_FactCallData] PRIMARY KEY CLUSTERED
(
	[CallRecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
