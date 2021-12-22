/* CreateDate: 11/14/2007 13:42:22.090 , ModifyDate: 05/01/2010 14:48:09.990 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure sprpt_TestExcel (@begdt datetime, @Enddt datetime)
AS

select top 100 *
from oncd_activity where creation_date between @begdt and @Enddt
GO
