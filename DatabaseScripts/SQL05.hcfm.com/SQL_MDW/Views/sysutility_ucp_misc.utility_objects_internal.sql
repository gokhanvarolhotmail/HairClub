/* CreateDate: 01/03/2014 07:07:53.247 , ModifyDate: 01/03/2014 07:07:53.247 */
GO
CREATE VIEW sysutility_ucp_misc.utility_objects_internal AS
SELECT
   SCHEMA_NAME (obj.[schema_id]) AS [object_schema],
   obj.name AS [object_name],
   obj.type_desc AS sql_object_type,
   CAST (prop.value AS varchar(60)) AS utility_object_type
FROM sys.extended_properties AS prop
INNER JOIN sys.objects AS obj ON prop.major_id = obj.[object_id]
WHERE prop.name = 'MS_UtilityObjectType';
GO
EXEC sys.sp_addextendedproperty @name=N'MS_UtilityObjectType', @value=N'MISC' , @level0type=N'SCHEMA',@level0name=N'sysutility_ucp_misc', @level1type=N'VIEW',@level1name=N'utility_objects_internal'
GO
