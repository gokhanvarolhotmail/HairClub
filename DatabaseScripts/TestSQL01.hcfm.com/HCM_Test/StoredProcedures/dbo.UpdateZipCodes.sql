/* CreateDate: 12/19/2006 15:56:17.807 , ModifyDate: 05/01/2010 14:48:09.400 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[UpdateZipCodes]

AS

INSERT INTO onca_zip
(			zip_code
,           city
,           country_code
,           state_code
,           zip_code_type
,			county_code
,			facility_code
,			msa_code
)
SELECT	ZIP
,       CITY
,       'US'
,		STATE
,       CODETYPE
,		COUNTY
,		FACILITY
,		MSA
FROM	csta_zip_newzips
WHERE ZIP NOT IN (SELECT onca_zip.zip_code FROM onca_zip WHERE onca_zip.zip_code = ZIP AND onca_zip.city = CITY)
GO
