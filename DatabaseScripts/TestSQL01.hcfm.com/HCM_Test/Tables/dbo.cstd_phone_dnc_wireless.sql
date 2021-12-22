/* CreateDate: 03/22/2016 11:02:14.543 , ModifyDate: 09/10/2019 22:34:21.403 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_phone_dnc_wireless](
	[phone_dnc_wireless_id] [uniqueidentifier] NOT NULL,
	[phonenumber] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dnc_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dnc_flag_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dnc_date] [datetime] NULL,
	[ebr_dnc_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ebr_dnc_date] [datetime] NULL,
	[wireless_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[wireless_date] [datetime] NULL,
	[last_vendor_update] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_phone_dnc_wireless] PRIMARY KEY CLUSTERED
(
	[phone_dnc_wireless_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [cstd_phone_dnc_wireless_i1] ON [dbo].[cstd_phone_dnc_wireless]
(
	[phonenumber] ASC
)
INCLUDE([dnc_flag],[ebr_dnc_flag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
