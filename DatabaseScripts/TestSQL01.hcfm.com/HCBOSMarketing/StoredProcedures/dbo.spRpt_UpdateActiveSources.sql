/* CreateDate: 11/13/2008 10:49:10.910 , ModifyDate: 01/25/2010 13:09:58.587 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spRpt_UpdateActiveSources
-- Procedure Description:	Update the active and inactive sources in onca_source.
--
-- Created By:				Alex Pasieka
-- Implemented By:
-- Last Modified By:		Alex Pasieka
--
-- Date Created:			10/10/2008
-- Date Implemented:		10/10/2008
-- Date Last Modified:		12/28/2009
--
-- Destination Server:		SQL3
-- Destination Database:	HCM
-- Related Application:		OLPA Media Source
-- MODIFICATIONS

Sample Execution:

EXEC spRpt_UpdateActiveSources
================================================================================================*/
--GRANT EXECUTE ON spRpt_UpdateActiveSources TO iis
CREATE PROCEDURE [dbo].[spRpt_UpdateActiveSources]
AS
BEGIN

	-- Update the active sources in on contact.
	UPDATE [SQL03].hcm.dbo.[onca_source]
	SET [active] = 'Y'
	WHERE RTRIM(source_code) IN (
		SELECT RTRIM(SourceCode)
		FROM [SQL03].[BOSMarketing].dbo.[MediaSourceSources]
		WHERE GETDATE() BETWEEN StartDAte AND [EndDate]	)

	-- Update the inactive sources in on contact.
	UPDATE [SQL03].hcm.dbo.[onca_source]
	SET [active] = 'N'
	WHERE RTRIM(source_code) IN (
		SELECT RTRIM(SourceCode)
		FROM [SQL03].[BOSMarketing].dbo.[MediaSourceSources]
		WHERE GETDATE() NOT BETWEEN StartDAte AND [EndDate]	)
END
GO
