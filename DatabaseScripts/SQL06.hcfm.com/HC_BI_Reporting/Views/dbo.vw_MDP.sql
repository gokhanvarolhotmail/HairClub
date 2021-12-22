/***********************************************************************
VIEW:					[vw_MDP]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		7/12/2019
-----------------------------------------------------------------------
NOTES:
This view provides MDP data to Finance per month, per year
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vw_MDP] ORDER BY YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vw_MDP]
AS


WITH Rolling2Years AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.FirstDateOfMonth
				,	DD.MonthNumber
				,	DD.YearNumber
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(yy, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  --First date of year one year ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --KEEP Today at 11:59PM

				--For Testing
				--WHERE DD.FullDate BETWEEN '7/1/2016' AND '7/31/2016'
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.FirstDateOfMonth
				,	DD.MonthNumber
				,	DD.YearNumber
		)

,	Centers AS (SELECT  DC.CenterNumber AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterNumber AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
				WHERE	DC.Active = 'Y'
						AND CT.CenterTypeDescriptionShort IN ( 'C','HW')
						AND DC.CenterNumber <> 100

	    )

SELECT  ROLL.MonthNumber
		,		ROLL.YearNumber
		,		SUM(ISNULL(FST.NB_MDPCnt,0)) AS NB_MDPCnt
		,		SUM(ISNULL(FST.NB_MDPAmt,0)) AS NB_MDPAmt
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN Rolling2Years ROLL
                    ON FST.OrderDateKey = ROLL.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipKey = m.MembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C  --Keep HomeCenter-based
                    ON cm.CenterKey = c.CenterKey
                INNER JOIN Centers
                    ON C.CenterNumber = Centers.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
        WHERE   SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
                AND SO.IsVoidedFlag = 0
GROUP BY ROLL.MonthNumber
		,		ROLL.YearNumber
