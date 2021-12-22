/* CreateDate: 01/03/2013 10:22:39.287 , ModifyDate: 01/03/2013 10:22:39.287 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[psoIsCenterOpen](@companyId [nvarchar](4000), @date [datetime])
RETURNS [bit] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Oncontact.PSO.BusinessLogic].[UserDefinedFunctions].[psoIsCenterOpen]
GO
