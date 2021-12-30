/* CreateDate: 04/20/2012 15:39:10.990 , ModifyDate: 02/27/2017 09:49:20.583 */
GO
/***********************************************************************

PROCEDURE:				mtnGetProductHistByClient	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/20/2012

LAST REVISION DATE:		4/20/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	4/20/2012	KMurdoch	Initial Creation

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetProductHistByClient '201','624311EF-580B-4F10-8DC1-5C0F066B0774', '07/1/2008'

	CenterID = Logged in Center
	ClientGUID = From datSalesOrder - ClientGUID
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetProductHistByClient] (
	@CenterID int
,	@ClientGUID UniqueIdentifier
,	@OrderDate datetime

) AS
	BEGIN


	SET NOCOUNT ON

	SELECT

			so.InvoiceNumber as 'InvoiceNumber'
		,	so.OrderDate as 'OrderDate'
		,	so.AppointmentGUID
		,	sc.SalesCodeDescription as 'ServiceProvided'
		,	sc.SalesCodeID as 'SalesCodeID'
		,	sc.SalesCodeSortOrder as 'SalesCodeSortOrder'
		,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		,	sc.SalesCodeDescription as 'SalesCodeDescription'
		,	sod.Quantity as 'Quantity'
		,	sod.Price as 'Price'
		,	sod.Discount as 'Discount'
		,	sc.IsSalesCodeKitFlag as 'IsKitFlag'
		,	so.ClientGUID as 'ClientGUID'
		,	so.SalesOrderGUID as 'SalesOrderGUID'
	FROM datSalesOrder so
		inner join datSalesorderDetail sod
			on so.SalesOrderGUID = sod.SalesOrderGUID
		inner join datClientMembership clm
			on so.ClientMembershipGUID = clm.ClientMembershipGUID
		inner join cfgSalesCode sc
			on sod.SalesCodeID = sc.SalesCodeID
	WHERE
		so.CenterID = @CenterID
		and so.ClientGUID = @clientguid
		and so.OrderDate >= @OrderDate
		and sc.SalesCodeTypeID = 1 --Products only
		and so.IsVoidedFlag = 0 --Only bring back valid orders
	order by so.OrderDate
END
GO
