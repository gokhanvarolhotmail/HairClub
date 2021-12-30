/* CreateDate: 01/03/2018 16:31:32.177 , ModifyDate: 11/08/2018 11:05:01.910 */
GO
CREATE TABLE [dbo].[csta_contact_occupation](
	[occupation_code] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_contact_occupation] PRIMARY KEY NONCLUSTERED
(
	[occupation_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
