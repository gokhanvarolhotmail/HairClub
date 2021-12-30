/* CreateDate: 07/30/2015 15:49:42.043 , ModifyDate: 07/30/2015 15:49:42.043 */
GO
create procedure [sp_MSupd_dboMediaSourceNumberTypes]
		@c1 tinyint = NULL,
		@c2 varchar(50) = NULL,
		@pkc1 tinyint = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[MediaSourceNumberTypes] set
		[NumberType] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [NumberType] end
where [NumberTypeID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
