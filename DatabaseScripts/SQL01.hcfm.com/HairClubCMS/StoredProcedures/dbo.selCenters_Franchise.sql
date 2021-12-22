/*===============================================================================================
 Procedure Name:            [selCenters_Franchise]
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              01/28/2014
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
This stored procedure is used in the report InterCompanyTransactions to find the "Single other center" if needed.
It creates either NULL values or a drop-down of all active centers.
================================================================================================
Sample Execution:

EXEC [selCenters_Franchise] 'A'
EXEC [selCenters_Franchise] 'C'
EXEC [selCenters_Franchise] 'F'
EXEC [selCenters_Franchise] 'S'

================================================================================================
*/

CREATE PROCEDURE [dbo].[selCenters_Franchise]
	@OtherCenter VARCHAR(1)

AS
BEGIN

	IF @OtherCenter IN('A','C','F')
	BEGIN
		SELECT NULL AS [Value], NULL AS [Description]
	END
	ELSE
	BEGIN

		SELECT  C.CenterID AS [Value]
			,	C.CenterDescriptionFullCalc AS [Description]
		FROM dbo.cfgCenter C
		WHERE CONVERT(VARCHAR, C.CenterID) LIKE '[78]%'
						AND C.IsActiveFlag = 1
		ORDER BY value
	END

END
