/* CreateDate: 05/14/2012 17:40:59.900 , ModifyDate: 02/27/2017 09:49:18.223 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnConfigurationApplicationUpdateEFTDate

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

EXEC mtnConfigurationApplicationUpdateEFTDate

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnConfigurationApplicationUpdateEFTDate]
AS
BEGIN
	SET NOCOUNT ON


	Update cfgConfigurationApplication
		SET LastUpdateClientEFT = GETDATE()
		,LastUpdate = GETUTCDATE()
		,lastUpdateUser = convert(nvarchar,'sa')
	FROM cfgConfigurationApplication

END
GO
