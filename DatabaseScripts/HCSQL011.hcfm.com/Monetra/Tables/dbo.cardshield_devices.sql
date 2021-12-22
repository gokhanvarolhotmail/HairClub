/* CreateDate: 10/01/2018 08:53:16.830 , ModifyDate: 10/01/2018 08:53:16.837 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cardshield_devices](
	[device_id] [bigint] NOT NULL,
	[key_id] [bigint] NOT NULL,
	[active] [tinyint] NOT NULL,
	[keyfmt] [int] NOT NULL,
	[devicetype] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[serial_num] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[descr] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ts] [bigint] NOT NULL,
	[last_ts] [bigint] NOT NULL,
	[last_user] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checkval] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[key_id] ASC,
	[device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_cardshield_devices_act_ts] ON [dbo].[cardshield_devices]
(
	[active] ASC,
	[last_ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [i_cardshield_devices_ser_type] ON [dbo].[cardshield_devices]
(
	[serial_num] ASC,
	[devicetype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
