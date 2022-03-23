/* CreateDate: 04/08/2020 11:22:00.260 , ModifyDate: 04/08/2020 11:22:00.260 */
GO
CREATE PROCEDURE [dbo].[upCubeDocMeasuresInMeasureGroup]
    (@Catalog       VARCHAR(255)
    ,@Cube          VARCHAR(255)
    ,@MeasureGroup  VARCHAR(255)
    )
AS

SELECT * FROM OPENQUERY(CubeLinkedServer, 'SELECT *
        FROM $SYSTEM.MDSCHEMA_MEASURES
        WHERE [MEASURE_IS_VISIBLE]')
     WHERE  CAST([CATALOG_NAME] AS VARCHAR(255))        = @Catalog
        AND CAST([CUBE_NAME] AS VARCHAR(255))           = @Cube
        AND CAST([MEASUREGROUP_NAME] AS VARCHAR(255))   = @MeasureGroup
GO
