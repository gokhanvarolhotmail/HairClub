/* CreateDate: 09/19/2012 12:06:45.100 , ModifyDate: 09/19/2012 12:06:45.100 */
GO
CREATE TABLE [bi_ent_dds].[FactPCP](
	[CenterKey] [int] NULL,
	[GenderKey] [int] NOT NULL,
	[MembershipKey] [int] NULL,
	[DateKey] [int] NULL,
	[PCP] [int] NULL,
	[Extreme] [int] NULL,
	[CorporateAdjustmentID] [int] NULL
) ON [FG1]
GO
