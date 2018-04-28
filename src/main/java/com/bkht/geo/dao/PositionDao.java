package com.bkht.geo.dao;


import com.bkht.core.jpa.BaseRepository;
import com.bkht.geo.entity.Position;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PositionDao extends BaseRepository<Position, Integer> {

}
