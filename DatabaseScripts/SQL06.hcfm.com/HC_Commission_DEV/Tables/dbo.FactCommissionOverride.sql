/* CreateDate: 01/23/2013 14:03:11.863 , ModifyDate: 07/24/2019 13:47:48.347 */
GO
CREATE TABLE [dbo].[FactCommissionOverride](
	[OverrideID] [int] IDENTITY(1,1) NOT NULL,
	[CommissionHeaderKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeFullName] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OverrideReasonID] [int] NULL,
	[Notes] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_FactCommissionOverride] PRIMARY KEY CLUSTERED
(
	[OverrideID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_FactCommissionOverride_CommissionHeaderKey] ON [dbo].[FactCommissionOverride]
(
	[CommissionHeaderKey] ASC
)
INCLUDE([EmployeeKey],[EmployeeFullName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
