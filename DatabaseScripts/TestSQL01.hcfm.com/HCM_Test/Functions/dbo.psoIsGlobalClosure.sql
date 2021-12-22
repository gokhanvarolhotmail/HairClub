/* CreateDate: 01/03/2013 10:22:39.290 , ModifyDate: 01/03/2013 10:22:39.290 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[psoIsGlobalClosure](@date [datetime])
RETURNS [bit] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Oncontact.PSO.BusinessLogic].[UserDefinedFunctions].[psoIsGlobalClosure]
GO
