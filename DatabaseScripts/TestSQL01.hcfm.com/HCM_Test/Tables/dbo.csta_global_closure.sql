/* CreateDate: 10/04/2006 16:26:48.547 , ModifyDate: 06/21/2012 10:00:00.127 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_global_closure](
	[global_closure_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[closure_date] [datetime] NOT NULL,
	[first_appointment] [datetime] NULL,
	[last_appointment] [datetime] NULL,
 CONSTRAINT [pk_csta_global_closure] PRIMARY KEY NONCLUSTERED
(
	[global_closure_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [csta_global_closure_i2] ON [dbo].[csta_global_closure]
(
	[closure_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
