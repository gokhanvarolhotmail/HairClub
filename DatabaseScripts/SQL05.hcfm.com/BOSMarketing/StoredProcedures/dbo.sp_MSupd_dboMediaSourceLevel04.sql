/* CreateDate: 07/30/2015 15:49:41.923 , ModifyDate: 07/30/2015 15:49:41.923 */
GO
create procedure [sp_MSupd_dboMediaSourceLevel04]
		@c1 int = NULL,
		@c2 varchar(50) = NULL,
		@c3 varchar(50) = NULL,
		@c4 smallint = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourceLevel04] set
		[Level04FormatCode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Level04FormatCode] end,
		[Level04Format] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Level04Format] end,
		[MediaID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MediaID] end
where [Level04ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
