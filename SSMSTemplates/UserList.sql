SELECT
	[Company], [Email], [User]
FROM (VALUES
('Raagvitech', 'vbachu@hairclub.com', 'HCFM\vbachu'),
('Raagvitech', 'tvijay@hairclub.com', 'HCFM\tvijay'),
('Raagvitech', 'ksumit@hairclub.com', 'HCFM\ksumit'))
[vdata] ([Company], [Email], [User])

SELECT
	'ShopDev' AS Company, [Email], NULL AS [User]
FROM (VALUES
('adnan.mehboob@shopdev.co'),
('amana.khan@shopdev.co'),
('kashif.irshad@shopdev.co'),
('kashif.irshad@shopdev.co '),
('raheel@shopdev.co'))
[vdata] ([Email])
