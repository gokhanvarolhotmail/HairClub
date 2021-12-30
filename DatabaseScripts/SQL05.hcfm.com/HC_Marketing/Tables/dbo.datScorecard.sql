/* CreateDate: 04/28/2020 15:28:58.540 , ModifyDate: 04/28/2020 15:32:38.630 */
GO
CREATE TABLE [dbo].[datScorecard](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[Organization] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrganizationType] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level4] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level5] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level6] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period01] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period02] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period03] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period04] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period05] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period06] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period07] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period08] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period09] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period10] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period11] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Period12] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datScorecard] PRIMARY KEY CLUSTERED
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
