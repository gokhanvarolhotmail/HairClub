/* CreateDate: 10/28/2010 15:03:50.543 , ModifyDate: 06/21/2012 10:00:00.143 */
GO
CREATE TABLE [dbo].[csta_hair_loss_experience](
	[hair_loss_experience_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_csta_hair_loss_experience] PRIMARY KEY CLUSTERED
(
	[hair_loss_experience_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
