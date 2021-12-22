/* CreateDate: 09/16/2019 10:43:16.140 , ModifyDate: 11/08/2019 09:35:58.703 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					James Lee
IMPLEMENTOR:			James Lee
DATE IMPLEMENTED:		9/12/2019
DESCRIPTION:			9/12/2019
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_EZPayStatus 'C',  '06/01/2019', '9/30/2019', 2
EXEC spRpt_EZPayStatus 'F',  '06/01/2019', '9/30/2019', 2
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_EZPayStatus]
--(
--	@sType CHAR(1)
--,	@begdt SMALLDATETIME
--,	@enddt SMALLDATETIME
--,	@Filter INT
--)

AS

BEGIN

SET NOCOUNT ON;
SET FMTONLY OFF;


CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
,   Sort       INT
)

/********************************** Get list of centers *************************************/


--	IF @sType = 'C' AND @Filter = 2  --By Area Managers
--	BEGIN
--		INSERT  INTO #Centers
--				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
--				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
--				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
--				,		DC.CenterNumber
--				,		DC.CenterSSID
--				,		DC.CenterDescription
--				,		DC.CenterDescriptionNumber
--				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--							ON CT.CenterTypeKey = DC.CenterTypeKey
--						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
--							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
--				WHERE	DC.Active = 'Y'
--				AND CMA.Active = 'Y'
--				AND CT.CenterTypeDescriptionShort IN ( 'C','HW')
--	END
--	IF @sType = 'C' AND @Filter = 3  -- By Centers
--	BEGIN
--		INSERT  INTO #Centers
--				SELECT  DC.CenterNumber AS 'MainGroupID'
--				,		DC.CenterDescriptionNumber AS 'MainGroup'
--				,		DC.CenterNumber AS 'MainGroupSortOrder'
--				,		DC.CenterNumber
--				,		DC.CenterSSID
--				,		DC.CenterDescription
--				,		DC.CenterDescriptionNumber
--				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--							ON CT.CenterTypeKey = DC.CenterTypeKey
--				WHERE	DC.Active = 'Y'
--						AND CT.CenterTypeDescriptionShort IN ( 'C','HW')
--						AND DC.CenterNumber <> 100 --Remove Corporate
--	END


--IF @sType = 'F'  --Always By Regions for Franchises
--	BEGIN
--		INSERT  INTO #Centers
--				SELECT  DR.RegionSSID AS 'MainGroupID'
--				,		DR.RegionDescription AS 'MainGroup'
--				,		DR.RegionSortOrder AS 'MainGroupSortOrder'
--				,		DC.CenterNumber
--				,		DC.CenterSSID
--				,		DC.CenterDescription
--				,		DC.CenterDescriptionNumber
--				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--							ON CT.CenterTypeKey = DC.CenterTypeKey
--						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
--							ON DC.RegionSSID = DR.RegionSSID
--				WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
--						AND DC.Active = 'Y'
--	END


		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				,       1
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE	DC.Active = 'Y'
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ( 'C','HW')

				UNION

				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DR.RegionSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				,       2
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
				WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'


SELECT
		MainGroupID
,		MainGroup
,		MainGroupSortOrder
,       ctr.CenterDescription
,       cl.ClientFullName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(15)) + ')'  AS 'ClientFullName'
,       MAX(ClientMembershipBeginDate) AS 'ClientMembershipBeginDate'
,       MAX(ClientMembershipContractPrice) AS 'ClientMembershipContractPrice'
,       MAX(ClientMembershipContractPaidAmount) 'ClientMembershipContractPaidAmount'    -- paid to date
,       MAX(SOD.Discount) AS 'Discount'
,       MAX(emp.EmployeeFullName) AS 'Employee'
--,       MAX(CASE WHEN SC.SalesCodeDescription = 'Assign Membership' THEN emp.EmployeeFullName ELSE emp.EmployeeFullName END) AS 'Employee'
,       MAX(clm.ClientMembershipMonthlyFee) AS 'Monthly Fee'
,       MAX(CASE WHEN cleft.ClientEFTGUID IS NULL THEN
               'NO EFT PROFILE'
           ELSE
               'Good'
        END) AS 'EFT Status'
,       MAX(CASE WHEN SC.SalesCodeDepartmentSSID = 5010 THEN 'Applied' ELSE '' END) AS 'AppliedStatus'
,       MAX(So.InvoiceNumber) AS InvoiceNumber
,       Sort

		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm        WITH ( NOLOCK )
		   INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M       WITH ( NOLOCK )
				  ON M.MembershipKey = clm.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so         WITH ( NOLOCK )
			ON so.ClientMembershipSSID = clm.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod  WITH ( NOLOCK )
			ON sod.SalesOrderSSID = so.SalesOrderSSID
		   --INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		   --     ON FST.SalesOrderDetailKey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc          WITH ( NOLOCK )
			ON sc.SalesCodeSSID = sod.SalesCodeSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr            WITH ( NOLOCK )
			ON ctr.CenterSSID = so.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma     WITH ( NOLOCK )
			ON ctr.CenterManagementAreaSSID = cma.CenterManagementAreaSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl             WITH ( NOLOCK )
			ON clm.ClientSSID = cl.ClientSSID
		INNER JOIN #Centers c                                        WITH ( NOLOCK )
		    ON ctr.centerssid = c.Centerssid
		--LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee emp
		--    ON emp.EmployeeSSID = sod.Employee1SSID
  	    LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee emp     WITH ( NOLOCK )
			--ON emp.EmployeeKey = FST.Employee1Key
			ON emp.EmployeeKey = SO.EmployeeKey
			--ON emp.EmployeeSSID = SOD.Employee2SSID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datClientEFT cleft  WITH ( NOLOCK )
			ON cleft.ClientMembershipGUID = clm.ClientMembershipSSID
		WHERE    M.MembershipDescriptionShort IN ( 'GRDSVEZ' )  --membership 285
						   --AND CenterNumber = 241
							   --AND ClientLastName = 'Atuahene'
							   AND (sc.SalesCodeDepartmentSSID = 1010 OR sc.SalesCodeDepartmentSSID = 5010)
							   AND so.IsVoidedFlag = 0
							   --AND ClientMembershipBeginDate between @begdt and @enddt
							   --AND sc.SalesCodeDescription = 'Assign Membership'
		GROUP BY
		Sort
,		MainGroupID
,		MainGroup
,		MainGroupSortOrder
,       ctr.CenterDescription
,       cl.ClientFullName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(15)) + ')'


--		ORDER BY
--		Sort


END
GO
