package com.bkht.geo.entity;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@JsonIgnoreProperties(value = {"position"})
public class PositionExtend implements Serializable  {

    private Integer id;

    private Position position;

    private String geoPeriod;

    private String geoFloor;

    private String rockProperty;

    private String geoEnviroment;

    private String geoEvent;

    private String  geoLook;

    @Id
    @GeneratedValue
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "position_id")
    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }

    public String getGeoPeriod() {
        return geoPeriod;
    }

    public void setGeoPeriod(String geoPeriod) {
        this.geoPeriod = geoPeriod;
    }

    public String getGeoFloor() {
        return geoFloor;
    }

    public void setGeoFloor(String geoFloor) {
        this.geoFloor = geoFloor;
    }

    public String getRockProperty() {
        return rockProperty;
    }

    public void setRockProperty(String rockProperty) {
        this.rockProperty = rockProperty;
    }

    public String getGeoEnviroment() {
        return geoEnviroment;
    }

    public void setGeoEnviroment(String geoEnviroment) {
        this.geoEnviroment = geoEnviroment;
    }

    public String getGeoEvent() {
        return geoEvent;
    }

    public void setGeoEvent(String geoEvent) {
        this.geoEvent = geoEvent;
    }

    public String getGeoLook() {
        return geoLook;
    }

    public void setGeoLook(String geoLook) {
        this.geoLook = geoLook;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PositionExtend that = (PositionExtend) o;
        if (that.id == null) return false;
        return id != null ? id.equals(that.id) : that.id == null;
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}
