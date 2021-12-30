/* CreateDate: 07/30/2015 15:49:41.680 , ModifyDate: 07/30/2015 15:49:41.680 */
GO
create procedure [sp_MSins_dboCampaignListTypes]
    @c1 int,
    @c2 varchar(60),
    @c3 varchar(1000),
    @c4 smalldatetime,
    @c5 varchar(40)
as
begin
	insert into [dbo].[CampaignListTypes](
		[ListID],
		[ListName],
		[ListDescription],
		[DateCreated],
		[CreatedBy]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5	)
end
GO
