/* CreateDate: 04/26/2021 12:28:48.783 , ModifyDate: 04/26/2021 12:28:48.783 */
GO
CREATE TABLE [dbo].[prod_inventory](
	[id] [bigint] NOT NULL,
	[timestamp_ms] [bigint] NOT NULL,
	[cnt] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
