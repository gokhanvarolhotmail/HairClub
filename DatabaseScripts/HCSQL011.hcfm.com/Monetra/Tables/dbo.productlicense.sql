/* CreateDate: 10/01/2018 08:53:16.893 , ModifyDate: 10/01/2018 08:53:16.900 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[productlicense](
	[id] [bigint] NOT NULL,
	[active] [tinyint] NOT NULL,
	[last_ts] [bigint] NOT NULL,
	[hold_ts] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[product] [int] NOT NULL,
	[producttype] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[serialnum] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_username] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_productlicense_act_prod_ts] ON [dbo].[productlicense]
(
	[active] ASC,
	[product] ASC,
	[last_ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [i_productlicense_prod_type_ser] ON [dbo].[productlicense]
(
	[product] ASC,
	[producttype] ASC,
	[serialnum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
