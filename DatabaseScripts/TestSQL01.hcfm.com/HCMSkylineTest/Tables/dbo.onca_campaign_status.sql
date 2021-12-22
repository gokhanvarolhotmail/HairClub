/* CreateDate: 11/08/2012 13:45:20.673 , ModifyDate: 11/08/2012 13:46:06.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_campaign_status](
	[campaign_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sold_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[response_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cancel_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_type] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_campaign_status] PRIMARY KEY CLUSTERED
(
	[campaign_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
