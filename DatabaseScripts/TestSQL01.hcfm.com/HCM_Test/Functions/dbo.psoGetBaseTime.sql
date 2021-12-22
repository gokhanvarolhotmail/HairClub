/* CreateDate: 01/03/2013 10:22:39.197 , ModifyDate: 01/03/2013 10:22:39.197 */
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
CREATE FUNCTION [dbo].[psoGetBaseTime]
(
	@Date DATETIME
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @BaseTime DATETIME

	-- Add the T-SQL statements to compute the return value here
	SET @BaseTime = DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, dbo.psoGetBaseDate(@Date), @Date), '1/1/1900')

	-- Return the result of the function
	RETURN @BaseTime

END
GO
