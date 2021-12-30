/* CreateDate: 12/09/2013 13:53:33.020 , ModifyDate: 12/09/2013 14:01:21.670 */
GO
/***********************************************************************
PROCEDURE:				spRpt_CommissionClientOverview_Transactions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			CommissionClientOverview
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		12/09/2013
------------------------------------------------------------------------
NOTES

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_CommissionClientOverview_Transactions '368347'  --Weber, Cheryl

EXEC spRpt_CommissionClientOverview_Transactions '20196'  --Steve Nicholson

EXEC spRpt_CommissionClientOverview_Transactions '416237'  --Rodriguez, Fabian

EXEC spRpt_CommissionClientOverview_Transactions '366417'  --Luu, Stacy

EXEC spRpt_CommissionClientOverview_Transactions '67439'  --Wright, Mark


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_CommissionClientOverview_Transactions]
(
	@ClientIdentifier INT
) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;

		/********************************** Create temp table objects *************************************/

	IF OBJECT_ID('tempdb..#trans') IS NOT NULL
	BEGIN
		DROP TABLE #trans
	END

	CREATE TABLE #trans(Direction VARCHAR(25)
		,	ClientIdentifier INT
		,	LastName NVARCHAR(50)
		,	FirstName NVARCHAR(50)
		,	ClientMembershipIdentifier NVARCHAR(50)
		,	ProcessName NVARCHAR(50)
		,	FST_TransactionDate DATETIME
		,	FST_Quantity INT
		,	FST_Price MONEY
		,	FST_Discount MONEY
		,	FST_ExtendedPrice MONEY
		,	SOD_OrderDate DATETIME
		,	InvoiceNumber NVARCHAR(50)
		)

	/***********Set the @ClientKey for use in the query*****************************************************/

	DECLARE @ClientKey INT

	SET @ClientKey = (SELECT ClientKey FROM [HC_BI_CMS_DDS].[bi_cms_dds].DimClient WHERE ClientIdentifier = @ClientIdentifier)

	PRINT '@ClientKey = ' + CAST(@ClientKey AS VARCHAR(10))


	/*********** Populate the main temp table #trans ***********************************/

	INSERT INTO #trans (Direction
		,	ClientIdentifier
		,	LastName
		,	FirstName
		,	ClientMembershipIdentifier
		,	ProcessName
		,	FST_TransactionDate
		,	FST_Quantity
		,	FST_Price
		,	FST_Discount
		,	FST_ExtendedPrice
		,	SOD_OrderDate
		,	InvoiceNumber)

SELECT 'FactSalesTrans' AS Direction
			,	@ClientIdentifier AS ClientIdentifier
			,	CLT.ClientLastName AS 'LastName'
			,	CLT.ClientFirstName AS 'FirstName'
			,	CAST(FST.ClientMembershipKey AS NVARCHAR(50)) AS 'ClientMembershipIdentifier'
			,	SalesCodeDescription AS ProcessName
			,	DD.FullDate AS FST_TransactionDate
			,	FST.Quantity AS FST_Quantity
			,	FST.Price AS FST_Price
			,	FST.Discount AS FST_Discount
			,	ExtendedPrice AS FST_ExtendedPrice
			,	SO.OrderDate AS SOD_OrderDate
			,	InvoiceNumber
	FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrder SO
			ON SOD.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimMembership M
			ON FST.MembershipKey = M.MembershipKey
	WHERE FST.ClientKey = @ClientKey
		AND M.BusinessSegmentDescription != 'Surgery'  --Other than surgeries
		AND YEAR(DD.FullDate) >= YEAR(DATEADD(YEAR,-1,GETDATE()))  --For the past year

	SELECT * FROM #trans

END
GO
