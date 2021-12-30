/* CreateDate: 08/22/2017 17:15:44.783 , ModifyDate: 08/22/2017 17:22:18.467 */
GO
CREATE TABLE [dbo].[oncd_activity_salesforce](
	[activity_id] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[salesforce_id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_code] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [varchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [varchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_id] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[completion_date] [varchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_salesforce] PRIMARY KEY CLUSTERED
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
