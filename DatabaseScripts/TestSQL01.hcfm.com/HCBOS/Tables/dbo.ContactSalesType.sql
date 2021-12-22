/* CreateDate: 02/04/2013 14:43:36.073 , ModifyDate: 02/04/2013 14:43:36.073 */
GO
CREATE TABLE [dbo].[ContactSalesType](
	[SalesTypeCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [int] NULL,
	[SortOrder] [int] NULL,
	[MembershipID] [int] NULL,
 CONSTRAINT [PK_ContactSalesType] PRIMARY KEY CLUSTERED
(
	[SalesTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
