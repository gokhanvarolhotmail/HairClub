/* CreateDate: 05/09/2014 09:40:37.287 , ModifyDate: 08/24/2016 11:37:53.313 */
GO
/***********************************************************************
FUNCTION: GetFirstVisitDate

DESTINATION SERVER: SQL06

DESTINATION DATABASE: HC_BI_Reporting

IMPLEMENTOR: Marlon Burrell

--------------------------------------------------------------------------------------------------------
NOTES:

10/21/2013 - MB - Added logic to ignore NonProgram if EXT is valid and to default to BIO if all conditions fail
08/24/2016 - RH - Commented out the reference to HCSQL2\SQL2005
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:

SELECT [dbo].[GetFirstVisitDate] (745, NULL, 399199)
***********************************************************************/
CREATE FUNCTION [dbo].[GetFirstVisitDate]
(
	@CenterSSID INT,
	@ClientIdentifierCMS INT,
	@ClientIdentifier INT
)
RETURNS DATETIME
AS
BEGIN

DECLARE @FirstVisit DATETIME


-- Get First Visit From cONEct
--IF ( @ClientIdentifierCMS IS NULL ) AND ( @ClientIdentifier IS NOT NULL )
IF @ClientIdentifier IS NOT NULL
   BEGIN
         SELECT @FirstVisit = MIN(DD.FullDate)
         FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
                    ON FST.CenterKey = CTR.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
                    ON FST.ClientKey = CLT.ClientKey
         WHERE  CLT.ClientIdentifier = @ClientIdentifier
   END


-- Get First Visit From INFOSTORE
--IF ( @ClientIdentifierCMS IS NOT NULL )
--   BEGIN
--         SELECT @FirstVisit = MIN([Date])
--         FROM   [HCSQL2\SQL2005].INFOSTORE.dbo.Transactions T
--         WHERE  T.Center = @CenterSSID
--                AND T.client_no = @ClientIdentifierCMS
--   END


RETURN @FirstVisit

END
GO
