/* CreateDate: 03/13/2013 12:17:40.190 , ModifyDate: 03/13/2013 12:17:40.190 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[RegexReplace](@input [nvarchar](4000), @pattern [nvarchar](4000), @replacement [nvarchar](4000))
RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [Oncontact.PSO.Common].[UserDefinedFunctions].[RegexReplace]
GO
