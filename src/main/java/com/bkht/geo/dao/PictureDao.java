package com.bkht.geo.dao;


import com.bkht.core.jpa.BaseRepository;
import com.bkht.geo.entity.Picture;
import org.springframework.stereotype.Repository;

@Repository
public interface PictureDao extends BaseRepository<Picture, Integer> {

}
