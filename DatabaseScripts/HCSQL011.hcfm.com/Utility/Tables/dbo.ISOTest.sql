/* CreateDate: 10/05/2016 20:31:07.273 , ModifyDate: 10/05/2016 20:31:07.273 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ISOTest](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_do_not_email] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_siebel_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
