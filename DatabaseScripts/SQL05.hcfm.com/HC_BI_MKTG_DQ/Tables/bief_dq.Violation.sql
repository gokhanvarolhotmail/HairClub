/* CreateDate: 05/03/2010 12:22:42.313 , ModifyDate: 05/03/2010 12:22:42.740 */
GO
CREATE TABLE [bief_dq].[Violation](
	[ViolationKey] [int] IDENTITY(1,1) NOT NULL,
	[RuleKey] [int] NOT NULL,
	[RuleActionKey] [int] NOT NULL,
	[ViolationStatusKey] [int] NOT NULL,
	[TableKey] [int] NOT NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DataQualityAuditKey] [int] NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Violation] PRIMARY KEY CLUSTERED
(
	[ViolationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
