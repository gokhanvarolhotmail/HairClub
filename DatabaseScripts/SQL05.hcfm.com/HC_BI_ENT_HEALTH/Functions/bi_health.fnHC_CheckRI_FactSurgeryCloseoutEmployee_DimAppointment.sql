/* CreateDate: 10/24/2011 14:11:09.563 , ModifyDate: 10/24/2011 14:11:09.563 */
GO
create   FUNCTION [bi_health].[fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimAppointment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimAppointment]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimAppointment]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-24-11  KMurdoch     Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, DimensionName varchar(150)
					, FieldName varchar(150)
					, FieldKey bigint
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @DimensionName			varchar(150)	-- Name of field
			, @FieldName				varchar(150)	-- Name of field

 	SET @TableName = N'[bi_cms_dds].[FactSurgeryCloseoutEmployee]'
  	SET @DimensionName = N'[bi_cms_dds].[DimAppointment]'
	SET @FieldName = N'[AppointmentKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, AppointmentKey
		FROM [bi_health].[synHC_DDS_FactSurgeryCloseoutEmployee]  WITH (NOLOCK)
		WHERE AppointmentKey NOT
		IN (
				SELECT SRC.AppointmentKey
				FROM [bi_health].[synHC_DDS_DimAppointment] SRC WITH (NOLOCK)
			)

RETURN
END
GO
