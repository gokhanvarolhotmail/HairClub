/* CreateDate: 09/18/2020 08:14:48.063 , ModifyDate: 09/18/2020 08:14:48.063 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpBPAgent_Dispositions](
	[disposition_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL
) ON [PRIMARY]
GO
