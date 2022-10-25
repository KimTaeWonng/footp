package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name="Message")
public class Message {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="message_id")
    private Long messageId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    @Column(name="message_text", length = 255, nullable = false)
    private String messageText;

    @Column(name="message_fileurl", length = 1024, nullable = false)
    private String messageFileurl;

    @Column(name="message_point")
    private Point messagePoint;

    @Column(name="is_opentoall", columnDefinition = "TINYINT", length = 1)
    private boolean isOpentoall;

    @Column(name="message_likenum")
    private int messageLikenum;

    @Column(name="message_spamnum")
    private int messageSpamnum;

    @Column(name="message_writedate", nullable = false)
    private LocalDateTime messageWritedate;

}