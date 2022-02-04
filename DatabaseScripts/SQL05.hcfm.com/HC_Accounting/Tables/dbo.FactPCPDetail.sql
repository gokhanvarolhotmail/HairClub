/* CreateDate: 03/19/2013 14:15:40.323 , ModifyDate: 02/03/2022 19:46:04.070 */
GO
CREATE TABLE [dbo].[FactPCPDetail](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterKey] [int] NULL,
	[ClientKey] [int] NULL,
	[GenderKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[DateKey] [int] NULL,
	[PCP] [int] NULL,
	[EXT] [int] NULL,
	[Timestamp] [datetime] NULL,
	[XTR] [int] NULL,
PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[FactPCPDetail]
(
	[ClientKey] ASC
)
INCLUDE([ID],[CenterKey],[GenderKey],[MembershipKey],[DateKey],[PCP],[EXT],[Timestamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactPCPDetail_DateKey] ON [dbo].[FactPCPDetail]
(
	[DateKey] ASC
)
INCLUDE([CenterKey],[ClientKey],[MembershipKey],[PCP],[EXT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactPCPDetail_CenterKey_INCL] ON [dbo].[FactPCPDetail]
(
	[CenterKey] ASC
)
INCLUDE([ClientKey],[DateKey],[PCP],[EXT],[XTR]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactPCPDetail_ClientKey] ON [dbo].[FactPCPDetail]
(
	[ClientKey] ASC
)
INCLUDE([ID],[CenterKey],[GenderKey],[MembershipKey],[DateKey],[PCP],[EXT],[Timestamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactPCPDetail] ADD  CONSTRAINT [DF_FactPCPDetail_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
