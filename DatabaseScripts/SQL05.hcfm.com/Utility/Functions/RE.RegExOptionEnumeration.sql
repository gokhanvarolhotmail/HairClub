/* CreateDate: 02/24/2022 11:43:07.777 , ModifyDate: 02/24/2022 11:43:07.777 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExOptionEnumeration](@IgnoreCase [bit], @MultiLine [bit], @ExplicitCapture [bit], @Compiled [bit], @SingleLine [bit], @IgnorePatternWhitespace [bit], @RightToLeft [bit], @ECMAScript [bit], @CultureInvariant [bit])
RETURNS [int] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExOptionEnumeration]
GO
