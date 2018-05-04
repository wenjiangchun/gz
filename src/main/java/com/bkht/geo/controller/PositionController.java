package com.bkht.geo.controller;

import com.bkht.geo.entity.Literature;
import com.bkht.geo.entity.Picture;
import com.bkht.geo.entity.Position;
import com.bkht.geo.entity.Video;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Controller
@RequestMapping("/ps")
public class PositionController {

    static final Logger LOG = LoggerFactory.getLogger(PositionController.class);

    @Value("${upload.path}")
    private String uploadPath;

    @Autowired
    private PositionService positionService;

    @Autowired
    private PointTypeService pointTypeService;

    @RequestMapping("/index")
    public String index(Model model) {
        LOG.debug("进入首页");
        return "geo/list";
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
        Page<Position> configList = this.positionService.findPage(p, dataTableParams.getQueryVairables());
        return DataTablePage.generateDataTablePage(configList, dataTableParams);
    }


    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("types", pointTypeService.findAll());
        return "geo/add";
    }

    @RequestMapping("/save")
    @ResponseBody
    public String saveCategory(Position position, Model model, MultipartHttpServletRequest request) {
        List<MultipartFile> pictures = request.getFiles("picture");
        List<MultipartFile> literatures = request.getFiles("literature");
        List<MultipartFile> videos = request.getFiles("video");
        Set<Picture> pictureSet = new HashSet<>();
        Set<Literature> literatureSet = new HashSet<>();
        Set<Video> videoSet = new HashSet<>();
        pictures.forEach(mf -> {
            try {
                mf.transferTo(new File(uploadPath + "//" + mf.getOriginalFilename()));
                Picture picture = new Picture();
                picture.setPosition(position);
                picture.setTitle(mf.getOriginalFilename());
                picture.setUrl(uploadPath + "//" + mf.getOriginalFilename());
                pictureSet.add(picture);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
        literatures.forEach(mf -> {
            try {
                mf.transferTo(new File(uploadPath + "//" + mf.getOriginalFilename()));
                Literature literature = new Literature();
                literature.setPosition(position);
                literature.setTitle(mf.getOriginalFilename());
                literature.setUrl(uploadPath + "//" + mf.getOriginalFilename());
                literatureSet.add(literature);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
        videos.forEach(mf -> {
            try {
                mf.transferTo(new File(uploadPath + "//" + mf.getOriginalFilename()));
                Video literature = new Video();
                literature.setPosition(position);
                literature.setName(mf.getOriginalFilename());
                literature.setUrl(uploadPath + "//" + mf.getOriginalFilename());
                videoSet.add(literature);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
        position.setLiteratures(literatureSet);
        position.setPictures(pictureSet);
        position.setVideos(videoSet);
        position.setPositionExtends(new HashSet<>(position.getExtendList()));
        try {
            positionService.save(position);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/delete/{id}")
    @ResponseBody
    public String delete(@PathVariable Integer id, Model model) {
        try {
            positionService.deleteById(id);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/edit/{id}")
    public String edit(@PathVariable Integer id, Model model) {
        model.addAttribute("position", this.positionService.findById(id));
        model.addAttribute("types", pointTypeService.findAll());
        return "geo/edit";
    }

    @RequestMapping("/update")
    @ResponseBody
    public String update(Position position, Model model) {
        try {
            Position p = this.positionService.findById(position.getId());
            p.setName(position.getName());
            p.setRegion(position.getRegion());
            p.setRegionCode(position.getRegionCode());
            p.setX(position.getX());
            p.setY(position.getY());
            p.setPointType(position.getPointType());
            positionService.save(p);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/editP/{id}")
    public String editP(@PathVariable Integer id, Model model) {
        model.addAttribute("position", this.positionService.findById(id));
        model.addAttribute("ps", this.positionService.findById(id).getPictures());
        return "geo/editP";
    }


    @RequestMapping("/updateP")
    @ResponseBody
    public String updateP(Position position, Model model, MultipartHttpServletRequest request, Integer[] pid) {
        try {
            Position p = this.positionService.findById(position.getId());
            List<MultipartFile> pictures = request.getFiles("picture");
            Set<Picture> pictureSet = new HashSet<>();
            pictures.forEach(mf -> {
                try {
                    mf.transferTo(new File(uploadPath + "/" + mf.getOriginalFilename()));
                    Picture picture = new Picture();
                    picture.setPosition(p);
                    picture.setTitle(mf.getOriginalFilename());
                    picture.setUrl(uploadPath + "/" + mf.getOriginalFilename());
                    pictureSet.add(picture);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
            List<Integer> pids = pid != null ? Arrays.asList(pid) : new ArrayList<>();
            //Set<Picture> removeList = new HashSet<>();
            p.getPictures().forEach(pc -> {
                if (pids.contains(pc.getId())) {
                    pictureSet.add(pc);
                }
            });
           /* p.getPictures().forEach(pc -> {
                if (!pictureSet.contains(pc)) {
                    pc.setPosition(null);
                    positionService.deletePictureById(pc.getId());
                }
            });*/
            p.getPictures().clear();
            p.getPictures().addAll(pictureSet);
            //p.getPictures().removeAll(removeList);
            positionService.save(p);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    @RequestMapping("/editL/{id}")
    public String editL(@PathVariable Integer id, Model model) {
        model.addAttribute("position", this.positionService.findById(id));
        model.addAttribute("ps", this.positionService.findById(id).getLiteratures());
        return "geo/editL";
    }

    @RequestMapping("/updateL")
    @ResponseBody
    public String updateL(Position position, Model model, MultipartHttpServletRequest request, Integer[] pid) {
        try {
            Position p = this.positionService.findById(position.getId());
            List<MultipartFile> literatures = request.getFiles("literature");
            Set<Literature> literatureSet = new HashSet<>();
            literatures.forEach(mf -> {
                try {
                    mf.transferTo(new File(uploadPath + "/" + mf.getOriginalFilename()));
                    Literature literature = new Literature();
                    literature.setPosition(p);
                    literature.setTitle(mf.getOriginalFilename());
                    literature.setUrl(uploadPath + "/" + mf.getOriginalFilename());
                    literatureSet.add(literature);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
            List<Integer> pids = pid != null ? Arrays.asList(pid) : new ArrayList<>();
            //Set<Literature> removeList = new HashSet<>();
            p.getLiteratures().forEach(pc -> {
                if (pids.contains(pc.getId())) {
                    literatureSet.add(pc);
                }
            });
           /* p.getLiteratures().forEach(pc -> {
                if (!literatureSet.contains(pc)) {
                    pc.setPosition(null);
                    positionService.deleteLiteratureById(pc.getId());
                }
            });*/
            p.getLiteratures().clear();
            p.getLiteratures().addAll(literatureSet);
            //p.getLiteratures().removeAll(removeList);
            positionService.save(p);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    @RequestMapping("/editT/{id}")
    public String editT(@PathVariable Integer id, Model model) {
        model.addAttribute("position", this.positionService.findById(id));
        model.addAttribute("ps", this.positionService.findById(id).getPositionExtends());
        return "geo/editT";
    }

    @RequestMapping("/updateT")
    @ResponseBody
    public String updateT(Position position, Model model) {
        try {
            Position p = this.positionService.findById(position.getId());
            p.getPositionExtends().forEach(positionExtend -> {
                //positionExtend.setPosition(null);
                //p.getPositionExtends().remove(positionExtend);
            });
            p.getPositionExtends().clear();
            p.getPositionExtends().addAll(new HashSet<>(position.getExtendList()));
           // p.setPositionExtends(new HashSet<>(position.getExtendList()));
            positionService.save(p);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }


    @RequestMapping("/editV/{id}")
    public String editV(@PathVariable Integer id, Model model) {
        model.addAttribute("position", this.positionService.findById(id));
        model.addAttribute("vs", this.positionService.findById(id).getVideos());
        return "geo/editV";
    }


    @RequestMapping("/updateV")
    @ResponseBody
    public String updateV(Position position, Model model, MultipartHttpServletRequest request, Integer[] pid) {
        try {
            Position p = this.positionService.findById(position.getId());
            List<MultipartFile> pictures = request.getFiles("video");
            Set<Video> pictureSet = new HashSet<>();
            pictures.forEach(mf -> {
                try {
                    mf.transferTo(new File(uploadPath + "/" + mf.getOriginalFilename()));
                    Video picture = new Video();
                    picture.setPosition(p);
                    picture.setName(mf.getOriginalFilename());
                    picture.setUrl(uploadPath + "/" + mf.getOriginalFilename());
                    pictureSet.add(picture);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
            List<Integer> pids = pid != null ? Arrays.asList(pid) : new ArrayList<>();
            p.getVideos().forEach(pc -> {
                if (pids.contains(pc.getId())) {
                    pictureSet.add(pc);
                }
            });
            p.getVideos().clear();
            p.getVideos().addAll(pictureSet);
            positionService.save(p);
            return "SUCCESS";
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }



    @RequestMapping("/deleteP/{id}")
    @ResponseBody
    public String deleteP(@PathVariable Integer id, Model model) {
        try {
            positionService.deletePictureById(id);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }


    @RequestMapping("/deleteL/{id}")
    @ResponseBody
    public String deleteL(@PathVariable Integer id, Model model) {
        try {
            positionService.deleteLiteratureById(id);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/deleteT/{id}")
    @ResponseBody
    public String deleteT(@PathVariable Integer id, Model model) {
        try {
            positionService.deletePositionExtendById(id);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/deleteV/{id}")
    @ResponseBody
    public String deleteV(@PathVariable Integer id, Model model) {
        try {
            positionService.deleteVideoById(id);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }



    @RequestMapping(value = "/previewPath")
    public ResponseEntity<byte[]> previewPath(String path, HttpServletRequest request,
                                              HttpServletResponse response) {
        HttpHeaders headers = new HttpHeaders();
        try {
            headers.setContentType(MediaType.valueOf(Files.probeContentType(Paths.get(path))));
            return new ResponseEntity<byte[]>(Files.readAllBytes(Paths.get(path)),
                    headers, HttpStatus.OK);
        } catch (Exception e) {
            headers.setContentType(MediaType.TEXT_HTML);
            String message = e.getMessage();
            message = "该文件不支持预览";
            try {
                return new ResponseEntity<byte[]>(Files.readAllBytes(Paths.get(path)),
                        headers, HttpStatus.OK);
            } catch (IOException e1) {
                e1.printStackTrace();
            }
            return null;
        }
    }


    /**
     * 下载文件或者文件夹，如果是文件夹则先压缩再下载，下载完成后删除压缩后的文件。
     * @param parentPath 文件或文件夹所在父目录
     * @param fileName 文件名称
     * @param request
     * @param response
     */
    @RequestMapping(value = "/download")
    public ResponseEntity<byte[]> downLoadPath(String parentPath, String fileName, HttpServletRequest request,
                                               HttpServletResponse response) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
                headers.setContentDispositionFormData("attachment", new String(fileName.getBytes(),"ISO-8859-1"));
                return new ResponseEntity<byte[]>(Files.readAllBytes(Paths.get(parentPath)),
                        headers, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.TEXT_PLAIN);
            List<Charset> acceptableCharsets = new ArrayList<>();
            acceptableCharsets.add(Charset.forName("iso-8859-1"));
            headers.setAcceptCharset(acceptableCharsets );
            return new ResponseEntity<byte[]>("download error!".getBytes(),
                    headers, HttpStatus.OK);
        }
    }

    @RequestMapping("getAll")
    @ResponseBody
    public List<Position> getAll(Integer typeId) {
        return this.positionService.findAll(typeId);
    }

    @RequestMapping("play")
    public String play(@RequestParam String name, Model model) {
        model.addAttribute("name", name);
        model.addAttribute("parentPath", uploadPath);
        return "play";
    }

    @RequestMapping("getExtends")
    public String getExtends(@RequestParam Integer id, Model model) {
        model.addAttribute("position", this.positionService.findById(id));
        model.addAttribute("ps", this.positionService.findById(id).getPositionExtends());
        return "geo/showT";
    }
}
