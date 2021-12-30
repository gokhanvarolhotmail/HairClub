/* CreateDate: 09/22/2008 15:00:53.953 , ModifyDate: 05/08/2010 02:30:04.683 */
GO
CREATE TABLE [dbo].[ContactOccupation](
	[OccupationCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [int] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_ContactOccupation] PRIMARY KEY CLUSTERED
(
	[OccupationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
