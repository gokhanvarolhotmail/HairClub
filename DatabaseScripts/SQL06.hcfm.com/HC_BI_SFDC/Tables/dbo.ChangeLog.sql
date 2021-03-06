/* CreateDate: 03/21/2022 13:00:03.363 , ModifyDate: 03/21/2022 13:00:05.380 */
GO
CREATE TABLE [dbo].[ChangeLog](
	[ChangeLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SessionID] [uniqueidentifier] NULL,
	[ObjectName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ObjectKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ColumnName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OldValue] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewValue] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ChangeLog] PRIMARY KEY CLUSTERED
(
	[ChangeLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
