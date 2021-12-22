/* CreateDate: 10/13/2015 12:56:36.510 , ModifyDate: 08/14/2020 14:34:09.733 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
