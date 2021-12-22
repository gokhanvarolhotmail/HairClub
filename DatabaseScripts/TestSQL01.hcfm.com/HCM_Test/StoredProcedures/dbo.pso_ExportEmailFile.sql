/* CreateDate: 08/20/2014 09:34:51.903 , ModifyDate: 08/20/2014 09:34:51.903 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pso_ExportEmailFile]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Oncontact.PSO.EmailExport].[Oncontact.PSO.EmailExport.StoredProcedure].[pso_ExportEmailFile]
GO
