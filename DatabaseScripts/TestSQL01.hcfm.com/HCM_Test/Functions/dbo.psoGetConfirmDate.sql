/* CreateDate: 01/03/2013 10:22:38.783 , ModifyDate: 01/03/2013 10:22:38.783 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[psoGetConfirmDate](@date [datetime])
RETURNS [datetime] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Oncontact.PSO.BusinessLogic].[UserDefinedFunctions].[psoGetConfirmDate]
GO
