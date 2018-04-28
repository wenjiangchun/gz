package com.bkht.geo.service;


import com.bkht.core.service.AbstractBaseService;
import com.bkht.geo.dao.*;
import com.bkht.geo.entity.PointType;
import com.bkht.geo.entity.Position;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class PointTypeService extends AbstractBaseService<PointType, Integer> {

    private PointTypeDao pointTypeDao;

    @Autowired
    public void setPointTypeDao(PointTypeDao pointTypeDao) {
        this.pointTypeDao = pointTypeDao;
        super.setDao(pointTypeDao);
    }
}
