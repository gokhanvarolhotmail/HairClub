/* CreateDate: 05/03/2010 12:09:05.067 , ModifyDate: 05/03/2010 12:09:05.400 */
GO
CREATE TABLE [bief_dq].[RuleType](
	[RuleTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[RuleType] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RuleTypeDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_RuleType] PRIMARY KEY CLUSTERED
(
	[RuleTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
