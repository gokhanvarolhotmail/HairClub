/* CreateDate: 08/05/2015 09:01:32.080 , ModifyDate: 08/05/2015 09:01:32.427 */
GO
CREATE TABLE [dbo].[ContactLudwigScale](
	[HairScaleCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [int] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_ContactLudwigScale] PRIMARY KEY CLUSTERED
(
	[HairScaleCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
