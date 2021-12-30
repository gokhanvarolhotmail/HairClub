/* CreateDate: 12/14/2012 09:59:40.860 , ModifyDate: 12/14/2012 10:01:32.127 */
GO
/***********************************************************************

		PROCEDURE:				dbaInsertTxfrInOrderDetail

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Kevin Murdoch

		IMPLEMENTOR: 			Kevin Murdoch

		DATE IMPLEMENTED: 		12/13/2012

		/LAST REVISION DATE: 	 12/13/2012

		--------------------------------------------------------------------------------------------------------
		NOTES:  This script is used to run Inserts for Txfrin for predetermined list of centers
				*10/30/2012 KRM - Created stored proc

		--------------------------------------------------------------------------------------------------------
		SAMPLE EXECUTION:

		EXEC [dbaInsertTxfrInOrderDetail]
		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaInsertTxfrInOrderDetail] AS
		BEGIN

			SET NOCOUNT ON
			--Create table object with ID column
			IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
			BEGIN
				DROP TABLE #Centers
			END
			CREATE TABLE #Centers(
				ID INT IDENTITY(1,1)
			,	Center INT
			)

			--Declare variables
			DECLARE @Count INT
			,	@Total INT
			,	@SQL VARCHAR(100)
			,	@CurrentCenter INT


            --Populate temp table with all centers
            INSERT INTO #Centers (Center)
            SELECT center_num
            FROM [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter]
            --
            -- RUN ALL CENTER INCLUDING 100 AND 279
            --
            WHERE ([Type] in ('c','j','f')
                AND [Inactive]=0
                --AND [Center_num] IN (206,207,208,209))
				--AND[Center_num] not IN (205,292,242,270,281,240,260,255)
				AND [Center_Num] like '[278]%' )
			--AND [CMS42ConversionComplete] = 1 ) or 	([Center_Num] = 100)


			--Set counter and total centers variables
			SET @Count = 1
			SELECT @Total = MAX(ID)
			FROM #Centers

			--Loop through each center and execute the dynamic SQL for each center
			WHILE @Count <= @Total
			BEGIN
				SELECT @CurrentCenter = Center
				FROM #Centers
				WHERE ID = @Count


		INSERT INTO [HairClubCMS].dbo.datSalesOrderDetail (
				[SalesOrderDetailGUID]
			,	[TransactionNumber_Temp]
			,	[SalesOrderGUID]
			,	[SalesCodeID]
			,	[Quantity]
			,	[Price]
			,	[Discount]
			,	[Tax1]
			,	[Tax2]
			,	[TaxRate1]
			,	[TaxRate2]
			,	[IsRefundedFlag]
			,	[RefundedSalesOrderDetailGUID]
			,	[RefundedTotalQuantity]
			,	[RefundedTotalPrice]
			,	[Employee1GUID]
			,	[Employee2GUID]
			,	[Employee3GUID]
			,	[Employee4GUID]
			,	[PreviousClientMembershipGUID]
			,   [Center_Temp]
			,	[Performer_Temp]
			,	[Performer2_Temp]
			,	[CreateDate]
			,	[CreateUser]
			,	[LastUpdate]
			,	[LastUpdateUser]
			,	[Member1Price_Temp]
			,	[CancelReasonID] )


			SELECT
				NEWID() AS [SalesOrderDetailGUID]
			,	t.transact_no AS [TransactionNumber_Temp]
			,	so.SalesOrderGUID AS [SalesOrderGUID]
			,	sc.SalesCodeID AS [SalesCodeID]
			,	ISNULL(t.Qty, 0) AS [Quantity]
			,	ISNULL(ABS(t.Member1_price), 0) AS [Price]
			,	ISNULL(t.Discount, 0) AS [Discount]
			,	ISNULL(t.Tax_1, 0) + ISNULL(t.Tax_2, 0) AS [Tax1]
			,	0 AS [Tax2]
			,	0 as [TaxRate1]
			--,	CASE
			--		WHEN t.Tax_1 > 0 OR t.Tax_2 > 0 THEN (ISNULL(t.Tax_1, 0) + ISNULL(t.Tax_2, 0)) / ((t.Qty * t.Price) - t.Discount)
			--
			,	0 AS [TaxRate2] -- ??
			,	t.IsRefund
			,	NULL AS [RefundedSalesOrderDetailGUID] -- ??
			,	0 AS [RefundedTotalQuantity] -- ??
			,	0 AS [RefundedTotalPrice] -- ??
			,	emp1.EmployeeGUID AS [Employee1GUID]
			,	emp2.EmployeeGUID AS [Employee2GUID]
			,	NULL AS [Employee3GUID]
			,	NULL AS [Employee4GUID]
			,	prevcm.ClientMembershipGUID as PreviousClientMembershipGUID
			,   t.Center as 'Center_Temp'
			,	t.Performer as 'Performer_Temp'
			,	t.Performer2 as 'Performer2_Temp'
			,	infostoreconv.dbo.[fn_GetUTCDateTime](t.[CMSCreateDate],t.[Center])  AS CreateDate
			,	so.cashier_temp AS CreateUser
			,	GETUTCDATE()  AS LastUpdate
			,	so.cashier_temp AS LastUpdateUser
			,	t.Member1_Price
			,	t.CancelReasonID
			FROM [HCSQL2\SQL2005].INFOSTORE.dbo.transactions t
				INNER JOIN INFOSTORECONV.dbo.CMSCONVsales_code sc
					on t.Code = sc.Code
				INNER JOIN [HairClubCMS].dbo.datSalesOrder so
					ON t.ticket_no = so.TicketNumber_Temp
					AND t.Center = so.CenterID
				inner join [HairClubCMS].dbo.datClient cl
					on t.client_no = cl.ClientNumber_Temp
				INNER JOIN [HairClubCMS].dbo.datClientMembership prevcm
					on t.Member1_ID = prevcm.Member1_ID_Temp
						and prevcm.ClientGUID = cl.ClientGUID
						and prevcm.CenterID = @CurrentCenter
				INNER JOIN [HairClubCMS].dbo.cfgMembership mem
					on prevcm.MembershipID = mem.MembershipID
				LEFT OUTER JOIN INFOSTORECONV.dbo.Employee emp1 --consultant
					ON t.Performer = emp1.code
					AND t.center = emp1.Center
				LEFT OUTER JOIN INFOSTORECONV.dbo.Employee emp2 --stylist
					ON t.Performer2 = emp2.code
					AND t.center = emp2.Center
				LEFT OUTER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod
					ON so.salesorderguid = sod.salesorderguid
			Where so.CenterID = @CurrentCenter
				--and t.[transact_no] > @LastTrxNo
				--AND
				and so.SalesOrderTypeID = 2 -- Membership orders
				AND t.Code =  'txfrin'
				AND t.Department IN (30)
				and SOD.Salesorderdetailguid is null
				print @currentcenter

				SET @Count = @Count + 1
			END
		END
GO
