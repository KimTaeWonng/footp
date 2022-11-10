package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.User;

@Repository
public interface StampboardRepository extends JpaRepository<Stampboard, Long>{
	
	public List<Stampboard> findAllByUserIdOrderByStampboardWritedateDesc(User uid);

	public List<Stampboard> findAllByOrderByStampboardLikenumDesc();
	public List<Stampboard> findAllByOrderByStampboardWritedateDesc();
	public List<Stampboard> findAllByUserId(User uid);
	public void deleteByStampboardId(Stampboard sid);
	
	@Transactional
	public void deleteByStampboardIdAndUserId(long sid, User uid);
	
	// 이름으로 검색했을 때 결과
	public List<Stampboard> findByStampboardTextContainingIgnoreCaseOrderByStampboardLikenumDesc(String text);
	public List<Stampboard> findByStampboardTextContainingIgnoreCaseOrderByStampboardWritedateDesc(String text);
}
