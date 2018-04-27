package com.bkht.shop.web.controller;

import com.bkht.geo.service.PointTypeService;
import com.bkht.shop.entity.BuyRecord;
import com.bkht.shop.entity.Category;
import com.bkht.shop.entity.Product;
import com.bkht.shop.entity.SaleRecord;
import com.bkht.shop.service.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Controller
public class BaseController {

    @Autowired
    private BaseService baseService;

    @Autowired
    private PointTypeService pointTypeService;
/*
    @RequestMapping("/")
    public String index(Model model) {
        List<BigDecimal> rs = baseService.staticsByDate(new Date());
        model.addAttribute("buy", rs.get(0));
        model.addAttribute("sale", rs.get(1));
        return "index";
    }*/

    @RequestMapping("/")
    public String map(Model model) {
        model.addAttribute("types", pointTypeService.findByProperty("show", true));
        return "map";
    }

    @RequestMapping("/c")
    public String categoryIndex(Model model) {
        model.addAttribute("cs", baseService.getAllCategory());
        return "category/list";
    }

    @RequestMapping("/c/form")
    public String formCategory(@RequestParam(required = false) Long id, Model model) {
        Category category = id != null ? baseService.findCategory(id) : new Category();
        model.addAttribute("category", category);
        return "category/form";
    }

    @RequestMapping("/c/save")
    @ResponseBody
    public String saveCategory(Category category, Model model) {
        baseService.saveOrUpdateCategory(category);
        return "SUCCESS";
    }

    @RequestMapping("/p")
    public String productIndex(Model model, @RequestParam(defaultValue = "0", required = false) int page, @RequestParam(defaultValue = "10", required = false) int size, @RequestParam(required = false) String name, @RequestParam(required = false) Long categoryId) {
        Page<Product> p = baseService.getProductPage(page, size, name, categoryId);
        model.addAttribute("ps", p);
        model.addAttribute("cs", baseService.getAllCategory());
        model.addAttribute("name", name);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("previous", p.hasPrevious());
        model.addAttribute("next", p.hasNext());
        return "product/list";
    }

    @RequestMapping("/p/form")
    public String formProduct(@RequestParam(required = false) Long id, Model model) {
        Product product = id != null ? baseService.findProduct(id) : new Product();
        model.addAttribute("product", product);
        model.addAttribute("cs", baseService.getAllCategory());
        return "product/form";
    }

    @RequestMapping("/p/save")
    @ResponseBody
    public String saveProduct(Product product, Model model) {
        baseService.saveOrUpdateProduct(product);
        return "SUCCESS";
    }

    @RequestMapping("/p/buyForm")
    public String buyProduct(@RequestParam Long id, Model model) {
        model.addAttribute("product", baseService.findProduct(id));
        return "product/buyForm";
    }

    @RequestMapping("/p/saleForm")
    public String saleProduct(@RequestParam Long id, Model model) {
        model.addAttribute("product", baseService.findProduct(id));
        //获取最后3次进货信息
        List<BuyRecord> buyRecordList = baseService.findSaleRecordLimit(id);
        model.addAttribute("buyRecordList", buyRecordList);
        return "product/saleForm";
    }

    @RequestMapping("/p/saveBr")
    @ResponseBody
    public String saveBuyRecord(BuyRecord record, Model model) {
        try {
            baseService.saveBuyRecord(record);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/p/saveSr")
    @ResponseBody
    public String saveSaleRecord(SaleRecord record, Model model) {
        try {
            baseService.saveSaleRecord(record);
            return "SUCCESS";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping("/b")
    public String buyRecordIndex(Model model, @RequestParam(defaultValue = "0", required = false) int page, @RequestParam(defaultValue = "10", required = false) int size, @RequestParam(required = false, defaultValue = "") String productName) {
        Page<BuyRecord> p = baseService.getBuyRecordPage(page, size, productName);
        model.addAttribute("ps", p);
        model.addAttribute("productName", productName);
        model.addAttribute("previous", p.hasPrevious());
        model.addAttribute("next", p.hasNext());
        return "buyRecord/list";
    }

    @RequestMapping("/s")
    public String saleRecordIndex(Model model, @RequestParam(defaultValue = "0", required = false) int page, @RequestParam(defaultValue = "10", required = false) int size, @RequestParam(required = false, defaultValue = "") String productName) {
        Page<SaleRecord> p = baseService.getSaleRecordPage(page, size, productName);
        model.addAttribute("ps", p);
        model.addAttribute("productName", productName);
        model.addAttribute("previous", p.hasPrevious());
        model.addAttribute("next", p.hasNext());
        return "saleRecord/list";
    }

    @RequestMapping("/findCountTop/{type}")
    @ResponseBody
    public List<Object[]> findTop(@PathVariable int type) {
        return this.baseService.findTopSaleRecord(type);
    }

    @RequestMapping("/findProfitTop")
    @ResponseBody
    public List<Product> findProfitTop() {
        return this.baseService.findTopSaleProfit();
    }



    @RequestMapping("/map2")
    public String map2(Model model) {
        return "map2";
    }
}
