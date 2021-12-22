/* CreateDate: 07/12/2011 13:41:32.860 , ModifyDate: 07/15/2011 13:21:10.070 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spRpt_SurgeryCommissionsByCenter
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Marlon Burrell
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			5/21/2009
-- Date Implemented:		5/21/2009
-- Date Last Modified:		5/21/2009
--
-- Destination Server:		HCSQL2\SQL2005
-- Destination Database:	Helios10
-- Related Application:		Surgery Commissions Report
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 07/13/2009 - DL	--> Initial Query was NOT using the ClientHomeCenterID on the datSalesOrder
					--> table. This resulted in valid surgery transactions not being selected.
					--> The query has been changed to now search only on the ClientHomeCenterID.
--
-- 07/20/2009 - DL	--> Excluded Surgery Closeout transactions from results.
--
-- 07/23/2009 - DL	--> Implemented REVISED Surgery Closeout Exclusions SQL.
-- 07/12/2011 - KM  --> Migrated version to SQL06
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spRpt_SurgeryCommissionsByCenter 545, '6/1/2011', '6/30/2011'
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryCommissionsByCenter]
(
	@CenterNumber INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT OFF;
	SET FMTONLY OFF;

	SET @EndDate = @EndDate + ' 23:59:59'
	SELECT
			CTR.CenterSSID as 'CenterID'
		,	CLHCTR.CenterSSID
		,	CTR.CenterDescriptionNumber as 'CenterDescriptionFullCalc'
		,	CL.ClientGUID as 'ClientGUID'
		,	CL.ClientName as 'ClientName'
		,	CLM.ClientMembershipSSID as 'ClientMembershipGUID'
		,	CLM.MembershipSSID as 'MembershipID'
		,	CL.Membership as 'Membership'
		,	CL.MembershipStartDate as 'SaleDate'
		,	CL.SurgeryDate as 'SurgeryDate'
		,	FSI.SalesCodeKey
		,	fsi.Employee1Key
		,	SalesCodeDepartmentSSID
		,	MAX(CASE CLM.[MembershipSSID]
						  WHEN 43 THEN 0.04
						  WHEN 44 THEN 0.06
						  ELSE 0
			END) AS 'CommissionRate'
		,	MAX(CL.ContractPaid) as ' TotalMembershipPayment'
		,	MAX(ISNULL(POSTEXT.PostEXTPmt, 0)) as 'TotalPostExtPayment'
		,	MAX(ISNULL(CL.ContractPaid, 0)) + MAX(ISNULL(POSTEXT.PostEXTPmt, 0)) as 'TotalPayment'
		,	MAX(CASE CLM.[MembershipSSID] WHEN 43 THEN 0.04 WHEN 44 THEN 0.06 ELSE 0 END)
			* (MAX(ISNULL(CL.ContractPaid, 0)) + MAX(ISNULL(POSTEXT.PostEXTPmt, 0))) as 'Commission'
		,	EMP.EmployeeInitials + ' - ' + EMP.EmployeeFullName as 'Performer'
	FROM
		dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo FSI
			INNER JOIN dbo.vw_SurgeryClients CL on
				FSI.ClientKey = CL.ClientKey
			INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR on
				FSI.CenterKey = CTR.CenterKey
			INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CLHCTR on
				FSI.ClientHomeCenterKey = CLHCTR.CenterKey
			INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM ON
				FSI.ClientMembershipKey = CLM.ClientMembershipKey
			INNER JOIN (SELECT ClientMembershipKey,Employee1Key				--Get Assigned Salesperson
							FROM synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo
								WHERE SalesCodeDepartmentSSID IN (1010,1075,1090)) SALE
					ON FSI.ClientMembershipKey = SALE.ClientMembershipKey
			LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimEmployee EMP on
				SALE.Employee1Key = EMP.EmployeeKey
			LEFT OUTER JOIN (SELECT ClientMembershipKey,sum([SF-Total_POSTEXTPMT]) AS 'PostEXTPmt'
							FROM synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo
								WHERE SalesCodeDepartmentSSID IN (2025) GROUP BY ClientMembershipKey) POSTEXT
					ON FSI.ClientMembershipKey = POSTEXT.ClientMembershipKey
	WHERE
		SalesCodeDepartmentSSID IN (5060)
		AND CLHCTR.CenterSSID = @CenterNumber
		AND FSI.OrderDate between @StartDate and @EndDate

	GROUP BY
			CTR.CenterSSID
		,   CLHCTR.CenterSSID
		,	CTR.CenterDescriptionNumber
		,	CL.ClientGUID
		,	CL.ClientName
		,	CLM.ClientMembershipSSID
		,	CLM.MembershipSSID
		,	CL.Membership
		,	CL.MembershipStartDate
		,	CL.SurgeryDate
		,	FSI.SalesCodeKey
		,	fsi.Employee1Key
		,	SalesCodeDepartmentSSID
		,	EMP.EmployeeInitials
		,	EMP.EmployeeFullName
	ORDER BY
			CTR.CenterSSID
		,	CL.ClientName
END
GO
