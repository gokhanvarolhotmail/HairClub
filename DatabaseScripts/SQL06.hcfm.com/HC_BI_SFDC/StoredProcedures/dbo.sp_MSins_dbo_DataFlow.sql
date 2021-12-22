/* CreateDate: 10/04/2019 14:09:30.093 , ModifyDate: 10/04/2019 14:09:30.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_dbo_DataFlow]
    @c1 int,
    @c2 varchar(250),
    @c3 varchar(50),
    @c4 datetime,
    @c5 datetime
as
begin
	insert into [dbo].[_DataFlow] (
		[DataFlowKey],
		[TableName],
		[Status],
		[LSET],
		[CET]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5	)
end
GO
