package com.bkht.shop.dao;

import com.bkht.core.jpa.BaseRepository;
import com.bkht.shop.entity.BuyRecord;
import com.bkht.shop.entity.SaleRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.QueryByExampleExecutor;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@EnableJpaRepositories
@Repository
public interface BuyRecordDao extends BaseRepository<BuyRecord, Long>, QueryByExampleExecutor<BuyRecord> {

    Page<BuyRecord> findByProductNameContaining(String productName, Pageable pageable);

    BuyRecord findFirstByProductIdOrderByBuyDateDesc(Long productId);

    List<BuyRecord> findFirst3ByProductIdOrderByBuyDateDesc(Long productId);
}
