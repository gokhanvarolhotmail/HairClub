/* CreateDate: 11/19/2012 16:11:59.980 , ModifyDate: 02/27/2017 09:49:28.973 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptNewBusiness90DayProtocol
-- Procedure Description:
--
-- Created By:				Hdu
-- Implemented By:			Hdu
-- Last Modified By:		Hdu
--
-- Date Created:			10/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:
	12/11/2012 -- MB -- Reformatted query and created temp table ahead of time to prevent issue where
						different length string data was inserted after the table is already created (WO# 82050)
	01/15/2013 -- MB -- Added new 4th checkup and stylist columns to report (WO# 82823)
	01/25/2013 -- MB -- Changed code for 24 hour checkup from "CKUK24" to "CKU24"
	07/26/2013 -- MB -- Filtered out "New Client" memberships (WO# 89248)
	09/09/2013 -- MB -- Added NB1 Removal columns (WO# 90126)
	10/08/2013 -- MB -- Fixed data type column of Removal stylist from INT to VARCHAR (WO# 92375)
	02/04/2015 -- RH -- Added CurrentXtrandsClientMembershipGUID to the COALESCE statement
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptNewBusiness90DayProtocol] 230, '1/1/2015', '2/1/2015'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptNewBusiness90DayProtocol](
	@CenterId INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON;


	CREATE TABLE #PIV (
		ClientGUID UNIQUEIDENTIFIER
	,	ClientFullNameCalc VARCHAR(100)
	,	SaleDate DATETIME
	,	CurrentMembership VARCHAR(100)
	,	NB1AppDate DATETIME
	,	NB1AppStylist VARCHAR(10)
	,	DateCol VARCHAR(100)
	,	DateColVal DATETIME
	,	EmployeeInitials VARCHAR(10)
	,	RemovalDate DATETIME
	,	RemovalStylist VARCHAR(10)
	,	Ranking INT
	)


	SELECT cl.ClientGUID
	,	cl.ClientIdentifier
	,	cl.ClientNumber_Temp
	,	cl.ClientFullNameCalc
	,	MAX(so.OrderDate) AS SaleDate
	,	nb1.NB1AppDate
	,	nb1.NB1AppStylist
	,	ccmm.MembershipDescription AS CurrentMembership
	,	Remv.RemovalDate
	,	Remv.RemovalStylist
	INTO #Clients
	FROM datSalesOrderDetail sod
		INNER JOIN datSalesOrder so
			ON so.SalesOrderGUID = sod.SalesOrderGUID
			AND so.CenterID = @CenterId
			AND so.OrderDate BETWEEN @StartDate and @EndDate + '23:59:59'
		INNER JOIN datClient cl
			ON cl.ClientGUID = so.ClientGUID
		LEFT OUTER JOIN datClientMembership ccm
			ON ccm.ClientMembershipGUID = COALESCE(cl.CurrentBioMatrixClientMembershipGUID, cl.CurrentSurgeryClientMembershipGUID, cl.CurrentExtremeTherapyClientMembershipGUID,cl.CurrentXtrandsClientMembershipGUID)
		LEFT OUTER JOIN cfgMembership ccmm
			ON ccmm.MembershipID = ccm.MembershipID
		LEFT OUTER JOIN (--Get NB1 App Date
			SELECT so1.ClientGUID
			,	so1.OrderDate AS NB1AppDate
			,	sty.EmployeeInitials AS NB1AppStylist
			,	ROW_NUMBER() OVER(PARTITION BY so1.ClientGUID ORDER BY so1.OrderDate DESC) AS RANKING
			FROM datSalesOrderDetail sod1
				INNER JOIN cfgSalesCode sc1
					ON sc1.SalesCodeID = sod1.SalesCodeID
				INNER JOIN datSalesOrder so1
					ON so1.SalesOrderGUID = sod1.SalesOrderGUID
					AND so1.CenterID = @CenterId
				LEFT OUTER JOIN datEmployee sty
					ON sty.EmployeeGUID = sod1.Employee2GUID
			WHERE SalesCodeDescriptionShort IN ('NB1A')
		) nb1
			ON nb1.ClientGUID = cl.ClientGUID
			AND RANKING = 1

		LEFT OUTER JOIN (--Get NB1 Removal Date
			SELECT so1.ClientGUID
			,	so1.OrderDate AS 'RemovalDate'
			,	sty.EmployeeInitials AS 'RemovalStylist'
			,	ROW_NUMBER() OVER(PARTITION BY so1.ClientGUID ORDER BY so1.OrderDate DESC) AS RANKING
			FROM datSalesOrderDetail sod1
				INNER JOIN cfgSalesCode sc1
					ON sc1.SalesCodeID = sod1.SalesCodeID
				INNER JOIN datSalesOrder so1
					ON so1.SalesOrderGUID = sod1.SalesOrderGUID
					AND so1.CenterID = @CenterId
				LEFT OUTER JOIN datEmployee sty
					ON sty.EmployeeGUID = sod1.Employee2GUID
			WHERE sc1.SalesCodeID = 399
		) Remv
			ON Remv.ClientGUID = cl.ClientGUID
			AND Remv.RANKING = 1

		INNER JOIN datClientMembership cm
			ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = cm.MembershipID
			AND m.RevenueGroupID = 1
			AND m.BusinessSegmentID = 1
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
	WHERE SalesCodeDescriptionShort IN ('INITASG')
		AND ccmm.MembershipID NOT IN (57)
	GROUP BY cl.ClientGUID
	,	cl.ClientIdentifier
	,	cl.ClientNumber_Temp
	,	cl.ClientFullNameCalc
	,	nb1.NB1AppDate
	,	nb1.NB1AppStylist
	,	ccmm.MembershipDescription
	,	Remv.RemovalDate
	,	Remv.RemovalStylist



	--GET DATE OF CHECKUPS AFTER THE NB1APP DATE
	INSERT INTO #PIV (
		ClientGUID
	,	ClientFullNameCalc
	,	SaleDate
	,	CurrentMembership
	,	NB1AppDate
	,	NB1AppStylist
	,	DateCol
	,	DateColVal
	,	EmployeeInitials
	,	RemovalDate
	,	RemovalStylist
	,	Ranking)
	SELECT cl.ClientGUID
	,	cl.ClientFullNameCalc
	,	cl.SaleDate
	,	cl.CurrentMembership
	,	cl.NB1AppDate
	,	cl.NB1AppStylist
	,	'CHECKUP' AS DATECOL
	,	so1.OrderDate DATECOLVAL
	,	sty.EmployeeInitials
	,	cl.RemovalDate
	,	cl.RemovalStylist
	,	ROW_NUMBER() OVER(PARTITION BY cl.ClientGUID, so1.SalesCodeDescriptionShort ORDER BY so1.OrderDate ASC) AS RANKING
	FROM #Clients cl
		LEFT OUTER JOIN (
			SELECT so.ClientGUID
			,	so.OrderDate
			,	sod.Employee2GUID
			,	sc.SalesCodeDescriptionShort
			FROM datSalesOrder so
				INNER JOIN datSalesOrderDetail sod
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
					AND sc.SalesCodeDescriptionShort IN ('CKU')
		) so1
			ON cl.ClientGUID = so1.ClientGUID
			AND so1.OrderDate > cl.NB1AppDate
		LEFT OUTER JOIN datEmployee sty
			ON sty.EmployeeGUID = so1.Employee2GUID


	--GET DATES OF SPECIFIC CODES
	INSERT INTO #PIV (
		ClientGUID
	,	ClientFullNameCalc
	,	SaleDate
	,	CurrentMembership
	,	NB1AppDate
	,	NB1AppStylist
	,	DateCol
	,	DateColVal
	,	EmployeeInitials
	,	RemovalDate
	,	RemovalStylist
	,	Ranking)
	SELECT cl.ClientGUID
	,	cl.ClientFullNameCalc
	,	cl.SaleDate
	,	cl.CurrentMembership
	,	cl.NB1AppDate
	,	cl.NB1AppStylist
	,	CASE sc.SalesCodeDescriptionShort
			WHEN 'CKUPRE' THEN 'PRECHECK'
			WHEN 'CKU24' THEN 'CHECK24'
			WHEN 'SVC' THEN 'SERVICE'
			WHEN 'SVCPCP' THEN 'SERVICE'
		END DATECOL
	,	so.OrderDate DATECOLVAL
	,	sty.EmployeeInitials
	,	cl.RemovalDate
	,	cl.RemovalStylist
	,	ROW_NUMBER() OVER(PARTITION BY cl.ClientGUID, sc.SalesCodeDescriptionShort ORDER BY so.OrderDate ASC) AS RANKING
	FROM datSalesOrderDetail sod
		INNER JOIN datSalesOrder so
			ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN #Clients cl
			ON cl.ClientGUID = so.ClientGUID
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		LEFT OUTER JOIN datEmployee sty
			ON sty.EmployeeGUID = sod.Employee2GUID
	WHERE sc.SalesCodeDescriptionShort IN ( 'CKUPRE', 'CKU24', 'CKUPCP', 'SVC', 'SVCPCP' )


	--FINAL OUTPUT
	SELECT ClientGUID
	,	ClientFullNameCalc
	,	SaleDate
	,	CurrentMembership
	,	CONVERT(VARCHAR, MAX(CASE DATECOL WHEN 'PRECHECK' THEN DATECOLVAL ELSE NULL END), 101) AS PreCheckDate
	,	MAX(CASE DATECOL WHEN 'PRECHECK' THEN EmployeeInitials ELSE '' END) AS PreCheckStylist
	,	MAX(CASE DATECOL WHEN 'CHECK24' THEN DATECOLVAL ELSE NULL END) AS Check24Date
	,	MAX(CASE DATECOL WHEN 'CHECK24' THEN EmployeeInitials ELSE '' END) AS Check24Stylist
	,	NB1AppDate
	,	NB1AppStylist
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 1 THEN DATECOLVAL ELSE NULL END) AS Check1Date
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 1 THEN EmployeeInitials ELSE '' END) AS Check1Stylist
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 2 THEN DATECOLVAL ELSE NULL END) AS Check2Date
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 2 THEN EmployeeInitials ELSE '' END) AS Check2Stylist
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 3 THEN DATECOLVAL ELSE NULL END) AS Check3Date
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 3 THEN EmployeeInitials ELSE '' END) AS Check3Stylist
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 4 THEN DATECOLVAL ELSE NULL END) AS Check4Date
	,	MAX(CASE WHEN DATECOL = 'CHECKUP' AND RANKING = 4 THEN EmployeeInitials ELSE '' END) AS Check4Stylist
	,	MAX(CASE WHEN DATECOL = 'SERVICE' AND RANKING = 1 THEN DATECOLVAL ELSE NULL END) AS Service1Date
	,	MAX(CASE WHEN DATECOL = 'SERVICE' AND RANKING = 1 THEN EmployeeInitials ELSE '' END) AS Service1Stylist
	,	MAX(CASE WHEN DATECOL = 'SERVICE' AND RANKING = 2 THEN DATECOLVAL ELSE NULL END) AS Service2Date
	,	MAX(CASE WHEN DATECOL = 'SERVICE' AND RANKING = 2 THEN EmployeeInitials ELSE '' END) AS Service2Stylist
	,	MAX(CASE WHEN DATECOL = 'SERVICE' AND RANKING = 3 THEN DATECOLVAL ELSE NULL END) AS Service3Date
	,	MAX(CASE WHEN DATECOL = 'SERVICE' AND RANKING = 3 THEN EmployeeInitials ELSE '' END) AS Service3Stylist
	,	RemovalDate
	,	RemovalStylist
	FROM #PIV
	GROUP BY ClientGUID
	,	ClientFullNameCalc
	,	SaleDate
	,	CurrentMembership
	,	NB1AppDate
	,	NB1AppStylist
	,	RemovalDate
	,	RemovalStylist
	ORDER BY ClientFullNameCalc

END
GO
