/* CreateDate: 01/25/2010 10:44:07.900 , ModifyDate: 06/21/2012 10:00:56.733 */
GO
CREATE TABLE [dbo].[onca_interest_subgroup_inter](
	[interest_subgroup_inter_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[interest_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[interest_sub_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_interest_subgroup_inter] PRIMARY KEY CLUSTERED
(
	[interest_subgroup_inter_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_interest_subgroup_inter]  WITH NOCHECK ADD  CONSTRAINT [interest_interest_sub_786] FOREIGN KEY([interest_code])
REFERENCES [dbo].[onca_interest] ([interest_code])
GO
ALTER TABLE [dbo].[onca_interest_subgroup_inter] CHECK CONSTRAINT [interest_interest_sub_786]
GO
ALTER TABLE [dbo].[onca_interest_subgroup_inter]  WITH NOCHECK ADD  CONSTRAINT [interest_sub_interest_sub_787] FOREIGN KEY([interest_sub_code])
REFERENCES [dbo].[onca_interest_subgroup] ([interest_sub_code])
GO
ALTER TABLE [dbo].[onca_interest_subgroup_inter] CHECK CONSTRAINT [interest_sub_interest_sub_787]
GO
