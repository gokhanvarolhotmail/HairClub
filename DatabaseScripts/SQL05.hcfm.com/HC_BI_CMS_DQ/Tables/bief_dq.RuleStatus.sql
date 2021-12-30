/* CreateDate: 05/03/2010 12:19:12.933 , ModifyDate: 05/03/2010 12:19:13.327 */
GO
CREATE TABLE [bief_dq].[RuleStatus](
	[RuleStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[RuleStatus] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RuleStatusDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_RuleStatus] PRIMARY KEY CLUSTERED
(
	[RuleStatusKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
