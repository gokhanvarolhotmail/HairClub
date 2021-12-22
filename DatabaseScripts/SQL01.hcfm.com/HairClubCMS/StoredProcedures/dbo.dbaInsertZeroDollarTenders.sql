/***********************************************************************

PROCEDURE:				dbaInsertZeroDollarTenders

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Joe Enders

IMPLEMENTOR: 			Joe Enders

DATE IMPLEMENTED: 		 12/13/2012

/LAST REVISION DATE: 	 12/13/2012

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used to add a default tender record to all valid closed sales orders
		* 12/13/2012 JGE - Created stored proc
		* 5/30/13 MVT - Modified so that "Membership" tender type is used for Membership Order

--------------------------------------------------------------------------------------------------------

***********************************************************************/
CREATE PROCEDURE [dbo].[dbaInsertZeroDollarTenders] AS

BEGIN

	SET NOCOUNT ON

	DECLARE @MOTenderTypeID int, @SOTenderTypeID int

	SELECT @MOTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'
	SELECT @SOTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'NC'


		INSERT INTO [datSalesOrderTender]
				   ([SalesOrderTenderGUID]
				   ,[SalesOrderGUID]
				   ,[TenderTypeID]
				   ,[Amount]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
			SELECT
					NEWID() as 'SalesOrderTenderGUID'
				,	so.SalesOrderGuid as 'SalesOrderGUID'
				,   @MOTenderTypeID as 'TenderTypeID'
				,	0 as 'Amount'
				,	GETUTCDATE()
				,	'sa-ZeroTender'
				,	GETUTCDATE()
				,	'sa-ZeroTender'

			FROM datSalesOrder so
				INNER JOIN lkpSalesOrderType st ON st.SalesOrderTypeID = so.SalesOrderTypeID
				LEFT OUTER JOIN datSalesOrderTender sot
					on so.SalesOrderGuid = sot.SalesOrderGuid
			where st.SalesOrderTypeDescriptionShort = 'MO' AND so.IsClosedFlag = 1 AND sot.SalesOrderGuid is NULL
			group by so.SalesOrderGuid

		INSERT INTO [datSalesOrderTender]
				   ([SalesOrderTenderGUID]
				   ,[SalesOrderGUID]
				   ,[TenderTypeID]
				   ,[Amount]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
			SELECT
					NEWID() as 'SalesOrderTenderGUID'
				,	so.SalesOrderGuid as 'SalesOrderGUID'
				,   @SOTenderTypeID as 'TenderTypeID'
				,	0 as 'Amount'
				,	GETUTCDATE()
				,	'sa-ZeroTender'
				,	GETUTCDATE()
				,	'sa-ZeroTender'

			FROM datSalesOrder so
				INNER JOIN lkpSalesOrderType st ON st.SalesOrderTypeID = so.SalesOrderTypeID
				LEFT OUTER JOIN datSalesOrderTender sot
					on so.SalesOrderGuid = sot.SalesOrderGuid
			where st.SalesOrderTypeDescriptionShort = 'SO' AND so.IsClosedFlag = 1 AND sot.SalesOrderGuid is NULL
			group by so.SalesOrderGuid

END
