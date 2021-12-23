/* CreateDate: 01/18/2005 09:34:07.983 , ModifyDate: 10/23/2017 12:35:40.143 */
GO
CREATE TABLE [dbo].[onca_territory_user](
	[territory_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[territory_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_territory_user] PRIMARY KEY CLUSTERED
(
	[territory_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_territory_user]  WITH NOCHECK ADD  CONSTRAINT [territory_territory_us_226] FOREIGN KEY([territory_code])
REFERENCES [dbo].[onca_territory] ([territory_code])
GO
ALTER TABLE [dbo].[onca_territory_user] CHECK CONSTRAINT [territory_territory_us_226]
GO
ALTER TABLE [dbo].[onca_territory_user]  WITH NOCHECK ADD  CONSTRAINT [user_territory_us_225] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_territory_user] CHECK CONSTRAINT [user_territory_us_225]
GO
