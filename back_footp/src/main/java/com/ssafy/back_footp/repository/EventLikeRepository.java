package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.EventLike;

@Repository
public interface EventLikeRepository extends JpaRepository<EventLike, Long>{

}
