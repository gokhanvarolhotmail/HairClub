/* CreateDate: 02/19/2013 11:59:05.050 , ModifyDate: 02/19/2013 11:59:05.050 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
