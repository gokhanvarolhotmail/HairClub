/* CreateDate: 12/11/2012 14:57:18.807 , ModifyDate: 12/11/2012 14:57:18.807 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetSalesTypeList

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetSalesTypeList
		* 6/22/2010 PRM - Always include the surgery option

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetSalesTypeList 201
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetSalesTypeList]
(
	@CenterNumber int
)
AS
BEGIN
	SET NOCOUNT ON

	--DECLARE @SurgeryCenterNumber int
	--SELECT  @SurgeryCenterNumber = SurgeryHubCenterID FROM cfgCenter WHERE CenterID = @CenterNumber

	SELECT SalesTypeCode, [Description]
	FROM HCBOS..ContactSalesType
	WHERE Active = 1 --AND (NOT @SurgeryCenterNumber IS NULL OR SalesTypeCode NOT IN (4))
	ORDER BY SortOrder
END
GO
