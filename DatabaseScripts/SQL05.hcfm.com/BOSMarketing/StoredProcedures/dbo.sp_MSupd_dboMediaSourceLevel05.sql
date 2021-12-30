/* CreateDate: 07/30/2015 15:49:41.967 , ModifyDate: 07/30/2015 15:49:41.967 */
GO
create procedure [sp_MSupd_dboMediaSourceLevel05]
		@c1 int = NULL,
		@c2 varchar(10) = NULL,
		@c3 varchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourceLevel05] set
		[Level05CreativeCode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Level05CreativeCode] end,
		[Level05Creative] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Level05Creative] end
where [Level05ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
