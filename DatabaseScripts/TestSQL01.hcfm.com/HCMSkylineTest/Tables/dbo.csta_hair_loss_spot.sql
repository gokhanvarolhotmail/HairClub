/* CreateDate: 11/08/2012 11:26:05.983 , ModifyDate: 11/08/2012 11:26:54.400 */
GO
CREATE TABLE [dbo].[csta_hair_loss_spot](
	[hair_loss_spot_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_csta_hair_loss_spot] PRIMARY KEY CLUSTERED
(
	[hair_loss_spot_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
