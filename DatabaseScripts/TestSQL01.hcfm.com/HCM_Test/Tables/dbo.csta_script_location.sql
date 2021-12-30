/* CreateDate: 10/04/2006 16:26:48.283 , ModifyDate: 06/21/2012 10:00:01.303 */
GO
CREATE TABLE [dbo].[csta_script_location](
	[script_location_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[script_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_script_location] PRIMARY KEY NONCLUSTERED
(
	[script_location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script_location] ADD  CONSTRAINT [DF__csta_scri__activ__125EB334]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_script_location]  WITH CHECK ADD  CONSTRAINT [csta_script_csta_script_location_725] FOREIGN KEY([script_code])
REFERENCES [dbo].[csta_script] ([script_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_script_location] CHECK CONSTRAINT [csta_script_csta_script_location_725]
GO
ALTER TABLE [dbo].[csta_script_location]  WITH CHECK ADD  CONSTRAINT [oncd_company_csta_script_location_769] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_script_location] CHECK CONSTRAINT [oncd_company_csta_script_location_769]
GO
