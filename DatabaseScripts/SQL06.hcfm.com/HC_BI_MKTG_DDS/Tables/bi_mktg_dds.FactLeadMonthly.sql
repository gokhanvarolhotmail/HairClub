/* CreateDate: 09/03/2021 09:37:07.690 , ModifyDate: 09/03/2021 09:37:14.463 */
GO
CREATE TABLE [bi_mktg_dds].[FactLeadMonthly](
	[ContactKey] [int] NOT NULL,
	[LeadCreationDateKey] [int] NOT NULL,
	[LeadCreationTimeKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[GenderKey] [int] NOT NULL,
	[OccupationKey] [int] NOT NULL,
	[EthnicityKey] [int] NOT NULL,
	[MaritalStatusKey] [int] NOT NULL,
	[HairLossTypeKey] [int] NOT NULL,
	[AgeRangeKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[PromotionCodeKey] [int] NULL,
	[SalesTypeKey] [int] NULL,
	[Leads] [int] NOT NULL,
	[Appointments] [int] NOT NULL,
	[Shows] [int] NOT NULL,
	[Sales] [int] NOT NULL,
	[Activities] [int] NOT NULL,
	[NoShows] [int] NOT NULL,
	[NoSales] [int] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[AssignedEmployeeKey] [int] NULL,
	[SHOWDIFF] [int] NULL,
	[SALEDIFF] [int] NULL,
	[QuestionAge] [int] NULL,
	[RecentSourceKey] [int] NULL,
	[InvalidLead] [int] NULL,
	[MonthlyInsertDate] [datetime] NULL,
 CONSTRAINT [PK_FactLeadMonthly] PRIMARY KEY CLUSTERED
(
	[ContactKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
