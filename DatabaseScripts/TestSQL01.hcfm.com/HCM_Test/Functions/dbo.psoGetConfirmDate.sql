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
EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'psoCenterOpen.cs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'psoGetConfirmDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'psoGetConfirmDate'
GO
