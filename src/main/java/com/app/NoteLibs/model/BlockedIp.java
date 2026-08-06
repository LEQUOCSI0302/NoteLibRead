package com.app.NoteLibs.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "blocked_ips")
@Data
public class BlockedIp {
    @Id
    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @Column(length = 100)
    private String reason;

    @Column(name = "blocked_at")
    private LocalDateTime blockedAt;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;
}
