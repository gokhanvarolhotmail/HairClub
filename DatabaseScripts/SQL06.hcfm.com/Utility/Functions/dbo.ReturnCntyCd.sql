/* CreateDate: 02/24/2022 11:43:20.673 , ModifyDate: 02/24/2022 11:43:20.673 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ReturnCntyCd](@CntyCd [nchar](5))
RETURNS  TABLE (
	[CntyCd] [nchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.ParseDelimitedclass].[ReturnCntyCd]
GO
