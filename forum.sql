/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80039
 Source Host           : localhost:3306
 Source Schema         : forum

 Target Server Type    : MySQL
 Target Server Version : 80039
 File Encoding         : 65001

 Date: 28/11/2024 21:15:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'can be plain text, url',
  `type` enum('plain','picture','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `author` int NOT NULL,
  `parent_type` tinyint(1) NULL DEFAULT 0 COMMENT '0: post parent; 1: comment parent',
  `parent` int NOT NULL COMMENT 'the id of which the comment replay to, can be post or comment',
  `child_count` int NULL DEFAULT 0,
  `likes` int NULL DEFAULT 0,
  `dislikes` int NULL DEFAULT 0,
  `is_delete` tinyint(1) NULL DEFAULT 0,
  `create_at` datetime NULL DEFAULT 'now()',
  `update_at` datetime NULL DEFAULT 'now()',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'integrated comment on post and comment on comment, support nested comments' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender` int NOT NULL,
  `receiver` int NOT NULL,
  `content` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_read` tinyint(1) NULL DEFAULT 0,
  `create_at` datetime NULL DEFAULT 'now()',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `author` int NOT NULL,
  `comment_count` int NULL DEFAULT 0,
  `likes` int NULL DEFAULT 0,
  `dislikes` int NULL DEFAULT 0,
  `is_delete` tinyint(1) NULL DEFAULT 0,
  `create_at` datetime NULL DEFAULT 'now()',
  `update_at` datetime NULL DEFAULT 'now()',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'post is different from comment, for it is required to search posts fast, but it doesn\'t matter if user wait when loading the posts\' details' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ref_follow
-- ----------------------------
DROP TABLE IF EXISTS `ref_follow`;
CREATE TABLE `ref_follow`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `following` int NULL DEFAULT NULL,
  `follower` int NULL DEFAULT NULL,
  `is_delete` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ref_follow_index_1`(`following` ASC, `follower` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ref_post_tag
-- ----------------------------
DROP TABLE IF EXISTS `ref_post_tag`;
CREATE TABLE `ref_post_tag`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NULL DEFAULT NULL,
  `tag_id` int NULL DEFAULT NULL,
  `is_delete` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ref_post_tag_index_0`(`post_id` ASC, `tag_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'tag can be filters and traced, so it is required to be an independent table' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'encrypted by bcrypt, salting, 60',
  `school` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pub_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'generated by RSA, base64 encoded',
  `is_delete` tinyint(1) NULL DEFAULT 0,
  `create_at` datetime NULL DEFAULT 'now()',
  `update_at` datetime NULL DEFAULT 'now()',
  `hide_until` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'when registering, user must provide its session id. Once session validation passed, use session id to generate a pair of keys' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for util_session_key
-- ----------------------------
DROP TABLE IF EXISTS `util_session_key`;
CREATE TABLE `util_session_key`  (
  `user_a` int NOT NULL,
  `user_b` int NOT NULL,
  `key_a` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `key_b` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_a`) USING BTREE,
  UNIQUE INDEX `recipient`(`user_a` ASC, `user_b` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
