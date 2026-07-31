-- Optional SQL for adding one ready AZS point.
-- You can also create it in game with /addazc [price] [rent_price].

INSERT INTO `fuel_stations`
(`owner_id`,`name`,`improvements`,`fuels`,`fuel_price`,`buy_fuel_price`,`balance`,`rent_time`,`price`,`rent_price`,`lock`,`x`,`y`,`z`,`eviction`)
VALUES
(0, 'АЗС bylibplugin', 0, 5000, 50, 50, 0, 0, 1000000, 5000, 0, 2641.88, 2587.00, 16.432, 0);
