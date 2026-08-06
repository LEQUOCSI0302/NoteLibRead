-- Flyway V3: Event Scheduler jobs
-- Cleanup orphan polymorphic records

DELIMITER $$

CREATE EVENT IF NOT EXISTS ev_cleanup_orphan_polymorphic
ON SCHEDULE EVERY 1 WEEK STARTS CURRENT_DATE + INTERVAL 7 DAY + INTERVAL 3 HOUR
DO BEGIN
    DELETE c FROM comments c
    LEFT JOIN works w ON c.target_type = 'work' AND c.target_id = w.id
    LEFT JOIN discussions d ON c.target_type = 'discussion' AND c.target_id = d.id
    LEFT JOIN ratings r ON c.target_type = 'rating' AND c.target_id = r.id
    WHERE w.id IS NULL AND d.id IS NULL AND r.id IS NULL;

    DELETE rpt FROM reports rpt
    LEFT JOIN works w ON rpt.target_type = 'work' AND rpt.target_id = w.id
    LEFT JOIN users u ON rpt.target_type = 'user' AND rpt.target_id = u.id
    LEFT JOIN comments c ON rpt.target_type = 'comment' AND rpt.target_id = c.id
    LEFT JOIN discussions d ON rpt.target_type = 'discussion' AND rpt.target_id = d.id
    LEFT JOIN ratings r ON rpt.target_type = 'rating' AND rpt.target_id = r.id
    WHERE w.id IS NULL AND u.id IS NULL AND c.id IS NULL AND d.id IS NULL AND r.id IS NULL;
END$$

DELIMITER ;
