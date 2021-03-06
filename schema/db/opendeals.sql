SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `opendeals` ;
CREATE SCHEMA IF NOT EXISTS `opendeals` DEFAULT CHARACTER SET utf8 ;
USE `opendeals` ;

-- -----------------------------------------------------
-- Table `opendeals`.`counties`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`counties` ;
CREATE  TABLE IF NOT EXISTS `opendeals`.`counties` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`municipalities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`municipalities` ;
CREATE  TABLE IF NOT EXISTS `opendeals`.`municipalities` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` MEDIUMTEXT NOT NULL ,
  `county_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_municipalities_counties` (`county_id` ASC) ,
  CONSTRAINT `fk_municipalities_counties`
    FOREIGN KEY (`county_id`)
    REFERENCES `opendeals`.`counties` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`offer_categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`offer_categories` ;
CREATE  TABLE IF NOT EXISTS `opendeals`.`offer_categories` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`days`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`days` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`days` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`users` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `username` MEDIUMTEXT NOT NULL ,
  `password` MEDIUMTEXT NOT NULL ,
  `email` MEDIUMTEXT NOT NULL ,
  `token` MEDIUMTEXT NULL DEFAULT NULL ,
  `email_verified` TINYINT(1) NOT NULL DEFAULT FALSE ,
  `is_banned` TINYINT(1) NOT NULL DEFAULT FALSE ,
  `role` MEDIUMTEXT NOT NULL ,
  `terms_accepted` TINYINT(1) NOT NULL DEFAULT FALSE,
  `last_login` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`companies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`companies` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`companies` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` MEDIUMTEXT NOT NULL ,
  `address` MEDIUMTEXT NULL DEFAULT NULL ,
  `postalcode` VARCHAR(5) NULL DEFAULT NULL ,
  `phone` VARCHAR(10) NOT NULL ,
  `fax` VARCHAR(10) NULL DEFAULT NULL ,
  `service_type` MEDIUMTEXT NULL DEFAULT NULL ,
  `afm` VARCHAR(9) NOT NULL ,
  `latitude` DOUBLE NULL DEFAULT NULL ,
  `longitude` DOUBLE NULL DEFAULT NULL ,
  `is_enabled` TINYINT(1) NOT NULL DEFAULT FALSE ,
  `explanation` VARCHAR(140) NULL DEFAULT NULL ,
  `user_id` INT NOT NULL ,
  `municipality_id` INT NULL DEFAULT NULL ,
  `image_count` INT NOT NULL DEFAULT 0 ,
  `work_hour_count` INT NOT NULL DEFAULT 0,
  `created` DATETIME NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_companies_users1` (`user_id` ASC) ,
  INDEX `fk_companies_municipalities` (`municipality_id` ASC) ,
  CONSTRAINT `fk_companies_users1`
    FOREIGN KEY (`user_id` )
    REFERENCES `opendeals`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_companies_municipalities`
    FOREIGN KEY (`municipality_id` )
    REFERENCES `opendeals`.`municipalities` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`images`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`images` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`images` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` MEDIUMTEXT NOT NULL ,
  `type` MEDIUMTEXT NOT NULL ,
  `size` INT NOT NULL DEFAULT 0,
  `size_thumb` INT NOT NULL DEFAULT 0,
  `error`INT NULL DEFAULT NULL ,
  `data` LONGBLOB NOT NULL ,
  `data_thumb` LONGBLOB NOT NULL ,
  `offer_id` INT NULL DEFAULT NULL ,
  `company_id` INT NULL DEFAULT NULL ,
  `image_category` INT NOT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_images_offers` (`offer_id` ASC) ,
  INDEX `fk_images_companies` (`company_id` ASC) ,
  CONSTRAINT `fk_images_offers`
    FOREIGN KEY (`offer_id`)
    REFERENCES `opendeals`.`offers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_images_companies`
    FOREIGN KEY (`company_id`)
    REFERENCES `opendeals`.`companies` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`offers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`offers` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`offers` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `title` TEXT NOT NULL ,
  `description` TEXT NULL DEFAULT NULL ,
  `started` DATETIME NULL DEFAULT NULL ,
  `ended` DATETIME NULL DEFAULT NULL ,
  `autostart` DATETIME NULL DEFAULT NULL ,
  `autoend` DATETIME NULL DEFAULT NULL ,
  `coupon_terms` TEXT NULL DEFAULT NULL ,
  `total_quantity` INT NOT NULL DEFAULT 0 ,
  `coupon_count` INT NOT NULL DEFAULT 0 ,
  `max_per_student` int(11) NOT NULL DEFAULT 0,
  `tags` MEDIUMTEXT NULL ,
  `offer_category_id` INT NOT NULL ,
  `offer_type_id` INT NOT NULL ,
  `company_id` INT NOT NULL ,
  `image_count` INT NOT NULL DEFAULT 0 ,
  `work_hour_count` INT NOT NULL DEFAULT 0 ,
  `offer_state_id` INT NOT NULL DEFAULT 1 ,
  `is_spam` TINYINT(1) NOT NULL DEFAULT 0 ,
  `explanation` VARCHAR(140) NULL DEFAULT NULL ,
  `vote_count` INT(11) NOT NULL DEFAULT 0 ,
  `vote_plus` INT(11) NOT NULL DEFAULT 0 ,
  `vote_minus` INT(11) NOT NULL DEFAULT 0 ,
  `created` DATETIME NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_offers_offer_categories` (`offer_category_id` ASC) ,
  INDEX `fk_offers_offer_types1` (`offer_type_id` ASC) ,
  INDEX `fk_offers_companies1` (`company_id` ASC) ,
  INDEX `fk_offers_offer_states` (`offer_state_id` ASC) ,
  CONSTRAINT `fk_offers_offer_categories`
    FOREIGN KEY (`offer_category_id` )
    REFERENCES `opendeals`.`offer_categories` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_offers_companies1`
    FOREIGN KEY (`company_id` )
    REFERENCES `opendeals`.`companies` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`students`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`students` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`students` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `firstname` MEDIUMTEXT NOT NULL ,
  `lastname` MEDIUMTEXT NOT NULL ,
  `receive_email` TINYINT(1) NOT NULL DEFAULT FALSE ,
  `user_id` INT NOT NULL ,
  `image_id` INT NULL DEFAULT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_students_users1` (`user_id` ASC) ,
  INDEX `fk_students_images` (`image_id` ASC) ,
  CONSTRAINT `fk_students_users1`
    FOREIGN KEY (`user_id` )
    REFERENCES `opendeals`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_students_images`
    FOREIGN KEY (`image_id` )
    REFERENCES `opendeals`.`images` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`coupons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`coupons` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`coupons` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `serial_number` TEXT NOT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  `is_used` TINYINT(1)  NOT NULL DEFAULT 0 ,
  `reinserted` TINYINT(1)  NOT NULL DEFAULT 0 ,
  `offer_id` INT NOT NULL ,
  `student_id` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_coupons_offers1` (`offer_id` ASC) ,
  INDEX `fk_coupons_students1` (`student_id` ASC) ,
  CONSTRAINT `fk_coupons_offers1`
    FOREIGN KEY (`offer_id` )
    REFERENCES `opendeals`.`offers` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_coupons_students1`
    FOREIGN KEY (`student_id` )
    REFERENCES `opendeals`.`students` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`work_hours`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`work_hours` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`work_hours` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `day_id` INT NOT NULL ,
  `starting1` TIME NOT NULL ,
  `ending1` TIME NOT NULL ,
  `starting2` TIME NOT NULL ,
  `ending2` TIME NOT NULL ,
  `company_id` INT NULL ,
  `offer_id` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_work_hours_days1` (`day_id` ASC) ,
  INDEX `fk_work_hours_companies1` (`company_id` ASC) ,
  INDEX `fk_work_hours_offers1` (`offer_id` ASC) ,
  CONSTRAINT `fk_work_hours_days1`
    FOREIGN KEY (`day_id` )
    REFERENCES `opendeals`.`days` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_hours_companies1`
    FOREIGN KEY (`company_id` )
    REFERENCES `opendeals`.`companies` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_hours_offers1`
    FOREIGN KEY (`offer_id` )
    REFERENCES `opendeals`.`offers` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`votes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`votes` ;

CREATE  TABLE IF NOT EXISTS `opendeals`.`votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `offer_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `vote` tinyint(1) NOT NULL COMMENT '0 negative, 1 positive',
  PRIMARY KEY (`id`) ,
  INDEX `fk_votes_offers1` (`offer_id` ASC) ,
  INDEX `fk_votes_students1` (`student_id` ASC) ,
  CONSTRAINT `fk_votes_offers1`
    FOREIGN KEY (`offer_id` )
    REFERENCES `opendeals`.`offers` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_votes_students1`
    FOREIGN KEY (`student_id` )
    REFERENCES `opendeals`.`students` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `opendeals`.`distances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `opendeals`.`distances`;

CREATE TABLE IF NOT EXISTS `opendeals`.`distances` (
  `id` int(11) NOT NULL AUTO_INCREMENT ,
  `user_id` int(11) NOT NULL ,
  `company_id` int(11) NOT NULL ,
  `radius` int(11) NOT NULL ,
  `distance` double NOT NULL ,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- --------------------------------------------------------
-- Table structure for table `stats_today`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `opendeals`.`stats_today`;

CREATE TABLE IF NOT EXISTS `opendeals`.`stats_today` (
  `id` int(11) NOT NULL AUTO_INCREMENT ,
  `ip` text NOT NULL ,
  `offer_id` int(11) NOT NULL ,
  `company_id` int(11) NOT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARACTER SET = utf8;


-- --------------------------------------------------------
-- Table structure for table `stats_total`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `opendeals`.`stats_total`;

CREATE TABLE IF NOT EXISTS `opendeals`.`stats_total` (
  `id` int(11) NOT NULL AUTO_INCREMENT ,
  `offer_id` int(11) NOT NULL ,
  `company_id` int(11) NOT NULL ,
  `visit_date` DATE NULL DEFAULT NULL ,
  `visits_total` int(11) NOT NULL ,
  `visits_unique` int(11) NOT NULL ,
  PRIMARY KEY (`id`))
ENGINE=InnoDB
DEFAULT CHARACTER SET = utf8;


DELIMITER //
CREATE FUNCTION `opendeals`.`geodist` (fromlat DOUBLE, fromlng DOUBLE, tolat DOUBLE, tolng DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
DECLARE latfrom,latto,latdiff,lngdiff DOUBLE;
DECLARE lathvr,lnghvr,root,dist DOUBLE;
DECLARE r INT;
SET r = 6371;
SET latfrom = radians(fromlat);
SET latto = radians(tolat);
SET latdiff = radians(tolat - fromlat);
SET lngdiff = radians(tolng - fromlng);
SET lathvr = sin(latdiff / 2) * sin(latdiff / 2);
SET lnghvr = sin(lngdiff / 2) * sin(lngdiff / 2);
SET root = sqrt(lathvr + cos(latfrom) * cos(latto) * sin(lnghvr));
SET dist = 2 * r * asin(root);
RETURN dist;
END //


DELIMITER //
CREATE PROCEDURE `opendeals`.`updatedistances` (IN uid INT, IN lat DOUBLE, IN lng DOUBLE, IN r INT)
BEGIN
DELETE FROM `opendeals`.`distances` WHERE `distances`.`user_id` = uid;
INSERT INTO `opendeals`.`distances` (user_id, company_id, radius, distance)
SELECT users.id, companies.id, r, geodist(lat,lng,companies.latitude,companies.longitude) AS d
FROM users,companies
WHERE users.id = uid
GROUP BY companies.id
HAVING d > 0 AND d < r
ORDER BY d ASC;
END //


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
