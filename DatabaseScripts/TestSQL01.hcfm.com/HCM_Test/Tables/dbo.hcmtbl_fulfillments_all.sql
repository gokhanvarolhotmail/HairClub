/* CreateDate: 10/10/2016 15:34:35.910 , ModifyDate: 10/10/2016 15:34:36.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hcmtbl_fulfillments_all](
	[recordid] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[center number] [int] NOT NULL,
	[center name] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center address 1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center address 2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center city] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center state] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[center zip] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact fname] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact lname] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact address 1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact address 2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact state] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact zip] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact create date] [datetime] NULL,
	[promo] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create by] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[promo2] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_gender] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filename] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
