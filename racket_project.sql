CREATE SCHEMA racket_project;
DROP TABLE IF EXISTS `results`;
CREATE TABLE `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `a` double NOT NULL,
  `b` double NOT NULL,
  `c` double NOT NULL,
  `x1` varchar(45) NOT NULL,
  `x2` varchar(45) NOT NULL,
  `v1` double NOT NULL,
  `v2` double NOT NULL,
  `delta` double NOT NULL,
  PRIMARY KEY (`id`)
) 
