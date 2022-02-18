/* CreateDate: 04/05/2013 08:33:10.900 , ModifyDate: 07/08/2015 12:48:06.910 */
GO
/***********************************************************************

PROCEDURE:	[SpSvc_PopulateDailyReceivableBlanaces]

DESTINATION SERVER:	   SQL06

DESTINATION DATABASE: HC_BI_Reporting

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 11/5/2012

------------------------------------------------------------------------
This procedure populates the daily receivable balances for all clients
------------------------------------------------------------------------

SAMPLE EXEC:
exec [SpSvc_PopulateDailyReceivableBalances]

NOTES

	04/03/2013 KRM Modified to derived Receivables balances from Infostore for noncONEct centers

***********************************************************************/
CREATE PROCEDURE [dbo].[SpSvc_PopulateDailyReceivableBalances] AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


DECLARE @Date DATETIME


SET @Date = CONVERT(DATETIME, CONVERT(VARCHAR(11), dateadd(dd, -1, GETDATE())))


--
-- Insert records on for cONEct Centers
--

INSERT  INTO FactReceivables (
			CenterKey
        ,	DateKey
        ,	ClientKey
        ,	Balance
        ,	PrePaid
		)
        SELECT  C.CenterKey
        ,       DD.DateKey
        ,       CLT.ClientKey
        ,       CLT.ClientARBalance
        ,       0
        FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
                    ON C.CenterSSID = CLT.CenterSSID
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DD.FullDate = @Date
        WHERE   CLT.ClientARBalance <> 0
                AND ( C.HasFullAccessFlag = 1
                      OR C.CenterSSID LIKE '[356]%' )
                AND NOT EXISTS ( SELECT FR.CenterKey
                                 FROM   FactReceivables FR
                                 WHERE  FR.CenterKey = C.CenterKey
                                        AND FR.ClientKey = CLT.ClientKey
                                        AND FR.DateKey = DD.DateKey )


--
-- Insert Records for Non-cONEct Centers
--
--INSERT  INTO FactReceivables (
--			CenterKey
--        ,	DateKey
--        ,	ClientKey
--        ,	Balance
--        ,	PrePaid
--		)
--        SELECT  C.CenterKey
--        ,       DD.DateKey
--        ,       CLT.ClientKey
--        ,       ( RCV.balance - RCV.prepaid )
--        ,       0
--        FROM    [HCSQL2\SQL2005].INFOSTORE.[dbo].[hcmtbl_receivables] RCV
--                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--                    ON RCV.center = C.CenterSSID
--                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
--                    ON C.CenterSSID = CLT.CenterSSID
--                       AND RCV.client_no = CLT.ClientNumber_Temp
--                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--                    ON DD.FullDate = @Date
--        WHERE   CLT.ClientARBalance <> 0
--                AND C.HasFullAccessFlag <> 1
--                AND RCV.[date] = @Date
--                AND NOT EXISTS ( SELECT FR.CenterKey
--                                 FROM   FactReceivables FR
--                                 WHERE  FR.CenterKey = C.CenterKey
--                                        AND FR.ClientKey = CLT.ClientKey
--                                        AND FR.DateKey = DD.DateKey )

END
GO
