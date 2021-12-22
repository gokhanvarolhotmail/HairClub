/***********************************************************************

PROCEDURE:				rptClientList

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Andrew Schwalbe

IMPLEMENTOR: 			Andrew Schwalbe

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns division and department data for a specific center and date range.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptClientList 'John', 'Smith', 301

***********************************************************************/


CREATE PROCEDURE [dbo].[rptClientList]
      @FirstName nvarchar(20) = null,
      @LastName nvarchar(20) = null,
      @CenterID int = null
AS
BEGIN
      SET NOCOUNT ON;

      SELECT *
      FROM datClient
      WHERE (@FirstName IS NULL OR FirstName Like @FirstName + '%')
              AND (@LastName IS NULL OR LastName Like @LastName + '%')
              AND (@CenterID IS NULL OR CenterID = @CenterID)
      ORDER BY LastName ASC, FirstName ASC, CenterID ASC

END
