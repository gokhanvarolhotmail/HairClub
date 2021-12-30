/* CreateDate: 05/03/2010 12:09:04.997 , ModifyDate: 05/03/2010 12:09:05.360 */
GO
CREATE TABLE [bief_dq].[RiskLevel](
	[RiskLevelKey] [int] IDENTITY(1,1) NOT NULL,
	[RiskLevel] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RiskLevelDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_RiskLevel] PRIMARY KEY CLUSTERED
(
	[RiskLevelKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
