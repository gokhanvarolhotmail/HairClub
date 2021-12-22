/* CreateDate: 09/25/2009 17:31:13.160 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetSolutionsList
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/29/2008
-- Date Implemented:		7/29/2008
-- Date Last Modified:		7/29/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_GetSolutionsList 201
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetSolutionsListTEST]
(
	@CenterNumber INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SurgeryCenterNumber INT

	SELECT  @SurgeryCenterNumber = [SurgeryCenterNumber]
	FROM    [hcsql2\sql2005].[HCFMDirectory].[dbo].[tblCenter]
	WHERE	[Center_Num] = @CenterNumber

	IF @SurgeryCenterNumber IS NULL
	  BEGIN
		SELECT  [SolutionsCode]
		,       [Description]
		FROM    [SolutionsOffered]
		WHERE   [Active] = 1
				AND [SolutionsCode] NOT IN ( 'SUR' )
		ORDER BY [SortOrder]
	  END
	ELSE
	  BEGIN
		SELECT  [SolutionsCode]
		,       [Description]
		FROM    [SolutionsOffered]
		WHERE   [Active] = 1
		ORDER BY [SortOrder]
	  END
END
GO
