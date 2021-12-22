/* CreateDate: 08/10/2006 13:53:14.623 , ModifyDate: 01/25/2010 08:11:31.743 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

==============================================================================
PROCEDURE:                    spdts_Update_Matrix_From_Closings

VERSION:                      v1.0

DESTINATION SERVER:           HCTESTSQL1\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:                 Howard Abelow

DATE IMPLEMENTED:              5/3/2006

LAST REVISION DATE:      9/24/2007

==============================================================================
DESCRIPTION: Updates the matrix by subtracting the center closings
==============================================================================

==============================================================================
NOTES: 	9/24/2007: HAbelow testing/debugging
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spdts_Update_Matrix_From_Closings
==============================================================================

*/
CREATE    PROCEDURE [dbo].[spdts_Update_Matrix_From_Closings]
AS
    UPDATE  m --dbo.Appointments_Matrix
    SET     m.Appts = 0
    FROM    dbo.Appointments_Matrix m,
            dbo.Appointments_Special_Closings sc
    WHERE   m.center = sc.center
            AND m.ApptDate = sc.CloseDate
            AND ( CONVERT(SMALLDATETIME, m.ApptTime) BETWEEN CONVERT(SMALLDATETIME, sc.FromTime)
                                                     AND     CONVERT(SMALLDATETIME, sc.ToTime) )
            AND Active = 1
            AND m.Appts > 0
GO
