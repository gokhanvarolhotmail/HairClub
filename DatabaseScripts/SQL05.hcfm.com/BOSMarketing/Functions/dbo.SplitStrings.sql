/* CreateDate: 07/30/2015 15:51:15.000 , ModifyDate: 07/30/2015 15:51:15.000 */
GO
-- =============================================
-- Author:		Alex Pasieka
-- Create date: 1/28/2009
-- Description: UDF to split comma separated lists into individual items.

-- =============================================
--	SELECT * FROM dbo.SplitStrings ('Test, Not Interested, Has to check with spouse,')
-- =============================================
CREATE FUNCTION [dbo].[SplitStrings]
(
	@List varchar(1000)
)
RETURNS
@ParsedList table
(
	ParsedList VARCHAR(50)
)
AS
BEGIN
	DECLARE @CenterNumber varchar(50), @Pos int

	SET @List = LTRIM(RTRIM(@List))+ ','
	SET @Pos = CHARINDEX(',', @List, 1)

	IF REPLACE(@List, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @CenterNumber = LTRIM(RTRIM(LEFT(@List, @Pos - 1)))
			INSERT INTO @ParsedList (ParsedList)
			VALUES (CAST(@CenterNumber AS varchar))
			SET @List = RIGHT(@List, LEN(@List) - @Pos)
			SET @Pos = CHARINDEX(',', @List, 1)

		END
	END
	RETURN
END
GO
