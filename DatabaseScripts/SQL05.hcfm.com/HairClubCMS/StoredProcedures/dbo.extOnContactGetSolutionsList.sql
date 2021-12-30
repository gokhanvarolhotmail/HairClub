/* CreateDate: 12/11/2012 14:57:18.817 , ModifyDate: 12/11/2012 14:57:18.817 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetSolutionsList

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetSolutionsList
		* 6/22/2010 PRM - Always include the Surgery option

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetSolutionsList 201
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetSolutionsList]
(
	@CenterNumber int
)
AS
BEGIN
	SET NOCOUNT ON

	--DECLARE @SurgeryCenterNumber int
	--SELECT  @SurgeryCenterNumber = SurgeryHubCenterID FROM cfgCenter WHERE CenterID = @CenterNumber

	SELECT  SolutionsCode, [Description]
	FROM HCBOS..SolutionsOffered
	WHERE   Active = 1 --AND (NOT @SurgeryCenterNumber IS NULL OR SolutionsCode NOT IN ('SUR'))
	ORDER BY SortOrder

END
GO
