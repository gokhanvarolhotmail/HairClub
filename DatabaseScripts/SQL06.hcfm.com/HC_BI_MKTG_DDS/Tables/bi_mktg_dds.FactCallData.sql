/* CreateDate: 09/03/2021 09:37:07.117 , ModifyDate: 09/03/2021 09:37:13.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[RowTimeStamp] [binary](8) NOT NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_FactCallData] ON [bi_mktg_dds].[FactCallData]
(
	[CallRecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
