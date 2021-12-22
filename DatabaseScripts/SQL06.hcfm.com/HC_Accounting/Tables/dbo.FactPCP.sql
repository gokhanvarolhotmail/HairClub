/* CreateDate: 10/03/2019 22:32:12.400 , ModifyDate: 10/03/2019 22:32:14.153 */
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
 CONSTRAINT [PK__FactPCP__3214EC27FEF4DDC5] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
