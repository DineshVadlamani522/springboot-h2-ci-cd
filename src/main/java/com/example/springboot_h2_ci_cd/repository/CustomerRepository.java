package com.example.springboot_h2_ci_cd.repository;


import com.example.springboot_h2_ci_cd.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {}
