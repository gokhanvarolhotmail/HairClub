/* CreateDate: 01/03/2014 07:07:45.890 , ModifyDate: 01/03/2014 07:07:45.890 */
GO
CREATE VIEW core.supported_collector_types
AS
    SELECT collector_type_uid
    FROM core.supported_collector_types_internal
GO
