/***********************************************************************
PROCEDURE:				dbaMaintainHairSystemOrders
DESTINATION SERVER:		SQL01/SQL05
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Kevin Murdoch
IMPLEMENTOR: 			Kevin Murdoch
DATE IMPLEMENTED: 		6/6/2011
LAST REVISION DATE: 	6/6/2011

--------------------------------------------------------------------------------------------------------
NOTES:  Use this script to Maintain Hair System Orders.  The execution of this procedure will get
-- Replicated to SQL05.
--------------------------------------------------------------------------------------------------------
***********************************************************************/
CREATE PROCEDURE dbaMaintainHairSystemOrders AS
      UPDATE HSO
            SET ReceivedCorpDate = BOSPROD.Receivdate,
                  ShippedFromCorpDate = BOSPROD.Manifdate
      FROM dathairsystemorder HSO
            LEFT OUTER JOIN [hcsql2\sql2005].BOSProduction.dbo.Orders BOSPROD ON
                  BOSPROD.SerialNumb = HSO.HairSystemOrderNumber
