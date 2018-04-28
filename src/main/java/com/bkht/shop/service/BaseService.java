package com.bkht.shop.service;

import com.bkht.core.jpa.HazeSpecification;
import com.bkht.shop.dao.BuyRecordDao;
import com.bkht.shop.dao.CategoryDao;
import com.bkht.shop.dao.ProductDao;
import com.bkht.shop.dao.SaleRecordDao;
import com.bkht.shop.entity.BuyRecord;
import com.bkht.shop.entity.Category;
import com.bkht.shop.entity.Product;
import com.bkht.shop.entity.SaleRecord;
import freemarker.template.utility.DateUtil;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.*;

@Service
@Transactional(readOnly = true)
public class BaseService {

    @Autowired
    private CategoryDao categoryDao;

    @Autowired
    private ProductDao productDao;

    @Autowired
    private SaleRecordDao saleRecordDao;

    @Autowired
    private BuyRecordDao buyRecordDao;

    @Autowired
    private ProductService productService;

    @Transactional
    public void saveOrUpdateCategory(Category category) {
        Assert.notNull(category, "类型不能为空");
        this.categoryDao.save(category);
    }

    public List<Category> getAllCategory() {
        return (List<Category>) this.categoryDao.findAll();
    }

    public Category findCategory(Long id) {
        Assert.notNull(id, "ID不能为空");
        return this.categoryDao.findOne(id);
    }

    public Page<Product> getProductPage(int page, int size, String name, Long categoryId) {

        Map<String, Object> queryParams = new HashMap<>();
        List<Product> products = productService.findAll(queryParams);Pageable pageable = new PageRequest(page, size);
        if (!StringUtils.hasText(name) && categoryId == null) {
            return this.productDao.findAll(pageable);
        } else {
            if (StringUtils.hasText(name) && categoryId != null) {
                return this.productDao.findByNameContainingAndCategoryId(name, categoryId, pageable);
            } else if (StringUtils.hasText(name)) {
                return this.productDao.findByNameContaining(name, pageable);
            } else {
                return this.productDao.findByCategoryId(categoryId, pageable);
            }
        }

    }

    @Transactional
    public void saveOrUpdateProduct(Product product) {
        Assert.notNull(product, "产品信息不能为空");
        this.productDao.save(product);
    }

    public Product findProduct(Long id) {
        Assert.notNull(id, "ID不能为空");
        return this.productDao.findOne(id);
    }

    @Transactional
    public void saveBuyRecord(BuyRecord record) {
        record.setTotalPrice(record.getBuyPrice() * record.getCount());
        record.setBuyDate(new Date());
        buyRecordDao.save(record);
        Product product = productDao.findOne(record.getProduct().getId());
        product.setCurrentCount(product.getCurrentCount() + record.getCount());
        productDao.save(product);
    }

    @Transactional
    public void saveSaleRecord(SaleRecord record) {
        Product product = productDao.findOne(record.getProduct().getId());
        if (product.getCurrentCount() < record.getCount()) {
            throw new IllegalArgumentException("当前库存不足");
        }
        record.setTotalPrice(record.getSalePrice() * record.getCount());
        record.setSaleDate(new Date());
        //saleRecordDao.save(record);
        product.setCurrentCount(product.getCurrentCount() - record.getCount());
        product.setSaleCount(record.getCount() + product.getSaleCount());
        //计算利润 首先取最后一次进价 然后使用售价减去进价乘以数量
        BuyRecord lastBuyRecord = buyRecordDao.findFirstByProductIdOrderByBuyDateDesc(product.getId());
        if (lastBuyRecord == null) {
            lastBuyRecord = new BuyRecord();
            lastBuyRecord.setBuyPrice(product.getPrice());
        }
        product.setProfit((record.getSalePrice() - lastBuyRecord.getBuyPrice()) * record.getCount() + product.getProfit());
        record.setProfit((record.getSalePrice() - lastBuyRecord.getBuyPrice()) * record.getCount());
        saleRecordDao.save(record);
        productDao.save(product);
    }

    public Page<BuyRecord> getBuyRecordPage(int page, int size, String productName) {
        Pageable pageable = new PageRequest(page, size);
        return this.buyRecordDao.findByProductNameContaining(productName, pageable);
    }

    public Page<SaleRecord> getSaleRecordPage(int page, int size, String productName) {
        Pageable pageable = new PageRequest(page, size);
        return this.saleRecordDao.findByProductNameContaining(productName, pageable);
    }

    public List<BigDecimal> staticsByDate(Date date) {
        date = DateUtils.setHours(date, 0);
        date = DateUtils.setMinutes(date, 0);
        Date startDate = DateUtils.setSeconds(date, 0);

        date = DateUtils.setHours(date, 23);
        date = DateUtils.setMinutes(date, 59);
        Date endDate = DateUtils.setSeconds(date, 59);

        Object[] d = new Object[]{startDate, endDate};
        Map<String, Object> queryParams = new HashMap<>();
        queryParams.put("buyDate_between", d);
        Specification<BuyRecord> spec = new HazeSpecification<>(queryParams);
        List<BuyRecord> buyRecords = this.buyRecordDao.findAll(spec);
        queryParams.clear();
        queryParams.put("saleDate_between", d);
        Specification<SaleRecord> saleRecordHazeSpecification = new HazeSpecification<>(queryParams);
        List<SaleRecord> saleRecords = this.saleRecordDao.findAll(saleRecordHazeSpecification);

        BigDecimal buy = new BigDecimal(0);
        for (BuyRecord buyRecord : buyRecords) {
            buy = buy.add(new BigDecimal(buyRecord.getTotalPrice()));
        }
        BigDecimal sale = new BigDecimal(0);
        for (SaleRecord saleRecord : saleRecords) {
            sale = sale.add(new BigDecimal(saleRecord.getTotalPrice()));
        }
        List<BigDecimal> results= new ArrayList<>();
        results.add(buy);
        results.add(sale);
        return results;
    }


    public List<BuyRecord> findSaleRecordLimit(Long productId) {
        return buyRecordDao.findFirst3ByProductIdOrderByBuyDateDesc(productId);
    }


    public List<Object[]> findTopSaleRecord(int type) {
        Date currentDate = new Date();
        Date startDate = DateUtils.setHours(currentDate, 0);
        startDate = DateUtils.setMinutes(startDate, 0);
        startDate = DateUtils.setSeconds(startDate, 0);
        if (type == 0) { //今天
            //results = this.saleRecordDao.findFirst5BySaleDateBetweenOrderByCountDesc(startDate, currentDate);
        } else if (type == 1) { //近7天
            startDate = DateUtils.addDays(startDate, -7);
        } else if (type == 2) {
            startDate = DateUtils.addDays(startDate, -30);
        } else if (type == 3) {
            startDate = DateUtils.addDays(startDate, -90);
        } else {

        }
        return this.saleRecordDao.findFirst5(startDate, currentDate);
    }

    public List<Product> findTopSaleProfit() {
        //return this.productDao.findFirst5OrderByProfitDesc();
        return null;
    }
}
