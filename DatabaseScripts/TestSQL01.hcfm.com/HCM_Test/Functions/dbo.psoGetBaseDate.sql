/* CreateDate: 01/03/2013 10:22:39.193 , ModifyDate: 01/03/2013 10:22:39.193 */
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
CREATE FUNCTION [dbo].[psoGetBaseDate]
(
	@Date DATETIME
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @BaseDate DATETIME

	SET @BaseDate = DATEADD(DAY, DATEDIFF(DAY, 0, @Date), 0)

	-- Return the result of the function
	RETURN @BaseDate

END
GO
