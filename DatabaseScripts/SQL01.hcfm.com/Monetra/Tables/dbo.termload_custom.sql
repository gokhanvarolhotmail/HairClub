/* CreateDate: 10/01/2018 08:53:16.890 , ModifyDate: 10/01/2018 08:53:16.890 */
GO
CREATE TABLE [dbo].[termload_custom](
	[user_id] [int] NOT NULL,
	[name] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[val] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED
(
	[user_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO