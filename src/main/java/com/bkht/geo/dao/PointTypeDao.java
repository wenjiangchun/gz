package com.bkht.geo.dao;


import com.bkht.core.jpa.BaseRepository;
import com.bkht.geo.entity.PointType;
import com.bkht.geo.entity.Position;
import com.sun.java.swing.plaf.gtk.GTKConstants;
import org.springframework.stereotype.Repository;

@Repository
public interface PointTypeDao extends BaseRepository<PointType, Integer> {

}
