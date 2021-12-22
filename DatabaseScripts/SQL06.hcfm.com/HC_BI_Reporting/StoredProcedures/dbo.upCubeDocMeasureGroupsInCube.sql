/* CreateDate: 04/08/2020 11:22:00.333 , ModifyDate: 04/08/2020 11:22:00.333 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upCubeDocMeasureGroupsInCube]
    (@Catalog       VARCHAR(255)
    ,@Cube          VARCHAR(255)
    )
AS


SELECT * FROM OPENQUERY(CubeLinkedServer, 'SELECT *
        FROM $SYSTEM.MDSCHEMA_MEASUREGROUPS ')
     WHERE  CAST([CATALOG_NAME] AS VARCHAR(255))        = @Catalog
        AND CAST([CUBE_NAME] AS VARCHAR(255))           = @Cube
GO
