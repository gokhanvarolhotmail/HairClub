/* CreateDate: 01/18/2005 09:34:14.203 , ModifyDate: 06/18/2013 09:24:50.770 */
GO
CREATE TABLE [dbo].[onct_entity_tree](
	[entity_tree_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_entity_tree] PRIMARY KEY CLUSTERED
(
	[entity_tree_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
