/* CreateDate: 02/24/2022 11:43:19.563 , ModifyDate: 02/24/2022 11:43:19.563 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [RE].[RegExMatches](@Pattern [nvarchar](4000), @Input [nvarchar](max), @Options [int])
RETURNS  TABLE (
	[Match] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MatchIndex] [int] NULL,
	[MatchLength] [int] NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.RegularExpressionFunctions].[RegExMatches]
GO
