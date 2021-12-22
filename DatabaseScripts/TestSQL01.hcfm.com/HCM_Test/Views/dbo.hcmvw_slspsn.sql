/* CreateDate: 10/17/2007 08:55:07.557 , ModifyDate: 05/01/2010 14:48:09.343 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[hcmvw_slspsn]

AS

SELECT user_code as telemarketer, display_name as description, title, 1 AS 'ORDER'

FROM onca_user  WITH(NOLOCK)


WHERE user_code Like 'T%'
GO
