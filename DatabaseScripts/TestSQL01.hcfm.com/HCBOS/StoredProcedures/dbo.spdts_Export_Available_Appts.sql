/* CreateDate: 08/10/2006 13:53:13.530 , ModifyDate: 01/25/2010 08:11:31.743 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

==============================================================================
PROCEDURE:                    spdts_Export_Available_Appts

VERSION:                      v1.0

DESTINATION SERVER:           HCTESTSQL1\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:                 Howard Abelow

DATE IMPLEMENTED:              5/3/2006

LAST REVISION DATE:      9/24/2007

==============================================================================
DESCRIPTION: Gets the dataset of available appts for export into text file
==============================================================================

==============================================================================
NOTES: 	9/24/2007: HAbelow testing/debugging
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spdts_Export_Available_Appts
==============================================================================

*/
CREATE     PROCEDURE [dbo].[spdts_Export_Available_Appts]
AS

SELECT distinct Center
,	Apptdate
,	ApptTime
FROM dbo.Appointments_Matrix
WHERE Appts > 0
ORDER BY Center, Apptdate, ApptTime
GO
