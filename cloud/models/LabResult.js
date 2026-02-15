const LabResult = Parse.Object.extend("LabResult", {
    // Instance methods
    get_lab_result_id: function() {
        return this.get("lab_result_id");
    },
    get_description: function() {
        return this.get("description");
    },
    get_entry_date: function() {
        return this.get("entry_date");
    },
    get_profile_id: function() {
        return this.get("profile_id");
    },
    get_test_name: function() {
        return this.get("test_name");
    },
    get_value: function() {
        return this.get("value");
    },
    get_units: function() {
        return this.get("units");
    },
    get_tested_date: function() {
        return this.get("tested_date");
    },
    get_medical_record: function() {
        return this.get("medical_record");
    },
    get_patient: function() {
        return this.get("patient");
    }
}, {
    // Class methods
    new: function() {
        const labResult = new LabResult();
        labResult.set("lab_result_id", "");
        labResult.set("description", "");
        labResult.set("entry_date", new Date());
        labResult.set("profile_id", "");
        labResult.set("test_name", "");
        labResult.set("value", "");
        labResult.set("units", "");
        labResult.set("tested_date", new Date());
        labResult.set("medical_record", null);
        labResult.set("patient", null);
        return labResult;
    }
});

module.exports = LabResult;
