/* CreateDate: 01/03/2013 10:22:39.260 , ModifyDate: 01/03/2013 10:22:39.260 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[psoGetNextCenterOpening](@companyId [nvarchar](4000), @date [datetime])
RETURNS [datetime] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Oncontact.PSO.BusinessLogic].[UserDefinedFunctions].[psoGetNextCenterOpening]
GO
