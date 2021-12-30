/* CreateDate: 01/26/2010 10:12:08.580 , ModifyDate: 01/26/2010 10:12:08.580 */
GO
SET QUOTED_IDENTIFIER OFF
GO
/*****************************************************************************/

CREATE PROCEDURE dbo.TempGetVersion
    @ver      char(10) OUTPUT
AS
    SELECT @ver = "2"
    RETURN 0
GO
