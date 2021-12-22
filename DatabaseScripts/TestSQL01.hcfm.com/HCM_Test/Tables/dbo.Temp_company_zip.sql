/* CreateDate: 04/08/2008 11:42:37.920 , ModifyDate: 04/08/2008 11:43:43.000 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Temp_company_zip](
	[name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL
) ON [PRIMARY]
GO
