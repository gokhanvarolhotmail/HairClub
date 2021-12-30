/* CreateDate: 03/04/2013 14:05:43.837 , ModifyDate: 06/18/2014 00:46:43.863 */
GO
CREATE TABLE [bi_ent_dds].[xxxFactAccounting](
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
	[DoctorEntityID] [int] NULL,
 CONSTRAINT [PK__FactAcco__9AB6AE2D25A691D2] PRIMARY KEY NONCLUSTERED
(
	[CenterID] ASC,
	[DateKey] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
