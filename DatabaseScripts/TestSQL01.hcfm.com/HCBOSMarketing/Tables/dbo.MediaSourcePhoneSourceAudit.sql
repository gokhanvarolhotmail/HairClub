/* CreateDate: 09/30/2008 11:57:43.020 , ModifyDate: 06/14/2009 09:00:16.143 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MediaSourcePhoneSourceAudit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[PhoneID] [int] NULL,
	[SourceID] [int] NULL,
	[DateEntered] [smalldatetime] NULL,
 CONSTRAINT [PK_AuditID] PRIMARY KEY CLUSTERED
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_PhoneidSourceid] ON [dbo].[MediaSourcePhoneSourceAudit]
(
	[PhoneID] ASC,
	[SourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
