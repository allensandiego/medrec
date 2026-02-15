const ExtractedData = Parse.Object.extend("ExtractedData", {
    // Instance methods
    get_extraction_id: function() {
        return this.get("extraction_id");
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
    get_medical_record: function() {
        return this.get("medical_record");
    },
    get_extracted_text: function() {
        return this.get("extracted_text");
    },
    get_structured_data: function() {
        return this.get("structured_data");
    },
    get_review_status: function() {
        return this.get("review_status");
    },
    get_patient: function() {
        return this.get("patient");
    }
}, {
    // Class methods
    new: function() {
        const extractedData = new ExtractedData();
        extractedData.set("extraction_id", "");
        extractedData.set("description", "");
        extractedData.set("entry_date", new Date());
        extractedData.set("profile_id", "");
        extractedData.set("medical_record", null);
        extractedData.set("extracted_text", "");
        extractedData.set("structured_data", {});
        extractedData.set("review_status", "pending");
        extractedData.set("patient", null);
        return extractedData;
    }
});

module.exports = ExtractedData;
