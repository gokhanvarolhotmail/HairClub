/* CreateDate: 05/03/2010 12:22:42.277 , ModifyDate: 05/03/2010 12:22:42.727 */
GO
CREATE TABLE [bief_dq].[RuleCategory](
	[RuleCategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[RuleCategory] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RuleCategoryDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_RuleCategory] PRIMARY KEY CLUSTERED
(
	[RuleCategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
