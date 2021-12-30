/* CreateDate: 01/03/2014 07:07:47.120 , ModifyDate: 01/03/2014 07:07:47.120 */
GO
CREATE FUNCTION [snapshots].[fn_get_performance_counter_statistics]
(
    @instance_name       sysname,
    @path_pattern         nvarchar(2048),
    @start_time          datetimeoffset(7) = NULL,
    @end_time            datetimeoffset(7) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        pc.path                        as path,
        MIN(pc.formatted_value)        as minimum_value,
        MAX(pc.formatted_value)        as maximum_value,
        AVG(pc.formatted_value)        as average_value,
        STDEV(pc.formatted_value)    as standard_deviation,
        VAR(pc.formatted_value)        as statistical_variance
    FROM [snapshots].[performance_counters] as pc
    JOIN [core].[snapshots] s on s.snapshot_id = pc.snapshot_id
    WHERE
        s.instance_name = @instance_name AND
        pc.path LIKE @path_pattern AND
        pc.collection_time >= @start_time AND
        pc.collection_time <= @end_time
    GROUP BY pc.path
)
GO
