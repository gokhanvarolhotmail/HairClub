/* CreateDate: 01/03/2014 07:07:50.970 , ModifyDate: 01/03/2014 07:07:50.970 */
GO
CREATE PROCEDURE [snapshots].[rpt_list_all_servers]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        instance_name,
        query_statistics_last_upload,
        disk_usage_last_upload,
        server_activity_last_upload
    FROM
    (
        SELECT
            -- Name of the SQL Server instance
            instance_name,
            -- Name of the collection set.  The names in the syscollector_collection_sets table can be localized.
            -- We use well-known strings here because we want to defer selection of the appropriate localized
            -- string to the client.
            CASE
                collection_set_uid
                WHEN '2DC02BD6-E230-4C05-8516-4E8C0EF21F95' THEN 'query_statistics_last_upload'
                WHEN '7B191952-8ECF-4E12-AEB2-EF646EF79FEF' THEN 'disk_usage_last_upload'
                WHEN '49268954-4FD4-4EB6-AA04-CD59D9BB5714' THEN 'server_activity_last_upload'
                ELSE NULL -- custom Collection set, not displayed on this report
            END AS top_level_report_name,
            -- Convert datetimeoffset to UTC datetime for RS 2005 compatibility
            CONVERT (datetime, SWITCHOFFSET (MAX (snapshot_time), '+00:00')) AS latest_snapshot_time
        FROM core.snapshots
        -- For this report, only system collection sets matter
        WHERE collection_set_uid IN ('2DC02BD6-E230-4C05-8516-4E8C0EF21F95', '7B191952-8ECF-4E12-AEB2-EF646EF79FEF', '49268954-4FD4-4EB6-AA04-CD59D9BB5714')
        GROUP BY instance_name, collection_set_uid
    ) AS instance_report_list
    PIVOT
    (
        MAX (latest_snapshot_time)
        FOR top_level_report_name IN (query_statistics_last_upload, disk_usage_last_upload, server_activity_last_upload)
    ) AS pvt
    ORDER BY instance_name;

END;
GO
