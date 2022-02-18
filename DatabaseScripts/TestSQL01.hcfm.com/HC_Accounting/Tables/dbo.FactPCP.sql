/* CreateDate: 03/06/2013 08:52:40.217 , ModifyDate: 01/27/2022 08:32:37.623 */
GO
CREATE TABLE [dbo].[FactPCP](
	[CenterID] [int] NOT NULL,
	[GenderID] [int] NOT NULL,
	[MembershipID] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[PCP] [int] NULL,
	[EXTREME] [int] NULL,
	[Timestamp] [datetime] NULL,
	[CorporateAdjustmentID] [int] NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterKey] [int] NULL,
	[GenderKey] [int] NULL,
	[XTR] [int] NULL,
PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactPCP] ADD  CONSTRAINT [DF_FactPCP_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
