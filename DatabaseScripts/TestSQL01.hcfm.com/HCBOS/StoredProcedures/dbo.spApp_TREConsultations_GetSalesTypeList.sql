/* CreateDate: 09/22/2008 15:06:47.203 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetSalesTypeList
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
EXEC spApp_TREConsultations_GetSalesTypeList 201
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetSalesTypeList]
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
	FROM    [HCSQL2\SQL2005].[HCFMDirectory].[dbo].[tblCenter]
	WHERE	[Center_Num] = @CenterNumber

	IF @SurgeryCenterNumber IS NULL
	  BEGIN
		SELECT  [SalesTypeCode]
		,       [Description]
		FROM    [ContactSalesType]
		WHERE   [Active] = 1
				AND [SalesTypeCode] NOT IN ( 4 )
		ORDER BY [SortOrder]
	  END
	ELSE
	  BEGIN
		SELECT  [SalesTypeCode]
		,       [Description]
		FROM    [ContactSalesType]
		WHERE   [Active] = 1
		ORDER BY [SortOrder]
	  END
END
GO
