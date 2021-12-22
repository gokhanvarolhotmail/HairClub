/* CreateDate: 01/08/2021 15:21:54.143 , ModifyDate: 01/08/2021 15:21:55.527 */
GO
CREATE TABLE [bi_ent_dds].[FactAccounting](
	[CenterID] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[PartitionDate] [datetime] NOT NULL,
	[AccountID] [int] NOT NULL,
	[Budget] [real] NULL,
	[Actual] [real] NULL,
	[Forecast] [real] NULL,
	[Flash] [real] NULL,
	[FlashReporting] [real] NULL,
	[Drivers] [real] NULL,
	[Timestamp] [datetime] NULL,
	[DoctorEntityID] [int] NULL
) ON [PRIMARY]
GO
