package com.bkht.shop.dao;

import com.bkht.core.jpa.BaseRepository;
import com.bkht.shop.entity.Product;
import com.bkht.shop.entity.SaleRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface SaleRecordDao extends BaseRepository<SaleRecord, Long> {

    Page<SaleRecord> findByProductNameContaining(String productName, Pageable pageable);

    List<SaleRecord> findFirst5BySaleDateBetweenOrderByCountDesc(Date startDate, Date endDate);

    @Query("select sr.product.name || sr.product.modelNum, sum(sr.count) from SaleRecord sr where saleDate between ?1 and ?2 group by product.id order by sum(sr.count) desc")
    List<Object[]> findFirst5(Date startDate, Date endDate);
}
