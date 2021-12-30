/* CreateDate: 12/11/2012 14:57:18.827 , ModifyDate: 12/11/2012 14:57:18.827 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetSourceList

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetSourceList

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetSourceList
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetSourceList]
AS
BEGIN
	SET NOCOUNT ON

	--added distinct statement because table has duplicate data
	SELECT DISTINCT LTRIM(RTRIM(s.source_code)) AS 'ID', LTRIM(RTRIM(mss.SourceName)) AS 'Description'
	FROM    HCMSkylineTest..onca_source s
			INNER JOIN HCBOSMarketing..MediaSourceSources mss ON s.source_code = mss.SourceCode
	WHERE   ISNULL(mss.IsInHouseSourceFlag, 'N') = 'Y'
	ORDER BY ID

END
GO
