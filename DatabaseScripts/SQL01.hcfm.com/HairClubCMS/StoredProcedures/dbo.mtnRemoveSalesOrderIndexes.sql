/*
==============================================================================
PROCEDURE:				mtnRemoveSalesOrderIndexes

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 7/3/13

LAST REVISION DATE: 	 7/3/13

==============================================================================
DESCRIPTION:	Removes Indexes from datSalesOrder and datSalesOrderDetail Tables before Import
==============================================================================
NOTES:
		* 07/03/13 MLM - Created Stored Proc
		* 07/12/13 MT  - Modified to no longer drop CV_datSalesOrder_CenterID_TicketNumberTemp_ClientGuid index and
							IX_datSalesOrder_CenterIDSOTypeOrderDate index.
		* 07/22/13 MT  - Added [IX_datSalesOrder_CMGuid_SOGuid_SOTypeID_EmpGuid_InvoiceNumber_OrderDate_CreateUser_CenterID]
							 index to script
==============================================================================
SAMPLE EXECUTION:
EXEC mtnRemoveSalesOrderIndexes
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnRemoveSalesOrderIndexes]
AS
BEGIN


		--IF EXISTS(Select * from sysindexes Where [name] = N'CV_datSalesOrder_CenterID_TicketNumberTemp_ClientGuid')
		--BEGIN
		--	DROP INDEX [CV_datSalesOrder_CenterID_TicketNumberTemp_ClientGuid] ON [dbo].[datSalesOrder]
		--END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_AppointmentGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_AppointmentGUID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CenterDeclineBatchGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_CenterDeclineBatchGUID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CenterFeeBatchGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_CenterFeeBatchGUID] ON [dbo].[datSalesOrder]
		END

		--IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CenterIDSOTypeOrderDate')
		--BEGIN
		--	DROP INDEX [IX_datSalesOrder_CenterIDSOTypeOrderDate] ON [dbo].[datSalesOrder]
		--END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_ClientGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_ClientGUID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_ClientGUID_SalesOrderGUID_OrderDate')
		BEGIN
			DROP INDEX [IX_datSalesOrder_ClientGUID_SalesOrderGUID_OrderDate] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_ClientMembershipGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_ClientMembershipGUID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_EndOfDayGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_EndOfDayGUID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_InvoiceNumber')
		BEGIN
			DROP INDEX [IX_datSalesOrder_InvoiceNumber] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_OrderDateINCLSOGUIDCenterID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_OrderDateINCLSOGUIDCenterID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_RegisterID')
		BEGIN
			DROP INDEX [IX_datSalesOrder_RegisterID] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'RP_datSalesOrder_RefundedSalesOrderGUID_INCLOI')
		BEGIN
			DROP INDEX [RP_datSalesOrder_RefundedSalesOrderGUID_INCLOI] ON [dbo].[datSalesOrder]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrderDetail_SalesCodeID_SalesOrderGUID_SalesOrderDetailGUID')
		BEGIN
			DROP INDEX [IX_datSalesOrderDetail_SalesCodeID_SalesOrderGUID_SalesOrderDetailGUID] ON [dbo].[datSalesOrderDetail]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrderDetail_TransactionNumber_Temp')
		BEGIN
			DROP INDEX [IX_datSalesOrderDetail_TransactionNumber_Temp] ON [dbo].[datSalesOrderDetail]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'RP_datSalesOrderTender_SalesOrderGUID_INCLTACCACF')
		BEGIN
			DROP INDEX [RP_datSalesOrderTender_SalesOrderGUID_INCLTACCACF] ON [dbo].[datSalesOrderTender]
		END

		IF EXISTS(Select * from sysindexes Where [name] = N'RP_datSalesOrdeDetail_SalesOrderGUID')
		BEGIN
			DROP INDEX [RP_datSalesOrdeDetail_SalesOrderGUID] ON [dbo].[datSalesOrderDetail]
		END


		--IF EXISTS(Select * from sysindexes Where [name] = N'IX_datSalesOrder_CMGuid_SOGuid_SOTypeID_EmpGuid_InvoiceNumber_OrderDate_CreateUser_CenterID')
		--BEGIN
		--	DROP INDEX [IX_datSalesOrder_CMGuid_SOGuid_SOTypeID_EmpGuid_InvoiceNumber_OrderDate_CreateUser_CenterID] ON [dbo].[datSalesOrder]
		--END
END
