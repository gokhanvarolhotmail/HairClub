/* CreateDate: 02/03/2021 18:16:24.603 , ModifyDate: 02/03/2021 18:23:14.190 */
GO
CREATE TABLE [dbo].[tmpRetailData](
	[CenterNumber] [int] NULL,
	[CenterDescription] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[ClientName] [nvarchar](180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[SalesCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[Department] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Price] [decimal](18, 2) NULL,
	[Tax] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[Consultant] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultantPayrollID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Stylist] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StylistPayrollID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_tmpRetailData_OrderDate] ON [dbo].[tmpRetailData]
(
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
