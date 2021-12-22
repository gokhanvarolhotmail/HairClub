/* CreateDate: 11/28/2017 16:44:10.937 , ModifyDate: 11/28/2017 16:44:10.937 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				dbaFindText

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		10/27/2010

LAST REVISION DATE: 	10/27/2010

==============================================================================
DESCRIPTION: Searches stored procs for a text string
==============================================================================
NOTES:
		* 10/27/2010 PRM - Created

==============================================================================
SAMPLE EXECUTION:

EXEC dbaFindText 'somestring'
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaFindText]
   @SearchText nvarchar(255)
AS
  BEGIN
	SELECT o.name
	FROM syscomments c, sysobjects o
	WHERE o.type = 'p'
		AND o.id = c.id
		AND c.text LIKE '%' + @SearchText + '%'
	ORDER BY o.name

  END
GO
