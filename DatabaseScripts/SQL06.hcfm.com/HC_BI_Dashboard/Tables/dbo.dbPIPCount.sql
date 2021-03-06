/* CreateDate: 05/09/2019 15:19:50.813 , ModifyDate: 05/09/2019 15:19:50.813 */
GO
CREATE TABLE [dbo].[dbPIPCount](
	[EmployeeKey] [int] NOT NULL,
	[EmployeeFullName] [nvarchar](1002) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserLogin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullDate] [date] NULL,
	[CenterNumber] [int] NULL,
	[CenterDescriptionNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterManagementAreaDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Consultations] [int] NULL,
	[NetNB1Count] [int] NULL,
	[NetNB1Revenue] [decimal](18, 4) NULL,
	[RevenueBudgetPerIC] [decimal](18, 4) NULL,
	[RevenuePercent] [decimal](18, 4) NULL,
	[ClosingBudget] [decimal](18, 4) NULL,
	[ClosingPercentActual] [decimal](18, 4) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ConsultationCenterSSID] [int] NULL,
	[ConsultationCenter] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCenterKey] [int] NULL,
	[SalesCenter] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
