/* CreateDate: 08/30/2011 15:14:53.913 , ModifyDate: 08/30/2011 15:14:53.913 */
GO
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
GO
