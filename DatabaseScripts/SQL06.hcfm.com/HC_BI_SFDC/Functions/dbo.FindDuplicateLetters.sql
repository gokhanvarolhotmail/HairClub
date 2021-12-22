/* CreateDate: 09/21/2020 16:49:17.590 , ModifyDate: 09/21/2020 16:49:17.590 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION FindDuplicateLetters
(
    @String NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN

    DECLARE @Result BIT = 0
    DECLARE @Counter INT = 1

    WHILE (@Counter <= LEN(@String) - 1)
    BEGIN


    IF(ASCII((SELECT SUBSTRING(@String, @Counter, 1))) = ASCII((SELECT SUBSTRING(@String, @Counter + 1, 1))))
        BEGIN
             SET @Result = 1
             BREAK
        END


        SET @Counter = @Counter + 1
    END

    RETURN @Result

END
GO
