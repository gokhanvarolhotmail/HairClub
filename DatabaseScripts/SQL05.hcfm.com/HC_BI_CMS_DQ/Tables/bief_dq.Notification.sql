/* CreateDate: 05/03/2010 12:19:12.863 , ModifyDate: 05/03/2010 12:19:13.310 */
GO
CREATE TABLE [bief_dq].[Notification](
	[NotificationKey] [int] IDENTITY(1,1) NOT NULL,
	[RuleKey] [int] NOT NULL,
	[RecipientType] [int] NULL,
	[Recipient] [int] NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED
(
	[NotificationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
