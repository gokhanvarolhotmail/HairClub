/* CreateDate: 11/06/2007 16:18:29.517 , ModifyDate: 11/06/2007 16:18:29.577 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_userSUBSET110607](
	[origin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[groups] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sls_psn_desc] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sls_psn_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[timestamp] [datetime] NOT NULL
) ON [PRIMARY]
GO
