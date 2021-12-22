/* CreateDate: 10/04/2006 16:26:48.377 , ModifyDate: 06/21/2012 10:11:11.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_company_promotion](
	[company_promotion_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_set_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_company_promotion] PRIMARY KEY NONCLUSTERED
(
	[company_promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_promotion]  WITH CHECK ADD  CONSTRAINT [onca_action_set_cstd_company_promotion_760] FOREIGN KEY([action_set_code])
REFERENCES [dbo].[onca_action_set] ([action_set_code])
GO
ALTER TABLE [dbo].[cstd_company_promotion] CHECK CONSTRAINT [onca_action_set_cstd_company_promotion_760]
GO
ALTER TABLE [dbo].[cstd_company_promotion]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_promotion_743] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_promotion] CHECK CONSTRAINT [onca_user_cstd_company_promotion_743]
GO
ALTER TABLE [dbo].[cstd_company_promotion]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_company_promotion_744] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_company_promotion] CHECK CONSTRAINT [onca_user_cstd_company_promotion_744]
GO
ALTER TABLE [dbo].[cstd_company_promotion]  WITH CHECK ADD  CONSTRAINT [oncd_company_cstd_company_promotion_741] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_promotion] CHECK CONSTRAINT [oncd_company_cstd_company_promotion_741]
GO
