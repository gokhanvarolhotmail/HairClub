/* CreateDate: 01/03/2014 07:07:50.407 , ModifyDate: 01/03/2014 07:07:50.407 */
GO
CREATE FUNCTION [snapshots].[fn_hexstrtovarbin]
(
    @hexStr varchar(max)
)
RETURNS varbinary(max)
AS
BEGIN
    DECLARE @ret varbinary(max)
    DECLARE @len int

    SET @ret = 0x;
    SET @len = LEN (@hexStr)-2;

    IF (@len >= 0) AND (LEFT (@hexStr, 2) = '0x')
        SET @hexStr = SUBSTRING (@hexStr, 3, @len);
    ELSE
        RETURN NULL;

    DECLARE @leftNibbleChar char(1), @rightNibbleChar char(1), @hexCharStr varchar(2)
    DECLARE @leftNibble int, @rightNibble int
    DECLARE @i int;
    SET @i = 1;
    WHILE (@i <= @len)
    BEGIN
        SET @hexCharStr = SUBSTRING (@hexStr, @i, 2)
        IF LEN (@hexCharStr) = 1 SET @hexCharStr = '0' + @hexCharStr
        SET @leftNibbleChar = LOWER (LEFT (@hexCharStr, 1))
        SET @rightNibbleChar = LOWER (RIGHT (@hexCharStr, 1))

        IF @leftNibbleChar BETWEEN 'a' AND 'f' COLLATE Latin1_General_BIN
           SET @leftNibble = (CONVERT (int, CONVERT (binary(1), @leftNibbleChar)) - CONVERT (int, CONVERT (binary(1), 'a')) + 10) * 16;
        ELSE IF @leftNibbleChar BETWEEN '0' AND '9' COLLATE Latin1_General_BIN
           SET @leftNibble = (CONVERT (int, CONVERT (binary(1), @leftNibbleChar)) - CONVERT (int, CONVERT (binary(1), '0'))) * 16;
        ELSE
            RETURN NULL;

        IF @rightNibbleChar BETWEEN 'a' AND 'f' COLLATE Latin1_General_BIN
           SET @rightNibble = (CONVERT (int, CONVERT (binary(1), @rightNibbleChar)) - CONVERT (int, CONVERT (binary(1), 'a')) + 10);
        ELSE IF @rightNibbleChar  BETWEEN '0' AND '9' COLLATE Latin1_General_BIN
           SET @rightNibble = (CONVERT (int, CONVERT (binary(1), @rightNibbleChar)) - CONVERT (int, CONVERT (binary(1), '0')));
        ELSE
            RETURN NULL;

        SET @ret = @ret + CONVERT (binary(1), @leftNibble + @rightNibble)
        SET @i = @i + 2
    END

    RETURN @ret
END
GO
