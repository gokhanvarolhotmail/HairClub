/* CreateDate: 05/05/2020 17:42:55.470 , ModifyDate: 05/05/2020 17:43:16.560 */
GO
CREATE TABLE [dbo].[mtnTREBebackExport](
	[TREBebackExportID] [int] NOT NULL,
	[ContactID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[Performer] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL,
	[IsProcessedFlag] [bit] NULL,
 CONSTRAINT [PK_mtnTREBebackExport] PRIMARY KEY CLUSTERED
(
	[TREBebackExportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
