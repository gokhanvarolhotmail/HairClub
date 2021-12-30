/* CreateDate: 12/27/2020 09:24:01.437 , ModifyDate: 12/27/2020 09:25:09.983 */
GO
CREATE TABLE [dbo].[FacebookLeads3](
	[id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_time] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ad_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ad_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[adset_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[adset_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[form_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[form_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_organic] [bit] NOT NULL,
	[platform] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[retailer_item_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
