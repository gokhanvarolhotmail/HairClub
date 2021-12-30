/* CreateDate: 05/05/2020 17:42:49.700 , ModifyDate: 05/05/2020 17:43:09.573 */
GO
CREATE TABLE [dbo].[datCommissionCorrection](
	[CommissionCorrectionID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
