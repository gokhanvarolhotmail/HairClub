/* CreateDate: 03/21/2022 07:50:08.627 , ModifyDate: 03/21/2022 07:50:08.627 */
GO
CREATE FUNCTION [dbo].[FindDuplicateLetters]
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
