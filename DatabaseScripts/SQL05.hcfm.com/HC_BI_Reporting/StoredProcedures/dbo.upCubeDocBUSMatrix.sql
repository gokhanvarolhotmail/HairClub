/* CreateDate: 04/08/2020 11:22:01.460 , ModifyDate: 04/08/2020 11:22:01.460 */
GO
CREATE PROCEDURE [dbo].[upCubeDocBUSMatrix]
    (@Catalog       VARCHAR(255),
     @Cube          VARCHAR(255)
    )
AS

SELECT
        bus.[CATALOG_NAME]
        ,bus.[CUBE_NAME]
        ,bus.[MEASUREGROUP_NAME]
        ,bus.[MEASUREGROUP_CARDINALITY]
        ,REPLACE(REPLACE(CAST(bus.[DIMENSION_UNIQUE_NAME] AS VARCHAR(255)) ,'[',''),']','') AS [DIMENSION_UNIQUE_NAME]
        ,bus.[DIMENSION_CARDINALITY]
        ,bus.[DIMENSION_IS_FACT_DIMENSION]
        ,bus.[DIMENSION_GRANULARITY]
        ,dim.[DIMENSION_MASTER_NAME]
        ,1 AS Relationship
    FROM
        OPENQUERY(CubeLinkedServer, 'SELECT
                  [CATALOG_NAME]
                , [CUBE_NAME]
                , [MEASUREGROUP_NAME]
                , [MEASUREGROUP_CARDINALITY]
                , [DIMENSION_UNIQUE_NAME]
                , [DIMENSION_CARDINALITY]
                , [DIMENSION_IS_FACT_DIMENSION]
                , [DIMENSION_GRANULARITY]
            FROM $SYSTEM.MDSCHEMA_MEASUREGROUP_DIMENSIONS
            WHERE [DIMENSION_IS_VISIBLE]') bus
        INNER JOIN
        OPENQUERY(CubeLinkedServer, 'SELECT
                  [CATALOG_NAME]
                , [CUBE_NAME]
                , [DIMENSION_UNIQUE_NAME]
                , [DIMENSION_MASTER_NAME]
            FROM $SYSTEM.MDSCHEMA_DIMENSIONS') dim
            ON CAST(bus.[CATALOG_NAME] AS VARCHAR(255))             = CAST(dim.[CATALOG_NAME] AS VARCHAR(255))
            AND CAST(bus.[CUBE_NAME] AS VARCHAR(255))               = CAST(dim.[CUBE_NAME] AS VARCHAR(255))
            AND CAST(bus.[DIMENSION_UNIQUE_NAME] AS VARCHAR(255))   = CAST(dim.[DIMENSION_UNIQUE_NAME] AS VARCHAR(255))
     WHERE  CAST(bus.[CATALOG_NAME] AS VARCHAR(255))        = @Catalog
        AND CAST(bus.[CUBE_NAME] AS VARCHAR(255))           = @Cube
GO
