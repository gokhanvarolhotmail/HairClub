/* CreateDate: 04/08/2020 11:22:01.350 , ModifyDate: 04/08/2020 11:22:01.350 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upCubeDocCubes]
    (@Catalog       VARCHAR(255) = NULL
    )
AS

    SELECT *
    FROM OPENQUERY(CubeLinkedServer,
        'SELECT *
         FROM $SYSTEM.MDSCHEMA_CUBES
         WHERE CUBE_SOURCE = 1')
     WHERE  CAST([CATALOG_NAME] AS VARCHAR(255)) = @Catalog
        OR @Catalog IS NULL
GO
