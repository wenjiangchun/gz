package com.bkht.geo.service;


import com.bkht.core.service.AbstractBaseService;
import com.bkht.geo.dao.*;
import com.bkht.geo.entity.PointType;
import com.bkht.geo.entity.Position;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.Transient;
import java.util.List;

@Service
@Transactional
public class PositionService extends AbstractBaseService<Position, Integer> {

    private PositionDao positionDao;

    @Autowired
    private PictureDao pictureDao;

    @Autowired
    private LiteratureDao literatureDao;

    @Autowired
    private PositionExtendDao positionExtendDao;

    @Autowired
    private PointTypeDao pointTypeDao;

    @Autowired
    public void setPositionDao(PositionDao positionDao) {
        this.positionDao = positionDao;
        super.setDao(positionDao);
    }

    @Transactional
    public void deletePictureById(Integer id) {
        pictureDao.delete(id);
    }

    @Transactional
    public void deleteLiteratureById(Integer id) {
        literatureDao.delete(id);
    }

    @Transactional
    public void deletePositionExtendById(Integer id) {
        positionExtendDao.delete(id);
    }

    public List<Position> findAll(Integer typeId) {

        return positionDao.findByProperty("pointType", pointTypeDao.findOne(typeId));
    }

}
