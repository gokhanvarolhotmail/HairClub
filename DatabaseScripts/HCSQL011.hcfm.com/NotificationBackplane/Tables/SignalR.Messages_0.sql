/* CreateDate: 10/13/2015 22:44:27.610 , ModifyDate: 04/05/2019 18:24:04.003 */
GO
CREATE TABLE [SignalR].[Messages_0](
	[PayloadId] [bigint] NOT NULL,
	[Payload] [varbinary](max) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[PayloadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
