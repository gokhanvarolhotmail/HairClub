/* CreateDate: 10/01/2018 08:53:16.843 , ModifyDate: 10/01/2018 08:53:16.843 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cardshield_devices_log](
	[device_id] [bigint] NOT NULL,
	[key_id] [bigint] NOT NULL,
	[ts] [bigint] NOT NULL,
	[type] [smallint] NOT NULL,
	[notes] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[monetra_username] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[approval_user] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[key_id] ASC,
	[device_id] ASC,
	[ts] ASC,
	[type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
