/* CreateDate: 09/22/2008 15:06:14.877 , ModifyDate: 01/25/2010 08:11:31.743 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetMaritalStatusList
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
EXEC spApp_TREConsultations_GetMaritalStatusList
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetMaritalStatusList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  [MaritalStatusCode]
	,       [Description]
	FROM    [ContactMaritalStatus]
	WHERE   [Active] = 1
	ORDER BY [SortOrder]
END
GO
