/* CreateDate: 10/01/2020 16:45:45.043 , ModifyDate: 11/24/2020 13:13:37.880 */
GO
/***********************************************************************
NAME:					fnIsLead
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					DLeiba
------------------------------------------------------------------------
NOTES:

	11/24/2020	KMurdoch	Removed check for Primary Flag per Jason K & Michael S
	11/24/2020  KMurdoch    Added check for last names = 'test' or ending with 'test'
	11/24/2020  KMurdoch    Added check for first name = 'test'
------------------------------------------------------------------------


------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnIsLead('00Q1V00000wKZOvUAO')
SELECT * FROM dbo.fnIsLead('00Q1V00000wKkaxUAC')
***********************************************************************/
CREATE FUNCTION [dbo].[fnIsLead]
(
	@SFDC_LeadID NVARCHAR(18)
)
RETURNS @IsInvalid TABLE
(
	Id NVARCHAR(18)
,	IsInvalidLead BIT
)
AS
BEGIN

INSERT  INTO @IsInvalid
		SELECT DISTINCT
				l.Id
		,		1 AS 'IsInvalidLead'
		FROM	HC_BI_SFDC.dbo.Lead l
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Email__c ec
					ON ec.Lead__c = l.Id
					--AND ec.Primary__c = 1
					AND ec.IsDeleted = 0
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Phone__c pc
					ON pc.Lead__c = l.Id
					--AND pc.Primary__c = 1
					AND pc.IsDeleted = 0
		WHERE	l.Id = @SFDC_LeadID
				AND ((
						(
							l.FirstName LIKE 'aaa%'
							OR l.FirstName LIKE 'bbb%'
							OR l.FirstName LIKE 'ccc%'
							OR l.FirstName LIKE 'ddd%'
							OR l.FirstName LIKE 'eee%'
							OR l.FirstName LIKE 'fff%'
							OR l.FirstName LIKE 'ggg%'
							OR l.FirstName LIKE 'hhh%'
							OR l.FirstName LIKE 'iii%'
							OR l.FirstName LIKE 'jjj%'
							OR l.FirstName LIKE 'kkk%'
							OR l.FirstName LIKE 'llll%'
							OR l.FirstName LIKE 'mmm%'
							OR l.FirstName LIKE 'nnn%'
							OR l.FirstName LIKE 'ooo%'
							OR l.FirstName LIKE 'ppp%'
							OR l.FirstName LIKE 'qqq%'
							OR l.FirstName LIKE 'rrr%'
							OR l.FirstName LIKE 'sss%'
							OR l.FirstName LIKE 'ttt%'
							OR l.FirstName LIKE 'uuu%'
							OR l.FirstName LIKE 'vvv%'
							OR l.FirstName LIKE 'www%'
							OR l.FirstName LIKE 'xxx%'
							OR l.FirstName LIKE 'yyy%'
							OR l.FirstName LIKE 'zzz%'
							OR l.FirstName LIKE '%[%$!#@*]%'
							OR l.FirstName LIKE '[0-9]%'
							OR l.FirstName LIKE 'test%[0-9]'
							OR l.FirstName LIKE 'test'
							OR l.FirstName LIKE '123%'
							OR l.FirstName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
							OR l.FirstName IS NULL
						)
						OR (
							l.LastName LIKE 'aaa%'
							OR	l.LastName LIKE 'bbb%'
							OR	l.LastName LIKE 'ccc%'
							OR	l.LastName LIKE 'ddd%'
							OR	l.LastName LIKE 'eee%'
							OR	l.LastName LIKE 'fff%'
							OR	l.LastName LIKE 'ggg%'
							OR	l.LastName LIKE 'hhh%'
							OR	l.LastName LIKE 'iii%'
							OR	l.LastName LIKE 'jjj%'
							OR	l.LastName LIKE 'kkk%'
							OR	l.LastName LIKE 'llll%'
							OR	l.LastName LIKE 'mmm%'
							OR	l.LastName LIKE 'nnn%'
							OR	l.LastName LIKE 'ooo%'
							OR	l.LastName LIKE 'ppp%'
							OR	l.LastName LIKE 'qqq%'
							OR	l.LastName LIKE 'rrr%'
							OR	l.LastName LIKE 'sss%'
							OR	l.LastName LIKE 'ttt%'
							OR	l.LastName LIKE 'uuu%'
							OR	l.LastName LIKE 'vvv%'
							OR	l.LastName LIKE 'www%'
							OR	l.LastName LIKE 'xxx%'
							OR	l.LastName LIKE 'yyy%'
							OR	l.LastName LIKE 'zzz%'
							OR	l.LastName LIKE '%[&%$!#@*]%'
							OR	l.LastName LIKE '[0-9]%'
							OR	l.LastName LIKE 'test%[0-9]'
							OR	l.LastName LIKE 'test'
							OR  l.LastName LIKE '%test'
							OR	l.LastName LIKE '123%'
							OR	l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
							OR	l.LastName IS NULL
						)
						OR ((l.FirstName = 'fat' AND l.LastName = 'ass')
							OR (l.FirstName = 'mickey' AND l.LastName = 'mouse')
							OR (l.FirstName = 'minnie' AND l.LastName = 'mouse')
							OR (l.FirstName = 'donald' AND l.LastName = 'duck')
							OR (l.FirstName = 'daisy' AND l.LastName = 'duck')
							OR (l.FirstName = 'fuck' AND l.LastName = 'off')
							OR (l.FirstName = 'do not' AND l.LastName = 'use')
						)
					)
				OR (
					(
						ec.Name NOT LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%'
						OR	ec.Name LIKE '%@hcfm.com'
						OR	ec.Name LIKE '%hairclub.com'
						OR	ec.Name LIKE '%@test.com'
						OR	ec.Name LIKE '%aaaa%'
						OR	ec.Name LIKE '%bbbb%'
						OR	ec.Name LIKE '%cccc%'
						OR	ec.Name LIKE '%dddd%'
						OR	ec.Name LIKE '%eeee%'
						OR	ec.Name LIKE '%ffff%'
						OR	ec.Name LIKE '%gggg%'
						OR	ec.Name LIKE '%hhhh%'
						OR	ec.Name LIKE '%iiii%'
						OR	ec.Name LIKE '%jjjj%'
						OR	ec.Name LIKE '%kkkk%'
						OR	ec.Name LIKE '%llll%'
						OR	ec.Name LIKE '%mmmm%'
						OR	ec.Name LIKE '%nnnn%'
						OR	ec.Name LIKE '%oooo%'
						OR	ec.Name LIKE '%pppp%'
						OR	ec.Name LIKE '%rrrr%'
						OR	ec.Name LIKE '%ssss%'
						OR	ec.Name LIKE '%tttt%'
						OR	ec.Name LIKE '%uuuu%'
						OR	ec.Name LIKE '%vvvv%'
						OR	ec.Name LIKE '%wwww%'
						OR	ec.Name LIKE '%xxxx%'
						OR	ec.Name LIKE '%yyyy%'
						OR	ec.Name LIKE '%zzzz%'
						OR	ec.Name LIKE '%EMAIL.COM'
						OR	ec.Name LIKE 'TEST123@%'
						OR	ec.Name LIKE 'TEST@%'
						OR	ec.Name LIKE 'TEST#@%'
						OR	ec.Name LIKE 'TESTPERSON@%'
						OR	ec.Name LIKE 'TESTWEB@%'
						OR	ec.Name LIKE 'TESTWEB#@%'
						OR	ec.Name IS NULL
					)
					AND (
							LEN(pc.PhoneAbr__c) NOT BETWEEN 10 AND 15
							OR	pc.PhoneAbr__c LIKE '0000%'
							OR	pc.PhoneAbr__c LIKE '1111%'
							OR	pc.PhoneAbr__c LIKE '2222%'
							OR	pc.PhoneAbr__c LIKE '333%'
							OR	pc.PhoneAbr__c LIKE '4444%'
							OR	pc.PhoneAbr__c LIKE '5555%'
							OR	pc.PhoneAbr__c LIKE '666%'
							OR	pc.PhoneAbr__c LIKE '7777777%'
							OR	pc.PhoneAbr__c LIKE '8888888%'
							OR	pc.PhoneAbr__c LIKE '9999%'
							OR	pc.PhoneAbr__c LIKE '123%'
							OR	ISNUMERIC(pc.PhoneAbr__c) = 0
							OR	pc.PhoneAbr__c IS NULL
						)
				))

    RETURN

END
GO
