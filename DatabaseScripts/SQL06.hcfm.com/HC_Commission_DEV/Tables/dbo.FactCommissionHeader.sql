CREATE TABLE [dbo].[FactCommissionHeader](
	[CommissionHeaderKey] [int] IDENTITY(1,1) NOT NULL,
	[CommissionTypeID] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[CenterSSID] [int] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderDate] [datetime] NULL,
	[ClientKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeFullName] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CalculatedCommission] [money] NULL,
	[AdvancedCommission] [money] NULL,
	[AdvancedCommissionDate] [datetime] NULL,
	[AdvancedPayPeriodKey] [int] NULL,
	[RetractedCommission] [money] NULL,
	[RetractedCommissionDate] [datetime] NULL,
	[RetractedPayPeriodKey] [int] NULL,
	[EarnedCommission] [money] NULL,
	[EarnedCommissionDate] [datetime] NULL,
	[PlanPercentage] [numeric](3, 2) NULL,
	[IsOverridden] [bit] NULL,
	[CommissionOverrideKey] [int] NULL,
	[BatchKey] [int] NULL,
	[IsClientCancelled] [bit] NULL,
	[IsClosed] [bit] NULL,
	[ClosedDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AdjustmentCommission] [money] NULL,
	[AdjustmentCommissionDate] [datetime] NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_FactCommissionHeader] PRIMARY KEY CLUSTERED
(
	[CommissionHeaderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idFactCommissionHeader_AdvancedPayPeriodKeyCommissionTypeID] ON [dbo].[FactCommissionHeader]
(
	[AdvancedPayPeriodKey] ASC,
	[CommissionTypeID] ASC
)
INCLUDE([CommissionHeaderKey],[AdvancedCommission]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactCommissionHeader_AdvancedCommissionDate] ON [dbo].[FactCommissionHeader]
(
	[AdvancedCommissionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactCommissionHeader_AdvancedPayPeriodKey] ON [dbo].[FactCommissionHeader]
(
	[AdvancedPayPeriodKey] ASC
)
INCLUDE([CommissionHeaderKey],[CommissionTypeID],[CenterKey],[ClientKey],[MembershipDescription],[EmployeeKey],[EmployeeFullName],[AdvancedCommission],[AdvancedCommissionDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactCommissionHeader_CenterKey] ON [dbo].[FactCommissionHeader]
(
	[CenterKey] ASC
)
INCLUDE([CommissionHeaderKey],[CommissionTypeID],[ClientKey],[MembershipDescription],[EmployeeKey],[EmployeeFullName],[AdvancedCommission],[AdvancedCommissionDate],[AdvancedPayPeriodKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactCommissionHeader_CommissionTypeID_INCL] ON [dbo].[FactCommissionHeader]
(
	[CommissionTypeID] ASC,
	[CenterSSID] ASC
)
INCLUDE([CommissionHeaderKey],[CenterKey],[SalesOrderKey],[SalesOrderDate],[ClosedDate],[CreateDate],[CreateUser],[UpdateDate],[UpdateUser],[EarnedCommissionDate],[PlanPercentage],[IsOverridden],[CommissionOverrideKey],[AdvancedCommission],[IsClosed],[AdvancedPayPeriodKey],[RetractedCommission],[RetractedCommissionDate],[RetractedPayPeriodKey],[ClientMembershipKey],[EarnedCommission],[MembershipKey],[MembershipDescription],[EmployeeKey],[EmployeeFullName],[CalculatedCommission],[AdvancedCommissionDate],[ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactCommissionHeader_CommissionTypeIDAdcancedCommissionDateIsClosed_INCL] ON [dbo].[FactCommissionHeader]
(
	[CommissionTypeID] ASC,
	[AdvancedCommissionDate] ASC,
	[IsClosed] ASC
)
INCLUDE([CommissionHeaderKey],[SalesOrderKey],[ClientMembershipKey],[MembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactCommissionHeader_CommissionTypeIDCenterSSID] ON [dbo].[FactCommissionHeader]
(
	[CommissionTypeID] ASC,
	[CenterSSID] ASC
)
INCLUDE([CommissionHeaderKey],[ClientMembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactCommissionHeader_SalesOrderKey_INCL] ON [dbo].[FactCommissionHeader]
(
	[SalesOrderKey] ASC
)
INCLUDE([CommissionHeaderKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
