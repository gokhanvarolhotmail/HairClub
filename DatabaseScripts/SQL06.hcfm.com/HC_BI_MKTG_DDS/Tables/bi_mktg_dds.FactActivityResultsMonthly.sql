/* CreateDate: 09/03/2021 09:37:07.593 , ModifyDate: 09/03/2021 09:37:14.177 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_mktg_dds].[FactActivityResultsMonthly](
	[ActivityKey] [int] NOT NULL,
	[ActivityDateKey] [int] NOT NULL,
	[ActivityTimeKey] [int] NOT NULL,
	[ActivityResultDateKey] [int] NOT NULL,
	[ActivityResultKey] [int] NOT NULL,
	[ActivityResultTimeKey] [int] NOT NULL,
	[ActivityCompletedDateKey] [int] NOT NULL,
	[ActivityCompletedTimeKey] [int] NOT NULL,
	[ActivityDueDateKey] [int] NOT NULL,
	[ActivityStartTimeKey] [int] NOT NULL,
	[OriginalAppointmentDateKey] [int] NOT NULL,
	[ActivitySavedDateKey] [int] NOT NULL,
	[ActivitySavedTimeKey] [int] NOT NULL,
	[ContactKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[SalesTypeKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[ActionCodeKey] [int] NOT NULL,
	[ResultCodeKey] [int] NOT NULL,
	[GenderKey] [int] NOT NULL,
	[OccupationKey] [int] NOT NULL,
	[EthnicityKey] [int] NOT NULL,
	[MaritalStatusKey] [int] NOT NULL,
	[HairLossTypeKey] [int] NOT NULL,
	[AgeRangeKey] [int] NOT NULL,
	[CompletedByEmployeeKey] [int] NOT NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Appointments] [int] NOT NULL,
	[Show] [int] NOT NULL,
	[NoShow] [int] NOT NULL,
	[Sale] [int] NOT NULL,
	[NoSale] [int] NOT NULL,
	[Consultation] [int] NOT NULL,
	[BeBack] [int] NOT NULL,
	[SurgeryOffered] [int] NOT NULL,
	[ReferredToDoctor] [int] NOT NULL,
	[InitialPayment] [money] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[ActivityEmployeeKey] [int] NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceKey] [int] NULL,
	[LeadCreationDateKey] [int] NULL,
	[LeadCreationTimeKey] [int] NULL,
	[PromoCodeKey] [int] NULL,
	[MonthlyInsertDate] [datetime] NULL,
 CONSTRAINT [PK_FactActivityResultsMonthly] PRIMARY KEY CLUSTERED
(
	[ActivityKey] ASC,
	[ActivityDateKey] ASC,
	[ActivityTimeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
