/* CreateDate: 05/12/2010 10:53:16.283 , ModifyDate: 05/13/2010 14:40:55.360 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimActivityType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimActivityType]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivityType]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_mktg_dds].[DimActivityType]'


	INSERT INTO @tbl
		SELECT @TableName, ActivityTypeKey, ActivityTypeSSID
		FROM [bi_health].[synHC_DDS_DimActivityType] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimActivityType] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
