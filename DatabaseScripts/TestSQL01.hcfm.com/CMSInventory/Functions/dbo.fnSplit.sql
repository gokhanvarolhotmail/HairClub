/* CreateDate: 09/26/2011 16:06:01.673 , ModifyDate: 09/26/2011 16:06:01.673 */
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
