/* CreateDate: 01/03/2014 07:07:53.253 , ModifyDate: 01/03/2014 07:07:53.253 */
GO
CREATE FUNCTION [sysutility_ucp_misc].[fn_get_max_size_available_by_growth_type_percent](
                @file_size_kb REAL,
                @max_size_kb REAL,
                @growth_percent REAL)
RETURNS REAL
AS
BEGIN
    DECLARE @max_size_available_kb REAL;
    DECLARE @one_plus_growth_percent REAL;
    DECLARE @exponent REAL;

    SELECT @max_size_available_kb = @file_size_kb;
    SELECT @one_plus_growth_percent = 1 + @growth_percent / 100;
    --- @file_size_kb > 0 is added to avoid the divided by zero exception. When a database is in the Emergency state, the size
    --- of its log file is zero.
    IF (@growth_percent > 0 AND @max_size_kb > @file_size_kb AND @file_size_kb > 0)
    BEGIN
        SELECT @exponent = FLOOR(LOG10(@max_size_kb / @file_size_kb) / LOG10(@one_plus_growth_percent));
        SELECT @max_size_available_kb = @file_size_kb * POWER(@one_plus_growth_percent, @exponent);
    END

    RETURN @max_size_available_kb
END
GO
