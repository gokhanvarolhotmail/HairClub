/* CreateDate: 10/03/2019 22:32:12.347 , ModifyDate: 11/08/2019 23:11:48.113 */
GO
CREATE TABLE [dbo].[FactAccounting](
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
 CONSTRAINT [PK_FactAccounting] PRIMARY KEY CLUSTERED
(
	[CenterID] ASC,
	[DateKey] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
