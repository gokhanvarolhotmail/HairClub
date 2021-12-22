/* CreateDate: 01/25/2010 11:09:09.897 , ModifyDate: 06/21/2012 10:00:52.280 */
GO
CREATE TABLE [dbo].[onca_project_contact_role](
	[project_contact_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_project_contact_role] PRIMARY KEY CLUSTERED
(
	[project_contact_role_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
