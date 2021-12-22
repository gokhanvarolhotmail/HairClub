/* CreateDate: 07/03/2013 16:15:21.130 , ModifyDate: 07/29/2013 11:53:38.273 */
GO
/*
==============================================================================
PROCEDURE:				[mtnAddSalesOrderIndexes]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 7/3/13

LAST REVISION DATE: 	 7/3/13

==============================================================================
DESCRIPTION:	Adds Indexes from datSalesOrder and datSalesOrderDetail Tables before Import
==============================================================================
NOTES:
		* 07/03/13 MLM - Created Stored Proc
		* 07/22/13 MT  - Added [IX_datSalesOrder_CMGuid_SOGuid_SOTypeID_EmpGuid_InvoiceNumber_OrderDate_CreateUser_CenterID]
							index to script
==============================================================================
SAMPLE EXECUTION:
EXEC [mtnAddSalesOrderIndexes]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnAddSalesOrderIndexes]
AS
BEGIN


		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrderDetail_TransactionNumber_Temp')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrderDetail_TransactionNumber_Temp] ON [dbo].[datSalesOrderDetail]
			(
				[Center_Temp] ASC,
				[TransactionNumber_Temp] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrderDetail_SalesCodeID_SalesOrderGUID_SalesOrderDetailGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrderDetail_SalesCodeID_SalesOrderGUID_SalesOrderDetailGUID] ON [dbo].[datSalesOrderDetail]
			(
				[SalesCodeID] ASC,
				[SalesOrderGUID] ASC,
				[SalesOrderDetailGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'RP_datSalesOrder_RefundedSalesOrderGUID_INCLOI')
		BEGIN
			CREATE NONCLUSTERED INDEX [RP_datSalesOrder_RefundedSalesOrderGUID_INCLOI] ON [dbo].[datSalesOrder]
			(
				[RefundedSalesOrderGUID] ASC
			)
			INCLUDE ( 	[OrderDate],
				[InvoiceNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_RegisterID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_RegisterID] ON [dbo].[datSalesOrder]
			(
				[RegisterID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_OrderDateINCLSOGUIDCenterID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_OrderDateINCLSOGUIDCenterID] ON [dbo].[datSalesOrder]
			(
				[OrderDate] ASC
			)
			INCLUDE ( 	[SalesOrderGUID],
				[CenterID],
				[SalesOrderTypeID],
				[ClientGUID],
				[ClientMembershipGUID],
				[IsVoidedFlag],
				[IsClosedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_InvoiceNumber')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_InvoiceNumber] ON [dbo].[datSalesOrder]
			(
				[InvoiceNumber] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_EndOfDayGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_EndOfDayGUID] ON [dbo].[datSalesOrder]
			(
				[EndOfDayGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_ClientMembershipGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientMembershipGUID] ON [dbo].[datSalesOrder]
			(
				[ClientMembershipGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_ClientGUID_SalesOrderGUID_OrderDate')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientGUID_SalesOrderGUID_OrderDate] ON [dbo].[datSalesOrder]
			(
				[ClientGUID] ASC,
				[SalesOrderGUID] ASC,
				[OrderDate] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_ClientGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientGUID] ON [dbo].[datSalesOrder]
			(
				[ClientGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CenterIDSOTypeOrderDate')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CenterIDSOTypeOrderDate] ON [dbo].[datSalesOrder]
			(
				[CenterID] ASC,
				[SalesOrderTypeID] ASC,
				[OrderDate] ASC
			)
			INCLUDE ( 	[SalesOrderGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CenterFeeBatchGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CenterFeeBatchGUID] ON [dbo].[datSalesOrder]
			(
				[CenterFeeBatchGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CenterDeclineBatchGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CenterDeclineBatchGUID] ON [dbo].[datSalesOrder]
			(
				[CenterDeclineBatchGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_AppointmentGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_datSalesOrder_AppointmentGUID] ON [dbo].[datSalesOrder]
			(
				[AppointmentGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'CV_datSalesOrder_CenterID_TicketNumberTemp_ClientGuid')
		BEGIN
			CREATE NONCLUSTERED INDEX [CV_datSalesOrder_CenterID_TicketNumberTemp_ClientGuid] ON [dbo].[datSalesOrder]
			(
				[CenterID] ASC,
				[TicketNumber_Temp] DESC,
				[ClientGUID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'RP_datSalesOrderTender_SalesOrderGUID_INCLTACCACF')
		BEGIN
			CREATE NONCLUSTERED INDEX [RP_datSalesOrderTender_SalesOrderGUID_INCLTACCACF] ON [dbo].[datSalesOrderTender]
			(
				[SalesOrderGUID] ASC
			)
			INCLUDE ( 	[TenderTypeID],
				[Amount],
				[CheckNumber],
				[CreditCardLast4Digits],
				[ApprovalCode],
				[CreditCardTypeID],
				[FinanceCompanyID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF NOT EXISTS(Select * from sysindexes Where [name] = N'RP_datSalesOrdeDetail_SalesOrderGUID')
		BEGIN
			CREATE NONCLUSTERED INDEX [RP_datSalesOrdeDetail_SalesOrderGUID] ON [dbo].[datSalesOrderDetail]
			(
				[SalesOrderGUID] ASC
			)
			INCLUDE ( 	[TransactionNumber_Temp],
				[SalesCodeID],
				[Quantity],
				[Price],
				[Discount],
				[Tax1],
				[Tax2],
				[Employee1GUID],
				[ExtendedPriceCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END


		--IF NOT EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CMGuid_SOGuid_SOTypeID_EmpGuid_InvoiceNumber_OrderDate_CreateUser_CenterID')
		--BEGIN
		--	CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CMGuid_SOGuid_SOTypeID_EmpGuid_InvoiceNumber_OrderDate_CreateUser_CenterID] ON [dbo].[datSalesOrder]
		--	(
		--		[ClientMembershipGUID] ASC,
		--		[SalesOrderGUID] ASC,
		--		[SalesOrderTypeID] ASC,
		--		[EmployeeGUID] ASC,
		--		[InvoiceNumber] ASC,
		--		[OrderDate] ASC,
		--		[CreateUser] ASC,
		--		[CenterID] ASC
		--	)
		--	INCLUDE ( 	[IsVoidedFlag]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		--END
END
GO
