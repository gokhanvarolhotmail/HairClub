/* CreateDate: 01/03/2018 16:31:34.370 , ModifyDate: 11/08/2018 11:05:01.607 */
GO
CREATE TABLE [dbo].[onca_action](
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chain_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[schedule_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[prompt_for_schedule] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[available_to_outlook] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[available_to_mobile] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[prompt_for_next] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[cst_noble_exclusion] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_noble_addition] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_is_outbound_call] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_action] PRIMARY KEY CLUSTERED
(
	[action_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
