/* CreateDate: 01/03/2014 07:07:53.270 , ModifyDate: 01/03/2014 07:07:53.270 */
GO
CREATE FUNCTION [sysutility_ucp_misc].[fn_get_max_size_available](
                @file_size_kb REAL,
                @max_size_kb REAL,
                @growth REAL,       --  growth is KB when type is not percentage, or a whole number percentage when percentage
                @smo_growth_type SMALLINT,  -- @smo_growth_type == 0 is KB growth, == 1 means percentage, or == 99 not supported to grow
                @free_space_on_drive_kb BIGINT)
RETURNS REAL
AS
BEGIN
    DECLARE @max_size_available_kb REAL;
    DECLARE @projected_max_file_size_kb REAL;

    -- Be conservative and initialize total space to @file_size_kb (assume no autogrow)
    SELECT @max_size_available_kb  = @file_size_kb;

    -- Let projected size be the current file size + volume free space (assuming no one else is competing and its completely available for this file)
    SELECT @projected_max_file_size_kb = @file_size_kb + @free_space_on_drive_kb;

    -- No auto grow, return the configured file size
    IF (@smo_growth_type = 99)
    BEGIN
        SELECT @max_size_available_kb = @file_size_kb;
    END
    ELSE
    BEGIN
        IF (0 < @max_size_kb AND @max_size_kb < @projected_max_file_size_kb)
        BEGIN
            -- if maxsize is configured and it's less than the project space
            -- then we use the maxsize as the growth boundary.
            SELECT @max_size_available_kb =
                CASE
                    WHEN (@smo_growth_type = 1) -- percent growth
                    THEN sysutility_ucp_misc.fn_get_max_size_available_by_growth_type_percent(@file_size_kb, @max_size_kb, @growth)

                    WHEN (@smo_growth_type = 0) -- KB growth
                    THEN sysutility_ucp_misc.fn_get_max_size_available_by_growth_type_kb(@file_size_kb, @max_size_kb, @growth)

                    ELSE @max_size_kb
                END
        END
        ELSE
        BEGIN
            -- either maxsize is not configured, in this case we use the project space
            -- or maxsize is bigger than the project space, and we suse the project space as well.
            SELECT @max_size_available_kb =
                CASE
                    WHEN (@smo_growth_type = 1) -- percent growth
                    THEN sysutility_ucp_misc.fn_get_max_size_available_by_growth_type_percent(@file_size_kb, @projected_max_file_size_kb, @growth)

                    WHEN (@smo_growth_type = 0) -- KB growth
                    THEN sysutility_ucp_misc.fn_get_max_size_available_by_growth_type_kb(@file_size_kb, @projected_max_file_size_kb, @growth)

                    ELSE @projected_max_file_size_kb
                END
        END
    END

    -- VSTS 351411
    -- In SQL2008 and SQL2008 R2, unfortunately the support for file stream file
    -- in SMO and dmv aren't complete: it always return 0 for everything including
    -- @file_size_kb, @max_size_kb, growth, thus walking through the code path above,
    -- we'll return 0, then the our data file storage utilization property use this
    -- value (as the denominator) to compute the percentage which would result
    -- in divide by zero (DBZ).
    --
    -- So for that case, we simply return the @projected_max_file_size_kb to avoid DBZ. Of course
    -- there is a tiny chance @projected_max_file_size_kb is also 0 (due to volume free space is 0
    -- the volume is full!) so we'll simply return 1 (kb)
    --
    -- Note 1: to avoid comparing equality of double-typed variable to 0, check against 1 KB
    --         it wouldn't be any faster but readability is lower.
    IF (@max_size_available_kb < 1.0)
    BEGIN
        SELECT @max_size_available_kb = @projected_max_file_size_kb;
        -- what if @projected_max_file_size_kb is still 0 (or near 0)? use 1 kb.
        IF (@max_size_available_kb < 1.0)
        BEGIN
            SELECT @max_size_available_kb = 1.0;
        END
    END

    RETURN @max_size_available_kb;
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'MISC' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_misc', @level1type=N'FUNCTION',@level1name=N'fn_get_max_size_available'
GO
