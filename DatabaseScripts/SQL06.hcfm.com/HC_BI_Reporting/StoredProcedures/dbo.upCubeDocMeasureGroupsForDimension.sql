/* CreateDate: 04/08/2020 11:22:00.430 , ModifyDate: 04/08/2020 11:22:00.430 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upCubeDocMeasureGroupsForDimension]
    (@Catalog       VARCHAR(255)
    ,@Cube          VARCHAR(255)
    ,@Dimension     VARCHAR(255)
    )
AS

    SELECT
          mgd.*
        , m.[DESCRIPTION]
    FROM OPENQUERY(CubeLinkedServer, 'SELECT
                  [CATALOG_NAME]
                , [CUBE_NAME]
                , [MEASUREGROUP_NAME]
                , [MEASUREGROUP_CARDINALITY]
                , [DIMENSION_UNIQUE_NAME]
            FROM $SYSTEM.MDSCHEMA_MEASUREGROUP_DIMENSIONS
            WHERE [DIMENSION_IS_VISIBLE]') mgd
        INNER JOIN OPENQUERY(CubeLinkedServer, 'SELECT
                [CATALOG_NAME]
                ,[CUBE_NAME]
                ,[MEASUREGROUP_NAME]
                ,[DESCRIPTION]
            FROM $SYSTEM.MDSCHEMA_MEASUREGROUPS
            ') m
                ON  CAST(mgd.[CATALOG_NAME] AS VARCHAR(255))          = CAST(m.[CATALOG_NAME] AS VARCHAR(255))
                AND CAST(mgd.[CUBE_NAME] AS VARCHAR(255))             = CAST(m.[CUBE_NAME] AS VARCHAR(255))
                AND CAST(mgd.[MEASUREGROUP_NAME] AS VARCHAR(255))     = CAST(m.[MEASUREGROUP_NAME] AS VARCHAR(255))
     WHERE  CAST(mgd.[CATALOG_NAME] AS VARCHAR(255))            = @Catalog
        AND CAST(mgd.[CUBE_NAME] AS VARCHAR(255))               = @Cube
        AND CAST(mgd.[DIMENSION_UNIQUE_NAME] AS VARCHAR(255))   = @Dimension
GO
