/* CreateDate: 01/03/2014 07:07:47.080 , ModifyDate: 01/03/2014 07:07:47.080 */
GO
CREATE FUNCTION [snapshots].[fn_get_performance_counters]
(
    @instance_name       sysname,
    @start_time          datetimeoffset(7) = NULL,
    @end_time            datetimeoffset(7) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        pc.performance_counter_id AS performance_counter_id,
        pc.collection_time AS collection_time,
        pc.path AS path,
        pc.performance_object_name AS performance_object_name,
        pc.performance_counter_name AS performance_counter_name,
        pc.performance_instance_name AS performance_instance_name,
        pc.formatted_value AS formatted_value
    FROM [snapshots].[performance_counters] as pc
    JOIN [core].[snapshots] s on s.snapshot_id = pc.snapshot_id
    WHERE
        @instance_name = s.instance_name AND
        ISNULL(@start_time,CAST (0 AS DATETIME)) <= pc.collection_time AND
        ISNULL(@end_time,GETDATE()) >= pc.collection_time
)
GO
