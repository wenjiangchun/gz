package com.bkht.geo.dao;


import com.bkht.core.jpa.BaseRepository;
import com.bkht.geo.entity.Position;
import com.bkht.geo.entity.PositionExtend;
import org.springframework.stereotype.Repository;

@Repository
public interface PositionExtendDao extends BaseRepository<PositionExtend, Integer> {

}
