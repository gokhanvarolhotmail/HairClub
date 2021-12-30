/* CreateDate: 07/29/2019 10:56:22.023 , ModifyDate: 07/29/2019 10:56:22.023 */
GO
CREATE TABLE [dbo].[IO Usage By Database](
	[Server Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Run Date] [datetime] NULL,
	[I/O Rank] [bigint] NULL,
	[Database Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Total I/O (MB)] [decimal](12, 2) NULL,
	[I/O Percent] [decimal](5, 2) NULL
) ON [PRIMARY]
GO
