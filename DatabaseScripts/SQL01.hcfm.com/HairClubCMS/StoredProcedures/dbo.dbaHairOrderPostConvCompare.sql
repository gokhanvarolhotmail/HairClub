-- EXEC dbaHairOrderPurchaseOrderImport

CREATE PROCEDURE [dbo].[dbaHairOrderPostConvCompare]

AS

BEGIN

delete from [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
--systypecode - System Type

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'systypecod',
	vw.systypecod,
	o.systypecod,
	vw.serialnumb,
	'System Type not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.systypecod) <> rtrim(vw.systypecod)

--scolorcode - Matrix Color

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'scolorcode',
	vw.scolorcode,
	o.scolorcode,
	vw.serialnumb,
	'Matrix Color not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where o.scolorcode <> vw.scolorcode


--templcode	- Template

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'templcode',
	vw.templcode,
	o.templcode,
	vw.serialnumb,
	'Template not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.templcode) <> rtrim(vw.templcode)

--hairlcode - Hair Length

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairlcode',
	vw.hairlcode,
	o.hairlcode,
	vw.serialnumb,
	'Hair Length not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hairlcode) <> rtrim(vw.hairlcode)

--recesscode - Recession

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'recesscode',
	vw.recesscode,
	o.recesscode,
	vw.serialnumb,
	'recession not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.recesscode) <> rtrim(vw.recesscode)
	and vw.recesscode <> 'Template'

--densecode	 - System Density

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'densecode',
	vw.densecode,
	o.densecode,
	vw.serialnumb,
	'System Density not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.densecode) <> rtrim(vw.densecode)
--
--frontdense - Front Density

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'frontdense',
	vw.frontdense,
	o.frontdense,
	vw.serialnumb,
	'Frontal Density not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.frontdense) <> rtrim(vw.frontdense)
	and vw.frontdense <> 'unkwn' and vw.frontdense <> 'ST'

--frontcode - Front Design

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'frontcode',
	vw.frontcode,
	o.frontcode,
	vw.serialnumb,
	'Front Design not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.frontcode) <> rtrim(vw.frontcode)
--
---hairccode - Curl
--
INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairccode',
	vw.hairccode,
	o.hairccode,
	vw.serialnumb,
	'Curl not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where o.hairccode <> vw.hairccode
--
---hairscode - Style
--
INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairscode',
	vw.hairccode,
	o.hairccode,
	vw.serialnumb,
	'Style not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where o.hairscode <> vw.hairscode

------------------------------------------HAIR COLOR---------------------------------------------
--
--hairtype - Hair Color

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairhuman',
	vw.hairhuman,
	o.hairhuman,
	vw.serialnumb,
	'Hair Color - Type not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hairhuman) <> rtrim(vw.hairhuman)

--haircfront Hair Color - Front

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'haircfront',
	vw.haircfront,
	o.haircfront,
	vw.serialnumb,
	'hair color - Front not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.haircfront) <> rtrim(vw.haircfront)

--hairctempl - Hair Color - Temple

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairctempl',
	vw.hairctempl,
	o.hairctempl,
	vw.serialnumb,
	'Hair Color - Temple not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hairctempl) <> rtrim(vw.hairctempl)

--hairctop - Hair Color - Top

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairctop',
	vw.hairctop,
	o.hairctop,
	vw.serialnumb,
	'Hair Color - Top not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hairctop) <> rtrim(vw.hairctop)

--haircsides - Hair Color - Sides

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'haircsides',
	vw.haircsides,
	o.haircsides,
	vw.serialnumb,
	'Hair Color - Sides not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.haircsides) <> rtrim(vw.haircsides)

--hairccrown - Hair Color - Crown

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hairccrown',
	vw.hairccrown,
	o.hairccrown,
	vw.serialnumb,
	'Hair Color - Crown not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hairccrown) <> rtrim(vw.hairccrown)

--haircback - Hair Color - Back

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'haircback',
	vw.haircback,
	o.haircback,
	vw.serialnumb,
	'Hair Color - Back not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.haircback) <> rtrim(vw.haircback)

------------------------------------------HIGHLIGHT #1---------------------------------------------
--
-- highhuman - Highlight 1 - Hair Type
INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])

select
	'highhuman',
	vw.highhuman,
	o.highhuman,
	vw.serialnumb,
	'Highlight 1 - Hair Type not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highhuman) <> rtrim(vw.highhuman)

-- Highstreak - Highlight 1 - Streak

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highstreak',
	vw.highstreak,
	o.highstreak,
	vw.serialnumb,
	'Highlight 1 - Streak not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highstreak) <> rtrim(vw.highstreak)

--
--highcfront - Highlight 1 - Front

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highcfront',
	vw.highcfront,
	o.highcfront,
	vw.serialnumb,
	'Highlight 1 - Front not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highcfront) <> rtrim(vw.highcfront)

--
--highpfront - Highlight 1 % - Front

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highpfront',
	vw.highpfront,
	o.highpfront,
	vw.serialnumb,
	'Highlight 1 - Front % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highpfront) <> rtrim(vw.highpfront)

--highctempl - Highlight 1 - temple

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highctempl',
	vw.highctempl,
	o.highctempl,
	vw.serialnumb,
	'Highlight 1 - Temple not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highctempl) <> rtrim(vw.highctempl)

--highptempl - Highlight 1 % - temple

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highptempl',
	vw.highptempl,
	o.highptempl,
	vw.serialnumb,
	'Highlight 1 - Temple % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highptempl) <> rtrim(vw.highptempl)

--highctop - Highlight 1 - Top

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highctop',
	vw.highctop,
	o.highctop,
	vw.serialnumb,
	'Highlight 1 - Top not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highctop) <> rtrim(vw.highctop)

--highctop - Highlight 1 % - Top

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highptop',
	vw.highptop,
	o.highptop,
	vw.serialnumb,
	'Highlight 1 - Top %not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highptop) <> rtrim(vw.highptop)

--highcsides - Highlight 1 - Sides

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highcsides',
	vw.highcsides,
	o.highcsides,
	vw.serialnumb,
	'Highlight 1 - Sides not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highcsides) <> rtrim(vw.highcsides)

--highpsides - Highlight 1 % - Sides

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highpsides',
	vw.highpsides,
	o.highpsides,
	vw.serialnumb,
	'Highlight 1 - Sides % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highpsides) <> rtrim(vw.highpsides)

--highccrown - Highlight 1 - Crown

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highccrown',
	vw.highccrown,
	o.highccrown,
	vw.serialnumb,
	'Highlight 1 - Crown not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highccrown) <> rtrim(vw.highccrown)

--highpcrown - Highlight 1 % - Crown

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highpcrown',
	vw.highpcrown,
	o.highpcrown,
	vw.serialnumb,
	'Highlight 1 - Crown % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highpcrown) <> rtrim(vw.highpcrown)


--highcback - Highlight 1 - Back

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highcback',
	vw.highcback,
	o.highcback,
	vw.serialnumb,
	'Highlight 1 - Back not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highcback) <> rtrim(vw.highcback)

--highpback - Highlight 1 % - Back

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'highpback',
	vw.highpback,
	o.highpback,
	vw.serialnumb,
	'Highlight 1 - Back % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.highpback) <> rtrim(vw.highpback)


------------------------------------------HIGHLIGHT #2---------------------------------------------
--
-- highhuman - Highlight 2 - Hair Type

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2human',
	vw.hig2human,
	o.hig2human,
	vw.serialnumb,
	'Highlight 2 - Hair Type not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2human) <> rtrim(vw.hig2human)

-- Highstreak - Highlight 2 - Streak

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2streak',
	vw.hig2streak,
	o.hig2streak,
	vw.serialnumb,
	'Highlight 2 - Streak not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2streak) <> rtrim(vw.hig2streak)

--
--highcfront - Highlight 2 - Front

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2cfront',
	vw.hig2cfront,
	o.hig2cfront,
	vw.serialnumb,
	'Highlight 2 - Front not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2cfront) <> rtrim(vw.hig2cfront)

--
--highpfront - Highlight 2 % - Front
--

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2pfront',
	vw.hig2pfront,

	o.hig2pfront,
	vw.serialnumb,
	'Highlight 2 - Front % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2pfront) <> rtrim(vw.hig2pfront)

--highctempl - Highlight 2 - temple

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2ctempl',
	vw.hig2ctempl,
	o.hig2ctempl,
	vw.serialnumb,
	'Highlight 2 - Temple not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2ctempl) <> rtrim(vw.hig2ctempl)

--highptempl - Highlight 2 % - temple

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2ptempl',
	vw.hig2ptempl,
	o.hig2ptempl,
	vw.serialnumb,
	'Highlight 2 - Temple % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2ptempl) <> rtrim(vw.hig2ptempl)

--highctop - Highlight 2 - Top

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2ctop',
	vw.hig2ctop,
	o.hig2ctop,
	vw.serialnumb,
	'Highlight 2 - Top not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2ctop) <> rtrim(vw.hig2ctop)

--highctop - Highlight 2 % - Top

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2ptop',
	vw.hig2ptop,
	o.hig2ptop,
	vw.serialnumb,
	'Highlight 2 - Top %not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2ptop) <> rtrim(vw.hig2ptop)

--highcsides - Highlight 2 - Sides

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2csides',
	vw.hig2csides,
	o.hig2csides,
	vw.serialnumb,
	'Highlight 2 - Sides not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2csides) <> rtrim(vw.hig2csides)

--highpsides - Highlight 2 % - Sides

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2psides',
	vw.hig2psides,
	o.hig2psides,
	vw.serialnumb,
	'Highlight 2 - Sides % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2psides) <> rtrim(vw.hig2psides)

--highccrown - Highlight 2 - Crown

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2ccrown',
	vw.hig2ccrown,
	o.hig2ccrown,
	vw.serialnumb,
	'Highlight 2 - Crown not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2ccrown) <> rtrim(vw.hig2ccrown)

--highpcrown - Highlight 2 % - Crown

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2pcrown',
	vw.hig2pcrown,
	o.hig2pcrown,
	vw.serialnumb,
	'Highlight 2 - Crown % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2pcrown) <> rtrim(vw.hig2pcrown)


--highcback - Highlight 2 - Back

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2cback',
	vw.hig2cback,
	o.hig2cback,
	vw.serialnumb,
	'Highlight 2 - Back not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2cback) <> rtrim(vw.hig2cback)

--highpback - Highlight 2 % - Back

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'hig2pback',
	vw.hig2pback,
	o.hig2pback,
	vw.serialnumb,
	'Highlight 2 - Back % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.hig2pback) <> rtrim(vw.hig2pback)



------------------------------------------Grey %---------------------------------------------
--
--Grey Hair Type

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greyhuman',
	vw.greyhuman,
	o.greyhuman,
	vw.serialnumb,
	'Grey Hair Type not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greyhuman) <> rtrim(vw.greyhuman)

--Grey % - Front

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greypfront',
	vw.greypfront,
	o.greypfront,
	vw.serialnumb,
	'Grey Front % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greypfront) <> rtrim(vw.greypfront)

--Grey % - Temple

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greyptempl',
	vw.greyptempl,
	o.greyptempl,
	vw.serialnumb,
	'Grey Temple % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greyptempl) <> rtrim(vw.greyptempl)

--Grey % - Top

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greyptop',
	vw.greyptop,
	o.greyptop,
	vw.serialnumb,
	'Grey Top % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greyptop) <> rtrim(vw.greyptop)

--Grey % - Sides

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greypsides',
	vw.greypsides,
	o.greypsides,
	vw.serialnumb,
	'Grey Sides % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greypsides) <> rtrim(vw.greypsides)

--Grey % - Crown

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greypcrown',
	vw.greypcrown,
	o.greypcrown,
	vw.serialnumb,
	'Grey crown % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greypcrown) <> rtrim(vw.greypcrown)

--Grey % - back

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'greypback',
	vw.greypback,
	o.greypback,
	vw.serialnumb,
	'Grey back % not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.greypback) <> rtrim(vw.greypback)

--templ Width

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'templwidth',
	vw.templwidth,
	o.templwidth,
	vw.serialnumb,
	'Template Width not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.templwidth) <> rtrim(vw.templwidth)

--templ Adj Width

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'adjwidth',
	vw.adjwidth,
	o.adjwidth,
	vw.serialnumb,
	'Template adj Width not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.adjwidth) <> rtrim(vw.adjwidth)

--templength

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'templength',
	vw.templength,
	o.templength,
	vw.serialnumb,
	'Template adj Width not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.templength) <> rtrim(vw.templength)

--templ Adj Length

INSERT INTO [HairSystemOrderConv_Temp].[dbo].[dbaConvCompare]
           ([AttributeDesc]
           ,[CMSValue]
           ,[ProdValue]
           ,[OrderNo]
           ,[Error])
select
	'adjlength',
	vw.adjlength,
	o.adjlength,
	vw.serialnumb,
	'Template adj Length not equal'
from vw_ProductionOrders Vw
	inner join BOSProduction.dbo.orders O	on vw.serialnumb = o.serialnumb
where rtrim(o.adjlength) <> rtrim(vw.adjlength)

END
