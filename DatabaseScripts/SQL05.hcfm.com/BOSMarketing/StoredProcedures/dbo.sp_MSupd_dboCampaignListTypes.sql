/* CreateDate: 07/30/2015 15:49:41.693 , ModifyDate: 07/30/2015 15:49:41.693 */
GO
create procedure [sp_MSupd_dboCampaignListTypes]
		@c1 int = NULL,
		@c2 varchar(60) = NULL,
		@c3 varchar(1000) = NULL,
		@c4 smalldatetime = NULL,
		@c5 varchar(40) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
update [dbo].[CampaignListTypes] set
		[ListName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ListName] end,
		[ListDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ListDescription] end,
		[DateCreated] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DateCreated] end,
		[CreatedBy] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreatedBy] end
where [ListID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
