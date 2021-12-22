/* CreateDate: 05/14/2012 17:40:59.973 , ModifyDate: 02/27/2017 09:49:20.087 */
GO
/***********************************************************************

PROCEDURE:				mtnGetCenterlistForClientEFTImport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 2/1/12 MLM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnGetCenterlistForClientEFTImport

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnGetCenterlistForClientEFTImport]
AS
BEGIN
	SET NOCOUNT ON


	Select DISTINCT c.CenterID
	From [HCSQL2\SQL2005].EFT.dbo.hcmtbl_EFT eft
		INNER JOIN cfgCenter c on eft.Center = c.CenterID
		INNER JOIN lkpCenterType cType on c.CenterTypeID = ctype.CenterTypeID
	WHERE cType.CenterTypeDescriptionShort = 'C'
	ORDER BY c.CenterID

END
GO
