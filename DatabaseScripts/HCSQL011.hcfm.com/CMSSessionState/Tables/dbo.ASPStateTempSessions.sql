/* CreateDate: 01/26/2010 10:12:08.633 , ModifyDate: 01/26/2010 10:12:08.637 */
GO
CREATE TABLE [dbo].[ASPStateTempSessions](
	[SessionId] [nvarchar](88) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created] [datetime] NOT NULL,
	[Expires] [datetime] NOT NULL,
	[LockDate] [datetime] NOT NULL,
	[LockDateLocal] [datetime] NOT NULL,
	[LockCookie] [int] NOT NULL,
	[Timeout] [int] NOT NULL,
	[Locked] [bit] NOT NULL,
	[SessionItemShort] [varbinary](7000) NULL,
	[SessionItemLong] [image] NULL,
	[Flags] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Index_Expires] ON [dbo].[ASPStateTempSessions]
(
	[Expires] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ASPStateTempSessions] ADD  DEFAULT (getutcdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ASPStateTempSessions] ADD  DEFAULT ((0)) FOR [Flags]
GO
