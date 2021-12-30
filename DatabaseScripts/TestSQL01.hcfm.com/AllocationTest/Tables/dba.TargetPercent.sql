/* CreateDate: 11/22/2019 14:57:35.363 , ModifyDate: 11/22/2019 14:57:35.363 */
GO
CREATE TABLE [dba].[TargetPercent](
	[TableName] [varchar](14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[@EndDate] [datetime] NULL,
	[@TotalCount] [int] NULL,
	[VendorID] [int] NULL,
	[PurchaseOrderGUID] [uniqueidentifier] NULL,
	[VendorAssignedCount] [int] NULL,
	[TotalCount] [int] NULL,
	[TargetPercent] [decimal](6, 5) NULL,
	[IsAllocationCompleteFlag] [bit] NULL,
	[ActualPercent] [decimal](29, 17) NULL,
	[VariancePercent] [decimal](30, 17) NULL
) ON [PRIMARY]
GO
