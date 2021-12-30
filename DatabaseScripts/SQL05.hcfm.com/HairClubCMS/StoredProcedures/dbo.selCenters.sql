/* CreateDate: 02/04/2014 15:11:49.927 , ModifyDate: 02/04/2014 15:11:49.927 */
GO
/*===============================================================================================
 Procedure Name:            selCenters
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

EXEC [selCenters] 'A'
EXEC [selCenters] 'C'
EXEC [selCenters] 'F'
EXEC [selCenters] 'S'

================================================================================================
*/

CREATE PROCEDURE [dbo].[selCenters]
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
		WHERE CONVERT(VARCHAR, C.CenterID) LIKE '[278]%'
						AND C.IsActiveFlag = 1
		ORDER BY value
	END

END
GO
