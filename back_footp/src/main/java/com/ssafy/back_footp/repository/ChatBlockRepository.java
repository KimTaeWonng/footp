package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.ChatBlock;
import com.ssafy.back_footp.entity.User;

@Repository
public interface ChatBlockRepository extends JpaRepository<ChatBlock, Long>{
	
	List<ChatBlock> findAllByUserBlocking(long userid);
	
	boolean existsByUserBlockingAndUserBlocked(long blocking, long blocked);
	ChatBlock findByUserBlockingAndUserBlocked(long blocking, long blocked);
	
	@Transactional
	void deleteByUserBlockingAndUserBlocked(long blocking, long blocked);
	

}