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
EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'psoCenterOpen.cs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'psoGetNextCenterOpening'
GO
EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=N'38' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'psoGetNextCenterOpening'
GO
