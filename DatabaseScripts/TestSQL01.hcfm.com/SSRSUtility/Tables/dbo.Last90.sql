/* CreateDate: 03/12/2019 09:24:30.043 , ModifyDate: 03/12/2019 09:24:30.043 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Last90](
	[ItemID] [uniqueidentifier] NULL,
	[Path] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Report Count] [int] NULL,
	[Earliest Run] [datetime] NULL,
	[Latest Run] [datetime] NULL,
	[RequestType_InteractiveCount] [int] NULL,
	[RequestType_SubscriptionCount] [int] NULL,
	[RequestType_RefreshCacheCount] [int] NULL,
	[ReportAction_RenderCount] [int] NULL,
	[ReportAction_BookmarkNavigationCount] [int] NULL,
	[ReportAction_DocumentMapNavigationCount] [int] NULL,
	[ReportAction_DrillThroughCount] [int] NULL,
	[ReportAction_FindStringCount] [int] NULL,
	[ReportAction_GetDocumentMapCount] [int] NULL,
	[ReportAction_ToggleCount] [int] NULL,
	[ReportAction_SortCount] [int] NULL,
	[ReportAction_ExecuteCount] [int] NULL,
	[Source_LiveCount] [int] NULL,
	[Source_CacheCount] [int] NULL,
	[Source_SnapshotCount] [int] NULL,
	[Source_HistoryCount] [int] NULL,
	[Source_AdHocCount] [int] NULL,
	[Source_SessionCount] [int] NULL,
	[Source_RDCECount] [int] NULL,
	[Format_CSVCount] [int] NULL,
	[Format_EXCELOPENXMLCount] [int] NULL,
	[Format_IMAGECount] [int] NULL,
	[Format_MHTMLCount] [int] NULL,
	[Format_PDFCount] [int] NULL,
	[Format_RPLCount] [int] NULL,
	[Format_WORDOPENXMLCount] [int] NULL,
	[Format_XMLCount] [int] NULL
) ON [PRIMARY]
GO
