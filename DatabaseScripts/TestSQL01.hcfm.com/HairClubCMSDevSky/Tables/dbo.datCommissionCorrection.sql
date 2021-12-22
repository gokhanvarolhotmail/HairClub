/* CreateDate: 02/24/2015 07:35:34.650 , ModifyDate: 12/07/2021 16:20:15.877 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datCommissionCorrection](
	[CommissionCorrectionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[PayPeriodKey] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[EmployeePositionID] [int] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CommissionPlanID] [int] NOT NULL,
	[CommissionPlanSectionID] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[AmountToBePaid] [money] NOT NULL,
	[CommissionAdjustmentReasonID] [int] NOT NULL,
	[ReasonForCorrection] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CommissionCorrectionStatusID] [int] NOT NULL,
	[ReasonForDenial] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[Comments] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusChangeDate] [datetime] NULL,
	[PayOnDate] [datetime] NULL,
 CONSTRAINT [PK_datCommissionCorrection] PRIMARY KEY CLUSTERED
(
	[CommissionCorrectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datCommissionCorrection_CenterID_PayPeriodKey] ON [dbo].[datCommissionCorrection]
(
	[CenterID] ASC,
	[PayPeriodKey] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_cfgCenter]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_datClient]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_datEmployee]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_lkpCommissionAdjustmentReason] FOREIGN KEY([CommissionAdjustmentReasonID])
REFERENCES [dbo].[lkpCommissionAdjustmentReason] ([CommissionAdjustmentReasonID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_lkpCommissionAdjustmentReason]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_lkpCommissionCorrectionStatus] FOREIGN KEY([CommissionCorrectionStatusID])
REFERENCES [dbo].[lkpCommissionCorrectionStatus] ([CommissionCorrectionStatusID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_lkpCommissionCorrectionStatus]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_lkpCommissionPlan] FOREIGN KEY([CommissionPlanID])
REFERENCES [dbo].[lkpCommissionPlan] ([CommissionPlanID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_lkpCommissionPlan]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_lkpCommissionPlanSection] FOREIGN KEY([CommissionPlanSectionID])
REFERENCES [dbo].[lkpCommissionPlanSection] ([CommissionPlanSectionID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_lkpCommissionPlanSection]
GO
ALTER TABLE [dbo].[datCommissionCorrection]  WITH CHECK ADD  CONSTRAINT [FK_datCommissionCorrection_lkpEmployeePosition] FOREIGN KEY([EmployeePositionID])
REFERENCES [dbo].[lkpEmployeePosition] ([EmployeePositionID])
GO
ALTER TABLE [dbo].[datCommissionCorrection] CHECK CONSTRAINT [FK_datCommissionCorrection_lkpEmployeePosition]
GO
