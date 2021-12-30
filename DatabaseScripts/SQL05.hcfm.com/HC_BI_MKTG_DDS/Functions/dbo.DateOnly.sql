/* CreateDate: 08/08/2012 15:45:36.707 , ModifyDate: 08/08/2012 15:45:36.707 */
GO
create  function [dbo].[DateOnly](@DateTime DateTime)
-- Returns @DateTime at midnight; i.e., it removes the time portion of a DateTime value.
returns datetime
as
    begin
    return dateadd(dd,0, datediff(dd,0,@DateTime))
    end
GO
