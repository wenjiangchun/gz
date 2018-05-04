package com.bkht.geo.dao;


import com.bkht.core.jpa.BaseRepository;
import com.bkht.geo.entity.Picture;
import com.bkht.geo.entity.Video;
import org.springframework.stereotype.Repository;

@Repository
public interface VideoDao extends BaseRepository<Video, Integer> {

}
