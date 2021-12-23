/* CreateDate: 01/25/2010 10:44:07.887 , ModifyDate: 06/21/2012 10:00:56.797 */
GO
CREATE TABLE [dbo].[onca_list_subgroup_list](
	[list_subgroup_list_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[list_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[list_subgroup_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_list_subgroup_list] PRIMARY KEY CLUSTERED
(
	[list_subgroup_list_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_list_subgroup_list]  WITH NOCHECK ADD  CONSTRAINT [list_list_subgrou_1081] FOREIGN KEY([list_code])
REFERENCES [dbo].[onca_list] ([list_code])
GO
ALTER TABLE [dbo].[onca_list_subgroup_list] CHECK CONSTRAINT [list_list_subgrou_1081]
GO
ALTER TABLE [dbo].[onca_list_subgroup_list]  WITH NOCHECK ADD  CONSTRAINT [list_subgrou_list_subgrou_1082] FOREIGN KEY([list_subgroup_code])
REFERENCES [dbo].[onca_list_subgroup] ([list_subgroup_code])
GO
ALTER TABLE [dbo].[onca_list_subgroup_list] CHECK CONSTRAINT [list_subgrou_list_subgrou_1082]
GO
