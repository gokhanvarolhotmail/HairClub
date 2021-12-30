/* CreateDate: 10/01/2018 08:53:16.780 , ModifyDate: 10/01/2018 08:53:16.783 */
GO
CREATE TABLE [dbo].[imagerepo](
	[userid] [int] NOT NULL,
	[ttid] [bigint] NOT NULL,
	[ts] [bigint] NOT NULL,
	[ptrannum] [bigint] NOT NULL,
	[txnstatus] [int] NOT NULL,
	[batnum] [int] NOT NULL,
	[image_type] [int] NOT NULL,
	[image_data] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED
(
	[userid] ASC,
	[ttid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_imagerepo_user_type] ON [dbo].[imagerepo]
(
	[userid] ASC,
	[image_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
