/* CreateDate: 09/22/2008 15:00:25.813 , ModifyDate: 05/08/2010 02:30:04.663 */
GO
CREATE TABLE [dbo].[ContactEthnicity](
	[EthnicityCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [int] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_ContactEthnicity] PRIMARY KEY CLUSTERED
(
	[EthnicityCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
