/* CreateDate: 04/26/2018 09:34:34.387 , ModifyDate: 04/26/2018 09:34:34.387 */
GO
create procedure [dbo].[sp_MSdel_dboSolutionsOffered]     @pkc1 varchar(50)
as
begin   	delete [dbo].[SolutionsOffered]
where [SolutionsCode] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
