/* CreateDate: 10/24/2013 09:54:51.657 , ModifyDate: 08/26/2014 13:10:34.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContestCenterReportGroup](
	[ContestCenterReportGroupSSID] [int] IDENTITY(1,1) NOT NULL,
	[ContestSSID] [int] NULL,
	[ContestReportGroupSSID] [int] NULL,
	[CenterSSID] [int] NOT NULL,
	[CenterSortOrder] [int] NULL,
 CONSTRAINT [PK_ContestCenterReportGroup] PRIMARY KEY CLUSTERED
(
	[ContestCenterReportGroupSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
