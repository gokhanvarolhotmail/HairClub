CREATE TABLE [dbo].[LogSpaceStats](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NULL,
	[DatabaseName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogSize] [decimal](18, 5) NULL,
	[LogUsed] [decimal](18, 5) NULL,
 CONSTRAINT [PK_LogSpaceStats] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogSpaceStats] ADD  DEFAULT (getdate()) FOR [LogDate]
