/* CreateDate: 09/22/2008 15:07:07.780 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetSourceList
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
--
-- 11/10/2009 - DL	--> Changed procedure to display the description from Marketing tool instead
					--> of the source code
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_GetSourceList
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetSourceList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  '' AS 'ID'
	,       '-- Select a Source --' AS 'Description'
	UNION
	SELECT  LTRIM(RTRIM([onca_source].[source_code])) AS 'ID'
	,       LTRIM(RTRIM([MediaSourceSources].[SourceName])) AS 'Description'
	FROM    [HCM].[dbo].[onca_source]
			INNER JOIN [BOSMarketing].[dbo].[MediaSourceSources]
			  ON [onca_source].[source_code] = [MediaSourceSources].[SourceCode]
	WHERE   ISNULL([MediaSourceSources].[IsInHouseSourceFlag], 'N') = 'Y'
	ORDER BY [ID]
END
GO
