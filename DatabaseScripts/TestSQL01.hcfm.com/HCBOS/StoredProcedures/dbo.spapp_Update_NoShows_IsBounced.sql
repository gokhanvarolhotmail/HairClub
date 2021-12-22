/* CreateDate: 08/09/2007 14:34:36.827 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE  [dbo].[spapp_Update_NoShows_IsBounced]

AS

/*

**  Update the noshows with the flag that specifies a .

**  bounced email for the NS1 campaign email that was sent

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/19/06  HABELOW   CREATE     		No Show Emails

**  08/02/07  MWEGNER(ONC) retrofitted for ONCV




SET NOCOUNT ON

UPDATE  dbo.noshowsdaily

SET  isBounced = 1

FROM  dbo.NoShowsBounced nsb

	INNER JOIN  dbo.noshowsdaily nsd

	ON nsb.recordid = nsd.recordid
*/


SET NOCOUNT ON

UPDATE  dbo.noshowsdaily

SET  isBounced = 1

FROM  dbo.NoShowsBounced nsb

	INNER JOIN  dbo.noshowsdaily nsd

	ON nsb.contact_id = nsd.contact_id
GO
