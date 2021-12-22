/* CreateDate: 04/08/2020 11:22:00.117 , ModifyDate: 04/08/2020 11:22:00.117 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upCubeDocSearch]
    (@Search        VARCHAR(255)
    ,@Catalog       VARCHAR(255)=NULL
    ,@Cube          VARCHAR(255)=NULL
    )
AS

    WITH dbo AS
    (
        --Cubes
        SELECT CAST('Cube' AS VARCHAR(20)) AS [Type]
                , CAST(CATALOG_NAME AS VARCHAR(255)) AS [Catalog]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Cube]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Name]
                , CAST(DESCRIPTION AS VARCHAR(4000)) AS [Description]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Link]
             FROM OPENQUERY(CubeLinkedServer, 'SELECT [CATALOG_NAME], [CUBE_NAME], [DESCRIPTION]
                FROM $SYSTEM.MDSCHEMA_CUBES
                WHERE CUBE_SOURCE = 1')
         WHERE  (CAST([CATALOG_NAME] AS VARCHAR(255))            = @Catalog OR @Catalog IS NULL)

        UNION ALL

        --Dimensions
        SELECT CAST('Dimension' AS VARCHAR(20)) AS [Type]
                , CAST(CATALOG_NAME AS VARCHAR(255)) AS [Catalog]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Cube]
                , CAST(DIMENSION_NAME AS VARCHAR(255)) AS [Name]
                , CAST(DESCRIPTION AS VARCHAR(4000)) AS [Description]
                , CAST(DIMENSION_UNIQUE_NAME AS VARCHAR(255)) AS [Link]
        FROM OPENQUERY(CubeLinkedServer, 'SELECT [CATALOG_NAME], [CUBE_NAME], [DIMENSION_NAME], [DESCRIPTION], [DIMENSION_UNIQUE_NAME]
                    FROM $SYSTEM.MDSCHEMA_DIMENSIONS
                    WHERE [DIMENSION_IS_VISIBLE]')
         WHERE  (CAST([CATALOG_NAME] AS VARCHAR(255))            = @Catalog OR @Catalog IS NULL)
            AND (CAST([CUBE_NAME] AS VARCHAR(255))               = @Cube OR @Cube IS NULL)
            AND LEFT(CAST(CUBE_NAME AS VARCHAR(255)),1)          <>'$' --Filter out dimensions not in a cube

         UNION ALL

        --Attributes
        SELECT CAST('Attribute' AS VARCHAR(20)) AS [Type]
                , CAST(CATALOG_NAME AS VARCHAR(255)) AS [Catalog]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Cube]
                , CAST(LEVEL_CAPTION AS VARCHAR(255)) AS [Name]
                , CAST(DESCRIPTION AS VARCHAR(4000)) AS [Description]
                , CAST(DIMENSION_UNIQUE_NAME AS VARCHAR(255)) AS [Link]
        FROM OPENQUERY(CubeLinkedServer, 'SELECT [CATALOG_NAME], [CUBE_NAME], [LEVEL_CAPTION], [DESCRIPTION], [DIMENSION_UNIQUE_NAME]
                    FROM $SYSTEM.MDSCHEMA_LEVELS
                    WHERE [LEVEL_NUMBER]>0
                    AND [LEVEL_IS_VISIBLE]')
         WHERE  (CAST([CATALOG_NAME] AS VARCHAR(255))            = @Catalog OR @Catalog IS NULL)
            AND (CAST([CUBE_NAME] AS VARCHAR(255))               = @Cube OR @Cube IS NULL)
            AND LEFT(CAST(CUBE_NAME AS VARCHAR(255)),1)          <>'$' --Filter out dimensions not in a cube


         UNION ALL

        --Measure Groups
        SELECT CAST('Measure Group' AS VARCHAR(20)) AS [Type]
                , CAST(CATALOG_NAME AS VARCHAR(255)) AS [Catalog]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Cube]
                , CAST(MEASUREGROUP_NAME AS VARCHAR(255)) AS [Name]
                , CAST(DESCRIPTION AS VARCHAR(4000)) AS [Description]
                , CAST(MEASUREGROUP_NAME AS VARCHAR(255)) AS [Link]
        FROM OPENQUERY(CubeLinkedServer, 'SELECT [CATALOG_NAME], [CUBE_NAME], [MEASUREGROUP_NAME], [DESCRIPTION]
                    FROM $SYSTEM.MDSCHEMA_MEASUREGROUPS')
         WHERE  (CAST([CATALOG_NAME] AS VARCHAR(255))            = @Catalog OR @Catalog IS NULL)
            AND (CAST([CUBE_NAME] AS VARCHAR(255))               = @Cube OR @Cube IS NULL)
            AND LEFT(CAST(CUBE_NAME AS VARCHAR(255)),1)          <>'$' --Filter out dimensions not in a cube


         UNION ALL

        --Measures
        SELECT CAST('Measure' AS VARCHAR(20)) AS [Type]
                , CAST(CATALOG_NAME AS VARCHAR(255)) AS [Catalog]
                , CAST(CUBE_NAME AS VARCHAR(255)) AS [Cube]
                , CAST(MEASURE_NAME AS VARCHAR(255)) AS [Name]
                , CAST(DESCRIPTION AS VARCHAR(4000)) AS [Description]
                , CAST(MEASUREGROUP_NAME AS VARCHAR(255)) AS [Link]
        FROM OPENQUERY(CubeLinkedServer, 'SELECT [CATALOG_NAME], [CUBE_NAME], [MEASURE_NAME], [DESCRIPTION], [MEASUREGROUP_NAME]
                    FROM $SYSTEM.MDSCHEMA_MEASURES
                    WHERE [MEASURE_IS_VISIBLE]')
         WHERE  (CAST([CATALOG_NAME] AS VARCHAR(255))            = @Catalog OR @Catalog IS NULL)
            AND (CAST([CUBE_NAME] AS VARCHAR(255))               = @Cube OR @Cube IS NULL)
            AND LEFT(CAST(CUBE_NAME AS VARCHAR(255)),1)          <>'$' --Filter out dimensions not in a cube


    )
    SELECT *
    FROM dbo
    WHERE @Search<>''
        AND ([Name] LIKE '%' + @Search + '%'
          OR [Description] LIKE '%' + @Search + '%'
        )
GO
