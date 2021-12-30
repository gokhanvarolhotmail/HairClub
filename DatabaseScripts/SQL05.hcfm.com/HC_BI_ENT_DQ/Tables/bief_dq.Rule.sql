/* CreateDate: 05/03/2010 12:09:05.010 , ModifyDate: 05/03/2010 12:09:05.367 */
GO
CREATE TABLE [bief_dq].[Rule](
	[RuleKey] [int] NOT NULL,
	[RuleName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RuleDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RuleTypeKey] [int] NULL,
	[RuleCategoryKey] [int] NOT NULL,
	[RiskLevelKey] [int] NOT NULL,
	[RuleStatusKey] [int] NOT NULL,
	[RuleActionKey] [int] NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Rule] PRIMARY KEY CLUSTERED
(
	[RuleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
