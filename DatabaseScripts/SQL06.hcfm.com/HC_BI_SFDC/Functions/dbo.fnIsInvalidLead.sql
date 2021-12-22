/* CreateDate: 10/02/2020 13:43:53.373 , ModifyDate: 03/22/2021 16:26:03.863 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
NAME:					fnIsInvalidLead
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					DLeiba
------------------------------------------------------------------------
NOTES:
	10/09/2020	KMurdoch	Removed check for Primary Flag per Jason K & Michael S
	11/20/2020  KMurdoch    Added check for last names = 'test' or ending with 'test'
	11/24/2020  KMurdoch    Added check for first name = 'test'
	11/30/2020	DLeiba		Added Date Criteria for Lead Definition
	02/05/2021	KMurdoch	Added replace to handle special characters in SalesForce phone & mobile phone
	03/09/2021	KMurdoch    Added Question (?) to invalid characters.
	03/18/2021  KMurdoch    Changed Hairclub.com, hcfm.com, email.com & test.com email addresses to be always invalid regardless of phone or name.
	03/20/2021  KMurdoch    Added check for Lead_Activity_Status__c - Moved to the top outside the name validation
------------------------------------------------------------------------


------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnIsInvalidLead('00Q1V00000wKnAmUAK')
SELECT * FROM dbo.fnIsInvalidLead('00Q1L00001aEaSFUA0')
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
    WHERE l.Id = @SFDC_LeadID
          AND CAST(l.ReportCreateDate__c AS DATE) >= '1/1/2020'
          AND
          (
              (
                  (l.Lead_Activity_Status__c = 'INVALID')

                  OR

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
                      OR l.FirstName LIKE '%[%$!#?@*]%'
                      OR l.FirstName LIKE '[0-9]%'
                      OR l.FirstName LIKE 'test%[0-9]'
                      OR l.FirstName LIKE 'test'
                      OR l.FirstName LIKE '123%'
                      OR l.FirstName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
                      OR l.FirstName IS NULL
                  )
                  OR
                  (
                      l.LastName LIKE 'aaa%'
                      OR l.LastName LIKE 'bbb%'
                      OR l.LastName LIKE 'ccc%'
                      OR l.LastName LIKE 'ddd%'
                      OR l.LastName LIKE 'eee%'
                      OR l.LastName LIKE 'fff%'
                      OR l.LastName LIKE 'ggg%'
                      OR l.LastName LIKE 'hhh%'
                      OR l.LastName LIKE 'iii%'
                      OR l.LastName LIKE 'jjj%'
                      OR l.LastName LIKE 'kkk%'
                      OR l.LastName LIKE 'llll%'
                      OR l.LastName LIKE 'mmm%'
                      OR l.LastName LIKE 'nnn%'
                      OR l.LastName LIKE 'ooo%'
                      OR l.LastName LIKE 'ppp%'
                      OR l.LastName LIKE 'qqq%'
                      OR l.LastName LIKE 'rrr%'
                      OR l.LastName LIKE 'sss%'
                      OR l.LastName LIKE 'ttt%'
                      OR l.LastName LIKE 'uuu%'
                      OR l.LastName LIKE 'vvv%'
                      OR l.LastName LIKE 'www%'
                      OR l.LastName LIKE 'xxx%'
                      OR l.LastName LIKE 'yyy%'
                      OR l.LastName LIKE 'zzz%'
                      OR l.LastName LIKE '%[&%$!?#@*]%'
                      OR l.LastName LIKE '[0-9]%'
                      OR l.LastName LIKE 'test%[0-9]'
                      OR l.LastName LIKE 'test'
                      OR l.LastName LIKE '%test'
                      OR l.LastName LIKE '123%'
                      OR l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
                      OR l.LastName IS NULL
                  )
                  OR
                  (
                      (
                          l.FirstName = 'fat'
                          AND l.LastName = 'ass'
                      )
                      OR
                      (
                          l.FirstName = 'mickey'
                          AND l.LastName = 'mouse'
                      )
                      OR
                      (
                          l.FirstName = 'minnie'
                          AND l.LastName = 'mouse'
                      )
                      OR
                      (
                          l.FirstName = 'donald'
                          AND l.LastName = 'duck'
                      )
                      OR
                      (
                          l.FirstName = 'daisy'
                          AND l.LastName = 'duck'
                      )
                      OR
                      (
                          l.FirstName = 'fuck'
                          AND l.LastName = 'off'
                      )
                      OR
                      (
                          l.FirstName = 'do not'
                          AND l.LastName = 'use'
                      )
                      OR ISNULL(ec.Name, l.Email) LIKE '%hairclub.com'
                      OR ISNULL(ec.Name, l.Email) LIKE '%@hcfm.com'
                      OR ISNULL(ec.Name, l.Email) LIKE '%@email.com'
                      OR ISNULL(ec.Name, l.Email) LIKE '%@test.com'

                  )
              )
              OR
              (
                  (
                      ISNULL(ec.Name, l.Email)NOT LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%@hcfm.com'
                      OR ISNULL(ec.Name, l.Email) LIKE '%hairclub.com'
                      OR ISNULL(ec.Name, l.Email) LIKE '%@test.com'
                      OR ISNULL(ec.Name, l.Email) LIKE '%aaaa%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%bbbb%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%cccc%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%dddd%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%eeee%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%ffff%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%gggg%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%hhhh%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%iiii%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%jjjj%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%kkkk%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%llll%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%mmmm%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%nnnn%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%oooo%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%pppp%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%rrrr%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%ssss%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%tttt%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%uuuu%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%vvvv%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%wwww%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%xxxx%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%yyyy%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%zzzz%'
                      OR ISNULL(ec.Name, l.Email) LIKE '%EMAIL.COM'
                      OR ISNULL(ec.Name, l.Email) LIKE 'TEST123@%'
                      OR ISNULL(ec.Name, l.Email) LIKE 'TEST@%'
                      OR ISNULL(ec.Name, l.Email) LIKE 'TEST#@%'
                      OR ISNULL(ec.Name, l.Email) LIKE 'TESTPERSON@%'
                      OR ISNULL(ec.Name, l.Email) LIKE 'TESTWEB@%'
                      OR ISNULL(ec.Name, l.Email) LIKE 'TESTWEB#@%'
                      OR ISNULL(ec.Name, l.Email) IS NULL
                  )
                  AND
                  (
                      LEN(COALESCE(
                                      pc.PhoneAbr__c,
                                      REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                      REPLACE(
                                                 REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                 '-',
                                                 ''
                                             )
                                  )
                         ) NOT
          BETWEEN 10 AND 15
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '0000%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '1111%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '2222%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '333%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '4444%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '5555%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '666%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '7777777%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '8888888%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '9999%'
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) LIKE '123%'
                      OR ISNUMERIC(COALESCE(
                                               pc.PhoneAbr__c,
                                               REPLACE(
                                                          REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''),
                                                          '-',
                                                          ''
                                                      ),
                                               REPLACE(
                                                          REPLACE(
                                                                     REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''),
                                                                     ' ',
                                                                     ''
                                                                 ),
                                                          '-',
                                                          ''
                                                      )
                                           )
                                  ) = 0
                      OR COALESCE(
                                     pc.PhoneAbr__c,
                                     REPLACE(REPLACE(REPLACE(REPLACE(l.Phone, '(', ''), ')', ''), ' ', ''), '-', ''),
                                     REPLACE(
                                                REPLACE(REPLACE(REPLACE(l.MobilePhone, '(', ''), ')', ''), ' ', ''),
                                                '-',
                                                ''
                                            )
                                 ) IS NULL
                  )
              )
          );

    RETURN;

END;
GO
