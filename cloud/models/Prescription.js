const Prescription = Parse.Object.extend("Prescription", {
    // Instance methods
    get_prescription_id: function() {
        return this.get("prescription_id");
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
    get_medication: function() {
        return this.get("medication");
    },
    get_dosage: function() {
        return this.get("dosage");
    },
    get_frequency: function() {
        return this.get("frequency");
    },
    get_prescribed_date: function() {
        return this.get("prescribed_date");
    },
    get_is_active: function() {
        return this.get("is_active");
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
        const prescription = new Prescription();
        prescription.set("prescription_id", "");
        prescription.set("description", "");
        prescription.set("entry_date", new Date());
        prescription.set("profile_id", "");
        prescription.set("medication", "");
        prescription.set("dosage", "");
        prescription.set("frequency", "");
        prescription.set("prescribed_date", new Date());
        prescription.set("is_active", true);
        prescription.set("medical_record", null);
        prescription.set("patient", null);
        return prescription;
    }
});

module.exports = Prescription;
