/* CreateDate: 12/07/2020 07:57:57.430 , ModifyDate: 12/15/2021 08:35:47.910 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selParLevelsData

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Alejandro Acevedo

IMPLEMENTOR: 			Alejandro Acevedo

DATE IMPLEMENTED: 		11/24/2020

LAST REVISION DATE: 	11/24/2020

--------------------------------------------------------------------------------------------------------
NOTES:  Return Par levels

		* 11/24/2020	AAM	Created (TFS #14695)

		* 12/15/2020    Added ParLevel Calculations (tfs#14736)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selParLevelsData 340

***********************************************************************/

CREATE PROCEDURE [dbo].[selParLevelsData]
		@CenterID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

		IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
	   DROP TABLE #Centers
	IF OBJECT_ID('tempdb..#UTCDates') IS NOT NULL
	   DROP TABLE #UTCDates
	IF OBJECT_ID('tempdb..#SoldSalesCodeData') IS NOT NULL
	   DROP TABLE #SoldSalesCodeData
	IF OBJECT_ID('tempdb..#BackbarSalesCodeData') IS NOT NULL
	   DROP TABLE #BackbarSalesCodeData
	IF OBJECT_ID('tempdb..#tmpParLevelData') IS NOT NULL
	   DROP TABLE #tmpParLevelData
	IF OBJECT_ID('tempdb..#calculatedParLevelData') IS NOT NULL
	   DROP TABLE #calculatedParLevelData


	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME


	SET @EndDate = getUtcDate()
	SET @StartDate = DATEADD(month, - 6, @enddate);


	SET FMTONLY OFF;
	SET NOCOUNT OFF;

		SELECT  tz.TimeZoneID
	,tz.UTCOffset
	,tz.UsesDayLightSavingsFlag
	,tz.IsActiveFlag
	,dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate'
	,dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
	INTO    #UTCDates
	FROM    lkpTimeZone tz
	WHERE   tz.IsActiveFlag = 1

	select  sc.SalesCodeDescriptionShort, count(sc.SalesCodeDescriptionShort) as 'SoldBySalesCode'
	into    #SoldSalesCodeData
	FROM    dbo.datSalesOrderDetail sod
			INNER JOIN datSalesOrder so
				ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN cfgSalesCode sc
				ON sc.SalesCodeID = sod.SalesCodeID
			INNER JOIN lkpSalesCodeDepartment scd
				ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
			INNER JOIN lkpSalesCodeDivision scdv
				ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
			INNER JOIN cfgCenter ctr
				ON ctr.CenterID = so.CenterID
			INNER JOIN lkpTimeZone tz
				ON tz.TimeZoneID = ctr.TimeZoneID
				 JOIN #UTCDates u
						ON u.TimeZoneID = tz.TimeZoneID
			INNER JOIN datClient cl
				ON cl.ClientGUID = so.ClientGUID
			INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = so.ClientMembershipGUID
				 INNER JOIN lkpClientMembershipStatus cms
						ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN cfgMembership m
				ON m.MembershipID = cm.MembershipID
	WHERE   so.OrderDate BETWEEN u.UTCStartDate AND u.UTCEndDate
				 AND scdv.SalesCodeDivisionID = 30 --Products
			AND so.IsVoidedFlag = 0 and ctr.CenterID=@centerId
	group by sc.SalesCodeDescriptionShort

	SELECT
	count(sc.SalesCodeDescriptionShort) as 'BackBarQuantity',
	sc.SalesCodeDescriptionShort AS 'SalesCode'
	into #BackbarSalesCodeData
	FROM datInventoryAdjustment ia
	INNER JOIN cfgCenter ctr
	ON ctr.CenterID = ia.CenterID
	INNER JOIN lkpInventoryAdjustmentType iat
	ON iat.InventoryAdjustmentTypeID = ia.InventoryAdjustmentTypeID
	INNER JOIN datInventoryAdjustmentDetail iad
	ON iad.InventoryAdjustmentID = ia.InventoryAdjustmentID
	INNER JOIN cfgSalesCode sc
	ON sc.SalesCodeID = iad.SalesCodeID
	INNER JOIN datEmployee e
	ON e.EmployeeGUID = ia.EmployeeGUID
	WHERE ia.InventoryAdjustmentDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'  and ctr.CenterId=@centerId
	AND iat.InventoryAdjustmentTypeID = 9 /* Back Bar */
	group by sc.SalesCodeDescriptionShort

	SELECT
	sc.SalesCodeDescription,
	sc.SalesCodeDescriptionShort,
	sc.size,
	sci.[Current Quantity] as 'QuantityOnHand',
	isnull(ssc.SoldBySalesCode,0) as 'Sold',
	cast(isnull(bsc.BackBarQuantity,0) as decimal(18,0)) as 'BackBarQuantity',
	cast((cast(isnull(ssc.SoldBySalesCode,0) as decimal)/24) as decimal(18,2)) as 'AvgSold',
	cast((cast(isnull(bsc.BackBarQuantity,0) as decimal)/24) as decimal(18,2)) as 'AvgBackBar',
	sci.[Current Quantity] as 'OnHand',
	sc.QuantityPerPack as 'QuantityPerPack',
	sc.IsBackbarApproved
	into #tmpParLevelData
	FROM [dbo].[HC_InventorySnapshot_NonserializedInventorySnapshot_TABLE] sci
	--INNER JOIN cfgsalescodecenter scc on scc. Salescodecenterid = sci.Salescodecenterid
	INNER JOIN cfgSalesCode sc on sc.SalesCodeDescriptionShort = sci.[Item SKU]
	INNER JOIN cfgcenter c on c.CenterNumber = sci.centerid
	INNER JOIN cfgconfigurationcenter cc on cc.Centerid = c.Centerid
	INNER JOIN lkpSize cs on cc.RecurringBusinessSizeID = cs.SizeId
	INNER JOIN lkpsize csn on cc.NewBusinesssizeID = csn.SizeId
	left join #soldSalesCodeData ssc on  sc.SalesCodeDescriptionShort= ssc.SalesCodeDescriptionShort
	left join #backbarSalesCodeData bsc on sc.SalesCodeDescriptionShort= bsc.SalesCode
	wHERE c.centerid = @CenterID  --and sci.QuantityOnHand<>0
	order by sc.SalesCodeDescription asc

	select parLevelData.*,
           cast((parLevelData.AvgSold+parLevelData.AvgBackbar) as decimal(18,2)) as AvgWeek
		  into #calculatedParLevelData
	from #tmpParLevelData parLevelData

		select calculatedData.*,
	    iif((calculatedData.AvgWeek<>0 or calculatedData.AvgWeek<>null),
		cast((calculatedData.QuantityOnHand/calculatedData.AvgWeek) as decimal(18,1)), 0) as 'WeeksOnHand',
		SuggestedQtyOrder=  case
								when (calculatedData.AvgWeek > 9 ) then 0
								else (iif((calculatedData.QuantityPerPack<>0 or calculatedData.QuantityPerPack<>null),
										iif((ceiling((((11*calculatedData.AvgWeek)-calculatedData.QuantityOnHand)/calculatedData.QuantityPerPack)))>0,
										ceiling((((11*calculatedData.AvgWeek)-calculatedData.QuantityOnHand)/calculatedData.QuantityPerPack)),0),
										0)
									)
							end
		from #calculatedParLevelData calculatedData	--Temp table with all the values

  END TRY

  BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

END
GO
