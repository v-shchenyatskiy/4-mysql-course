DROP TABLE IF EXISTS `user_wall`;
CREATE TABLE `user_wall` (
	`id` SERIAL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `media_id` BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
    
	-- PRIMARY KEY (user_id, media_id), -- можно использовать вместо `id` SERIAL, но тогда добавится индекс
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `video_albums`;
CREATE TABLE `video_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `video`;
CREATE TABLE `video` (
	id SERIAL,
	`album_id` BIGINT UNSIGNED NULL,
	`media_id` BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (album_id) REFERENCES video_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `audio_albums`;
CREATE TABLE `audio_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `audio`;
CREATE TABLE `audio` (
	id SERIAL,
	`album_id` BIGINT UNSIGNED NULL,
	`media_id` BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (album_id) REFERENCES audio_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);