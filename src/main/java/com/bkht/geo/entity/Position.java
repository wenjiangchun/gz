package com.bkht.geo.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
public class Position implements Serializable {

    private Integer id;

    private String name;

    private String x;

    private String y;

    private String region;

    private String regionCode;

    private Set<Literature> literatures = new HashSet<>();

    private Set<Picture> pictures = new HashSet<>();

    private Set<PositionExtend> positionExtends = new HashSet<>();

    private PointType pointType;

    @Id
    @GeneratedValue
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getX() {
        return x;
    }

    public void setX(String x) {
        this.x = x;
    }

    public String getY() {
        return y;
    }

    public void setY(String y) {
        this.y = y;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getRegionCode() {
        return regionCode;
    }

    public void setRegionCode(String regionCode) {
        this.regionCode = regionCode;
    }

    @OneToMany(mappedBy = "position", cascade = {CascadeType.ALL},orphanRemoval = true)
    public Set<Literature> getLiteratures() {
        return literatures;
    }

    public void setLiteratures(Set<Literature> literatures) {
        this.literatures = literatures;
    }

    @OneToMany(mappedBy = "position", cascade = {CascadeType.ALL},orphanRemoval = true)
    public Set<Picture> getPictures() {
        return pictures;
    }

    public void setPictures(Set<Picture> pictures) {
        this.pictures = pictures;
    }

    @OneToMany(mappedBy = "position", cascade = {CascadeType.ALL},orphanRemoval = true)
    public Set<PositionExtend> getPositionExtends() {
        return positionExtends;
    }

    public void setPositionExtends(Set<PositionExtend> positionExtends) {
        this.positionExtends = positionExtends;
        positionExtends.forEach(positionExtend -> {
            positionExtend.setPosition(this);
        });
    }

    private List<PositionExtend> extendList = new ArrayList<>();

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "position_type_id")
    public PointType getPointType() {
        return pointType;
    }

    public void setPointType(PointType pointType) {
        this.pointType = pointType;
    }

    @Transient
    public List<PositionExtend> getExtendList() {
        return extendList;
    }

    public void setExtendList(List<PositionExtend> extendList) {
        this.extendList = extendList;
    }
}
