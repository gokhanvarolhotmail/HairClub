/* CreateDate: 06/09/2014 11:35:46.067 , ModifyDate: 06/09/2014 11:35:46.067 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommandLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchemaName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectType] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IndexName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IndexType] [tinyint] NULL,
	[StatisticsName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PartitionNumber] [int] NULL,
	[ExtendedInfo] [xml] NULL,
	[Command] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CommandType] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ErrorNumber] [int] NULL,
	[ErrorMessage] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
