/* CreateDate: 10/01/2018 08:53:16.860 , ModifyDate: 10/01/2018 08:53:16.860 */
GO
CREATE TABLE [dbo].[bbmerchinfo](
	[bbmerchid] [int] NOT NULL,
	[m_key] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[m_val] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[bbmerchid] ASC,
	[m_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
