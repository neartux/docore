package com.reliablesystems.doctoroffice.core.dao.doctorsoffice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

@Repository
public class DoctorsOfficeDAOImpl implements DoctorsOfficeDAO {
    private JdbcTemplate jdbcTemplate;

    @Autowired
    @Qualifier("doDataSource")
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
}