/* CreateDate: 04/08/2020 11:22:01.533 , ModifyDate: 04/08/2020 11:22:01.533 */
GO
CREATE PROCEDURE [dbo].[upCubeDocAttributesInDimension]
    (@Catalog       VARCHAR(255)
    ,@Cube          VARCHAR(255)
    ,@Dimension  VARCHAR(255)
    )
AS

SELECT *
        , CASE WHEN CAST([LEVEL_ORIGIN] AS INT) & 1 = 1 THEN 1 ELSE 0 END AS IsHierarchy
        , CASE WHEN CAST([LEVEL_ORIGIN] AS INT) & 2 = 2 THEN 1 ELSE 0 END AS IsAttribute
        , CASE WHEN CAST([LEVEL_ORIGIN] AS INT) & 4 = 4 THEN 1 ELSE 0 END AS IsKey
    FROM OPENQUERY(CubeLinkedServer, 'SELECT * FROM $SYSTEM.MDSCHEMA_LEVELS
        WHERE [LEVEL_NUMBER]>0
        AND [LEVEL_IS_VISIBLE]')
     WHERE  CAST([CATALOG_NAME] AS VARCHAR(255))            = @Catalog
        AND CAST([CUBE_NAME] AS VARCHAR(255))               = @Cube
        AND CAST([DIMENSION_UNIQUE_NAME] AS VARCHAR(255))   = @Dimension
GO
