/* CreateDate: 09/22/2008 15:00:41.360 , ModifyDate: 05/08/2010 02:30:04.673 */
GO
CREATE TABLE [dbo].[ContactMaritalStatus](
	[MaritalStatusCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [int] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_ContactMaritalStatus] PRIMARY KEY CLUSTERED
(
	[MaritalStatusCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
