/* CreateDate: 02/03/2011 17:32:43.710 , ModifyDate: 09/03/2021 09:35:33.480 */
GO
CREATE TABLE [bi_mktg_dds].[FactLead](
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
	[NewBusinessRevenue] [money] NULL,
	[PCPMemberRevenue] [money] NULL,
	[PCPLaserRevenue] [money] NULL,
	[RetailRevenue] [money] NULL,
	[ServiceRevenue] [money] NULL,
	[NBLaserRevenue] [money] NULL,
 CONSTRAINT [PK_FactLead] PRIMARY KEY CLUSTERED
(
	[ContactKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactLead_ContactKey] ON [bi_mktg_dds].[FactLead]
(
	[ContactKey] ASC
)
INCLUDE([LeadCreationDateKey],[LeadCreationTimeKey],[CenterKey],[SourceKey],[GenderKey],[OccupationKey],[EthnicityKey],[MaritalStatusKey],[HairLossTypeKey],[AgeRangeKey],[EmployeeKey],[Leads],[Appointments],[Shows],[Sales],[Activities],[NoShows],[NoSales]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactLead_AssignedEmployeeKey] ON [bi_mktg_dds].[FactLead]
(
	[AssignedEmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactLead_CenterKey] ON [bi_mktg_dds].[FactLead]
(
	[CenterKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactLead_EmployeeKey] ON [bi_mktg_dds].[FactLead]
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
