/* CreateDate: 05/24/2018 10:02:01.603 , ModifyDate: 08/08/2018 15:18:28.527 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Canary](
	[CheckDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Canary] PRIMARY KEY CLUSTERED
(
	[CheckDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
