/* CreateDate: 07/30/2015 15:49:42.003 , ModifyDate: 07/30/2015 15:49:42.003 */
GO
create procedure [sp_MSupd_dboMediaSourceMediaTypes]
		@c1 smallint = NULL,
		@c2 varchar(50) = NULL,
		@c3 varchar(50) = NULL,
		@pkc1 smallint = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourceMediaTypes] set
		[MediaCode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MediaCode] end,
		[Media] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Media] end
where [MediaID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
