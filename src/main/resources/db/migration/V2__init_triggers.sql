-- Flyway V2: Triggers for cache sync
-- MySQL triggers for ratings, reactions, avatar, cover

DELIMITER $$

CREATE TRIGGER trg_rating_after_insert AFTER INSERT ON ratings FOR EACH ROW
BEGIN
    UPDATE works SET
                     rating_count = (SELECT COUNT(*) FROM ratings WHERE work_id = NEW.work_id),
                     avg_rating   = (SELECT ROUND(AVG(score),2) FROM ratings WHERE work_id = NEW.work_id)
    WHERE id = NEW.work_id;
    END$$

    CREATE TRIGGER trg_rating_after_update AFTER UPDATE ON ratings FOR EACH ROW
    BEGIN
        UPDATE works SET
                         rating_count = (SELECT COUNT(*) FROM ratings WHERE work_id = NEW.work_id),
                         avg_rating   = (SELECT ROUND(AVG(score),2) FROM ratings WHERE work_id = NEW.work_id)
        WHERE id = NEW.work_id;
        END$$

        CREATE TRIGGER trg_rating_after_delete AFTER DELETE ON ratings FOR EACH ROW
        BEGIN
            UPDATE works SET
                             rating_count = (SELECT COUNT(*) FROM ratings WHERE work_id = OLD.work_id),
                             avg_rating   = (SELECT COALESCE(ROUND(AVG(score),2),0) FROM ratings WHERE work_id = OLD.work_id)
            WHERE id = OLD.work_id;
            END$$

            CREATE TRIGGER trg_reaction_after_insert AFTER INSERT ON comment_reactions FOR EACH ROW
            BEGIN
                UPDATE comments SET
                                    upvotes   = (SELECT COUNT(*) FROM comment_reactions WHERE comment_id = NEW.comment_id AND type='like'),
                                    downvotes = (SELECT COUNT(*) FROM comment_reactions WHERE comment_id = NEW.comment_id AND type='dislike')
                WHERE id = NEW.comment_id;
                END$$

                CREATE TRIGGER trg_reaction_after_update AFTER UPDATE ON comment_reactions FOR EACH ROW
                BEGIN
                    UPDATE comments SET
                                        upvotes   = (SELECT COUNT(*) FROM comment_reactions WHERE comment_id = NEW.comment_id AND type='like'),
                                        downvotes = (SELECT COUNT(*) FROM comment_reactions WHERE comment_id = NEW.comment_id AND type='dislike')
                    WHERE id = NEW.comment_id;
                    END$$

                    CREATE TRIGGER trg_reaction_after_delete AFTER DELETE ON comment_reactions FOR EACH ROW
                    BEGIN
                        UPDATE comments SET
                                            upvotes   = (SELECT COUNT(*) FROM comment_reactions WHERE comment_id = OLD.comment_id AND type='like'),
                                            downvotes = (SELECT COUNT(*) FROM comment_reactions WHERE comment_id = OLD.comment_id AND type='dislike')
                        WHERE id = OLD.comment_id;
                        END$$

                        CREATE TRIGGER trg_author_avatar_insert AFTER INSERT ON author_images FOR EACH ROW
                        BEGIN
                            IF NEW.image_type = 'avatar' THEN
                            UPDATE authors SET avatar_url = NEW.image_url WHERE id = NEW.author_id;
                        END IF;
                        END$$

                        CREATE TRIGGER trg_author_avatar_update AFTER UPDATE ON author_images FOR EACH ROW
                        BEGIN
                            IF NEW.image_type = 'avatar' THEN
                            UPDATE authors SET avatar_url = NEW.image_url WHERE id = NEW.author_id;
                            ELSEIF OLD.image_type = 'avatar' AND NEW.image_type != 'avatar' THEN
                            UPDATE authors SET avatar_url = (
                                SELECT image_url FROM author_images WHERE author_id = NEW.author_id AND image_type = 'avatar' ORDER BY id DESC LIMIT 1
                                ) WHERE id = NEW.author_id;
                        END IF;
                        END$$

                        CREATE TRIGGER trg_author_avatar_delete AFTER DELETE ON author_images FOR EACH ROW
                        BEGIN
                            IF OLD.image_type = 'avatar' THEN
                            UPDATE authors SET avatar_url = (
                                SELECT image_url FROM author_images WHERE author_id = OLD.author_id AND image_type = 'avatar' ORDER BY id DESC LIMIT 1
                                ) WHERE id = OLD.author_id;
                        END IF;
                        END$$

                        CREATE TRIGGER trg_work_cover_insert AFTER INSERT ON work_images FOR EACH ROW
                        BEGIN
                            IF NEW.image_type = 'cover' THEN
                            UPDATE works SET cover_url = NEW.image_url WHERE id = NEW.work_id;
                        END IF;
                        END$$

                        CREATE TRIGGER trg_work_cover_update AFTER UPDATE ON work_images FOR EACH ROW
                        BEGIN
                            IF NEW.image_type = 'cover' THEN
                            UPDATE works SET cover_url = NEW.image_url WHERE id = NEW.work_id;
                            ELSEIF OLD.image_type = 'cover' AND NEW.image_type != 'cover' THEN
                            UPDATE works SET cover_url = (
                                SELECT image_url FROM work_images WHERE work_id = NEW.work_id AND image_type = 'cover' ORDER BY id DESC LIMIT 1
                                ) WHERE id = NEW.work_id;
                        END IF;
                        END$$

                        CREATE TRIGGER trg_work_cover_delete AFTER DELETE ON work_images FOR EACH ROW
                        BEGIN
                            IF OLD.image_type = 'cover' THEN
                            UPDATE works SET cover_url = (
                                SELECT image_url FROM work_images WHERE work_id = OLD.work_id AND image_type = 'cover' ORDER BY id DESC LIMIT 1
                                ) WHERE id = OLD.work_id;
                        END IF;
                        END$$

                        CREATE TRIGGER trg_spotlight_admin_only_insert BEFORE INSERT ON daily_spotlights FOR EACH ROW
                        BEGIN
                            DECLARE uploader_role VARCHAR(20);
                            SELECT role INTO uploader_role FROM users WHERE id = NEW.uploaded_by;
                            IF uploader_role IS NULL OR uploader_role NOT IN ('admin','mod') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chỉ admin hoặc mod mới được đăng video/ảnh nổi bật trang chủ';
                        END IF;
                        END$$

                        CREATE TRIGGER trg_spotlight_admin_only_update BEFORE UPDATE ON daily_spotlights FOR EACH ROW
                        BEGIN
                            DECLARE uploader_role VARCHAR(20);
                            SELECT role INTO uploader_role FROM users WHERE id = NEW.uploaded_by;
                            IF uploader_role IS NULL OR uploader_role NOT IN ('admin','mod') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chỉ admin hoặc mod mới được sửa video/ảnh nổi bật trang chủ';
                        END IF;
                        END$$

                        DELIMITER ;
