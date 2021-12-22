/* CreateDate: 05/11/2009 11:35:51.547 , ModifyDate: 06/21/2012 10:12:24.340 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_no_exceptions](
	[no_exception_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_no_exceptio__2454DCEB] PRIMARY KEY CLUSTERED
(
	[no_exception_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
