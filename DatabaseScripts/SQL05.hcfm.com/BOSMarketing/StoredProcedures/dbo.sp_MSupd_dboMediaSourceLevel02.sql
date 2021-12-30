/* CreateDate: 07/30/2015 15:49:41.840 , ModifyDate: 07/30/2015 15:49:41.840 */
GO
create procedure [sp_MSupd_dboMediaSourceLevel02]
		@c1 smallint = NULL,
		@c2 varchar(10) = NULL,
		@c3 varchar(50) = NULL,
		@c4 smallint = NULL,
		@pkc1 smallint = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourceLevel02] set
		[Level02LocationCode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Level02LocationCode] end,
		[Level02Location] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Level02Location] end,
		[MediaID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MediaID] end
where [Level02ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
