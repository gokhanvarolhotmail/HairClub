/* CreateDate: 09/04/2007 09:40:45.307 , ModifyDate: 05/01/2010 14:48:09.103 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  FUNCTION ENTRYPOINT (@create_by char(10))
RETURNS varchar(25) AS
BEGIN
RETURN(

	CASE WHEN @create_by IN('TM 100', 'CMR', 'idrc') THEN 'Overflow' ELSE
	CASE WHEN @create_by IN('TM 600', 'TM 601') THEN 'Web' ELSE
	CASE WHEN @create_by LIKE 'TM%' THEN 'Telemarketing' ELSE
	CASE WHEN @create_by LIKE '[2378]__' THEN 'Walk In' ELSE 'N/A' END END END END
)
END



/*
idrc is an old overflow code.
It was added on 11/29/01 based on direction from telemarketing.
Records containing this code were returned previously to the 'n/a' category in the detail and summary reports,
negatively impacting accuracy.
-bsingley
*/
GO
