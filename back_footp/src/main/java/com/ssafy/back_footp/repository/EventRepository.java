package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Event;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface EventRepository extends JpaRepository<Event, Long>{
    @Query(value = "select * from event as e where (ST_Distance_Sphere(e.event_point, point(:lon, :lat))) <= 500 order by e.event_writedate", nativeQuery = true)
    List<Event> findAllInRadiusOrderByEventWritedate(double lon, double lat);
    @Query(value = "select * from event as e where (ST_Distance_Sphere(e.event_point, point(:lon, :lat))) <= 500 order by e.event_likenum", nativeQuery = true)
    List<Event> findAllInRadiusOrderByEventLikenum(double lon, double lat);
    List<Event> findByUserIdOrderByEventWritedate(long id);
    List<Event> findAllByOrderByEventWritedate();
    List<Event> findAllByOrderByEventLikenumDesc();
    
    Event findByEventIdAndUserId(User userid, long eventid);
}
