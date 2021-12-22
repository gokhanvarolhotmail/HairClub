/* CreateDate: 02/18/2013 06:45:39.307 , ModifyDate: 02/27/2017 09:49:20.650 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnGetProductHistByClient	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		5/8/2012

LAST REVISION DATE:		5/8/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	5/7/2012	KMurdoch	Initial Creation

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetProductHistByClientCommaSeparated '201','624311EF-580B-4F10-8DC1-5C0F066B0774', '07/1/2008'

	CenterID = Logged in Center
	ClientGUID = From datSalesOrder - ClientGUID
	OrderDate = Use 7/1/08 if speed is not an issue, otherwise, we can use 1 year from getdate()
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetProductHistByClientCommaSeparated] (
	@CenterID int
,	@ClientGUID UniqueIdentifier
,	@OrderDate datetime

) AS
	BEGIN

	SELECT so.SalesOrderGUID,
		MAX(SUBSTRING(dbo.fnGetSalesOrderDetailList(so.SalesOrderGUID),2,1000)) as 'SalesOrderDetail'
	INTO #SODet
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod
			on so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN cfgSalesCode sc
			on sod.SalesCodeID = sc.SalesCodeID
	WHERE so.ClientGUID = @ClientGUID
		and so.SalesOrderTypeID = 1
		and sc.SalesCodeTypeID = 1
	group by so.SalesOrderGUID


	SELECT

			so.InvoiceNumber as 'InvoiceNumber'
		,	so.OrderDate as 'OrderDate'
		,	so.SalesOrderGUID as 'SalesOrderGUID'
		,	so.ClientGUID as 'ClientGUID'
		,	#SODet.SalesOrderDetail as 'SalesOrderDetail'
		--,	sc.SalesCodeDescription as 'ServiceProvided'
		--,	sc.SalesCodeID as 'SalesCodeID'
		--,	sc.SalesCodeSortOrder as 'SalesCodeSortOrder'
		--,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		--,	sc.SalesCodeDescription as 'SalesCodeDescription'
		--,	sod.Quantity as 'Quantity'
		--,	sod.Price as 'Price'
		--,	sod.Discount as 'Discount'
		--,	sc.IsSalesCodeKitFlag as 'IsKitFlag'

	FROM datSalesOrder so
		inner join datSalesorderDetail sod
			on so.SalesOrderGUID = sod.SalesOrderGUID
		inner join #SODet
			on so.SalesOrderGUID = #SODet.SalesOrderGUID
		--inner join datClientMembership clm
		--	on so.ClientMembershipGUID = clm.ClientMembershipGUID
		--inner join cfgSalesCode sc
		--	on sod.SalesCodeID = sc.SalesCodeID
	WHERE
		so.CenterID = @CenterID
		and so.ClientGUID = @clientguid
		and so.OrderDate >= @OrderDate
		and so.IsVoidedFlag = 0 --Only bring back valid orders

	group by
			so.InvoiceNumber
		,	so.OrderDate
		,	so.SalesOrderGUID
		,	so.ClientGUID
		,	#SODet.SalesOrderDetail
	order by so.OrderDate
END
GO
