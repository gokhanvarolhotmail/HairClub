/* CreateDate: 10/01/2018 08:53:16.817 , ModifyDate: 10/01/2018 08:53:16.817 */
GO
CREATE TABLE [dbo].[idtrack](
	[cnt_id] [int] NOT NULL,
	[last_id] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[cnt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO