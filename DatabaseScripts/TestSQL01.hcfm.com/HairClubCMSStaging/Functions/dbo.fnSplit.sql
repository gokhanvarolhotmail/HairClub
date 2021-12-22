/* CreateDate: 12/31/2010 13:21:06.840 , ModifyDate: 02/27/2017 09:49:37.827 */
GO
CREATE FUNCTION [dbo].[fnSplit](
    @sInputList VARCHAR(MAX) -- List of delimited items
  , @sDelimiter VARCHAR(MAX) = ',' -- delimiter that separates items
) RETURNS @List TABLE (item VARCHAR(MAX))

BEGIN
DECLARE @sItem VARCHAR(MAX)
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))

 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
GO
