/* CreateDate: 01/03/2014 07:07:53.250 , ModifyDate: 01/03/2014 07:07:53.250 */
GO
CREATE FUNCTION [sysutility_ucp_misc].[fn_get_max_size_available_by_growth_type_kb](
                @file_size_kb REAL,
                @max_size_kb REAL,
                @growth_size_kb REAL)
RETURNS REAL
AS
BEGIN
    DECLARE @max_size_available_kb REAL;

    SELECT @max_size_available_kb = @file_size_kb;

    IF (@growth_size_kb > 0 AND @max_size_kb > @file_size_kb)
    BEGIN
        SELECT @max_size_available_kb =
            (@max_size_kb -
              CONVERT(REAL, CONVERT(BIGINT, @max_size_kb - @file_size_kb) % CONVERT(BIGINT, @growth_size_kb)))
    END

    RETURN @max_size_available_kb
END
GO
