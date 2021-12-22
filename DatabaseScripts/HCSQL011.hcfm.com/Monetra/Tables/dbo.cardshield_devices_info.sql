/* CreateDate: 10/01/2018 08:53:16.837 , ModifyDate: 10/01/2018 08:53:16.843 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cardshield_devices_info](
	[device_id] [bigint] NOT NULL,
	[key_id] [bigint] NOT NULL,
	[userid] [int] NULL,
	[is_disabled] [tinyint] NULL,
	[consec_failures] [int] NULL,
	[device_manuf] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[device_model] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[device_manuf_sn] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[device_app] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[device_appver] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[device_kernver] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[key_id] ASC,
	[device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [i_cardshield_devices_info_sn_manuf_model] ON [dbo].[cardshield_devices_info]
(
	[device_manuf_sn] ASC,
	[device_manuf] ASC,
	[device_model] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_cardshield_devices_info_userid] ON [dbo].[cardshield_devices_info]
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
