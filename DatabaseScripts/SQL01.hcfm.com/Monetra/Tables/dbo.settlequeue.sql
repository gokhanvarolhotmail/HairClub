/* CreateDate: 10/01/2018 08:53:16.737 , ModifyDate: 10/01/2018 08:53:16.737 */
GO
CREATE TABLE [dbo].[settlequeue](
	[userid] [int] NOT NULL,
	[batch] [int] NOT NULL,
	[sub] [int] NOT NULL,
	[datetime] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[userid] ASC,
	[batch] ASC,
	[sub] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
