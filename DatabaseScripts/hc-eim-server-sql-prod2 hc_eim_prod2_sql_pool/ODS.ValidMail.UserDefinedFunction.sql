/****** Object:  UserDefinedFunction [ODS].[ValidMail]    Script Date: 3/23/2022 10:16:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [ODS].[ValidMail] (@EmailIn [varchar](100)) RETURNS varchar(100)
AS
BEGIN

-- Created: 9/Feb/2021 By EIM Team
-- Purpose: Based on the logic received, this function validates the correct email address and returns the email address or NULL
-- Input Params: EMAIL in varchar data type
-- Output Params: EMAIL or NULL depending on the valid or not. In case the email is not valid, the it returns a NULL value

    DECLARE @EmailOut varchar(100);
    SET @EmailOut =
		CASE
		-- The following logic is reused from the BI environment. If any of the following rules gets detected, the eMail is NOT valid
			WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', ''))))) > 0 -- Invalid characters
			OR PATINDEX('[@.-_]%', LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', ''))))) > 0 -- Valid but cannot be starting character
			OR PATINDEX('%[@.-_]', LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', ''))))) > 0 -- Valid but cannot be ending character
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%..%' -- Cannot have two periods in a row
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%@%@%' -- Cannot have two @ anywhere
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.@%'
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%@.%' -- Cannot have @ and . next to each other
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.cm'
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.or'
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.ne' -- Missing last letter
			THEN
				NULL
			ELSE
				-- If thew email address is a valid one, we return it back.
				LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', ''))))
		END;
    RETURN(@EmailOut);
END
GO
