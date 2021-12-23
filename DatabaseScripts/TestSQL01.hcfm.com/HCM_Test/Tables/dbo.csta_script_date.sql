/* CreateDate: 05/15/2017 09:13:31.627 , ModifyDate: 05/15/2017 09:13:32.190 */
GO
CREATE TABLE [dbo].[csta_script_date](
	[script_date_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[script_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[from_date] [datetime] NULL,
	[to_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_script_date] PRIMARY KEY NONCLUSTERED
(
	[script_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script_date] ADD  CONSTRAINT [DF__csta_script_date_active]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_script_date]  WITH NOCHECK ADD  CONSTRAINT [csta_script_csta_script_date] FOREIGN KEY([script_code])
REFERENCES [dbo].[csta_script] ([script_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_script_date] CHECK CONSTRAINT [csta_script_csta_script_date]
GO
ALTER TABLE [dbo].[csta_script_date]  WITH NOCHECK ADD  CONSTRAINT [oncd_company_csta_script_date] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_script_date] CHECK CONSTRAINT [oncd_company_csta_script_date]
GO
