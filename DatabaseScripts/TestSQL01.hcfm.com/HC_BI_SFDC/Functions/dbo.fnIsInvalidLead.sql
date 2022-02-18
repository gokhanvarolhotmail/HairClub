/* CreateDate: 10/02/2020 13:43:45.753 , ModifyDate: 05/12/2021 16:01:35.897 */
GO
/***********************************************************************
NAME:					fnIsInvalidLead
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					DLeiba
------------------------------------------------------------------------
NOTES:
	04/07/2021	KMurdoch	Rewrite from Team International
------------------------------------------------------------------------


------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnIsInvalidLead('00Q1L00001aEa2vUAC')
SELECT * FROM dbo.fnIsInvalidLead('00Q1L00001aEa2vUAC')
***********************************************************************/
CREATE FUNCTION [dbo].[fnIsInvalidLead]
(
    @SFDC_LeadID NVARCHAR(18)
)
RETURNS @IsInvalid TABLE
(
    Id NVARCHAR(18),
    IsInvalidLead BIT
)
AS
BEGIN

    INSERT INTO @IsInvalid
    SELECT DISTINCT
           l.Id,
           1 AS 'IsInvalidLead'
    FROM HC_BI_SFDC.dbo.Lead l
        LEFT OUTER JOIN HC_BI_SFDC.dbo.Email__c ec
            ON ec.Lead__c = l.Id
               --AND ec.Primary__c = 1
               AND ec.IsDeleted = 0
        LEFT OUTER JOIN HC_BI_SFDC.dbo.Phone__c pc
            ON pc.Lead__c = l.Id
               --AND pc.Primary__c = 1
               AND pc.IsDeleted = 0
WHERE  l.Id = @SFDC_LeadID
          AND CAST(l.ReportCreateDate__c AS DATE) >= '10/1/2020'
          AND
			((
                                (
                                    l.FirstName LIKE 'aaa%'
									OR ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(l.LastName,'(',''),')',''),' ',''),'-','') )=1			-----*****change
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
                                    OR l.FirstName LIKE '%[!@#$%^&*?:{}|<>\]%'					-----*****change removed (), periods (.), and forward slash /
                                    OR l.FirstName LIKE '[0-9]%'
                                    OR l.FirstName LIKE 'test%[0-9]'
                                    OR l.FirstName LIKE 'test'
                                    OR l.FirstName LIKE 'test%'
                                    OR l.FirstName LIKE '%test'
                                    OR l.FirstName LIKE '123%'
                                    OR l.FirstName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
                                    OR l.FirstName IS NULL
                                )
                                OR (
                                    l.LastName LIKE 'aaa%'
									OR ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(l.LastName,'(',''),')',''),' ',''),'-','') ) = 1  -----*****change
                                    OR  l.LastName LIKE 'bbb%'
                                    OR  l.LastName LIKE 'ccc%'
                                    OR  l.LastName LIKE 'ddd%'
                                    OR  l.LastName LIKE 'eee%'
                                    OR  l.LastName LIKE 'fff%'
                                    OR  l.LastName LIKE 'ggg%'
                                    OR  l.LastName LIKE 'hhh%'
                                    OR  l.LastName LIKE 'iii%'
                                    OR  l.LastName LIKE 'jjj%'
                                    OR  l.LastName LIKE 'kkk%'
                                    OR  l.LastName LIKE 'llll%'
                                    OR  l.LastName LIKE 'mmm%'
                                    OR  l.LastName LIKE 'nnn%'
                                    OR  l.LastName LIKE 'ooo%'
                                    OR  l.LastName LIKE 'ppp%'
                                    OR  l.LastName LIKE 'qqq%'
                                    OR  l.LastName LIKE 'rrr%'
                                    OR  l.LastName LIKE 'sss%'
                                    OR  l.LastName LIKE 'ttt%'
                                    OR  l.LastName LIKE 'uuu%'
                                    OR  l.LastName LIKE 'vvv%'
                                    OR  l.LastName LIKE 'www%'
                                    OR  l.LastName LIKE 'xxx%'
                                    OR  l.LastName LIKE 'yyy%'
                                    OR  l.LastName LIKE 'zzz%'
                                    OR  l.LastName LIKE '%[!@#$%^&*?:{}|<>\]%'				-----*****change removed (), periods (.), and forward slash /
                                    OR  l.LastName LIKE '[0-9]%'
                                    OR  l.LastName LIKE 'test%[0-9]%'						----***** change adde left bracket after 9 ]
                                    OR  l.LastName LIKE 'test'
                                    OR  l.LastName LIKE '%test'
                                    --OR  l.LastName LIKE 'test%'					-----*****this is a change because people named 'Testa', 'Tester', Testaverde
                                    OR  l.LastName LIKE '123%'
                                    OR  l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
									--OR  l.LastName like '[.]'					-----*****this is a change		added check for periods only - s/b invalid
                                    OR  l.LastName IS NULL
                                )
                                OR ((l.FirstName = 'fat' AND l.LastName = 'ass')
                                    OR (l.FirstName = 'mickey' AND l.LastName = 'mouse')
                                    OR (l.FirstName = 'minnie' AND l.LastName = 'mouse')
                                    OR (l.FirstName = 'donald' AND l.LastName = 'duck')
                                    OR (l.FirstName = 'daisy' AND l.LastName = 'duck')
                                    OR (l.FirstName = 'fuck' AND l.LastName = 'off')
                                    OR (l.FirstName = 'do not' AND l.LastName = 'use')
                                    OR (l.FirstName IS NULL AND l.LastName IS NULL)
                                )
                            )
                        OR (
                                l.Email LIKE '%@hcfm.com'
                                OR  l.Email LIKE '%hairclub.com'
                            )
                        OR (
                            (
                                l.Email NOT LIKE '%[-A-Z0-9_][@][A-Z0-9]%[.][A-Z0-9]%'
                                OR  l.Email LIKE '%@hcfm.com'
                                OR  l.Email LIKE '%hairclub.c%'
                                OR  l.Email LIKE '%@test.com'
                                OR  l.Email LIKE '%aaaa%'
                                OR  l.Email LIKE '%bbbb%'
                                OR  l.Email LIKE '%cccc%'
                                OR  l.Email LIKE '%dddd%'
                                OR  l.Email LIKE '%eeee%'
                                OR  l.Email LIKE '%ffff%'
                                OR  l.Email LIKE '%gggg%'
                                OR  l.Email LIKE '%hhhh%'
                                OR  l.Email LIKE '%iiii%'
                                OR  l.Email LIKE '%jjjj%'
                                OR  l.Email LIKE '%kkkk%'
                                OR  l.Email LIKE '%llll%'
                                OR  l.Email LIKE '%mmmm%'
                                OR  l.Email LIKE '%nnnn%'
                                OR  l.Email LIKE '%oooo%'
                                OR  l.Email LIKE '%pppp%'
                                OR  l.Email LIKE '%rrrr%'
                                OR  l.Email LIKE '%ssss%'
                                OR  l.Email LIKE '%tttt%'
                                OR  l.Email LIKE '%uuuu%'
                                OR  l.Email LIKE '%vvvv%'
                                OR  l.Email LIKE '%wwww%'
                                OR  l.Email LIKE '%xxxx%'
                                OR  l.Email LIKE '%yyyy%'
                                OR  l.Email LIKE '%zzzz%'
                                --OR  l.Email LIKE '%EMAIL.COM'				----*****We believe this is a valid email domain
                                OR  l.Email LIKE 'TEST123@%'
                                OR  l.Email LIKE 'TEST@%'
                                OR  l.Email LIKE 'TEST#@%'
                                OR  l.Email LIKE 'TESTPERSON@%'
                                OR  l.Email LIKE 'TESTWEB@%'
                                OR  l.Email LIKE 'TESTWEB#@%'
                                OR  l.Email IS NULL
                            )
                            AND (
                                    LEN(REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','')) NOT BETWEEN 10 AND 15
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '0000%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '1111%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '2222%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '333%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '4444%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '5555%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '666%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '7777777%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '8888888%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '9999%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '123%'
                                    --OR  ISNUMERIC(l.Phone) = 0
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') IS NULL
                                )
                            AND (
                                    LEN(REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','')) NOT BETWEEN 10 AND 15
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '0000%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '1111%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '2222%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '333%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '4444%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '5555%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '666%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '7777777%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '8888888%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '9999%'
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '123%'
                                    --OR  ISNUMERIC(l.Phone) = 0
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') IS NULL
                                )
                        ));

    RETURN;

END;
GO
