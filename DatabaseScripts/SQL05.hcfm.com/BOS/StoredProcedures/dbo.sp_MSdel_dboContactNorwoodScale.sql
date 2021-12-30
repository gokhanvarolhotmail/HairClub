/* CreateDate: 08/05/2015 09:01:32.187 , ModifyDate: 08/05/2015 09:01:32.187 */
GO
create procedure [sp_MSdel_dboContactNorwoodScale]
		@pkc1 varchar(50)
as
begin
	delete [dbo].[ContactNorwoodScale]
where [HairScaleCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
