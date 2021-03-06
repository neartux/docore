package com.reliablesystems.doctoroffice.core.service.patient;

import com.reliablesystems.doctoroffice.core.domain.Patient;
import com.reliablesystems.doctoroffice.core.to.patient.PatientTO;

import java.util.List;

public interface PatientService {
    List<PatientTO> findPatientsByCompany(long companyId, int ofset, int limit, String search);

    int findAllPatientsCountByCompany(long companyId, String search);

    Patient findPatientById(long id);

    long createPatient(Patient patient);

    void updatePatient(PatientTO patientTO);

    void inactivePatient(long id);

    void updateProfilePicturePath(long id, String path);
}
