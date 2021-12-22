/* CreateDate: 09/04/2007 09:40:45.633 , ModifyDate: 05/01/2010 14:48:08.990 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Rewrite for ONCV - Howard Abelow 9/28/2007*/

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
