/* CreateDate: 11/02/2015 10:01:56.753 , ModifyDate: 10/23/2017 12:35:40.147 */
GO
CREATE TABLE [dbo].[cstd_contact_marketing_score](
	[contact_marketing_score_id] [uniqueidentifier] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[marketing_score_contact_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[marketing_score_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[marketing_score] [decimal](15, 4) NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_contact_marketing_score] PRIMARY KEY CLUSTERED
(
	[contact_marketing_score_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_contact_marketing_score]  WITH CHECK ADD  CONSTRAINT [contact_marketing_score_contact] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[cstd_contact_marketing_score] CHECK CONSTRAINT [contact_marketing_score_contact]
GO
ALTER TABLE [dbo].[cstd_contact_marketing_score]  WITH CHECK ADD  CONSTRAINT [contact_marketing_score_created_by] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_contact_marketing_score] CHECK CONSTRAINT [contact_marketing_score_created_by]
GO
ALTER TABLE [dbo].[cstd_contact_marketing_score]  WITH CHECK ADD  CONSTRAINT [contact_marketing_score_updated_by] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_contact_marketing_score] CHECK CONSTRAINT [contact_marketing_score_updated_by]
GO
