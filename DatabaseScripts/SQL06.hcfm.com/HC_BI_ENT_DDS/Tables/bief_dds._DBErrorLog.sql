/* CreateDate: 01/08/2021 15:21:53.133 , ModifyDate: 01/08/2021 15:22:34.737 */
GO
CREATE TABLE [bief_dds].[_DBErrorLog](
	[DBErrorLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[UserName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ErrorNumber] [int] NOT NULL,
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
