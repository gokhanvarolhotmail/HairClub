/* CreateDate: 01/18/2005 09:34:07.500 , ModifyDate: 06/21/2012 10:01:00.367 */
GO
CREATE TABLE [dbo].[onca_email_type](
	[email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_email_type] PRIMARY KEY CLUSTERED
(
	[email_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
