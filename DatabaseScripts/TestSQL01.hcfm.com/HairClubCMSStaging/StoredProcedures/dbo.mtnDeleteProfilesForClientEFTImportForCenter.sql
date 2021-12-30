/* CreateDate: 05/14/2012 17:41:18.223 , ModifyDate: 02/27/2017 09:49:18.917 */
GO
/***********************************************************************

PROCEDURE:				mtnDeleteProfilesForClientEFTImportForCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 5/14/2012

LAST REVISION DATE: 	 5/14/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 5/14/12 MLM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnDeleteProfilesForClientEFTImportForCenter 201

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnDeleteProfilesForClientEFTImportForCenter]
	@CenterId int
AS
BEGIN
	SET NOCOUNT ON


			/*Delete Record(s) Do not Exists in CMS 2.6*/
			DELETE FROM dbo.datClientEFT
			FROM dbo.datClientEFT
				INNER JOIN dbo.datClient AS c ON dbo.datClientEFT.ClientGUID = c.ClientGUID
				LEFT OUTER JOIN	[HCSQL2\SQL2005].EFT.dbo.hcmtbl_EFT AS eft ON c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
			WHERE (eft.Client_No IS NULL)
				AND c.CenterID = @CenterId

END
GO
