/* CreateDate: 09/22/2008 15:04:45.377 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetCompanyID
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/18/2008
-- Date Implemented:		7/18/2008
-- Date Last Modified:		7/18/2008
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
EXEC spApp_TREConsultations_GetCompanyID
================================================================================================*/
CREATE PROCEDURE spApp_TREConsultations_GetCompanyID
(
	@CenterNumber INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  [company_id]
	FROM    [HCM].[dbo].[oncd_company]
	WHERE   [cst_center_number] = @CenterNumber
END
GO
