/* CreateDate: 07/18/2016 07:45:10.790 , ModifyDate: 12/07/2021 16:20:15.860 */
GO
CREATE TABLE [dbo].[datPaymentPlan](
	[PaymentPlanID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[PaymentPlanStatusID] [int] NOT NULL,
	[ContractAmount] [money] NOT NULL,
	[DownpaymentAmount] [money] NOT NULL,
	[TotalNumberOfPayments] [int] NOT NULL,
	[RemainingNumberOfPayments] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[SatisfactionDate] [datetime] NULL,
	[CancelDate] [datetime] NULL,
	[RemainingBalance] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPaymentPlan] PRIMARY KEY CLUSTERED
(
	[PaymentPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPaymentPlan]  WITH CHECK ADD  CONSTRAINT [FK_datPaymentPlan_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datPaymentPlan] CHECK CONSTRAINT [FK_datPaymentPlan_datClient]
GO
ALTER TABLE [dbo].[datPaymentPlan]  WITH CHECK ADD  CONSTRAINT [FK_datPaymentPlan_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datPaymentPlan] CHECK CONSTRAINT [FK_datPaymentPlan_datClientMembership]
GO
ALTER TABLE [dbo].[datPaymentPlan]  WITH CHECK ADD  CONSTRAINT [FK_datPaymentPlan_lkpPaymentPlanStatus] FOREIGN KEY([PaymentPlanStatusID])
REFERENCES [dbo].[lkpPaymentPlanStatus] ([PaymentPlanStatusID])
GO
ALTER TABLE [dbo].[datPaymentPlan] CHECK CONSTRAINT [FK_datPaymentPlan_lkpPaymentPlanStatus]
GO
