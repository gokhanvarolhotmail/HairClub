/* CreateDate: 08/18/2011 16:34:59.857 , ModifyDate: 08/18/2011 16:34:59.857 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Howard Abelow
-- Create date: 1/4/2007
-- Description: UDF to split comma separated lists into individual items.
--					Used to parse a multiple list of centers. Returns a
--					table variable which can be joined to a select statement
--					fltering on multiple centers
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
