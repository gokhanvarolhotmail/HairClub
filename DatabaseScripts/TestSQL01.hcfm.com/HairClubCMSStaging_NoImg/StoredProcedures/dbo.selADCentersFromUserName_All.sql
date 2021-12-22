/* CreateDate: 07/31/2014 16:10:27.460 , ModifyDate: 07/31/2014 16:10:27.460 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selADCentersFromUserName_All

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Rachelen Hut

DATE IMPLEMENTED: 		07/30/2014

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the centers the user has access to and includes the choice of All Corporate or All Franchise.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [selADCentersFromUserName_All] 'aptak'

EXEC [selADCentersFromUserName_All] 'jdull'

EXEC [selADCentersFromUserName_All] 'rstivers'

EXEC [selADCentersFromUserName_All] 'lrealejo'

***********************************************************************/

CREATE PROCEDURE [dbo].[selADCentersFromUserName_All] (
	@User VARCHAR(100))
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



	SELECT cu.CenterID, cu.CenterDescription
	FROM [dbo].[fnGetCentersForUser](@User) cu
	WHERE IsSurgeryCenter IS NULL
		UNION
	SELECT cu.CenterID, cu.CenterDescription
	FROM [dbo].[fnGetCentersForUser](@User) cu
		INNER JOIN cfgConfigurationCenter cc on cu.CenterID = cc.CenterID
		INNER JOIN lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	WHERE cbt.CenterBusinessTypeDescriptionShort <> 'Surgery'
	ORDER BY CenterID




END
GO
