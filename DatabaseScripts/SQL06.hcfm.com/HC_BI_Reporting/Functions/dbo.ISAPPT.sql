/* Rewrite for ONCV - Howard Abelow 9/28/2007*/

CREATE FUNCTION [dbo].[ISAPPT]
    (
      @action_code as varchar(10)
    )
RETURNS bit
AS
BEGIN
    RETURN ( CASE WHEN @action_code IN ( 'APPOINT' , 'INHOUSE') THEN 1
                  ELSE 0
             END )
   END
