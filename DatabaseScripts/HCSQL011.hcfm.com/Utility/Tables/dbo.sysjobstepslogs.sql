/* CreateDate: 07/31/2014 11:52:06.970 , ModifyDate: 07/31/2014 11:52:06.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysjobstepslogs](
	[RunDate] [datetime] NOT NULL,
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[log] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[date_created] [datetime] NOT NULL,
	[date_modified] [datetime] NOT NULL,
	[log_size] [bigint] NULL,
	[step_uid] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
