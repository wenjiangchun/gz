package com.bkht.shop.dao;

import com.bkht.core.jpa.BaseRepository;
import com.bkht.shop.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductDao extends BaseRepository<Product, Long> {

    Page<Product> findByNameContainingAndCategoryId(String name, Long categoryId, Pageable pageable);

    Page<Product> findByNameContaining(String name, Pageable pageable);

    Page<Product> findByCategoryId(Long categoryId, Pageable pageable);

   // List<Product> findFirst5OrderByProfitDesc();
}
