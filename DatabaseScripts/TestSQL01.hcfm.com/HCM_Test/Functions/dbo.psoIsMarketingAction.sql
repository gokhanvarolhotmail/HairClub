/* CreateDate: 01/03/2013 10:22:38.760 , ModifyDate: 01/03/2013 10:22:38.760 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[psoIsMarketingAction]
(
	@ActionCode NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @is_marketing_activity NCHAR(1)

	IF(@ActionCode IN ('CANCELCALL','NOSHOWCALL','OUTSELECT'))
		SET @is_marketing_activity = 'Y'
	ELSE
		SET @is_marketing_activity = 'N'

	RETURN @is_marketing_activity
END
GO
