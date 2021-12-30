/* CreateDate: 07/20/2014 22:04:21.920 , ModifyDate: 07/20/2014 22:04:21.920 */
GO
CREATE TABLE [dbo].[LogSpaceStats](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NULL,
	[DatabaseName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogSize] [decimal](18, 5) NULL,
	[LogUsed] [decimal](18, 5) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogSpaceStats] ADD  DEFAULT (getdate()) FOR [LogDate]
GO
