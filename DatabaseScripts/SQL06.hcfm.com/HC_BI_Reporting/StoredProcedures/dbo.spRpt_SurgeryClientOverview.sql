/* CreateDate: 11/18/2013 17:37:28.540 , ModifyDate: 12/05/2013 15:35:20.680 */
GO
/***********************************************************************
PROCEDURE:				spRpt_SurgeryClientOverview
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_SurgeryClientOverview
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES

12/5/2013	RHut	Moved transactions into their own stored procedure to simplify research.  This stored procedure finds Incoming and Outgoing information.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_SurgeryClientOverview '368347'  --Weber, Cheryl

EXEC spRpt_SurgeryClientOverview '20196'  --Steve Nicholson

EXEC spRpt_SurgeryClientOverview '416237'  --Rodriguez, Fabian

EXEC spRpt_SurgeryClientOverview '366417'  --Luu, Stacy

EXEC spRpt_SurgeryClientOverview '67439'  --Wright, Mark


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SurgeryClientOverview]
(
	@ClientIdentifier INT
) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;


	/********************************** Create temp table objects *************************************/

	IF OBJECT_ID('tempdb..#surgery') IS NOT NULL
	BEGIN
		DROP TABLE #surgery
	END

	CREATE TABLE #surgery(OutgoingRequestID INT
		,	IncomingRequestID INT
		,	Direction VARCHAR(25)
		,	ClientIdentifier INT
		,	SiebelID NVARCHAR(50)
		,	LastName NVARCHAR(50)
		,	FirstName NVARCHAR(50)
		,	CreateDate DATETIME
		,	ClientMembershipIdentifier NVARCHAR(50)
		,	OUT_InvoiceNumber NVARCHAR(50)
		,	OUT_ProcessName NVARCHAR(50)
		,	OUT_Amount MONEY
		,	INB_TreatmentPlanDate DATETIME
		,	INB_ProcedureDate DATETIME
		,	INB_ProcedureGraftCount INT
		,	INB_PaymentAmount MONEY
		,	INB_ProcedureStatus NVARCHAR(50)
		,	INB_ProcedureAmount MONEY
		,	ProcessName NVARCHAR(50)
		,	InvoiceNumber NVARCHAR(50)
		)


	/***********Set the @ClientKey for use in the query*****************************************************/

	DECLARE @ClientKey INT

	SET @ClientKey = (SELECT ClientKey FROM [HC_BI_CMS_DDS].[bi_cms_dds].DimClient WHERE ClientIdentifier = @ClientIdentifier)

	PRINT '@ClientKey = ' + CAST(@ClientKey AS VARCHAR(10))


	/*********** Populate the main temp table #surgery ***********************************/

	INSERT INTO #surgery (OutgoingRequestID
		,	IncomingRequestID
		,	Direction
		,	ClientIdentifier
		,	SiebelID
		,	LastName
		,	FirstName
		,	CreateDate
		,	ClientMembershipIdentifier
		,	OUT_InvoiceNumber
		,	OUT_ProcessName
		,	OUT_Amount
		,	INB_TreatmentPlanDate
		,	INB_ProcedureDate
		,	INB_ProcedureGraftCount
		,	INB_PaymentAmount
		,	INB_ProcedureStatus
		,	INB_ProcedureAmount
		,	ProcessName
		,	InvoiceNumber)

	--SELECT the Outgoing Request data and the Incoming Request data as a UNION statement

	SELECT OutgoingRequestID
		,	IncomingRequestID
		,	Direction
		,	ClientIdentifier AS 'ClientIdentifier'
		,	SiebelID AS 'SiebelID'
		,	LastName AS 'LastName'
		,	FirstName AS 'FirstName'
		,	CreateDate AS 'CreateDate'
		,	ClientMembershipIdentifier AS 'ClientMembershipIdentifier'
		,	OUT_InvoiceNumber AS 'OUT_InvoiceNumber'
		,	OUT_ProcessName AS 'OUT_ProcessName'
		,	OUT_Amount AS 'OUT_Amount'
		,	INB_TreatmentPlanDate AS 'INB_TreatmentPlanDate'
		,	INB_ProcedureDate AS 'INB_ProcedureDate'
		,	INB_ProcedureGraftCount AS 'INB_ProcedureGraftCount'
		,	INB_PaymentAmount AS 'INB_PaymentAmount'
		,	INB_ProcedureStatus AS 'INB_ProcedureStatus'
		,	INB_ProcedureAmount AS 'INB_ProcedureAmount'
		,	ProcessName AS 'ProcessName'
		,	InvoiceNumber
	FROM
		(SELECT OutgoingRequestID
		,	NULL AS IncomingRequestID
		,	'OUTBOUND' AS Direction
		,	ORL.ClientIdentifier
		,	ORL.SiebelID
		,	ISNULL(ORL.LastName, CL.ClientLastName) AS 'LastName'
		,	ISNULL(ORL.FirstName, CL.ClientFirstName) AS 'FirstName'
		,	ORL.CreateDate AS 'CreateDate'
		,	ClientMembershipIdentifier
		,	ORL.InvoiceNumber AS 'OUT_InvoiceNumber'
		,	ORL.ProcessName AS 'OUT_ProcessName'
		,	ORL.Amount AS 'OUT_Amount'
		,	NULL AS INB_TreatmentPlanDate
		,	NULL AS INB_ProcedureDate
		,	NULL AS INB_ProcedureGraftCount
		,	NULL AS INB_PaymentAmount
		,	NULL AS INB_ProcedureStatus
		,	NULL AS INB_ProcedureAmount
		,	ProcessName
		,	ORL.InvoiceNumber
		FROM SQL01.HairclubCMS.dbo.datOutgoingRequestLog ORL
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimClient CL
			ON ORL.ClientIdentifier = CL.ClientIdentifier
		WHERE ORL.ClientIdentifier = @ClientIdentifier
		UNION
		SELECT
			NULL AS OutgoingRequestID
			,	IRL.IncomingRequestID
			,	'INBOUND' AS Direction
			,	IRL.ConectID AS ClientIdentifier
			,	IRL.SiebelID
			,	ISNULL(IRL.LastName, CL.ClientLastName) AS 'LastName'
			,	ISNULL(IRL.FirstName, CL.ClientFirstName) AS 'FirstName'
			,	IRL.CreateDate AS 'CreateDate'
			,	NULL AS ClientMembershipIdentifier
			,	NULL AS OUT_InvoiceNumber
			,	NULL AS OUT_ProcessName
			,	NULL AS OUT_Amount
			,	IRL.TreatmentPlanDate AS INB_TreatmentPlanDate
			,	IRL.ProcedureDate AS INB_ProcedureDate
			,	IRL.ProcedureGraftCount AS INB_ProcedureGraftCount
			,	PaymentAmount AS INB_PaymentAmount
			,	IRL.ProcedureStatus AS INB_ProcedureStatus
			,	IRL.ProcedureAmount AS INB_ProcedureAmount
			,	IRL.ProcessName
			,	SO.InvoiceNumber
			FROM  SQL01.HairclubCMS.dbo.[datIncomingRequestLog] IRL
			INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimClient CL
				ON IRL.ConectID = CL.ClientIdentifier
			INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesOrder SO
				ON IRL.IncomingRequestID = SO.IncomingRequestID
			WHERE ConectID = @ClientIdentifier
	)q

	WHERE YEAR(CreateDate) >= YEAR(DATEADD(YEAR,-1,GETDATE())) --a way to remove the old data




	/************Final Select**************************************************/

	SELECT * FROM #surgery

END
GO
