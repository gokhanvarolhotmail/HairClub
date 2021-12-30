/* CreateDate: 08/05/2015 09:01:32.107 , ModifyDate: 08/05/2015 09:01:32.107 */
GO
create procedure [sp_MSdel_dboContactLudwigScale]
		@pkc1 varchar(50)
as
begin
	delete [dbo].[ContactLudwigScale]
where [HairScaleCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
