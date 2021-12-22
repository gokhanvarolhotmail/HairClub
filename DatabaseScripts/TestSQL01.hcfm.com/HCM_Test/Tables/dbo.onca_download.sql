/* CreateDate: 03/01/2006 09:36:47.333 , ModifyDate: 06/21/2012 10:01:00.333 */
GO
CREATE TABLE [dbo].[onca_download](
	[download_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[download_url] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[download_title] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__oncd_download__17C35226] PRIMARY KEY CLUSTERED
(
	[download_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
