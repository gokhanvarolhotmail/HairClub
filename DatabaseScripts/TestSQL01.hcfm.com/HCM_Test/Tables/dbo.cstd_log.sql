/* CreateDate: 01/03/2013 10:22:38.820 , ModifyDate: 01/03/2013 10:22:38.863 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_log] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
