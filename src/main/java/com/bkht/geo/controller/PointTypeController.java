package com.bkht.geo.controller;

import com.bkht.geo.entity.Literature;
import com.bkht.geo.entity.Picture;
import com.bkht.geo.entity.PointType;
import com.bkht.geo.entity.Position;
import com.bkht.geo.service.PointTypeService;
import com.bkht.geo.service.PositionService;
import com.bkht.web.ui.datatable.DataTablePage;
import com.bkht.web.ui.datatable.DataTableParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@Controller
@RequestMapping("/pt")
public class PointTypeController {

    static final Logger LOG = LoggerFactory.getLogger(PointTypeController.class);

    @Value("${upload.path}")
    private String uploadPath;

    @Autowired
    private PointTypeService pointTypeService;

    @RequestMapping("/index")
    public String index(Model model) {
        LOG.debug("进入首页");
        return "geo/typeList";
    }


    @RequestMapping(value = "search")
    @ResponseBody
    public DataTablePage search(DataTableParams dataTableParams, ServletRequest request) {
        PageRequest p = dataTableParams.getPageRequest();
        Map<String, Object> queryVaribles = dataTableParams.getQueryVairables();
        /*if (queryVaribles != null && queryVaribles.get("configType") != null) {
            String value = (String) queryVaribles.get("configType");
            queryVaribles.put("configType", ConfigType.valueOf(value));
        }*/
        Page<PointType> configList = this.pointTypeService.findPage(p, dataTableParams.getQueryVairables());
        return DataTablePage.generateDataTablePage(configList, dataTableParams);
    }


    @RequestMapping("/add")
    public String add(Model model) {
        return "geo/addType";
    }

    @RequestMapping("/save")
    @ResponseBody
    public String saveCategory(PointType pointType, Model model, MultipartHttpServletRequest request) {
        try {
            MultipartFile file = request.getFile("file");
            if (file != null) {
                file.transferTo(new File(uploadPath + "//" + file.getOriginalFilename()));
                pointType.setUrl(uploadPath + "//" + file.getOriginalFilename());
            }
            pointTypeService.save(pointType);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/delete/{id}")
    @ResponseBody
    public String delete(@PathVariable Integer id, Model model) {
        try {
            pointTypeService.deleteById(id);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/edit/{id}")
    public String edit(@PathVariable Integer id, Model model) {
        model.addAttribute("type", this.pointTypeService.findById(id));
        return "geo/editType";
    }

    @RequestMapping("/update")
    @ResponseBody
    public String update(PointType pointType, Model model, MultipartHttpServletRequest request) {
        try {
            MultipartFile file = request.getFile("file");
            if (file != null) {
                file.transferTo(new File(uploadPath + "//" + file.getOriginalFilename()));
                pointType.setUrl(uploadPath + "//" + file.getOriginalFilename());
            }
            pointTypeService.save(pointType);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("getAll")
    @ResponseBody
    public List<PointType> getAll() {
        return this.pointTypeService.findAll();
    }
}
