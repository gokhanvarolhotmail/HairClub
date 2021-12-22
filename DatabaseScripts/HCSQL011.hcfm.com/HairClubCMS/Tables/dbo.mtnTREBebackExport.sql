/* CreateDate: 09/28/2009 16:51:53.950 , ModifyDate: 05/26/2020 10:49:41.783 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mtnTREBebackExport](
	[TREBebackExportID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
