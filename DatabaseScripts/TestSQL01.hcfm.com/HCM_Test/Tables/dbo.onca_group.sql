/* CreateDate: 01/18/2005 09:34:10.263 , ModifyDate: 06/21/2012 10:01:00.423 */
GO
CREATE TABLE [dbo].[onca_group](
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_group] PRIMARY KEY CLUSTERED
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
