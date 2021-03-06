/* CreateDate: 10/01/2018 08:53:16.867 , ModifyDate: 10/01/2018 08:53:16.867 */
GO
CREATE TABLE [dbo].[bbacctids](
	[bbacctid] [int] NOT NULL,
	[m_proc] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[descr] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[bbacctid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
