/* CreateDate: 08/19/2011 08:50:34.783 , ModifyDate: 08/19/2011 08:50:34.783 */
GO
CREATE FUNCTION [dbo].[ENTRYPOINT] (@create_by char(10))
RETURNS varchar(25) AS
BEGIN
RETURN(

	CASE WHEN @create_by IN('TM 300', 'TM 301', 'TM 500', 'TM 801') THEN 'Overflow' ELSE
	CASE WHEN @create_by IN('TM 600', 'TM 302') THEN 'Web' ELSE
	CASE WHEN @create_by LIKE 'TM%' THEN 'Telemarketing' ELSE
	CASE WHEN @create_by LIKE '[2378]__' THEN 'Walk In' ELSE 'N/A' END END END END
)
END
GO
