/* CreateDate: 07/30/2015 15:49:42.167 , ModifyDate: 07/30/2015 15:49:42.167 */
GO
create procedure [sp_MSupd_dboMediaSourceQwestOptions]
		@c1 smallint = NULL,
		@c2 char(50) = NULL,
		@pkc1 smallint = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourceQwestOptions] set
		[Qwest] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Qwest] end
where [QwestID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
