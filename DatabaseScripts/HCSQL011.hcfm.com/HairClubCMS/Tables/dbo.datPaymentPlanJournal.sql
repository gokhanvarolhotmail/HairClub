/* CreateDate: 07/18/2016 07:45:10.933 , ModifyDate: 07/18/2016 07:45:10.953 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datPaymentPlanJournal](
	[PaymentPlanJournalID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentPlanID] [int] NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[Amount] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPaymentPlanJournal] PRIMARY KEY NONCLUSTERED
(
	[PaymentPlanJournalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPaymentPlanJournal]  WITH CHECK ADD  CONSTRAINT [FK_datPaymentPlanJournal_datPaymentPlan] FOREIGN KEY([PaymentPlanID])
REFERENCES [dbo].[datPaymentPlan] ([PaymentPlanID])
GO
ALTER TABLE [dbo].[datPaymentPlanJournal] CHECK CONSTRAINT [FK_datPaymentPlanJournal_datPaymentPlan]
GO
