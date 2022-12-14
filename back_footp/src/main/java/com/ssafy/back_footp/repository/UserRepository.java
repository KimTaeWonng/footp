package com.ssafy.back_footp.repository;

import java.security.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
	
	//중복처리
	public boolean existsByUserEmail(String email);
	public boolean existsByUserNickname(String nickname);
	
	//로그인에 쓰일거
	public User findByUserEmailAndUserPassword(String email, String password);
	
	public Optional<User> findByUserEmail(String email);
	public User findByUserId(Long uid);
	
	//회원탈퇴
	@Transactional
	public void deleteByUserId(long uid);
	
	
	
	public static final String keepLogin = "UPDATE user set user_sessionkey =:sessionId, user_sessionlimit =:sessionLimit WHERE user_id=:userId";
	@Transactional
	@Modifying
	@Query(value = keepLogin, nativeQuery = true)
	public int keepLogin(@Param("userId") long user_id, @Param("sessionId") String sessionId, @Param("sessionLimit") LocalDateTime sessionLimit);
	
	public static final String checkUserWithSessionKey = "SELECT * FROM user WHERE user_sessionkey =:user_sessionkey and user_sessionlimit > now()";
	@Query(value = checkUserWithSessionKey, nativeQuery = true)
	public User checkUserWithSessionKey(@Param("user_sessionkey") String User_sessionkey);
	
}
