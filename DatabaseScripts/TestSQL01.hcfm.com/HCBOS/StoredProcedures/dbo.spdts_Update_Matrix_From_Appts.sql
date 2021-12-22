/* CreateDate: 08/10/2006 13:53:14.077 , ModifyDate: 01/25/2010 08:11:31.743 */
GO
/*

==============================================================================
PROCEDURE:                    spdts_Update_Matrix_From_Appts

VERSION:                      v1.0

DESTINATION SERVER:           HCTESTSQL1\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:                 Howard Abelow

DATE IMPLEMENTED:              5/3/2006

LAST REVISION DATE:      9/24/2007

==============================================================================
DESCRIPTION: Updates the matrix by subtarcting the actual appts
==============================================================================

==============================================================================
NOTES: 	9/24/2007: HAbelow testing/debugging
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spdts_Update_Matrix_From_Appts
==============================================================================

*/
CREATE  PROCEDURE [dbo].[spdts_Update_Matrix_From_Appts]
AS
    UPDATE  m --dbo.Appointments_Matrix
    SET     m.Appts = m.Appts - s.Appts
    FROM    dbo.Appointments_Matrix m,
            dbo.Appointments_Scheduled s
    WHERE   m.center = s.center
            AND m.ApptDate = s.ApptDate
            AND m.ApptTime = s.ApptTime
GO
