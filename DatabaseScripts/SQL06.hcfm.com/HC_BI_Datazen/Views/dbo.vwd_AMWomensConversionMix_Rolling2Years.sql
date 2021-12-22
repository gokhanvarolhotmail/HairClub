/* CreateDate: 02/23/2016 15:29:55.613 , ModifyDate: 01/09/2018 14:59:42.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_AMWomensConversionMix_Rolling2Years
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			02/17/2016
------------------------------------------------------------------------
NOTES: This view is being used in the Area Manager Datazen dashboard
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_AMWomensConversionMix_Rolling2Years ORDER BY CenterSSID, YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwd_AMWomensConversionMix_Rolling2Years]
AS

WITH Rolling2Years AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
					AND GETDATE() -- Today
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
)
,	Conversions AS (SELECT C.CenterSSID
					,	ROLL.FirstDateOfMonth
					,	ROLL.YearNumber
					,	ROLL.MonthNumber
					,	SUM(CASE WHEN CMNEW.MembershipSSID IN(63,64) THEN FST.NB_BIOConvCnt ELSE 0 END) AS 'Ruby'
					,	SUM(CASE WHEN CMNEW.MembershipSSID IN(65,66) THEN FST.NB_BIOConvCnt ELSE 0 END) AS 'Emerald'
					,	SUM(CASE WHEN CMNEW.MembershipSSID IN(67,68) THEN FST.NB_BIOConvCnt ELSE 0 END) AS 'Sapphire'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						INNER JOIN Rolling2Years ROLL
							ON FST.OrderDateKey = ROLL.DateKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
							ON FST.SalesOrderKey = SO.SalesOrderKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CMNEW
							ON SO.ClientMembershipKey = CMNEW.ClientMembershipKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership NEW
							ON CMNEW.MembershipKey = NEW.MembershipKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
							ON CMNEW.CenterKey = C.CenterKey       --KEEP HomeCenter Based to match the Recurring Flash
					WHERE   CMNEW.MembershipSSID IN(63,64,65,66,67,68)
					AND C.CenterSSID <> 100
					GROUP BY c.CenterSSID
					,	ROLL.FirstDateOfMonth
					,	ROLL.YearNumber
					,	ROLL.MonthNumber
)

SELECT CenterSSID, FirstDateOfMonth, YearNumber, MonthNumber, ConvType, QTY
FROM Conversions CONV
UNPIVOT
(QTY
FOR ConvType IN(Ruby,Emerald,Sapphire)
)u;
GO
