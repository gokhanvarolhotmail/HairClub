/* CreateDate: 01/18/2005 09:34:07.513 , ModifyDate: 06/21/2012 10:01:00.383 */
GO
CREATE TABLE [dbo].[onca_enclosure](
	[enclosure_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cost] [decimal](15, 4) NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cost_group_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_enclosure] PRIMARY KEY CLUSTERED
(
	[enclosure_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_enclosure]  WITH CHECK ADD  CONSTRAINT [cost_group_enclosure_833] FOREIGN KEY([cost_group_code])
REFERENCES [dbo].[onca_cost_group] ([cost_group_code])
GO
ALTER TABLE [dbo].[onca_enclosure] CHECK CONSTRAINT [cost_group_enclosure_833]
GO
