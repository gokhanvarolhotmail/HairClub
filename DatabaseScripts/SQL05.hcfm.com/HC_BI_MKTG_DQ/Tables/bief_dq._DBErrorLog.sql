/* CreateDate: 05/03/2010 12:22:42.360 , ModifyDate: 05/03/2010 12:22:42.773 */
GO
CREATE TABLE [bief_dq].[_DBErrorLog](
	[DBErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[UserName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ErrorNumber] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](126) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorDetails] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__DBErrorLog_DBErrorLogID] PRIMARY KEY NONCLUSTERED
(
	[DBErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_dq].[_DBErrorLog] ADD  CONSTRAINT [DF__DBErrorLog_ErrorTime]  DEFAULT (getdate()) FOR [ErrorTime]
GO
ALTER TABLE [bief_dq].[_DBErrorLog] ADD  CONSTRAINT [DF__DBErrorLog_ErrorDetails]  DEFAULT ('') FOR [ErrorDetails]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for _DBErrorLog records.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'DBErrorLogID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date and time at which the error occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The user who executed the batch in which the error occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The error number of the error that occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The severity of the error that occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorSeverity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The state number of the error that occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the stored procedure or trigger where the error occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorProcedure'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The line number at which the error occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorLine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The message text of the error that occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The detail text of the error that occurred.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog', @level2type=N'COLUMN',@level2name=N'ErrorDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Audit table tracking errors in the the Reporting database that are caught by the CATCH block of a TRY...CATCH construct. Data is inserted by stored procedure bief_dq.uspLogError when it is executed from inside the CATCH block of a TRY...CATCH construct.' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBErrorLog'
GO
