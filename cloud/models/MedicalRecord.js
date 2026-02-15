const MedicalRecord = Parse.Object.extend("MedicalRecord", {
    // Instance methods
    get_record_id: function() {
        return this.get("record_id");
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
    get_title: function() {
        return this.get("title");
    },
    get_record_type: function() {
        return this.get("record_type");
    },
    get_date_of_record: function() {
        return this.get("date_of_record");
    },
    get_provider: function() {
        return this.get("provider");
    },
    get_facility: function() {
        return this.get("facility");
    },
    get_tags: function() {
        return this.get("tags");
    },
    get_notes: function() {
        return this.get("notes");
    },
    get_patient: function() {
        return this.get("patient");
    }
}, {
    // Class methods
    new: function() {
        const medicalRecord = new MedicalRecord();
        medicalRecord.set("record_id", "");
        medicalRecord.set("description", "");
        medicalRecord.set("entry_date", new Date());
        medicalRecord.set("profile_id", "");
        medicalRecord.set("title", "");
        medicalRecord.set("record_type", "");
        medicalRecord.set("date_of_record", new Date());
        medicalRecord.set("provider", "");
        medicalRecord.set("facility", "");
        medicalRecord.set("tags", []);
        medicalRecord.set("notes", "");
        medicalRecord.set("patient", null);
        return medicalRecord;
    }
});

module.exports = MedicalRecord;
