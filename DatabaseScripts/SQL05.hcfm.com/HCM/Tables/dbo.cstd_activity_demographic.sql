/* CreateDate: 01/03/2018 16:31:34.717 , ModifyDate: 11/08/2018 11:05:01.733 */
GO
CREATE TABLE [dbo].[cstd_activity_demographic](
	[activity_demographic_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[gender] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[birthday] [datetime] NULL,
	[occupation_code] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ethnicity_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[maritalstatus_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[norwood] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ludwig] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[age] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[performer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price_quoted] [money] NULL,
	[solution_offered] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[no_sale_reason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[disc_style] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_activity_demographic] PRIMARY KEY CLUSTERED
(
	[activity_demographic_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_activity_demographic_activity_id] ON [dbo].[cstd_activity_demographic]
(
	[activity_id] ASC
)
INCLUDE([birthday],[occupation_code],[ethnicity_code],[maritalstatus_code],[norwood],[ludwig],[performer],[price_quoted],[solution_offered],[no_sale_reason],[disc_style]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
