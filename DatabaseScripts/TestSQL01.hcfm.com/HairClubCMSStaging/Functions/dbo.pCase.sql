/* CreateDate: 10/04/2010 12:09:08.313 , ModifyDate: 02/17/2013 18:08:07.987 */
GO
CREATE FUNCTION [dbo].[pCase]
(
    @strIn varchar(255)
)
RETURNS varchar(255)
AS
BEGIN
    IF @strIn IS NULL
        RETURN NULL

    DECLARE
        @strOut varchar(255),
        @i int,
        @Up BIT,
        @c varchar(2)

    SELECT
        @strOut = '',
        @i = 0,
        @Up = 1

    WHILE @i <= DATALENGTH(@strIn)
      BEGIN
        SET @c = SUBSTRING(@strIn,@i,1)
        IF @c IN (' ','-','''')
        BEGIN
            SET @strOut = @strOut + @c
            SET @Up = 1
        END
        ELSE
        BEGIN
            IF @up = 1
                SET @c = UPPER(@c)
            ELSE
                SET @c = LOWER(@c)

            SET @strOut = @strOut + @c
            SET @Up = 0
        END
        SET @i = @i + 1
      END
    RETURN @strOut
END
GO
