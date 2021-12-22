/* CreateDate: 08/14/2007 18:59:44.423 , ModifyDate: 09/24/2007 13:45:02.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ISAPPT]
    (
      @action_code as varchar(10)
    )
RETURNS bit
AS BEGIN
    RETURN ( CASE WHEN @action_code IN ( 'APPOINT' ) THEN 1
                  ELSE 0
             END )
   END
GO
