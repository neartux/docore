package com.reliablesystems.doctoroffice.core.service.state;

import com.reliablesystems.doctoroffice.core.exception.BackEndException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(value = "doTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = BackEndException.class)
public class StateServiceImpl implements StateService {
}
