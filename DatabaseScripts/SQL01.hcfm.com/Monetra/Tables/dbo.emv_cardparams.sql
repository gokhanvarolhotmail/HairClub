CREATE TABLE [dbo].[emv_cardparams](
	[user_id] [int] NOT NULL,
	[rid_or_aid] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[is_contactless] [tinyint] NOT NULL,
	[fallback_allowed] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[offline_floor_limit] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[threshold_value_biased] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[max_percent_biased] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[target_percent_random] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tac_default] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tac_deny] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tac_online] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_ddol] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_tdol] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[term_ctls_rcpt_req] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[term_option_status] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[term_trans_info] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[merch_type_ind] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctls_floor_limit] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctls_nocvm_limit] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctls_msr_aid_version] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctls_aid_version_list] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctls_default_udol] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[user_id] ASC,
	[rid_or_aid] ASC,
	[is_contactless] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
