/* CreateDate: 05/05/2020 17:42:53.600 , ModifyDate: 05/05/2020 17:42:53.600 */
GO
create procedure [sp_MSins_dbodatTelemedicineCollaborationComment]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 nvarchar(max),
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 datetime,
    @c8 nvarchar(25)
as
begin
	insert into [dbo].[datTelemedicineCollaborationComment] (
		[TelemedicineCollaborationCommentGUID],
		[TelemedicineCollaborationGUID],
		[EmployeeGUID],
		[Details],
		[CreateUser],
		[CreateDateTime],
		[LastUpdate],
		[LastUpdateUser]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8	)
end
GO
