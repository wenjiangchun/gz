package com.bkht.geo.dao;


import com.bkht.core.jpa.BaseRepository;
import com.bkht.geo.entity.Literature;
import com.bkht.geo.entity.PositionExtend;
import org.springframework.stereotype.Repository;

@Repository
public interface LiteratureDao extends BaseRepository<Literature, Integer> {

}
