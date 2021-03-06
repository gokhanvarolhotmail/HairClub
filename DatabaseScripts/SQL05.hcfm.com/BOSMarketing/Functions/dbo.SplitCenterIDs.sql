/* CreateDate: 07/30/2015 15:51:14.953 , ModifyDate: 07/30/2015 15:51:14.953 */
GO
-- =============================================
-- Author:		Howard Abelow
-- Create date: 1/4/2007
-- Description: UDF to split comma separated lists into individual items.
--					Used to parse a multiple list of centers. Returns a
--					table variable which can be joined to a select statement
--					fltering on multiple centers
-- =============================================
--	SELECT * FROM dbo.SplitCenterIDs ('201, 31, 205, 212')
-- =============================================
CREATE FUNCTION [dbo].[SplitCenterIDs]
(
	@CenterList varchar(1000)
)
RETURNS
@ParsedList table
(
	CenterNumber int
)
AS
BEGIN
	DECLARE @CenterNumber varchar(3), @Pos int

	SET @CenterList = LTRIM(RTRIM(@CenterList))+ ','
	SET @Pos = CHARINDEX(',', @CenterList, 1)

	IF REPLACE(@CenterList, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @CenterNumber = LTRIM(RTRIM(LEFT(@CenterList, @Pos - 1)))
			IF @CenterNumber <> ''
			BEGIN
				INSERT INTO @ParsedList (CenterNumber)
				VALUES (CAST(@CenterNumber AS int)) --Use Appropriate conversion
			END
			SET @CenterList = RIGHT(@CenterList, LEN(@CenterList) - @Pos)
			SET @Pos = CHARINDEX(',', @CenterList, 1)

		END
	END
	RETURN
END
GO
