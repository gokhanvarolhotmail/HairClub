/* CreateDate: 03/29/2013 13:48:50.377 , ModifyDate: 03/25/2021 10:02:49.243 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSOrderDenormalizationUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		10/24/2012

LAST REVISION DATE: 	02/04/2013

==============================================================================
DESCRIPTION:	Update Order (Sales Order Denormalized) table
==============================================================================
NOTES:
		* 09/11/2012 MVT - Created
		* 11/20/2012 MVT - Updated to fill in Division, Division Description, Department,
							Department Description, and Sales Code Description for a Tender Record.
		* 11/26/2012 MVT - Fixed tender issues.
		* 12/07/2012 MVT - Updated to user Center time zone for order date
		* 12/07/2012 MVT - Added GL and GLName columns
		* 12/09/2012 MVT - Added logic to record Tender Identifier.
		* 12/16/2012 MVT - Added Sales Order Type
		* 12/20/2012 MVT - Modified to only insert orders that started 10 min prior to this proc running.
							This is done so that orders are imported as a whole with all detail and tender
							records.
		* 01/15/2013 KRM - Modified GL derivation to be based on Business Segment
		* 01/15/2013 MVT - Added logic to distinguish between FO and SO tenders.  Added 998* Departments for FO's.
							Added CC Type to Sales Code Description field for Tender.
		* 01/18/2013 MVT - Fixed issue with GL join.
		* 02/04/2013 MVT - Added Finance Company name to the Finance tender types
		* 03/29/2013 MVT - Moved proc from SQL01 HairClubCMS DB to SQL05. Changed Name from dbaOrderDenormalizationUpdate.
		* 04/02/2013 MVT - Modified so that the order record related to the SO is updated each time the SO, SO Detail, or SO Tender are modified.
		* 01/09/2014 MVT - Added another check to try and prevent duplicate tenders.
		* 02/05/2014 MB  - Replaced initial 2 queries with optimized version and indexes to gain effeciency
		* 04/24/2014 MVT - Added Siebel ID column
		* 04/28/2014 MVT - Modified script to update Siebel ID column
		* 05/28/2014 MVT - Added BosleyProcedureOffice, BosleyConsultOffice, and CreditCardLast4Digits columns
		* 05/30/2014 MVT - Added SalesCodeSerialNumber column
		* 01/07/2015 KRM - Added in new GL derivation for XtrandsMem
		* 03/23/2015 DSL - Added join to lkpGeneralLedger table for Xtrands Business Segment & changed SELECT statement to use that table for the GL ID
		* 02/16/2016 DSL - Added join to datHairSystemOrder table for new HairSystemOrderNumber column
		* 02/16/2016 DSL - Added logic to determine Gender value for new column in dbaOrder table
		* 08/31/2016 MVT - TFS #7799 - Added logic to Update "Tax1" and "Tax2" columns.
		* 03/02/2017 MVT - Improved performance by restructuring the inserts into the @UpdateOrders table to only
							orders that need to be updates ++ Modified the Updates to start with @UpdateOrders temp
							table and joining to dbaOrders, instead of vice versa.  This limits the starting set of
							data to only needed updates. ++ Determined the MinCreateDate ahead of time instead of doing
							DateDiff in the Where clause of the Insert Select statement.
		* 06/04/2018 DSL - Updated logic to use CenterNumber instead of CenterID
		* 03/25/2021 KRM - Updated logic to handle new Tender Type - FinanceAR
		* 03/25/2021 KRM - Added ApprovalCode
==============================================================================
SAMPLE EXECUTION:
EXEC [extHairClubCMSOrderDenormalizationUpdate ]
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSOrderDenormalizationUpdate ]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ProcStartTime As DateTime = GETUTCDATE()

	DECLARE @MinCreateDate AS DateTime = DATEADD(HOUR, -1, @ProcStartTime)

	DECLARE @UpdateOrders TABLE
	(
		SalesOrderGuid uniqueidentifier PRIMARY KEY
	)

	-- detail records that changed
	INSERT INTO @UpdateOrders
	SELECT DISTINCT SO.SalesOrderGUID
	FROM dbo.[dbaOrder] O
		INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail SOD
			ON SOD.SalesOrderDetailGuid = O.SalesOrderDetailGuid
		INNER JOIN [HairClubCMS].dbo.datSalesOrder SO
			ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	WHERE SOD.LastUpdate > O.RecordLastUpdate
		OR SO.LastUpdate > O.SalesOrderLastUpdate


	-- tender records that changed
	INSERT INTO @UpdateOrders
	SELECT DISTINCT SOT.SalesOrderGUID
	FROM [dbaOrder] O
		INNER JOIN  [HairClubCMS].dbo.datSalesOrderTender SOT
			ON SOT.SalesOrderTenderGuid = O.SalesOrderTenderGuid
		LEFT OUTER JOIN @UpdateOrders UO
			ON SOT.SalesOrderGuid = UO.SalesOrderGUID
	WHERE SOT.LastUpdate > O.RecordLastUpdate
		AND uo.SalesOrderGuid IS NULL


	-- Update Detail record if SO or Detail record were updated
	UPDATE ord SET
		ord.[SalesOrderInvoiceNumber] = so.InvoiceNumber
		,ord.[SalesOrderlineID] = so.InvoiceNumber + '-' + CAST(sod.EntrySortOrder AS nvarchar(4))
		,ord.ReferenceSalesOrderInvoiceNumber = rso.InvoiceNumber
		,ord.[SalesOrderType] = ISNULL(ot.SalesOrderTypeDescription, 'Not Defined')
		,ord.[TransactionCenterID] = cent.CenterNumber
		,ord.[TransactionCenterName] = cent.CenterDescription
		,ord.[ClientHomeCenterID] = hcent.CenterNumber
		,ord.[ClientHomeCenterName] = hcent.CenterDescription
		,ord.[OrderDate] = DATEADD(Hour,
							CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
								THEN ( tz.[UTCOffset] )
							WHEN DATEPART(WK, so.OrderDate) <= 10
											OR DATEPART(WK, so.OrderDate) >= 45
								THEN ( tz.[UTCOffset] )
							ELSE ( ( tz.[UTCOffset] ) + 1 ) END, so.OrderDate)
		,ord.[IsOrderInBalance] = CASE WHEN
										ABS((SELECT ISNULL(SUM(ISNULL(sod.PriceTaxCalc,0)),0)
											FROM [HairClubCMS].dbo.datSalesOrderDetail sod
											WHERE sod.SalesOrderGUID = ord.SalesOrderGuid) -
												(SELECT ISNULL(SUM(ISNULL(sot.Amount,0)),0)
											FROM [HairClubCMS].dbo.datSalesOrderTender sot
											WHERE sot.SalesOrderGUID = ord.SalesOrderGuid)) > 0.01
										THEN 0 ELSE 1 END
		,ord.[IsOrderVoided] = so.IsVoidedFlag
		,ord.[IsOrderClosed] = so.IsClosedFlag
		,ord.[ClientIdentifier] = c.ClientIdentifier
		,ord.[LastName] = c.LastName
		,ord.[FirstName] = c.FirstName
		,ord.[MembershipID] = m.MembershipID
		,ord.[MembershipDescription] = m.[MembershipDescription]
		,ord.[BusinessSegment] = bs.BusinessSegmentDescription
		,ord.[ClientMembershipIdentifier] = cm.ClientMembershipIdentifier
		,ord.[GL] = CASE
						WHEN m.BusinessSegmentID = 2 then glext.GeneralLedgerDescriptionShort
						WHEN m.BusinessSegmentID = 3 then glsur.GeneralLedgerDescriptionShort
						WHEN m.BusinessSegmentID = 6 then glxtr.GeneralLedgerDescriptionShort
						ELSE glbio.GeneralLedgerDescriptionShort
						END
		,ord.[GLName] =  CASE
						WHEN m.BusinessSegmentID = 2 then glext.GeneralLedgerDescription
						WHEN m.BusinessSegmentID = 3 then glsur.GeneralLedgerDescription
						WHEN m.BusinessSegmentID = 6 then glxtr.GeneralLedgerDescription
						ELSE glbio.GeneralLedgerDescription
						END
		,ord.[Division] = div.SalesCodeDivisionID
		,ord.[DivisionDescription] = div.SalesCodeDivisionDescription
		,ord.[Department] = dep.SalesCodeDepartmentID
		,ord.[DepartmentDescription] = dep.SalesCodeDepartmentDescription
		,ord.[Code] = sc.SalesCodeDescriptionShort
		,ord.[SalesCodeDescription] = sc.SalesCodeDescription
		,ord.[SalesCodeId] = sc.SalesCodeId
		,ord.[UnitPrice] = ROUND(ISNULL(sod.Price, 0), 2)
		,ord.[Quantity] = ISNULL(sod.Quantity, 0)
		,ord.[QuantityPrice] = ROUND(ISNULL(sod.Price * sod.Quantity, 0), 2)
		,ord.[Discount] = ROUND(ISNULL(sod.Discount, 0), 2)
		,ord.[NetPrice] = ROUND(ISNULL(sod.ExtendedPriceCalc, 0), 2)
		,ord.[Tax1] = ROUND(ISNULL(sod.[Tax1], 0), 2)
		,ord.[Tax2] = ROUND(ISNULL(sod.[Tax2], 0), 2)
		,ord.[Price] = ROUND(ISNULL(sod.[PriceTaxCalc], 0), 2)
		,ord.[RecordLastUpdate] = sod.LastUpdate
		,ord.[SalesOrderLastUpdate] = so.LastUpdate
		,ord.[SalesOrderGuid] = so.SalesOrderGuid
		,ord.[ReferenceSalesOrderGuid] = so.RefundedSalesOrderGUID
		,ord.[SalesOrderDetailGuid] = sod.SalesOrderDetailGUID
		,ord.[LastUpdate] = GETUTCDATE()
		,ord.[LastUpdateUser] = 'DenormSD-Update'
		,ord.[DepositNumber] = ed.DepositNumber
		,ord.[SiebelID] = c.SiebelID
		,ord.[BosleyProcedureOffice] = c.[BosleyProcedureOffice]
		,ord.[BosleyConsultOffice] = c.[BosleyConsultOffice]
		,ord.[SalesCodeSerialNumber] = sod.SalesCodeSerialNumber
		,ord.Gender = CASE WHEN ISNULL(c.GenderID, 1) = 1 THEN 'Male' ELSE 'Female' END
		,ord.HairSystemOrderNumber = ISNULL(LTRIM(RTRIM(hso.HairSystemOrderNumber)), '')
	FROM @UpdateOrders uo
		INNER JOIN dbaOrder ord ON uo.SalesOrderGuid = ord.SalesOrderGuid
		INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON sod.SalesOrderDetailGuid = ord.SalesOrderDetailGuid AND sod.SalesOrderGuid = ord.SalesOrderGUID
		INNER JOIN [HairClubCMS].dbo.datSalesOrder so with (nolock) ON sod.SalesOrderGuid = so.SalesOrderGuid
		LEFT JOIN [HairClubCMS].dbo.datSalesOrder rso with (nolock) ON so.RefundedSalesOrderGuid = rso.SalesOrderGuid
		INNER JOIN [HairClubCMS].dbo.cfgCenter cent with (nolock) ON cent.CenterId = so.CenterId
		INNER JOIN [HairClubCMS].dbo.lkpTimeZone tz with (nolock) ON cent.TimeZoneID = tz.TimeZoneID
		LEFT JOIN [HairClubCMS].dbo.cfgCenter hcent with (nolock) ON hcent.CenterId = so.ClientHomeCenterID
		INNER JOIN [HairClubCMS].dbo.datClient c with (nolock) ON c.ClientGuid = so.ClientGuid
		INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cm.ClientMembershipGuid = so.ClientMembershipGuid
		INNER JOIN [HairClubCMS].dbo.cfgMembership m with (nolock) ON m.MembershipID = cm.MembershipId
		INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs with (nolock) ON bs.BusinessSegmentID =  m.BusinessSegmentID
		INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
		--LEFT JOIN lkpGeneralLedger gl ON sc.GLNumber = gl.GeneralLedgerID
		LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glbio with (nolock) ON sc.BIOGeneralLedgerID = glbio.GeneralLedgerID
		LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glext with (nolock) ON sc.EXTGeneralLedgerID = glext.GeneralLedgerID
		LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glsur with (nolock) ON sc.SURGeneralLedgerID = glsur.GeneralLedgerID
		LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glxtr with (nolock) ON sc.XTRGeneralLedgerID = glxtr.GeneralLedgerID
		INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment dep with (nolock) ON dep.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = dep.SalesCodeDivisionID
		LEFT JOIN [HairClubCMS].dbo.lkpSalesOrderType ot with (nolock) ON ot.SalesOrderTypeId = so.SalesOrderTypeId
		LEFT JOIN [HairClubCMS].dbo.datEndOfDay ed with (nolock) ON ed.EndOfDayGUID = so.EndOfDayGUID
		LEFT JOIN [HairClubCMS].dbo.datHairSystemOrder hso ON hso.HairSystemOrderGUID = sod.HairSystemOrderGUID
	--WHERE so.LastUpdate > ord.SalesOrderLastUpdate OR uo.SalesOrderGuid IS NOT NULL


	-- Update Tender record if SO or Tender record were updated
	UPDATE ord SET
		ord.[SalesOrderInvoiceNumber] = so.InvoiceNumber
		,ord.[SalesOrderType] = ISNULL(ot.SalesOrderTypeDescription, 'Not Defined')
		,ord.[SalesOrderlineID] = so.InvoiceNumber + '-T' + CAST(sot.EntrySortOrder AS nvarchar(4))
		,ord.[ReferenceSalesOrderInvoiceNumber] = rso.InvoiceNumber
		,ord.[TransactionCenterID] = cent.CenterNumber
		,ord.[TransactionCenterName] = cent.CenterDescription
		,ord.[ClientHomeCenterID] = hcent.CenterNumber
		,ord.[ClientHomeCenterName] = hcent.CenterDescription
		,ord.[OrderDate] = DATEADD(Hour,
							CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
								THEN ( tz.[UTCOffset] )
							WHEN DATEPART(WK, so.OrderDate) <= 10
											OR DATEPART(WK, so.OrderDate) >= 45
								THEN ( tz.[UTCOffset] )
							ELSE ( ( tz.[UTCOffset] ) + 1 ) END, so.OrderDate)
		,ord.[IsOrderInBalance] = CASE WHEN
										ABS((SELECT ISNULL(SUM(ISNULL(sod.PriceTaxCalc,0)),0)
											FROM [HairClubCMS].dbo.datSalesOrderDetail sod
											WHERE sod.SalesOrderGUID = ord.SalesOrderGuid) -
												(SELECT ISNULL(SUM(ISNULL(sot.Amount,0)),0)
											FROM [HairClubCMS].dbo.datSalesOrderTender sot
											WHERE sot.SalesOrderGUID = ord.SalesOrderGuid)) > 0.01
										THEN 0 ELSE 1 END
		,ord.[IsOrderVoided] = so.IsVoidedFlag
		,ord.[IsOrderClosed] = so.IsClosedFlag
		,ord.[ClientIdentifier] = c.ClientIdentifier
		,ord.[LastName] = c.LastName
		,ord.[FirstName] = c.FirstName
		,ord.[MembershipID] = m.MembershipID
		,ord.[MembershipDescription] = m.[MembershipDescription]
		,ord.[BusinessSegment] = bs.BusinessSegmentDescription
		,ord.[ClientMembershipIdentifier] = cm.ClientMembershipIdentifier
		,ord.Division = 99
		,ord.DivisionDescription = 'Tender'
		,ord.Department = CASE WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9980
								WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9981
								WHEN tt.TenderTypeDescriptionShort = 'Cash' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9982
								WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9983
								WHEN tt.TenderTypeDescriptionShort = 'InterCo' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9984
								WHEN tt.TenderTypeDescriptionShort = 'AR' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9985
								WHEN tt.TenderTypeDescriptionShort = 'CC' THEN 9990
								WHEN tt.TenderTypeDescriptionShort = 'Check' THEN 9991
								WHEN tt.TenderTypeDescriptionShort = 'Cash' THEN 9992
								WHEN tt.TenderTypeDescriptionShort = 'Finance' THEN 9993
								WHEN tt.TenderTypeDescriptionShort = 'InterCo' THEN 9994
								WHEN tt.TenderTypeDescriptionShort = 'AR' THEN 9995
								WHEN tt.TenderTypeDescriptionShort = 'FinanceAR' THEN 9996
							ELSE 9999 END
		,ord.DepartmentDescription = CASE WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Credit Card - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'ACH'
											WHEN tt.TenderTypeDescriptionShort = 'Cash' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Cash - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Finance - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'InterCo' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Inter Company - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'AR' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'AR - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'CC' THEN 'Credit Card'
											WHEN tt.TenderTypeDescriptionShort = 'Check' THEN 'Check'
											WHEN tt.TenderTypeDescriptionShort = 'Cash' THEN 'Cash'
											WHEN tt.TenderTypeDescriptionShort = 'Finance' THEN 'Finance'
											WHEN tt.TenderTypeDescriptionShort = 'FinanceAR' THEN 'FinanceAR'
											WHEN tt.TenderTypeDescriptionShort = 'InterCo' THEN 'Inter Company'
											WHEN tt.TenderTypeDescriptionShort = 'AR' THEN 'AR'
										ELSE 'Unknown' END
		,ord.[Code] = CASE WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'ACH'
											WHEN ot.SalesOrderTypeDescriptionShort = 'FO' THEN tt.TenderTypeDescriptionShort + ' - EFT'
										ELSE tt.TenderTypeDescriptionShort END
		,ord.SalesCodeDescription = CASE WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' AND cct.CreditCardTypeDescription IS NOT NULL THEN 'Credit Card - EFT (' + cct.CreditCardTypeDescription + ')'
											WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Credit Card - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'ACH'
											WHEN tt.TenderTypeDescriptionShort = 'Cash' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Cash - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' AND fc.FinanceCompanyDescription IS NOT NULL THEN 'Finance - EFT (' + fc.FinanceCompanyDescription + ')'
											WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Finance - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'InterCo' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Inter Company - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'AR' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'AR - EFT'
											WHEN tt.TenderTypeDescriptionShort = 'CC' AND cct.CreditCardTypeDescription IS NOT NULL THEN 'Credit Card (' + cct.CreditCardTypeDescription + ')'
											WHEN tt.TenderTypeDescriptionShort = 'CC' THEN 'Credit Card'
											WHEN tt.TenderTypeDescriptionShort = 'Check' THEN 'Check'
											WHEN tt.TenderTypeDescriptionShort = 'Cash' THEN 'Cash'
											WHEN tt.TenderTypeDescriptionShort = 'Finance' AND fc.FinanceCompanyDescription IS NOT NULL THEN 'Finance (' + fc.FinanceCompanyDescription + ')'
											WHEN tt.TenderTypeDescriptionShort = 'FinanceAR' AND fc.FinanceCompanyDescription IS NOT NULL THEN 'FinanceAR (' + fc.FinanceCompanyDescription + ')'
											WHEN tt.TenderTypeDescriptionShort = 'Finance' THEN 'Finance'
											WHEN tt.TenderTypeDescriptionShort = 'InterCo' THEN 'Inter Company'
											WHEN tt.TenderTypeDescriptionShort = 'AR' THEN 'AR'
										ELSE 'Unknown' END
		,ord.[Tender] = ROUND(sot.Amount, 2)
		,ord.[RecordLastUpdate] = sot.LastUpdate
		,ord.[SalesOrderLastUpdate] = so.LastUpdate
		,ord.[SalesOrderGuid] = so.SalesOrderGuid
		,ord.[ReferenceSalesOrderGuid] = so.[RefundedSalesOrderGUID]
		,ord.[SalesOrderTenderGuid] = sot.SalesOrderTenderGuid
		,ord.[GL] = CASE WHEN so.SalesOrderTypeID = 3 then glfo.GeneralLedgerDescriptionShort
						ELSE glso.GeneralLedgerDescriptionShort end
		,ord.[GLName] = CASE WHEN so.SalesOrderTypeID = 3 then glfo.GeneralLedgerDescription
						ELSE glso.GeneralLedgerDescription end
		,ord.[LastUpdate] = GETUTCDATE()
		,ord.[LastUpdateUser] = 'DenormST-Update'
		,ord.DepositNumber = ed.DepositNumber
		,ord.SiebelID = c.SiebelID
		,ord.[BosleyProcedureOffice] = c.[BosleyProcedureOffice]
		,ord.[BosleyConsultOffice] = c.[BosleyConsultOffice]
		,ord.[CreditCardLast4Digits] = sot.CreditCardLast4Digits
		,ord.[ApprovalCode] = sot.ApprovalCode
	FROM @UpdateOrders uo
		INNER JOIN dbaOrder ord ON uo.SalesOrderGuid = ord.SalesOrderGuid
		INNER JOIN [HairClubCMS].dbo.datSalesOrderTender sot with (nolock) ON sot.SalesOrderTenderGuid = ord.SalesOrderTenderGuid AND sot.SalesOrderGuid = ord.SalesOrderGUID
		INNER JOIN [HairClubCMS].dbo.datSalesOrder so with (nolock) ON sot.SalesOrderGuid = so.SalesOrderGuid
		LEFT JOIN [HairClubCMS].dbo.datSalesOrder rso with (nolock) ON so.RefundedSalesOrderGuid = rso.SalesOrderGuid
		INNER JOIN [HairClubCMS].dbo.cfgCenter cent with (nolock) ON cent.CenterId = so.CenterId
		INNER JOIN [HairClubCMS].dbo.lkpTimeZone tz with (nolock) ON cent.TimeZoneID = tz.TimeZoneID
		LEFT JOIN [HairClubCMS].dbo.cfgCenter hcent with (nolock) ON hcent.CenterId = so.ClientHomeCenterID
		INNER JOIN [HairClubCMS].dbo.datClient c with (nolock) ON c.ClientGuid = so.ClientGuid
		INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cm.ClientMembershipGuid = so.ClientMembershipGuid
		INNER JOIN [HairClubCMS].dbo.cfgMembership m with (nolock) ON m.MembershipID = cm.MembershipId
		INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs with (nolock) ON bs.BusinessSegmentID =  m.BusinessSegmentID
		INNER JOIN [HairClubCMS].dbo.lkpTenderType tt with (nolock) ON tt.TenderTypeID = sot.TenderTypeID
		LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLSO with (nolock) ON tt.GeneralLedgerID = GLSO.GeneralLedgerID
		LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLFO with (nolock) ON tt.EFTGeneralLedgerID = GLFO.GeneralLedgerID
		LEFT JOIN [HairClubCMS].dbo.lkpSalesOrderType ot with (nolock) ON ot.SalesOrderTypeId = so.SalesOrderTypeId
		LEFT JOIN [HairClubCMS].dbo.lkpCreditCardType cct with (nolock) ON cct.CreditCardTypeId = sot.CreditCardTypeID
		LEFT JOIN [HairClubCMS].dbo.lkpFinanceCompany fc with (nolock) ON fc.FinanceCompanyID = sot.FinanceCompanyID
		LEFT JOIN [HairClubCMS].dbo.datEndOfDay ed with (nolock) ON ed.EndOfDayGUID = so.EndOfDayGUID
		--LEFT JOIN @UpdateOrders uo ON uo.SalesOrderGuid = ord.SalesOrderGuid
	--WHERE so.LastUpdate > ord.SalesOrderLastUpdate OR uo.SalesOrderGuid IS NOT NULL


	/************************************************************************/
	/* --																	*/
	/* -- Insert new records												*/
	/* --																	*/
	/************************************************************************/

	-- Insert New Sales Order Detail Records
	INSERT INTO [dbo].[dbaOrder]
			   ([SalesOrderInvoiceNumber]
			   ,[SalesOrderType]
			   ,[SalesOrderlineID]
			   ,[ReferenceSalesOrderInvoiceNumber]
			   ,[TransactionCenterID]
			   ,[TransactionCenterName]
			   ,[ClientHomeCenterID]
			   ,[ClientHomeCenterName]
			   ,[OrderDate]
			   ,[IsOrderInBalance]
			   ,[IsOrderVoided]
			   ,[IsOrderClosed]
			   ,[ClientIdentifier]
			   ,[LastName]
			   ,[FirstName]
			   ,[MembershipID]
			   ,[MembershipDescription]
			   ,[BusinessSegment]
			   ,[ClientMembershipIdentifier]
			   ,[GL]
			   ,[GLName]
			   ,[Division]
			   ,[DivisionDescription]
			   ,[Department]
			   ,[DepartmentDescription]
			   ,[Code]
			   ,[SalesCodeDescription]
			   ,[SalesCodeId]
			   ,[UnitPrice]
			   ,[Quantity]
			   ,[QuantityPrice]
			   ,[Discount]
			   ,[NetPrice]
			   ,[Tax1]
			   ,[Tax2]
			   ,[Price]
			   ,[Tender]
			   ,[DepositNumber]
			   ,[RecordLastUpdate]
			   ,[SalesOrderLastUpdate]
			   ,[SalesOrderGuid]
			   ,[ReferenceSalesOrderGuid]
			   ,[SalesOrderDetailGuid]
			   ,[SalesOrderTenderGuid]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[SiebelID]
			   ,[BosleyProcedureOffice]
			   ,[BosleyConsultOffice]
			   ,[CreditCardLast4Digits]
			   ,[SalesCodeSerialNumber]
			   ,[Gender]
			   ,[HairSystemOrderNumber])
			 SELECT so.InvoiceNumber
					, ISNULL(ot.SalesOrderTypeDescription, 'Not Defined')
					, so.InvoiceNumber + '-' + CAST(sod.EntrySortOrder AS nvarchar(4))
					, rso.InvoiceNumber
					, cent.CenterNumber
					, cent.CenterDescription
					, hcent.CenterNumber
					, hcent.CenterDescription
					, DATEADD(Hour,
							CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
								THEN ( tz.[UTCOffset] )
							WHEN DATEPART(WK, so.OrderDate) <= 10
											OR DATEPART(WK, so.OrderDate) >= 45
								THEN ( tz.[UTCOffset] )
							ELSE ( ( tz.[UTCOffset] ) + 1 ) END, so.OrderDate)
					, CASE WHEN
							ABS((SELECT ISNULL(SUM(ISNULL(sod.PriceTaxCalc,0)),0)
								FROM [HairClubCMS].dbo.datSalesOrderDetail sod
								WHERE sod.SalesOrderGUID = so.SalesOrderGuid) -
									(SELECT ISNULL(SUM(ISNULL(sot.Amount,0)),0)
								FROM [HairClubCMS].dbo.datSalesOrderTender sot
								WHERE sot.SalesOrderGUID = so.SalesOrderGuid)) > 0.01
							THEN 0 ELSE 1 END
					, so.IsVoidedFlag
					, so.IsClosedFlag
					, c.ClientIdentifier
					, c.LastName
					, c.FirstName
					, m.MembershipID
					, m.[MembershipDescription]
					, bs.BusinessSegmentDescription
					, cm.ClientMembershipIdentifier
					, CASE
						WHEN m.BusinessSegmentID = 2 then glext.GeneralLedgerDescriptionShort
						WHEN m.BusinessSegmentID = 3 then glsur.GeneralLedgerDescriptionShort
						WHEN m.BusinessSegmentID = 6 then glxtr.GeneralLedgerDescriptionShort
						ELSE glbio.GeneralLedgerDescriptionShort
						END
					, CASE
						WHEN m.BusinessSegmentID = 2 then glext.GeneralLedgerDescription
						WHEN m.BusinessSegmentID = 3 then glsur.GeneralLedgerDescription
						WHEN m.BusinessSegmentID = 6 then glxtr.GeneralLedgerDescription
						ELSE glbio.GeneralLedgerDescription
						END
					, div.SalesCodeDivisionID
					, div.SalesCodeDivisionDescription
					, dep.SalesCodeDepartmentID
					, dep.SalesCodeDepartmentDescription
					, sc.SalesCodeDescriptionShort
					, sc.SalesCodeDescription
					, sc.SalesCodeId
					, ROUND(ISNULL(sod.Price, 0), 2)
					, ISNULL(sod.Quantity, 0)
					, ROUND(ISNULL(sod.Price * sod.Quantity, 0), 2)
					, ROUND(ISNULL(sod.Discount, 0), 2)
					, ROUND(ISNULL(sod.ExtendedPriceCalc, 0), 2)
					, ROUND(ISNULL(sod.[Tax1], 0), 2)
					, ROUND(ISNULL(sod.[Tax2], 0), 2)
					, ROUND(ISNULL(sod.[PriceTaxCalc], 0), 2)
					, NULL  -- Tender
					, ed.DepositNumber
					, sod.LastUpdate
					, so.LastUpdate
					, so.SalesOrderGuid
					, so.[RefundedSalesOrderGUID]
					, sod.SalesOrderDetailGUID
					, NULL  -- SalesOrderTenderGuid
					, GETUTCDATE()
					, 'DenormSD-Insert'
					, GETUTCDATE()
					, 'DenormSD-Insert'
					,c.SiebelID
					,c.BosleyProcedureOffice
					,c.BosleyConsultOffice
					,NULL
					,sod.SalesCodeSerialNumber
					,CASE WHEN ISNULL(c.GenderID, 1) = 1 THEN 'Male' ELSE 'Female' END
					,ISNULL(LTRIM(RTRIM(hso.HairSystemOrderNumber)), '')
			FROM [HairClubCMS].dbo.datSalesOrder so
				INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON sod.SalesOrderGuid = so.SalesOrderGUID
				LEFT JOIN [HairClubCMS].dbo.datSalesOrder rso with (nolock) ON so.RefundedSalesOrderGuid = rso.SalesOrderGuid
				INNER JOIN [HairClubCMS].dbo.cfgCenter cent with (nolock) ON cent.CenterId = so.CenterId
				INNER JOIN [HairClubCMS].dbo.lkpTimeZone tz with (nolock) ON cent.TimeZoneID = tz.TimeZoneID
				LEFT JOIN [HairClubCMS].dbo.cfgCenter hcent with (nolock) ON hcent.CenterId = so.ClientHomeCenterID
				INNER JOIN [HairClubCMS].dbo.datClient c with (nolock) ON c.ClientGuid = so.ClientGuid
				INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cm.ClientMembershipGuid = so.ClientMembershipGuid
				INNER JOIN [HairClubCMS].dbo.cfgMembership m with (nolock) ON m.MembershipID = cm.MembershipId
				INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs with (nolock) ON bs.BusinessSegmentID =  m.BusinessSegmentID
				INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
				LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger gl ON sc.GLNumber = gl.GeneralLedgerID
				LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glbio WITH (nolock) ON sc.BIOGeneralLedgerID = glbio.GeneralLedgerID
				LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glext with (nolock) ON sc.EXTGeneralLedgerID = glext.GeneralLedgerID
				LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glsur with (nolock) ON sc.SURGeneralLedgerID = glsur.GeneralLedgerID
				LEFT JOIN [HairClubCMS].dbo.lkpGeneralLedger glxtr with (nolock) ON sc.XTRGeneralLedgerID = glxtr.GeneralLedgerID
				INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment dep with (nolock) ON dep.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
				INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = dep.SalesCodeDivisionID
				LEFT OUTER JOIN dbaOrder ord with (nolock) ON ord.SalesOrderGuid = so.SalesOrderGuid AND ord.SalesOrderDetailGuid = sod.SalesOrderDetailGuid
				LEFT JOIN [HairClubCMS].dbo.lkpSalesOrderType ot with (nolock) ON ot.SalesOrderTypeId = so.SalesOrderTypeId
				LEFT JOIN [HairClubCMS].dbo.datEndOfDay ed with (nolock) ON ed.EndOfDayGUID = so.EndOfDayGUID
				LEFT JOIN [HairClubCMS].dbo.datHairSystemOrder hso ON hso.HairSystemOrderGUID = sod.HairSystemOrderGUID
			WHERE ord.SalesOrderGuid IS NULL
				AND so.CreateDate < @MinCreateDate
			--	AND DATEDIFF ( minute , so.CreateDate , @ProcStartTime ) > 10
			--ORDER BY so.CreateDate desc, so.InvoiceNumber, sod.EntrySortOrder


	-- Insert New Sales Order Tender Records
	INSERT INTO [dbo].[dbaOrder]
			   ([SalesOrderInvoiceNumber]
			   ,[SalesOrderType]
			   ,[SalesOrderlineID]
			   ,[ReferenceSalesOrderInvoiceNumber]
			   ,[TransactionCenterID]
			   ,[TransactionCenterName]
			   ,[ClientHomeCenterID]
			   ,[ClientHomeCenterName]
			   ,[OrderDate]
			   ,[IsOrderInBalance]
			   ,[IsOrderVoided]
			   ,[IsOrderClosed]
			   ,[ClientIdentifier]
			   ,[LastName]
			   ,[FirstName]
			   ,[MembershipID]
			   ,[MembershipDescription]
			   ,[BusinessSegment]
			   ,[ClientMembershipIdentifier]
			   ,[Division]
			   ,[DivisionDescription]
			   ,[Department]
			   ,[DepartmentDescription]
			   ,[Code]
			   ,[SalesCodeDescription]
			   ,[SalesCodeId]
			   ,[UnitPrice]
			   ,[Quantity]
			   ,[QuantityPrice]
			   ,[Discount]
			   ,[NetPrice]
			   ,[Tax1]
			   ,[Tax2]
			   ,[Price]
			   ,[Tender]
			   ,[DepositNumber]
			   ,[RecordLastUpdate]
			   ,[SalesOrderLastUpdate]
			   ,[SalesOrderGuid]
			   ,[ReferenceSalesOrderGuid]
			   ,[SalesOrderDetailGuid]
			   ,[SalesOrderTenderGuid]
			   ,[GL]
			   ,[GLName]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[SiebelID]
			   ,[BosleyProcedureOffice]
			   ,[BosleyConsultOffice]
			   ,[CreditCardLast4Digits]
			   ,[ApprovalCode])
			 SELECT so.InvoiceNumber
					, ISNULL(ot.SalesOrderTypeDescription, 'Not Defined')
					, so.InvoiceNumber + '-T' + CAST(sot.EntrySortOrder AS nvarchar(4))
					, rso.InvoiceNumber
					, cent.CenterNumber
					, cent.CenterDescription
					, hcent.CenterNumber
					, hcent.CenterDescription
					, DATEADD(Hour,
							CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
								THEN ( tz.[UTCOffset] )
							WHEN DATEPART(WK, so.OrderDate) <= 10
											OR DATEPART(WK, so.OrderDate) >= 45
								THEN ( tz.[UTCOffset] )
							ELSE ( ( tz.[UTCOffset] ) + 1 ) END, so.OrderDate)
					, CASE WHEN
							ABS((SELECT ISNULL(SUM(ISNULL(sod.PriceTaxCalc,0)),0)
								FROM [HairClubCMS].dbo.datSalesOrderDetail sod
								WHERE sod.SalesOrderGUID = so.SalesOrderGuid) -
									(SELECT ISNULL(SUM(ISNULL(sot.Amount,0)),0)
								FROM [HairClubCMS].dbo.datSalesOrderTender sot
								WHERE sot.SalesOrderGUID = so.SalesOrderGuid)) > 0.01
							THEN 0 ELSE 1 END
					, so.IsVoidedFlag
					, so.IsClosedFlag
					, c.ClientIdentifier
					, c.LastName
					, c.FirstName
					, m.MembershipID
					, m.[MembershipDescription]
					, bs.BusinessSegmentDescription
					, cm.ClientMembershipIdentifier
					, 99  -- Division for Tender
					, 'Tender'
					, CASE WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9980
							WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9981
							WHEN tt.TenderTypeDescriptionShort = 'Cash' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9982
							WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9983
							WHEN tt.TenderTypeDescriptionShort = 'InterCo' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9984
							WHEN tt.TenderTypeDescriptionShort = 'AR' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 9985
							WHEN tt.TenderTypeDescriptionShort = 'CC' THEN 9990
							WHEN tt.TenderTypeDescriptionShort = 'Check' THEN 9991
							WHEN tt.TenderTypeDescriptionShort = 'Cash' THEN 9992
							WHEN tt.TenderTypeDescriptionShort = 'Finance' THEN 9993
							WHEN tt.TenderTypeDescriptionShort = 'InterCo' THEN 9994
							WHEN tt.TenderTypeDescriptionShort = 'AR' THEN 9995
							WHEN tt.TenderTypeDescriptionShort = 'FinanceAR' THEN 9996
						ELSE 9999 END --Department
					, CASE WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Credit Card - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'ACH'
							WHEN tt.TenderTypeDescriptionShort = 'Cash' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Cash - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Finance - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'InterCo' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Inter Company - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'AR' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'AR - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'CC' THEN 'Credit Card'
							WHEN tt.TenderTypeDescriptionShort = 'Check' THEN 'Check'
							WHEN tt.TenderTypeDescriptionShort = 'Cash' THEN 'Cash'
							WHEN tt.TenderTypeDescriptionShort = 'Finance' THEN 'Finance'
							WHEN tt.TenderTypeDescriptionShort = 'InterCo' THEN 'Inter Company'
							WHEN tt.TenderTypeDescriptionShort = 'AR' THEN 'AR'
							WHEN tt.TenderTypeDescriptionShort = 'FincanceAR' THEN 'FinanceAR'
						ELSE 'Unknown' END --Department Description
					, CASE WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'ACH'
							WHEN ot.SalesOrderTypeDescriptionShort = 'FO' THEN tt.TenderTypeDescriptionShort + ' - EFT'
						ELSE tt.TenderTypeDescriptionShort END  -- Code
					, CASE WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' AND cct.CreditCardTypeDescription IS NOT NULL THEN 'Credit Card - EFT (' + cct.CreditCardTypeDescription + ')'
							WHEN tt.TenderTypeDescriptionShort = 'CC' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Credit Card - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'Check' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'ACH'
							WHEN tt.TenderTypeDescriptionShort = 'Cash' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Cash - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' AND fc.FinanceCompanyDescription IS NOT NULL THEN 'Finance - EFT (' + fc.FinanceCompanyDescription + ')'
							WHEN tt.TenderTypeDescriptionShort = 'Finance' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Finance - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'InterCo' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'Inter Company - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'AR' AND ot.SalesOrderTypeDescriptionShort = 'FO' THEN 'AR - EFT'
							WHEN tt.TenderTypeDescriptionShort = 'CC' AND cct.CreditCardTypeDescription IS NOT NULL THEN 'Credit Card (' + cct.CreditCardTypeDescription + ')'
							WHEN tt.TenderTypeDescriptionShort = 'CC' THEN 'Credit Card'
							WHEN tt.TenderTypeDescriptionShort = 'Check' THEN 'Check'
							WHEN tt.TenderTypeDescriptionShort = 'Cash' THEN 'Cash'
							WHEN tt.TenderTypeDescriptionShort = 'Finance' AND fc.FinanceCompanyDescription IS NOT NULL THEN 'Finance (' + fc.FinanceCompanyDescription + ')'
							WHEN tt.TenderTypeDescriptionShort = 'FinanceAR' AND fc.FinanceCompanyDescription IS NOT NULL THEN 'FinanceAR (' + fc.FinanceCompanyDescription + ')'
							WHEN tt.TenderTypeDescriptionShort = 'Finance' THEN 'Finance'
							WHEN tt.TenderTypeDescriptionShort = 'InterCo' THEN 'Inter Company'
							WHEN tt.TenderTypeDescriptionShort = 'AR' THEN 'AR'
						ELSE 'Unknown' END  -- Sales Code Description
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
					, ROUND(sot.Amount, 2)
					, ed.DepositNumber
					, sot.LastUpdate
					, so.LastUpdate
					, so.SalesOrderGuid
					, so.[RefundedSalesOrderGUID]
					, NULL  -- SalesOrderDetailGuid
					, sot.SalesOrderTenderGuid
					, CASE WHEN so.SalesOrderTypeID = 3 then glfo.GeneralLedgerDescriptionShort
						ELSE glso.GeneralLedgerDescriptionShort end
					, CASE WHEN so.SalesOrderTypeID = 3 then glfo.GeneralLedgerDescription
						ELSE glso.GeneralLedgerDescription end
					, GETUTCDATE()
					, 'DenormST-Insert'
					, GETUTCDATE()
					, 'DenormST-Insert'
					,c.SiebelID
					,c.BosleyProcedureOffice
					,c.BosleyConsultOffice
					,sot.CreditCardLast4Digits
					,sot.ApprovalCode
			FROM [HairClubCMS].dbo.datSalesOrder so
				INNER JOIN [HairClubCMS].dbo.datSalesOrderTender sot with (nolock) ON sot.SalesOrderGuid = so.SalesOrderGUID
				LEFT JOIN [HairClubCMS].dbo.datSalesOrder rso with (nolock) ON so.RefundedSalesOrderGuid = rso.SalesOrderGuid
				INNER JOIN [HairClubCMS].dbo.cfgCenter cent with (nolock) ON cent.CenterId = so.CenterId
				INNER JOIN [HairClubCMS].dbo.lkpTimeZone tz with (nolock) ON cent.TimeZoneID = tz.TimeZoneID
				LEFT JOIN [HairClubCMS].dbo.cfgCenter hcent with (nolock) ON hcent.CenterId = so.ClientHomeCenterID
				INNER JOIN [HairClubCMS].dbo.datClient c with (nolock) ON c.ClientGuid = so.ClientGuid
				INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cm.ClientMembershipGuid = so.ClientMembershipGuid
				INNER JOIN [HairClubCMS].dbo.cfgMembership m with (nolock) ON m.MembershipID = cm.MembershipId
				INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs with (nolock) ON bs.BusinessSegmentID =  m.BusinessSegmentID
				INNER JOIN [HairClubCMS].dbo.lkpTenderType tt with (nolock) ON tt.TenderTypeID = sot.TenderTypeID
				LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLSO with (nolock) ON tt.GeneralLedgerID = GLSO.GeneralLedgerID
				LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLFO with (nolock) ON tt.EFTGeneralLedgerID = GLFO.GeneralLedgerID
				LEFT OUTER JOIN dbaOrder ord with (nolock) ON ord.SalesOrderGuid = so.SalesOrderGuid AND ord.SalesOrderTenderGuid = sot.SalesOrderTenderGUID
				LEFT JOIN [HairClubCMS].dbo.lkpSalesOrderType ot with (nolock) ON ot.SalesOrderTypeId = so.SalesOrderTypeId
				LEFT JOIN [HairClubCMS].dbo.lkpCreditCardType cct with (nolock) ON cct.CreditCardTypeId = sot.CreditCardTypeID
				LEFT JOIN [HairClubCMS].dbo.lkpFinanceCompany fc with (nolock) ON fc.FinanceCompanyID = sot.FinanceCompanyID
				LEFT JOIN [HairClubCMS].dbo.datEndOfDay ed with (nolock) ON ed.EndOfDayGUID = so.EndOfDayGUID
			WHERE ord.SalesOrderGuid IS NULL
				AND (SELECT COUNT(*) FROM dbaOrder ino WHERE ino.SalesOrderTenderGuid = sot.SalesOrderTenderGUID) = 0
				AND so.CreateDate < @MinCreateDate
				--AND DATEDIFF ( minute , so.CreateDate , @ProcStartTime ) > 10
			--ORDER BY so.CreateDate desc, so.InvoiceNumber



			-- Update Client Data
			UPDATE ord SET
				SiebelID = c.SiebelID,
				BosleyProcedureOffice = c.BosleyProcedureOffice,
				BosleyConsultOffice = c.BosleyConsultOffice,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'Client-Update'
			FROM dbaOrder ord
				INNER JOIN [HairClubCMS].dbo.datClient c ON c.ClientIdentifier = ord.ClientIdentifier
			WHERE (ord.SiebelID IS NULL AND c.SiebelID IS NOT NULL)
				OR (ord.SiebelID IS NOT NULL AND ord.SiebelID <> c.SiebelID)
				OR (ord.BosleyConsultOffice IS NULL AND c.BosleyConsultOffice IS NOT NULL)
				OR (ord.BosleyConsultOffice IS NOT NULL AND ord.BosleyConsultOffice <> c.BosleyConsultOffice)
				OR (ord.BosleyProcedureOffice IS NULL AND c.BosleyProcedureOffice IS NOT NULL)
				OR (ord.BosleyProcedureOffice IS NOT NULL AND ord.BosleyProcedureOffice <> c.BosleyProcedureOffice)

END
GO
