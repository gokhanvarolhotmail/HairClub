/* CreateDate: 01/03/2018 16:31:35.230 , ModifyDate: 11/08/2018 11:05:01.253 */
GO
CREATE TABLE [dbo].[onca_time_zone](
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[greenwich_offset] [float] NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_time_zone] PRIMARY KEY CLUSTERED
(
	[time_zone_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
