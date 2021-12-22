/* CreateDate: 06/07/2010 10:16:29.413 , ModifyDate: 06/07/2010 10:16:29.420 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZIPCodesUS](
	[zip] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[state] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cityname] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[facility] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[areacode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dma] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
