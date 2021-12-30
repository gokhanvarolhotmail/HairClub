/* CreateDate: 08/05/2015 09:01:32.177 , ModifyDate: 08/05/2015 09:01:32.177 */
GO
create procedure [sp_MSupd_dboContactNorwoodScale]
		@c1 varchar(50) = NULL,
		@c2 varchar(50) = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@pkc1 varchar(50) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[ContactNorwoodScale] set
		[HairScaleCode] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairScaleCode] end,
		[Description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Description] end,
		[Active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Active] end,
		[SortOrder] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SortOrder] end
where [HairScaleCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[ContactNorwoodScale] set
		[Description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Description] end,
		[Active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Active] end,
		[SortOrder] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SortOrder] end
where [HairScaleCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
