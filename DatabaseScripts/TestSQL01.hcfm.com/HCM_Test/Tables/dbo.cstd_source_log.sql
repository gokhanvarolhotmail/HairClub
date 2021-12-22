/* CreateDate: 02/23/2009 11:55:18.487 , ModifyDate: 02/23/2009 11:55:18.563 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_source_log](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL
) ON [PRIMARY]
GO
