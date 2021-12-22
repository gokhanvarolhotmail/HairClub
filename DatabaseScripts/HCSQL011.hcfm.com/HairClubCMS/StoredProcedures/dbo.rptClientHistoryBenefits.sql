/* CreateDate: 06/19/2013 23:57:22.550 , ModifyDate: 08/13/2014 16:19:31.143 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:                  rptClientHistoryBenefits
-- Procedure Description:
--
-- Created By:                      Mike Maass
-- Implemented By:                  Mike Maass
-- Last Modified By:				Rachelen Hut
--
-- Date Created:              06/18/13
-- Date Implemented:
-- Date Last Modified:        12/13/13
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**
12/03/2013	RMH	Changed the parameter to include an array of all memberships - past and present.
08/13/2014	RMH	Added AND SO.IsVoidedFlag = 0 (WO#105195)
================================================================================================
Sample Execution:
EXEC rptClientHistoryBenefits 'B8B8B2CB-D164-406A-B28F-98A95C6E5731'

EXEC rptClientHistoryBenefits '58770EA0-CBA8-4C59-A5DA-5C7567292273,1808DD75-791A-41A5-AF93-3B828F856D59'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientHistoryBenefits]
	@ClientMembershipGUIDArray NVARCHAR(MAX)
AS
BEGIN

	/***********Create temp table for the ClientMembershipGUID *****************************/

	IF OBJECT_ID('tempdb..#guid') IS NOT NULL
		DROP TABLE #guid

	CREATE TABLE #guid(ID INT IDENTITY(1,1), ClientMembershipGUID VARCHAR(MAX))

	--Populate the temp table with the GUID's

	DECLARE @string VARCHAR(MAX)
	DECLARE @pos numeric(20)
	DECLARE @piece varchar(50)

	SET @string = @ClientMembershipGUIDArray

	--Add a comma to the end of the string in order to capture the last characters
	IF RIGHT(@string,1) <> ','
	BEGIN
		SET @string = @string + ','
	END

	--Split the string and insert the pieces into the table
	SET @pos = patindex('%,%' , @string)
	PRINT @pos
	WHILE @pos <> 0
	BEGIN
		SET @piece = LEFT(@string, @pos-1)
		INSERT INTO #guid
		  SELECT @piece
		  PRINT @piece
		SET @string = stuff(@string, 1, @pos, NULL)
		PRINT @string
		SET @pos = charindex(',' , @string)
		PRINT @pos
	END

	--SELECT * FROM #guid

	DECLARE @ProductKitID int
			,@ApplicationID Int
			,@ServicesID int
			,@NewApplicationID int
			,@SolutionsID int
			,@EXTServicesID int
			,@EXTMgmtServicesID int


	SELECT @ProductKitID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'PRKits'
	SELECT @ApplicationID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'SVApp'
	SELECT @ServicesID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'SVSrv'
	SELECT @NewApplicationID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'SVNewApp'
	SELECT @SolutionsID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'SVSol'
	SELECT @EXTServicesID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'EXTSrv'
	SELECT @EXTMgmtServicesID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WHERE SalesCodeDepartmentDescriptionShort = 'EXTMgmSrv'

	DECLARE @BioSysID int
		,@ServiceID Int
		,@SolutionID int
		,@ProdKitID int

	SELECT @BioSysID = AccumulatorID FROM cfgAccumulator WHERE AccumulatorDescriptionShort = 'BioSys'
	SELECT @ServiceID = AccumulatorID FROM cfgAccumulator WHERE AccumulatorDescriptionShort = 'SERV'
	SELECT @SolutionID = AccumulatorID FROM cfgAccumulator WHERE AccumulatorDescriptionShort = 'SOL'
	SELECT @ProdKitID = AccumulatorID FROM cfgAccumulator WHERE AccumulatorDescriptionShort = 'PRODKIT'

	;WITH BENEFIT_CTE AS
	(
	Select CAST(SO.ClientMembershipGUID AS NVARCHAR(MAX)) AS ClientMembershipGUID
		,	M.MembershipDescription
		,	CM.BeginDate
		,	CM.EndDate
		,	M.MembershipSortOrder
		,	so.InvoiceNumber
		,	so.OrderDate
		,	sc.SalesCodeDescription
		,	CASE WHEN aj.AccumulatorID = @BioSysID THEN 1 ELSE 0 END as SystemCount
		,	CASE WHEN aj.AccumulatorID = @ServiceID THEN 1 ELSE 0 END as ServiceCount
		,	CASE WHEN aj.AccumulatorID = @SolutionID THEN 1 ELSE 0 END as SolutionCount
		,	CASE WHEN aj.AccumulatorID = @ProdKitID THEN 1 ELSE 0 END as ProductKitCount
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod
			ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN cfgSalesCode sc
			ON sod.SalesCodeId = sc.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
		LEFT OUTER JOIN cfgAccumulatorJoin aj
			ON sc.SalesCodeID = aj.SalesCodeID
		INNER JOIN datClientMembership CM
			ON SO.ClientMembershipGUID = CM.ClientMembershipGUID
		INNER JOIN cfgMembership M
			ON CM.MembershipID = M.MembershipID
	WHERE so.ClientMembershipGUID IN(SELECT ClientMembershipGUID FROM #guid)
		AND so.IsVoidedFlag = 0
		AND (sc.SalesCodeDepartmentID = @ProductKitID
			 OR sc.SalesCodeDepartmentID = @ApplicationID
			 OR sc.SalesCodeDepartmentID = @ServicesID
			 OR sc.SalesCodeDepartmentID = @NewApplicationID
			 OR sc.SalesCodeDepartmentID = @SolutionsID
			 OR sc.SalesCodeDepartmentID = @EXTServicesID
			 OR sc.SalesCodeDepartmentID = @EXTMgmtServicesID)
	)
	SELECT ClientMembershipGUID
		,	MembershipDescription
		,	BeginDate
		,	EndDate
		,	MembershipSortOrder
		,	InvoiceNumber
		,	OrderDate
		,	SalesCodeDescription
		,	SUM(SystemCount) as SystemCount
		,	SUM(ServiceCount) as ServiceCount
		,	SUM(SolutionCount) as SolutionCount
		,	SUM(ProductKitCount) as ProductKitCount
	FROM BENEFIT_CTE
	GROUP BY ClientMembershipGUID
		,	MembershipDescription
		,	BeginDate
		,	EndDate
		,	MembershipSortOrder
		,	InvoiceNumber
		,	OrderDate
		,	SalesCodeDescription


END
GO
