LOAD DATA LOCAL INFILE "counties.csv"
INTO TABLE `opendeals`.`counties`
CHARACTER SET 'UTF8'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name);

