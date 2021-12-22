/* CreateDate: 05/14/2012 17:41:00.050 , ModifyDate: 02/27/2017 09:49:18.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnDeleteProfilesForClientEFTImport

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

EXEC mtnDeleteProfilesForClientEFTImport

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnDeleteProfilesForClientEFTImport]
AS
BEGIN
	SET NOCOUNT ON


			/*Delete Record(s) Do not Exists in CMS 2.6*/
			DELETE FROM dbo.datClientEFT
			FROM dbo.datClientEFT
				INNER JOIN dbo.datClient AS c ON dbo.datClientEFT.ClientGUID = c.ClientGUID
				LEFT OUTER JOIN	[HCSQL2\SQL2005].EFT.dbo.hcmtbl_EFT AS eft ON c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
			WHERE (eft.Client_No IS NULL)

END
GO
