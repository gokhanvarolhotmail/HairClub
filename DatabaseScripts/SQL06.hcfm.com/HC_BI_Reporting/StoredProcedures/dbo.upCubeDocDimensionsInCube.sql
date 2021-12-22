CREATE PROCEDURE [dbo].[upCubeDocDimensionsInCube]
    (@Catalog       VARCHAR(255)
    ,@Cube          VARCHAR(255)
    )
AS

SELECT * FROM OPENQUERY(CubeLinkedServer, 'SELECT *
        FROM $SYSTEM.MDSCHEMA_DIMENSIONS
        WHERE [DIMENSION_IS_VISIBLE]')
     WHERE  CAST([CATALOG_NAME] AS VARCHAR(255))        = @Catalog
        AND CAST([CUBE_NAME] AS VARCHAR(255))           = @Cube
