-- ============================================================
-- Database Schema: Web Tác Phẩm (Truyện / Anime / Manga)
-- MySQL 8.0+ | Charset: utf8mb4 | Engine: InnoDB
--
-- Generated from: thiet-ke-database-mysql-v2(1).md
-- Last updated: 2026-08-05
--
-- Setup:
--   CREATE DATABASE your_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--   USE your_db;
--   SET GLOBAL event_scheduler = ON;
-- ============================================================

CREATE DATABASE IF NOT EXISTS note_lib_read CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE note_lib_read;
SET default_storage_engine = InnoDB;

CREATE TABLE work_types (
                            id          SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                            code        VARCHAR(20) UNIQUE NOT NULL,
                            name        VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE authors (
                         id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                         name        VARCHAR(255) NOT NULL,
                         pen_name    VARCHAR(255),
                         bio         TEXT,
                         avatar_url  VARCHAR(500),   -- FIX #6: cache, đồng bộ bởi trigger bên dưới khi author_images đổi ảnh avatar
                         country     VARCHAR(100),
                         birth_date  DATE,
                         created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE author_images (
                               id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                               author_id   BIGINT UNSIGNED NOT NULL,
                               image_url   VARCHAR(500) NOT NULL,
                               image_type  ENUM('avatar','portrait','event','gallery') DEFAULT 'gallery',
                               caption     VARCHAR(255),
                               sort_order  INT DEFAULT 0,
                               created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE genres (
                        id          SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        name        VARCHAR(100) UNIQUE NOT NULL,
                        slug        VARCHAR(100) UNIQUE NOT NULL,
                        description TEXT
) ENGINE=InnoDB;

CREATE TABLE works (
                       id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       type_id         SMALLINT UNSIGNED NOT NULL,
                       title           VARCHAR(500) NOT NULL,
                       alt_titles      JSON,
                       slug            VARCHAR(500) UNIQUE NOT NULL,
                       description     TEXT,
                       cover_url       VARCHAR(500),  -- FIX #6: cache, đồng bộ bởi trigger bên dưới khi work_images đổi ảnh cover
                       release_date    DATE,
                       status          VARCHAR(20) DEFAULT 'ongoing',
                       total_episodes  INT,
                       total_chapters  INT,
                       view_count      BIGINT UNSIGNED DEFAULT 0,
                       avg_rating      DECIMAL(3,2) DEFAULT 0,
                       rating_count    INT UNSIGNED DEFAULT 0,
                       created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       FOREIGN KEY (type_id) REFERENCES work_types(id),
                       FULLTEXT KEY ft_title_desc (title, description)
) ENGINE=InnoDB;

CREATE TABLE work_images (
                             id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                             work_id     BIGINT UNSIGNED NOT NULL,
                             image_url   VARCHAR(500) NOT NULL,
                             image_type  ENUM('cover','banner','poster','screenshot','gallery') DEFAULT 'gallery',
                             caption     VARCHAR(255),
                             sort_order  INT DEFAULT 0,
                             created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE work_authors (
                              work_id     BIGINT UNSIGNED NOT NULL,
                              author_id   BIGINT UNSIGNED NOT NULL,
                              role        VARCHAR(30) DEFAULT 'author',
                              PRIMARY KEY (work_id, author_id, role),
                              FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE CASCADE,
                              FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE work_genres (
                             work_id     BIGINT UNSIGNED NOT NULL,
                             genre_id    SMALLINT UNSIGNED NOT NULL,
                             PRIMARY KEY (work_id, genre_id),
                             FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE CASCADE,
                             FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE work_episodes (
                               id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                               work_id     BIGINT UNSIGNED NOT NULL,
                               number      INT NOT NULL,
                               title       VARCHAR(255),
                               content_url VARCHAR(500),
                               released_at TIMESTAMP NULL,
                               UNIQUE KEY uq_work_number (work_id, number),
                               FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE users (
                       id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                       username        VARCHAR(50) UNIQUE NOT NULL,
                       email           VARCHAR(255) UNIQUE NOT NULL,
                       password_hash   VARCHAR(255) NOT NULL,
                       avatar_url      VARCHAR(500),
                       role            VARCHAR(20) DEFAULT 'user',   -- 'user','mod','admin'
                       nickname        VARCHAR(100),
                       reputation      INT DEFAULT 0,
                       is_verified     TINYINT(1) DEFAULT 0,
                       is_banned       TINYINT(1) DEFAULT 0,
                       is_suspicious   TINYINT(1) DEFAULT 0,          -- soft-block chờ duyệt tay khi nghi bot/spam
                       last_login_at   TIMESTAMP NULL,
                       created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE badges (
                        id          SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                        code        VARCHAR(50) UNIQUE NOT NULL,
                        name        VARCHAR(100) NOT NULL,
                        description TEXT,
                        icon_url    VARCHAR(500)
) ENGINE=InnoDB;

CREATE TABLE user_badges (
                             user_id     BIGINT UNSIGNED NOT NULL,
                             badge_id    SMALLINT UNSIGNED NOT NULL,
                             awarded_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (user_id, badge_id),
                             FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                             FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE reputation_logs (
                                 id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                 user_id     BIGINT UNSIGNED NOT NULL,
                                 delta       INT NOT NULL,
                                 reason      VARCHAR(100),
                                 ref_type    VARCHAR(30),   -- FIX #1: polymorphic, KHÔNG có FK thật — app tự đảm bảo toàn vẹn
                                 ref_id      BIGINT UNSIGNED,
                                 created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ratings (
                         id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                         work_id     BIGINT UNSIGNED NOT NULL,
                         user_id     BIGINT UNSIGNED NOT NULL,
                         score       TINYINT UNSIGNED NOT NULL CHECK (score BETWEEN 1 AND 10),
                         review_text TEXT,
                         created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         UNIQUE KEY uq_work_user (work_id, user_id),
                         FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE CASCADE,
                         FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- FIX #2: target_type dùng 'rating' thay vì 'review' (review_text chỉ là 1 cột trong ratings, không phải bảng riêng)
CREATE TABLE comments (
                          id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                          user_id     BIGINT UNSIGNED NOT NULL,
                          parent_id   BIGINT UNSIGNED NULL,
                          target_type ENUM('work','discussion','rating') NOT NULL,
                          target_id   BIGINT UNSIGNED NOT NULL,   -- FIX #1: polymorphic, KHÔNG có FK thật
                          content     TEXT NOT NULL,
                          upvotes     INT DEFAULT 0,              -- FIX #5: đồng bộ bởi trigger từ comment_reactions
                          downvotes   INT DEFAULT 0,
                          is_hidden   TINYINT(1) DEFAULT 0,
                          created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                          FOREIGN KEY (parent_id) REFERENCES comments(id) ON DELETE CASCADE,
                          KEY idx_target (target_type, target_id)
) ENGINE=InnoDB;

CREATE TABLE discussions (
                             id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                             user_id     BIGINT UNSIGNED NOT NULL,
                             work_id     BIGINT UNSIGNED NULL,
                             title       VARCHAR(255) NOT NULL,
                             content     TEXT,
                             view_count  INT DEFAULT 0,
                             is_pinned   TINYINT(1) DEFAULT 0,
                             is_locked   TINYINT(1) DEFAULT 0,
                             created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                             FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE comment_reactions (
                                   user_id     BIGINT UNSIGNED NOT NULL,
                                   comment_id  BIGINT UNSIGNED NOT NULL,
                                   type        ENUM('like','dislike') DEFAULT 'like',
                                   created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   PRIMARY KEY (user_id, comment_id),
                                   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                   FOREIGN KEY (comment_id) REFERENCES comments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- FIX #8: thêm CHECK đảm bảo work_id hoặc custom_title phải có ít nhất 1 giá trị
CREATE TABLE user_watch_history (
                                    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                    user_id         BIGINT UNSIGNED NOT NULL,
                                    work_id         BIGINT UNSIGNED NULL,
                                    custom_title    VARCHAR(500),
                                    source_url      TEXT,
                                    status          ENUM('watching','completed','dropped','plan_to_watch','rewatching') DEFAULT 'watching',
                                    progress_note   VARCHAR(100),
                                    personal_note   TEXT,
                                    personal_rating TINYINT CHECK (personal_rating BETWEEN 1 AND 10),
                                    started_at      DATE,
                                    finished_at     DATE,
                                    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    -- NOTE: App layer phải validate: work_id hoặc custom_title phải có ít nhất 1 giá trị
    -- MySQL 8.0 không cho CHECK trên cột có FK + ON DELETE SET NULL
                                    FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE user_favorites (
                                user_id     BIGINT UNSIGNED NOT NULL,
                                work_id     BIGINT UNSIGNED NOT NULL,
                                created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                PRIMARY KEY (user_id, work_id),
                                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- FIX #4: work_id KHÔNG có FK thật (chủ đích) — bảng này bị TRUNCATE + INSERT lại mỗi lần refresh,
-- có FK sẽ vướng khi work bị xoá đúng lúc refresh đang chạy. Đánh đổi: work đã xoá có thể còn
-- "lảng vảng" trong bảng ranking tới lần refresh kế tiếp (tối đa 30 phút).
CREATE TABLE work_rankings (
                               id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                               work_id       BIGINT UNSIGNED NOT NULL,
                               scope         ENUM('overall','yearly','genre','type') NOT NULL,
                               scope_value   VARCHAR(50) NOT NULL,   -- vd: '2026', 'action', 'anime'
                               rank_position INT NOT NULL,
                               score         DECIMAL(10,4) NOT NULL,
                               computed_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               UNIQUE KEY uq_scope_work (scope, scope_value, work_id),
                               KEY idx_scope_rank (scope, scope_value, rank_position)
) ENGINE=InnoDB;

CREATE TABLE rate_limit_events (
                                   id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                   ip_address  VARCHAR(45) NOT NULL,
                                   user_id     BIGINT UNSIGNED NULL,
                                   action      VARCHAR(30) NOT NULL,
                                   created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   KEY idx_ip_action_time (ip_address, action, created_at),
    -- FIX #7: trước đây thiếu ON DELETE, mặc định RESTRICT sẽ chặn xoá user có log rate-limit
                                   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE blocked_ips (
                             ip_address  VARCHAR(45) PRIMARY KEY,
                             reason      VARCHAR(100),
                             blocked_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             expires_at  TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE user_tokens (
                             id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                             user_id         BIGINT UNSIGNED NOT NULL,
                             refresh_token_hash   VARCHAR(64) NOT NULL,    -- lưu SHA-256, KHÔNG lưu token thô
                             user_agent      VARCHAR(255),
                             ip_address      VARCHAR(45),
                             expires_at      TIMESTAMP NOT NULL,
                             created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                             UNIQUE KEY idx_tokens_hash (refresh_token_hash),
                             KEY idx_tokens_user (user_id, expires_at)
) ENGINE=InnoDB;

CREATE TABLE notifications (
                               id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                               user_id     BIGINT UNSIGNED NOT NULL,
                               type        VARCHAR(50) NOT NULL,
                               title       VARCHAR(255) NOT NULL,
                               content     TEXT,
                               link_url    TEXT,
                               is_read     TINYINT(1) DEFAULT 0,
                               created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- FIX #2 + FIX #3: gộp 'review' vào 'rating', bổ sung 'work' và 'user' để report được thẳng
-- tác phẩm (vi phạm bản quyền) hoặc người dùng (quấy rối/spam)
CREATE TABLE reports (
                         id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                         reporter_id BIGINT UNSIGNED NOT NULL,
                         target_type ENUM('work','user','comment','discussion','rating') NOT NULL,
                         target_id   BIGINT UNSIGNED NOT NULL,   -- FIX #1: polymorphic, KHÔNG có FK thật
                         reason      VARCHAR(255) NOT NULL,
                         status      ENUM('pending','resolved','dismissed') DEFAULT 'pending',
                         created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE daily_spotlights (
                                  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                  media_type      ENUM('video','image') NOT NULL,
                                  media_url       VARCHAR(500) NOT NULL,   -- link CDN/storage, KHÔNG lưu file trong DB
                                  thumbnail_url   VARCHAR(500),
                                  title           VARCHAR(255) NOT NULL,
                                  description     TEXT,
                                  work_id         BIGINT UNSIGNED NULL,     -- optional: gắn với 1 tác phẩm cụ thể
                                  display_date    DATE NOT NULL UNIQUE,     -- mỗi ngày chỉ 1 dòng active
                                  uploaded_by     BIGINT UNSIGNED NOT NULL, -- phải là admin/mod
                                  view_count      INT UNSIGNED DEFAULT 0,
                                  is_active       TINYINT(1) DEFAULT 1,
                                  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (work_id) REFERENCES works(id) ON DELETE SET NULL,
                                  FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

