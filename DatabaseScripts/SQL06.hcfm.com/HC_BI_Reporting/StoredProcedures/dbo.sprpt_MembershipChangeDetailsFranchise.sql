/***********************************************************************
PROCEDURE:	[sprpt_MembershipChangeDetailsFranchise]
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/29/2012
-- Date Implemented:       8/29/2012
-- Date Last Modified:     8/29/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
-- Change History:
02/03/2015	RH	Added CurrentXtrandsClientMembershipSSID to COALESCE statements.
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC [sprpt_MembershipChangeDetailsFranchise] 746, 12, 2012
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_MembershipChangeDetailsFranchise] (
	@Center INT
,	@Month VARCHAR(5)
,	@Year VARCHAR(10))

 AS
	SET FMTONLY OFF
	SET NOCOUNT ON

	/*
		@Type = Flash Heading

		34 = Net
	*/
BEGIN

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME

	SET @StartDate = @Month + '/1/' + @Year
	SET @EndDate = DATEADD(dd,-1,DATEADD(mm,1,@StartDate))

	-------------------------------------------- ALL -----------------------------------------------
IF (@center = 0)
	BEGIN
		SELECT ce.CenterSSID center
		,	ce.CenterDescriptionNumber AS 'CenterName'
		,	ce.RegionSSID RegionID
		,	re.RegionDescription Region
		,	cl.ClientNumber_Temp client_no
		,	cl.ClientLastName last_name
		,	cl.ClientFirstName first_name
		,	CAST(cl.ClientNumber_Temp AS VARCHAR(20)) + ' - ' + cl.ClientFullName AS 'ClientName'
		,	sod.TransactionNumber_Temp transact_no
		,	so.TicketNumber_Temp ticket_no
		,	d.FullDate [date]
		,	sc.SalesCodeDescriptionShort [code]
		,	sc.SalesCodeDescription [description]
		,	sc.SalesCodeDepartmentSSID [Department]
		,	m.MembershipDescription As 'from'
		,	cmem.MembershipDescription  As 'to'
		,	t.Quantity AS 'qty'--CASE WHEN dbo.ISINVERSE_SIGN(transactions.code)=1 THEN t.Quantity * -1 ELSE t.Quantity END AS 'qty'
		,	CASE WHEN sc.SalesCodeDescriptionShort IN ('SERVWO', 'PRODWO', 'PCPREVWO', 'NB1REVWO') AND d.FullDate < '9/18/06'
				THEN ROUND( t.Price/(1+t.TaxRate2),2)
				ELSE t.Price END
			AS 'price'
		,	t.Tax1 tax_1
		,	t.Tax2 tax_2
		,	em.EmployeeInitials performer
		,	cr.CancelReasonID CancelReasonID
		,	cr.CancelReasonDescription CancelReasonDescription
		,	CASE WHEN so.IsVoidedFlag = 1 THEN 'v' ELSE '' END AS 'voided'
		,	CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXU', 'NB2XU', 'ACQUIREDXU') THEN 1 ELSE 0 END AS 'UpgradeCount'
		,	CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXD') THEN 1 ELSE 0 END AS 'DowngradeCount'

		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey

		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey

		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey

		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey

				LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr ON cr.CancelReasonID = sod.CancelReasonID
				--LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimCancelReason cr ON cr.CancelReasonID = sod.CancelReasonID

		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey

		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey

		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON cm.ClientMembershipSSID = COALESCE(cl.CurrentBioMatrixClientMembershipSSID,cl.CurrentExtremeTherapyClientMembershipSSID,cl.CurrentSurgeryClientMembershipSSID,cl.CurrentXtrandsClientMembershipSSID)
			INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] cmem ON cmem.MembershipKey = cm.MembershipKey

		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee em ON em.EmployeeKey = t.Employee1Key
		WHERE d.FullDate BETWEEN @StartDate AND @EndDate + '23:59:59'
			AND re.RegionSSID IN (2,3,4,5) --(28, 29, 30, 31)
			AND sc.SalesCodeDescriptionShort IN ('PCPXU', 'PCPXD', 'NB2XU', 'ACQUIREDXU')
			AND so.IsVoidedFlag <> 1
	END
ELSE
	BEGIN
	-------------------------------------------- By Center -----------------------------------------------
		IF (@center NOT IN (28, 29, 30, 31, 6, 32))
		BEGIN
			SELECT ce.CenterSSID center
			,	ce.CenterDescriptionNumber AS 'CenterName'
			,	ce.RegionSSID RegionID
			,	re.RegionDescription Region
			,	cl.ClientNumber_Temp client_no
			,	cl.ClientLastName last_name
			,	cl.ClientFirstName first_name
			,	CAST(cl.ClientNumber_Temp AS VARCHAR(20)) + ' - ' + cl.ClientFullName AS 'ClientName'
			,	sod.TransactionNumber_Temp transact_no
			,	so.TicketNumber_Temp ticket_no
			,	d.FullDate [date]
			,	sc.SalesCodeDescriptionShort [code]
			,	sc.SalesCodeDescription [description]
			,	sc.SalesCodeDepartmentSSID [Department]
			,	m.MembershipDescription As 'from'
			,	cmem.MembershipDescription  As 'to'
			,	t.Quantity AS 'qty'--CASE WHEN dbo.ISINVERSE_SIGN(transactions.code)=1 THEN t.Quantity * -1 ELSE t.Quantity END AS 'qty'
			,	CASE WHEN sc.SalesCodeDescriptionShort IN ('SERVWO', 'PRODWO', 'PCPREVWO', 'NB1REVWO') AND d.FullDate < '9/18/06'
					THEN ROUND( t.Price/(1+t.TaxRate2),2)
					ELSE t.Price END
				AS 'price'
			,	t.Tax1 tax_1
			,	t.Tax2 tax_2
			,	em.EmployeeInitials performer
			,	cr.CancelReasonID CancelReasonID
			,	cr.CancelReasonDescription CancelReasonDescription
			,	CASE WHEN so.IsVoidedFlag = 1 THEN 'v' ELSE '' END AS 'voided'
			,	CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXU', 'NB2XU', 'ACQUIREDXU') THEN 1 ELSE 0 END AS 'UpgradeCount'
			,	CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXD') THEN 1 ELSE 0 END AS 'DowngradeCount'

			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey

			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey

					LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr ON cr.CancelReasonID = sod.CancelReasonID

			INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON cm.ClientMembershipSSID = COALESCE(cl.CurrentBioMatrixClientMembershipSSID,cl.CurrentExtremeTherapyClientMembershipSSID,cl.CurrentSurgeryClientMembershipSSID, cl.CurrentXtrandsClientMembershipSSID)
				INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] cmem ON cmem.MembershipKey = cm.MembershipKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee em ON em.EmployeeKey = t.Employee1Key
			WHERE d.FullDate BETWEEN @StartDate AND @EndDate + '23:59:59'
				--AND re.RegionSSID IN (2,3,4,5) --(28, 29, 30, 31)
				AND sc.SalesCodeDescriptionShort IN ('PCPXU', 'PCPXD', 'NB2XU', 'ACQUIREDXU')
				AND so.IsVoidedFlag <> 1
				AND ce.CenterSSID = @center
		END


		-------------------------------------------- By Region -----------------------------------------------
		IF (@center IN (28, 29, 30, 31, 6, 32))
		BEGIN
			SELECT ce.CenterSSID center
			,	ce.CenterDescriptionNumber AS 'CenterName'
			,	ce.RegionSSID RegionID
			,	re.RegionDescription Region
			,	cl.ClientNumber_Temp client_no
			,	cl.ClientLastName last_name
			,	cl.ClientFirstName first_name
			,	CAST(cl.ClientNumber_Temp AS VARCHAR(20)) + ' - ' + cl.ClientFullName AS 'ClientName'
			,	sod.TransactionNumber_Temp transact_no
			,	so.TicketNumber_Temp ticket_no
			,	d.FullDate [date]
			,	sc.SalesCodeDescriptionShort [code]
			,	sc.SalesCodeDescription [description]
			,	sc.SalesCodeDepartmentSSID [Department]
			,	m.MembershipDescription As 'from'
			,	cmem.MembershipDescription  As 'to'
			,	t.Quantity AS 'qty'--CASE WHEN dbo.ISINVERSE_SIGN(transactions.code)=1 THEN t.Quantity * -1 ELSE t.Quantity END AS 'qty'
			,	CASE WHEN sc.SalesCodeDescriptionShort IN ('SERVWO', 'PRODWO', 'PCPREVWO', 'NB1REVWO') AND d.FullDate < '9/18/06'
					THEN ROUND( t.Price/(1+t.TaxRate2),2)
					ELSE t.Price END
				AS 'price'
			,	t.Tax1 tax_1
			,	t.Tax2 tax_2
			,	em.EmployeeInitials performer
			,	cr.CancelReasonID CancelReasonID
			,	cr.CancelReasonDescription CancelReasonDescription
			,	CASE WHEN so.IsVoidedFlag = 1 THEN 'v' ELSE '' END AS 'voided'
			,	CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXU', 'NB2XU', 'ACQUIREDXU') THEN 1 ELSE 0 END AS 'UpgradeCount'
			,	CASE WHEN sc.SalesCodeDescriptionShort IN ('PCPXD') THEN 1 ELSE 0 END AS 'DowngradeCount'

			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey

			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON ce.RegionKey = re.RegionKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey

					LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr ON cr.CancelReasonID = sod.CancelReasonID
					--LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimCancelReason cr ON cr.CancelReasonID = sod.CancelReasonID

			INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON cm.ClientMembershipSSID = COALESCE(cl.CurrentBioMatrixClientMembershipSSID,cl.CurrentExtremeTherapyClientMembershipSSID,cl.CurrentSurgeryClientMembershipSSID, cl.CurrentXtrandsClientMembershipSSID)
				INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] cmem ON cmem.MembershipKey = cm.MembershipKey

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee em ON em.EmployeeKey = t.Employee1Key
			WHERE d.FullDate BETWEEN @StartDate AND @EndDate + '23:59:59'
				--AND re.RegionSSID IN (2,3,4,5) --(28, 29, 30, 31)
				AND sc.SalesCodeDescriptionShort IN ('PCPXU', 'PCPXD', 'NB2XU', 'ACQUIREDXU')
				AND so.IsVoidedFlag <> 1
				AND ce.RegionSSID = @center
		END
	END
END
