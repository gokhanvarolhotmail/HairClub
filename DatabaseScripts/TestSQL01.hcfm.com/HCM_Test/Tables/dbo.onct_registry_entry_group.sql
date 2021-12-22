/* CreateDate: 01/25/2010 11:09:09.990 , ModifyDate: 06/21/2012 10:03:58.377 */
GO
CREATE TABLE [dbo].[onct_registry_entry_group](
	[registry_entry_group_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
 CONSTRAINT [pk_onct_registry_entry_group] PRIMARY KEY CLUSTERED
(
	[registry_entry_group_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
