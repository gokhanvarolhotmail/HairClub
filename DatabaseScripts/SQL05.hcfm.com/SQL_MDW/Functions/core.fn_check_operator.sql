/* CreateDate: 01/03/2014 07:07:46.483 , ModifyDate: 01/03/2014 07:07:46.483 */
GO
CREATE FUNCTION [core].[fn_check_operator](
        @snapshot_id int
    )
    RETURNS bit
    AS
    BEGIN
        DECLARE @retval bit;

        DECLARE @operator sysname;
        SELECT @operator=operator FROM core.snapshots WHERE snapshot_id = @snapshot_id;
        IF (@operator = SUSER_SNAME())
            SELECT @retval = 1;
        ELSE
            SELECT @retval = 0;
        RETURN @retval;
    END;
GO
