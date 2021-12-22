/***********************************************************************
PROCEDURE:				spRpt_SurgeryClientOverview_Transactions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_SurgeryClientOverview
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		12/05/2013
------------------------------------------------------------------------
NOTES

12/5/2013	RHut	Moved transactions into their own stored procedure to simplify research.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_SurgeryClientOverview_Transactions '368347'  --Weber, Cheryl

EXEC spRpt_SurgeryClientOverview_Transactions '20196'  --Steve Nicholson

EXEC spRpt_SurgeryClientOverview_Transactions '416237'  --Rodriguez, Fabian

EXEC spRpt_SurgeryClientOverview_Transactions '366417'  --Luu, Stacy

EXEC spRpt_SurgeryClientOverview_Transactions '67439'  --Wright, Mark


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SurgeryClientOverview_Transactions]
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

	CREATE TABLE #trans(IncomingRequestID INT
		,	Direction VARCHAR(25)
		,	ClientIdentifier INT
		,	LastName NVARCHAR(50)
		,	FirstName NVARCHAR(50)
		,	ClientMembershipIdentifier NVARCHAR(50)
		,	ProcessName NVARCHAR(50)
		,	FST_TransactionDate DATETIME
		,	FST_S_PostExtAmt MONEY
		,	FST_Quantity INT
		,	FST_Price MONEY
		,	FST_Discount MONEY
		,	FST_ExtendedPrice MONEY
		,	FST_S_SurgeryPerformedAmt MONEY
		,	FST_S_SurgeryGraftsCnt INT
		,	FST_S_SurCnt INT
		,	FST_SurAmt MONEY
		,	SOD_OrderDate DATETIME
		,	InvoiceNumber NVARCHAR(50)
		)

	/***********Set the @ClientKey for use in the query*****************************************************/

	DECLARE @ClientKey INT

	SET @ClientKey = (SELECT ClientKey FROM [HC_BI_CMS_DDS].[bi_cms_dds].DimClient WHERE ClientIdentifier = @ClientIdentifier)

	PRINT '@ClientKey = ' + CAST(@ClientKey AS VARCHAR(10))


	/*********** Populate the main temp table #trans ***********************************/

	INSERT INTO #trans (IncomingRequestID
		,	Direction
		,	ClientIdentifier
		,	LastName
		,	FirstName
		,	ClientMembershipIdentifier
		,	ProcessName
		,	FST_TransactionDate
		,	FST_S_PostExtAmt
		,	FST_Quantity
		,	FST_Price
		,	FST_Discount
		,	FST_ExtendedPrice
		,	FST_S_SurgeryPerformedAmt
		,	FST_S_SurgeryGraftsCnt
		,	FST_S_SurCnt
		,	FST_SurAmt
		,	SOD_OrderDate
		,	InvoiceNumber)

SELECT 	SO.IncomingRequestID AS IncomingRequestID
			,	'FactSalesTrans' AS Direction
			,	@ClientIdentifier AS ClientIdentifier
			,	CLT.ClientLastName AS 'LastName'
			,	CLT.ClientFirstName AS 'FirstName'
			,	CAST(FST.ClientMembershipKey AS NVARCHAR(50)) AS 'ClientMembershipIdentifier'
			,	SalesCodeDescription AS ProcessName
			,	DD.FullDate AS FST_TransactionDate
			,	S_PostExtAmt AS FST_S_PostExtAmt
			,	FST.Quantity AS FST_Quantity
			,	FST.Price AS FST_Price
			,	FST.Discount AS FST_Discount
			,	ExtendedPrice AS FST_ExtendedPrice
			,	S_SurgeryPerformedAmt AS FST_S_SurgeryPerformedAmt
			,	S_SurgeryGraftsCnt AS FST_S_SurgeryGraftsCnt
			,	S_SurCnt AS FST_S_SurCnt
			,	S_SurAmt AS FST_SurAmt
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
		AND M.BusinessSegmentDescription = 'Surgery'
		AND YEAR(DD.FullDate) >= YEAR(DATEADD(YEAR,-1,GETDATE()))  --For the past year

	SELECT * FROM #trans

END
