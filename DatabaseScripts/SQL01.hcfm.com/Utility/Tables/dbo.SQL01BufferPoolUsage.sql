/* CreateDate: 08/05/2018 20:56:48.410 , ModifyDate: 08/05/2018 20:56:48.410 */
GO
CREATE TABLE [dbo].[SQL01BufferPoolUsage](
	[Object Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[index_id] [int] NOT NULL,
	[Buffer size(MB)] [decimal](10, 2) NULL,
	[BufferCount] [int] NULL,
	[Row Count] [bigint] NOT NULL,
	[Compression Type] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
