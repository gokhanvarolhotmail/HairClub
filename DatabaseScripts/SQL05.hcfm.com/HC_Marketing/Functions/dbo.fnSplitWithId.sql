/* CreateDate: 05/21/2020 11:36:15.957 , ModifyDate: 05/21/2020 11:36:15.957 */
GO
/***********************************************************************
NAME:					fnSplitWithId
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					HDu
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------

10/17/2013 - DL - Created function to split string lists into a table (#92357)
------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnSplitWithId('201,212,263,285,296', ',')
***********************************************************************/
CREATE FUNCTION [dbo].[fnSplitWithId]
(
	@String VARCHAR(200)
,	@Delimiter VARCHAR(5)
)
RETURNS @SplittedValues TABLE
(
	Id SMALLINT IDENTITY(1, 1)
,	SplitValue VARCHAR(MAX)
)
AS
BEGIN

    DECLARE @SplitLength INT

    WHILE LEN(@String) > 0
          BEGIN

                SELECT  @SplitLength = ( CASE CHARINDEX(@Delimiter, @String)
                                           WHEN 0 THEN LEN(@String)
                                           ELSE CHARINDEX(@Delimiter, @String)
                                                - 1
                                         END )

                INSERT  INTO @SplittedValues
                        SELECT  SUBSTRING(@String, 1, @SplitLength)

                SELECT  @String = ( CASE ( LEN(@String) - @SplitLength )
                                      WHEN 0 THEN ''
                                      ELSE RIGHT(@String,
                                                 LEN(@String) - @SplitLength
                                                 - 1)
                                    END )

          END

    RETURN

END
GO
