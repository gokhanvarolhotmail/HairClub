/* CreateDate: 06/18/2020 11:17:37.897 , ModifyDate: 01/05/2021 23:29:27.123 */
GO
CREATE TABLE [dbo].[dbLASSDashboard](
	[Area] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstDateOfMonth] [datetime] NULL,
	[FullDate] [datetime] NULL,
	[SourceCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Channel] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Origin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeviceType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollfreeNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Leads] [int] NULL,
	[Appointments] [int] NULL,
	[Consultations] [int] NULL,
	[BeBacks] [int] NULL,
	[Inhouses] [int] NULL,
	[Shows] [int] NULL,
	[Sales] [int] NULL,
	[NoShows] [int] NULL,
	[NoSales] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_dbLASSDashboard_Area_INCL] ON [dbo].[dbLASSDashboard]
(
	[Area] ASC
)
INCLUDE([CenterNumber],[FirstDateOfMonth],[FullDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbLASSDashboard_CenterNumber_INCL] ON [dbo].[dbLASSDashboard]
(
	[CenterNumber] ASC
)
INCLUDE([Area],[FirstDateOfMonth],[FullDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
