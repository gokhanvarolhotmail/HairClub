/* CreateDate: 09/02/2020 09:42:54.223 , ModifyDate: 09/02/2020 09:43:09.463 */
GO
CREATE TABLE [dbo].[dbTransaction](
	[DateKey] [int] NULL,
	[CenterKey] [int] NULL,
	[SalesOrderTypeKey] [int] NOT NULL,
	[SalesCodeKey] [int] NOT NULL,
	[SalesCodeDepartmentKey] [int] NOT NULL,
	[SalesCodeDivisionKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ContractPrice] [money] NOT NULL,
	[ContractPaidAmount] [money] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[Employee1Key] [int] NOT NULL,
	[Employee2Key] [int] NOT NULL,
	[Quantity] [int] NULL,
	[Price] [money] NULL,
	[Tax] [money] NULL,
	[Total] [money] NULL,
	[GrossNBCount] [int] NULL,
	[NetNBCount] [int] NULL,
	[NetNBRevenue] [money] NULL,
	[NetPCPRevenue] [money] NULL,
	[NetNonProgramRevenue] [money] NULL,
	[NetRetailRevenue] [money] NULL,
	[NetServiceRevenue] [money] NULL,
	[NetTotalRevenue] [money] NULL,
	[NetFirstServiceCount] [int] NULL,
	[NetApplicationCount] [int] NULL,
	[NetConversionCount] [int] NULL,
	[NetXPICount] [int] NULL,
	[NetXPIRevenue] [money] NULL,
	[NetXPI6Count] [int] NULL,
	[NetXPI6Revenue] [money] NULL,
	[NetEXTCount] [int] NULL,
	[NetEXTRevenue] [money] NULL,
	[NetPostEXTCount] [int] NULL,
	[NetPostEXTRevenue] [money] NULL,
	[NetXtrandsCount] [int] NULL,
	[NetXtrandsRevenue] [money] NULL,
	[NetSurgeryCount] [int] NULL,
	[NetSurgeryRevenue] [money] NULL,
	[NetPRPCount] [int] NULL,
	[NetPRPRevenue] [money] NULL,
	[NetRestorInkCount] [int] NULL,
	[NetRestorInkRevenue] [money] NULL,
	[NetLaserCount] [int] NULL,
	[NetLaserRevenue] [money] NULL,
	[NetNBLaserCount] [int] NULL,
	[NetNBLaserRevenue] [money] NULL,
	[NetPCPLaserCount] [int] NULL,
	[NetPCPLaserRevenue] [money] NULL
) ON [PRIMARY]
GO