/* CreateDate: 06/18/2013 09:24:40.583 , ModifyDate: 06/18/2013 09:24:41.357 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_corporate_callback_type](
	[corporate_callback_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_corporate_callback_type] PRIMARY KEY CLUSTERED
(
	[corporate_callback_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_corporate_callback_type] ADD  CONSTRAINT [DF_csta_corporate_callback_type_active]  DEFAULT ('Y') FOR [active]
GO
