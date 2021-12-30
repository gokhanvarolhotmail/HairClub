/* CreateDate: 11/17/2016 12:29:26.510 , ModifyDate: 11/17/2016 12:29:26.527 */
GO
CREATE TABLE [dbo].[datExportHeader](
	[ExportHeaderID] [int] IDENTITY(1,1) NOT NULL,
	[ExportStartDate] [datetime] NULL,
	[ExportEndDate] [datetime] NULL,
	[IsCompletedFlag] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datExportHeader] PRIMARY KEY CLUSTERED
(
	[ExportHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datExportHeader_ExportEndDate] ON [dbo].[datExportHeader]
(
	[ExportEndDate] DESC,
	[IsCompletedFlag] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
