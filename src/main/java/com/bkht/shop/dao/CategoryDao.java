package com.bkht.shop.dao;

import com.bkht.shop.entity.Category;
import com.bkht.shop.entity.Product;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryDao extends PagingAndSortingRepository<Category, Long> {
}
