/* CreateDate: 05/03/2010 12:09:20.260 , ModifyDate: 05/03/2010 12:09:20.380 */
GO
CREATE TABLE [bief_meta].[ErrorLog](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[EventType] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PackageName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EventCode] [int] NULL,
	[EventDescription] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PackageDuration] [int] NULL,
	[Host] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExecutionInstanceGUID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED
(
	[EventID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'e.g. OnPostExecute, OnError' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'ErrorLog', @level2type=N'COLUMN',@level2name=N'EventType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Some events (e.g. OnError) will provide a code' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'ErrorLog', @level2type=N'COLUMN',@level2name=N'EventCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Some events (e.g. OnInformation) will provide an event description' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'ErrorLog', @level2type=N'COLUMN',@level2name=N'EventDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'How long has the package been executing for' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'ErrorLog', @level2type=N'COLUMN',@level2name=N'PackageDuration'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Which machine was the package running on' , @level0type=N'SCHEMA',@level0name=N'bief_meta', @level1type=N'TABLE',@level1name=N'ErrorLog', @level2type=N'COLUMN',@level2name=N'Host'
GO
