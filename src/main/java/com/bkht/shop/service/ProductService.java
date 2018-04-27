package com.bkht.shop.service;

import com.bkht.core.service.AbstractBaseService;
import com.bkht.shop.dao.ProductDao;
import com.bkht.shop.entity.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ProductService extends AbstractBaseService<Product, Long> {

    private ProductDao productDao;

    @Autowired
    public void setProductDao(ProductDao productDao) {
        this.productDao = productDao;
        super.setDao(productDao);
    }
}
