/* CreateDate: 01/03/2014 07:07:47.047 , ModifyDate: 01/03/2014 07:07:47.047 */
GO
CREATE VIEW [snapshots].[performance_counters]
AS
SELECT
    pci.performance_counter_id,
    pcv.snapshot_id AS snapshot_id,
    pcv.collection_time AS collection_time,
    pci.path AS path,
    pci.object_name AS performance_object_name,
    pci.counter_name AS performance_counter_name,
    pci.instance_name AS performance_instance_name,
    pcv.formatted_value AS formatted_value,
    pcv.raw_value_first,
    pcv.raw_value_second
FROM
    snapshots.performance_counter_instances pci
    INNER JOIN snapshots.performance_counter_values pcv ON pci.performance_counter_id = pcv.performance_counter_instance_id
GO
