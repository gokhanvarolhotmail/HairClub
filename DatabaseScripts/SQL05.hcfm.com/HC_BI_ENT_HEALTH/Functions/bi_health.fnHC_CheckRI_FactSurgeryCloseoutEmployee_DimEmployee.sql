/* CreateDate: 10/24/2011 14:10:02.370 , ModifyDate: 10/24/2011 14:10:02.370 */
GO
create    FUNCTION [bi_health].[fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSurgeryCloseoutEmployee_DimEmployee]()
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
  	SET @DimensionName = N'[bi_cms_dds].[DimEmployee]'
	SET @FieldName = N'[EmployeeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, AppointmentKey
		FROM [bi_health].[synHC_DDS_FactSurgeryCloseoutEmployee]  WITH (NOLOCK)
		WHERE EmployeeKey NOT
		IN (
				SELECT SRC.EmployeeKey
				FROM [bi_health].[synHC_DDS_DimEmployee] SRC WITH (NOLOCK)
			)

RETURN
END
GO
