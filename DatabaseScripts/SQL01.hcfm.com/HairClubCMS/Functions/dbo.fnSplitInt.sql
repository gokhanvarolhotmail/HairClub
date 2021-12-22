CREATE FUNCTION [dbo].[fnSplitInt](
    @sInputList nvarchar(2000) -- List of delimited items
  , @sDelimiter nchar(1) = ',' -- delimiter that separates items
) RETURNS @List TABLE (item int)

BEGIN
	DECLARE @sItem VARCHAR(20)
	WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
	BEGIN
		SELECT
			@sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
			@sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))));

		IF LEN(@sItem) > 0
			INSERT INTO @List SELECT CAST(@sItem AS int);
	END

	IF LEN(@sInputList) > 0
		INSERT INTO @List SELECT CAST(@sInputList AS int); -- Put the last item in
	RETURN
END
