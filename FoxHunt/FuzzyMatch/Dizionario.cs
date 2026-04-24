using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.SessionState;
using System.DirectoryServices.AccountManagement;
using BaseClasses;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.IO;
using System.Web.UI.WebControls.WebParts;
using static FoxHunt.dsShare;
using System.Data.SQLite;
using System.Runtime.InteropServices.ComTypes;
using System.Net.Mail;
using System.Text;
using static System.Collections.Specialized.BitVector32;
using System.Net.NetworkInformation;
using DTIGrid;
using System.IO.Compression;
using CsvHelper;
using System.Globalization;

namespace FoxHunt
{
    public static class Dizionario
    {
        // Master dictionary for all Dictionary Types
        //Each Dictionary type gets a class to hold it and it's topic dictionaries
        public static Dictionary<string, string> MasterDictionary
        {
            get
            {
                var master = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

                AddDictionaryToMaster(Synonyms.SynonymDictionary, master);

                return master;
            }
        }


        #region Helper Functions
        /// <summary>
        /// Safely add a key/value pair to a dictionary.
        /// Logs a warning if the key already exists.
        /// </summary>
        public static void SafeAdd(Dictionary<string, string> dict, string key, string value)
        {
            if (dict.ContainsKey(key))
            {
                Console.WriteLine($"Warning: Duplicate key '{key}' ignored (existing value: '{dict[key]}', new value: '{value}')");
                return;
            }

            dict.Add(key, value);
        }

        /// <summary>
        /// Loops over a dictionary and adds all entries to the master dictionary safely.
        /// </summary>
        public static void AddDictionaryToMaster(Dictionary<string, string> source, Dictionary<string, string> target)
        {
            foreach (var kvp in source)
            {
                SafeAdd(target, kvp.Key, kvp.Value);
            }
        }

        /// <summary>
        /// Loads synonyms from a DataTable with "Key" and "Value" columns into the master dictionary safely.
        /// </summary>
        public static void LoadFromDataTable(DataTable table)
        {
            if (!table.Columns.Contains("Key") || !table.Columns.Contains("Value"))
            {
                throw new ArgumentException("DataTable must have 'Key' and 'Value' columns.");
            }

            foreach (DataRow row in table.Rows)
            {
                string key = row["Key"].ToString();
                string value = row["Value"].ToString();
                SafeAdd(MasterDictionary, key, value);
            }
        }
        #endregion


        public class Synonyms
        {

            public static Dictionary<string, string> SynonymDictionary
            {
                get
                {
                    var master = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

                    // Aggregate all specialized dictionaries

                    //AddDictionaryToMaster(AddressLocationDictionary, master);
                    // --- Core Identity & Contact ---
                    AddDictionaryToMaster(IdentityPersonDictionary, master);
                    AddDictionaryToMaster(AddressLocationDictionary, master);
                    AddDictionaryToMaster(ContactCommunicationDictionary, master);
                    AddDictionaryToMaster(OrganizationIdentityDictionary, master);

                    // --- Financial & Product ---
                    AddDictionaryToMaster(FinancialIdentityDictionary, master);
                    AddDictionaryToMaster(ProductInventoryDictionary, master);
                    AddDictionaryToMaster(MeasurementQuantityDictionary, master);

                    // --- Metadata & Politics ---
                    AddDictionaryToMaster(TemporalAuditDictionary, master);
                    AddDictionaryToMaster(ElectionPoliticalDictionary, master);
                    AddDictionaryToMaster(MiscMetadataDictionary, master);

                    // --- New Specialized Domains ---
                    AddDictionaryToMaster(EmploymentHrDictionary, master);
                    AddDictionaryToMaster(TechnicalAssetsDictionary, master);
                    AddDictionaryToMaster(HealthcareMedicalDictionary, master);

                    // If you create more specialized dictionaries, add them here:
                    // AddDictionaryToMaster(ContactDictionary, master);
                    // AddDictionaryToMaster(OrganizationDictionary, master);
                    // AddDictionaryToMaster(FinanceDictionary, master);

                    return master;
                }
            }

            public static Dictionary<string, string> IdentityPersonDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    { "firstname", "firstname" },
    { "fname", "firstname" },
    { "first", "firstname" },
    { "first_name", "firstname" },
    { "givenname", "firstname" },
    { "given_name", "firstname" },
    { "given", "firstname" },
    { "gn", "firstname" },
    { "f_name", "firstname" },
    { "f", "firstname" }, // Kept here, removed from gender
    { "firstinitial", "firstname" },
    { "first_initial", "firstname" },
    { "initial", "firstname" },
    { "initials", "firstname" },
    { "nick", "firstname" },
    { "nickname", "firstname" },

    { "lastname", "lastname" },
    { "lname", "lastname" },
    { "last", "lastname" },
    { "last_name", "lastname" },
    { "familyname", "lastname" },
    { "family_name", "lastname" },
    { "surname", "lastname" },
    { "sirname", "lastname" },
    { "sn", "lastname" },
    { "l_name", "lastname" },
    { "l", "lastname" },

    { "middle", "middlename" },
    { "mname", "middlename" },
    { "middlename", "middlename" },
    { "middle_name", "middlename" },
    { "mid", "middlename" },
    { "m_initial", "middlename" },

    { "fullname", "fullname" },
    { "full_name", "fullname" },
    { "complete_name", "fullname" },
    { "complete", "fullname" },
    { "displayname", "fullname" },
    { "display_name", "fullname" },
    { "name", "fullname" },
    { "nm", "fullname" },

    { "dob", "dateofbirth" },
    { "birthdate", "dateofbirth" },
    { "dateofbirth", "dateofbirth" },
    { "birth_date", "dateofbirth" },
    { "bday", "dateofbirth" },
    { "b_date", "dateofbirth" },
    { "b_dob", "dateofbirth" },
    { "birth", "dateofbirth" },

    { "ssn", "socialsecuritynumber" },
    { "social", "socialsecuritynumber" },
    { "socialsecurity", "socialsecuritynumber" },
    { "social_security", "socialsecuritynumber" },
    { "ssa", "socialsecuritynumber" },
    { "sin", "socialsecuritynumber" },
    { "sin_number", "socialsecuritynumber" },
    { "social_sec", "socialsecuritynumber" },
    { "social_sec_num", "socialsecuritynumber" },

    { "gender", "gender" },
    { "sex", "gender" },
    { "gndr", "gender" },
    { "male", "gender" },
    { "female", "gender" },
    { "m", "gender" },
    // "f" was removed here as it duplicated the "firstname" shorthand
    { "nonbinary", "gender" },
    { "nb", "gender" },

    { "age", "age" },
    { "years", "age" },
    { "agent_age", "age" },
    { "cust_age", "age" },

    { "title", "nametitle" },
    { "nametitle", "nametitle" },
    { "titleprefix", "nametitle" },
    { "name_prefix", "nametitle" },
    { "title_prefix", "nametitle" },
    { "nameprefix", "nametitle" },

    { "suffix", "namesuffix" },
    { "namesuffix", "namesuffix" },
    { "suffixname", "namesuffix" },
    { "name_suffix", "namesuffix" },
    { "namepostfix", "namesuffix" }
};

            public static Dictionary<string, string> AddressLocationDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Address Line 1 / Primary Street Address ---
    { "address", "address" },
    { "addr", "address" },
    { "addr1", "address" },
    { "address1", "address" },
    { "addr_line1", "address" },
    { "address_line1", "address" },
    { "streetaddr", "address" },
    { "street_address", "address" },
    { "street_addr", "address" },
    { "line1", "address" },
    { "mailing_address", "address" },
    { "shipping_address", "address" },
    { "billing_address", "address" },
    { "home_address", "address" },
    { "business_address", "address" },
    { "site_address", "address" },
    { "physical_address", "address" },
    { "residence", "address" },
    { "location", "address" },
    { "premise", "address" },

    // --- Address Line 2 / Secondary Info ---
    { "address2", "address2" },
    { "addr2", "address2" },
    { "address_line2", "address2" },
    { "addr_line2", "address2" },
    { "line2", "address2" },
    { "address_line_2", "address2" },
    { "secondary_address", "address2" },

    // --- Street Name & Types ---
    { "street", "street" },
    { "st", "street" }, // Note: Prioritized as 'Street' per your list
    { "st.", "street" },
    { "str", "street" },
    { "streetname", "street" },
    { "street_name", "street" },
    { "rd", "street" },
    { "road", "street" },
    { "ave", "street" },
    { "avenue", "street" },
    { "blvd", "street" },
    { "boulevard", "street" },
    { "lane", "street" },
    { "ln", "street" },
    { "drive", "street" },
    { "dr", "street" },
    { "pkwy", "street" },
    { "parkway", "street" },
    { "ct", "street" },
    { "court", "street" },
    { "pl", "street" },
    { "place", "street" },
    { "ter", "street" },
    { "terrace", "street" },
    { "way", "street" },
    { "hwy", "street" },
    { "highway", "street" },
    { "trl", "street" },
    { "trail", "street" },
    { "cir", "street" },
    { "circle", "street" },
    { "loop", "street" },
    { "path", "street" },
    { "aly", "street" },
    { "alley", "street" },
    { "expy", "street" },
    { "expressway", "street" },
    { "xing", "street" },
    { "crossing", "street" },

    // --- Sub-Units (Apartment, Suite, etc.) ---
    { "apt", "apartment" },
    { "apartment", "apartment" },
    { "apt_number", "apartment" },
    { "apt_no", "apartment" },
    { "unit", "apartment" },
    { "unit_number", "apartment" },
    { "ste", "suite" },
    { "suite", "suite" },
    { "ste_number", "suite" },
    { "bldg", "building" },
    { "building", "building" },
    { "fl", "floor" },
    { "floor", "floor" },
    { "rm", "room" },
    { "room", "room" },
    { "ofc", "office" },
    { "office", "office" },
    { "dept", "department" },
    { "department", "department" },
    { "po_box", "pobox" },
    { "pobox", "pobox" },
    { "box_number", "pobox" },

    // --- City & Locality ---
    { "city", "city" },
    { "town", "city" },
    { "municipality", "city" },
    { "cityname", "city" },
    { "city_name", "city" },
    { "locality", "city" },
    { "township", "city" },
    { "village", "city" },
    { "muni", "city" },
    { "urbanization", "city" },

    // --- State & Region ---
    { "state", "state" },
    { "province", "state" },
    { "region", "state" },
    { "state_code", "state" },
    { "prov", "state" },
    { "territory", "state" },
    { "county", "state" },
    { "parish", "state" },
    { "reg", "state" },
    { "administrative_area", "state" },

    // --- Postal Code ---
    { "zip", "zipcode" },
    { "zipcode", "zipcode" },
    { "postal", "zipcode" },
    { "postalcode", "zipcode" },
    { "zip_code", "zipcode" },
    { "addrzip", "zipcode" },
    { "zipcod", "zipcode" },
    { "zcode", "zipcode" },
    { "post_code", "zipcode" },
    { "pcode", "zipcode" },
    { "zip5", "zipcode" },
    { "zip4", "zipcode" },
    { "postcode", "zipcode" },

    // --- Country ---
    { "country", "country" },
    { "nation", "country" },
    { "country_code", "country" },
    { "cntry", "country" },
    { "ctry", "country" },
    { "iso_country", "country" },
    { "country_name", "country" },

    // --- Coordinates ---
    { "latitude", "latitude" },
    { "lat", "latitude" },
    { "lat_deg", "latitude" },
    { "longitude", "longitude" },
    { "long", "longitude" },
    { "lng", "longitude" },
    { "lon", "longitude" },
    { "lon_deg", "longitude" },
    { "coords", "coordinates" },
    { "gps", "coordinates" },
    { "coord", "coordinates" },

    // --- Directionals ---
    { "north", "direction" },
    { "south", "direction" },
    { "east", "direction" },
    { "west", "direction" },
    { "nw", "direction" },
    { "ne", "direction" },
    { "sw", "direction" },
    { "se", "direction" },
    { "northeast", "direction" },
    { "northwest", "direction" },
    { "southeast", "direction" },
    { "southwest", "direction" }
};

            public static Dictionary<string, string> ContactCommunicationDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Primary Phone & General ---
    { "phone", "phonenumber" },
    { "telephone", "phonenumber" },
    { "tel", "phonenumber" },
    { "ph", "phonenumber" },
    { "phone1", "phonenumber" },
    { "phone_number", "phonenumber" },
    { "phoneno", "phonenumber" },
    { "phone_no", "phonenumber" },
    { "tel_no", "phonenumber" },
    { "tel_number", "phonenumber" },
    { "contact_no", "phonenumber" },
    { "contact_phone", "phonenumber" },
    { "primary_phone", "phonenumber" },
    { "daytime_phone", "phonenumber" },
    { "day_phone", "phonenumber" },
    { "voice_phone", "phonenumber" },

    // --- Mobile / Cell ---
    { "mobile", "phonenumber" },
    { "cellphone", "phonenumber" },
    { "cell", "phonenumber" },
    { "mob", "phonenumber" },
    { "cell_no", "phonenumber" },
    { "mobile_no", "phonenumber" },
    { "mobile_phone", "phonenumber" },
    { "cell_phone", "phonenumber" },
    { "handphone", "phonenumber" },
    { "cellular", "phonenumber" },
    { "mob_phone", "phonenumber" },
    { "sms_number", "phonenumber" },
    { "text_number", "phonenumber" },

    // --- Alternate / Secondary Phone ---
    { "phone2", "alternatephonenumber" },
    { "alt_phone", "alternatephonenumber" },
    { "alternate_phone", "alternatephonenumber" },
    { "phone_alt", "alternatephonenumber" },
    { "secondary_phone", "alternatephonenumber" },
    { "other_phone", "alternatephonenumber" },
    { "alt_tel", "alternatephonenumber" },

    // --- Work & Office ---
    { "workphone", "workphone" },
    { "work_phone", "workphone" },
    { "office_phone", "workphone" },
    { "off_phone", "workphone" },
    { "work_tel", "workphone" },
    { "office_tel", "workphone" },
    { "bus_phone", "workphone" },
    { "business_phone", "workphone" },
    { "work_no", "workphone" },
    { "office_no", "workphone" },
    { "ext", "phoneextension" },
    { "extension", "phoneextension" },
    { "extn", "phoneextension" },
    { "phone_ext", "phoneextension" },

    // --- Home Phone ---
    { "homephone", "homephone" },
    { "home_phone", "homephone" },
    { "home_tel", "homephone" },
    { "home_no", "homephone" },
    { "residence_phone", "homephone" },
    { "res_phone", "homephone" },

    // --- Email Address ---
    { "email", "emailaddress" },
    { "emailaddress", "emailaddress" },
    { "email1", "emailaddress" },
    { "e-mail", "emailaddress" },
    { "e_mail", "emailaddress" },
    { "mail", "emailaddress" },
    { "mail_address", "emailaddress" },
    { "email_addr", "emailaddress" },
    { "email_primary", "emailaddress" },
    { "primary_email", "emailaddress" },
    { "electronic_mail", "emailaddress" },
    { "mbox", "emailaddress" },
    { "mailbox", "emailaddress" },

    // --- Alternate Email ---
    { "email2", "alternateemail" },
    { "alt_email", "alternateemail" },
    { "alternate_email", "alternateemail" },
    { "sec_email", "alternateemail" },
    { "secondary_email", "alternateemail" },
    { "other_email", "alternateemail" },
    { "personal_email", "alternateemail" },
    { "work_email", "alternateemail" },

    // --- Fax & Pager ---
    { "fax", "faxnumber" },
    { "faxnumber", "faxnumber" },
    { "fax_no", "faxnumber" },
    { "fax_number", "faxnumber" },
    { "facsimile", "faxnumber" },
    { "fx", "faxnumber" },
    { "pager", "pagernumber" },
    { "page", "pagernumber" },
    { "beeper", "pagernumber" },
    { "pager_no", "pagernumber" },

    // --- Web & Social ---
    { "website", "website" },
    { "url", "website" },
    { "web", "website" },
    { "web_site", "website" },
    { "web_address", "website" },
    { "homepage", "website" },
    { "site_url", "website" },
    { "web_link", "website" },
    { "link", "website" },
    { "social_url", "website" },
    { "linkedin", "socialhandle" },
    { "twitter", "socialhandle" },
    { "x_handle", "socialhandle" },
    { "facebook", "socialhandle" },
    { "fb_url", "socialhandle" },
    { "insta", "socialhandle" },
    { "instagram", "socialhandle" },
    { "github", "socialhandle" },
    { "handle", "socialhandle" },

    // --- Contact Names & People ---
    { "contact", "contactname" },
    { "contactname", "contactname" },
    { "contact_name", "contactname" },
    { "contact_person", "contactname" },
    { "attn", "contactname" },
    { "attention", "contactname" },
    { "emergency_contact", "emergencycontact" },
    { "ice_contact", "emergencycontact" },
    { "emergency_name", "emergencycontact" },
    { "emergency_phone", "emergencycontact" },
    { "next_of_kin", "emergencycontact" },
    { "ref", "referral" },
    { "reference", "referral" },
    { "referred_by", "referral" },

    // --- Messaging ---
    { "skype", "messaging" },
    { "whatsapp", "messaging" },
    { "slack", "messaging" },
    { "messenger", "messaging" },
    { "chat_id", "messaging" },
    { "im", "messaging" },
    { "instant_messenger", "messaging" }
};

            public static Dictionary<string, string> OrganizationIdentityDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Company / Corporate Entities ---
    { "organization", "company" },
    { "organization_name", "company" },
    { "org_name", "company" },
    { "org", "company" },
    { "firm", "company" },
    { "business_name", "company" },
    { "business", "company" },
    { "biz_name", "company" },
    { "company", "company" },
    { "co", "company" },
    { "corp", "company" },
    { "corporation", "company" },
    { "inc", "company" },
    { "incorporated", "company" },
    { "llc", "company" },
    { "limited", "company" },
    { "ltd", "company" },
    { "enterprise", "company" },
    { "venture", "company" },
    { "agency", "company" },
    { "practice", "company" },
    { "boutique", "company" },
    { "brand", "company" },
    { "subsidiary", "company" },
    { "parent_company", "company" },
    { "holding_company", "company" },
    { "conglomerate", "company" },
    { "partnership", "company" },
    { "gp", "company" },
    { "lp", "company" },
    { "establishment", "company" },
    { "legal_entity", "company" },
    { "legal_name", "company" },
    { "dba", "company" },
    { "trade_name", "company" },
    { "vendor", "company" },
    { "supplier", "company" },
    { "client_name", "company" },
    { "customer_name", "company" },
    { "provider", "company" },

    // --- Internal Structure / Departments ---
    { "department", "department" },
    { "dept", "department" },
    { "dept_name", "department" },
    { "division", "department" },
    { "div", "department" },
    { "team", "department" },
    { "squad", "department" },
    { "workgroup", "department" },
    { "group", "department" },
    { "unit", "department" },
    { "business_unit", "department" },
    { "bu", "department" },
    { "branch", "department" },
    { "section", "department" },
    { "bureau", "department" },
    { "office", "department" },
    { "site", "department" },
    { "faculty", "department" },
    { "school", "department" },
    { "lab", "department" },
    { "laboratory", "department" },
    { "plant", "department" },
    { "facility", "department" },
    { "function", "department" },
    { "area", "department" },
    { "silo", "department" },
    { "wing", "department" },
    { "cost_center", "department" },

    // --- General Groups / Parties ---
    { "party", "party" },
    { "entity", "party" },
    { "association", "party" },
    { "assoc", "party" },
    { "club", "party" },
    { "committee", "party" },
    { "society", "party" },
    { "collective", "party" },
    { "guild", "party" },
    { "union", "party" },
    { "syndicate", "party" },
    { "consortium", "party" },
    { "federation", "party" },
    { "alliance", "party" },
    { "league", "party" },
    { "coalition", "party" },
    { "foundation", "party" },
    { "trust", "party" },
    { "nonprofit", "party" },
    { "non_profit", "party" },
    { "ngo", "party" },
    { "npo", "party" },
    { "charity", "party" },
    { "institute", "party" },
    { "institution", "party" },
    { "academy", "party" },
    { "chamber", "party" },
    { "assembly", "party" },

    // --- Government & Public Sector ---
    { "authority", "government" },
    { "commission", "government" },
    { "board", "government" },
    { "ministry", "government" },
    { "council", "government" },
    { "municipality_name", "government" },
    { "district", "government" },
    { "ward", "government" },
    { "parish_name", "government" },
    { "agency_name", "government" },
    { "gov_entity", "government" },

    // --- Meta / Categorization ---
    { "organization_type", "organizationtype" },
    { "org_type", "organizationtype" },
    { "entity_type", "organizationtype" },
    { "company_type", "organizationtype" },
    { "business_type", "organizationtype" },
    { "industry", "industry" },
    { "sector", "industry" },
    { "vertical", "industry" },
    { "sic_code", "industry" },
    { "naics_code", "industry" },
    { "nace_code", "industry" },
    { "tax_id", "taxidentifier" },
    { "ein", "taxidentifier" },
    { "vat_number", "taxidentifier" },
    { "registration_no", "taxidentifier" }
};

            public static Dictionary<string, string> FinancialIdentityDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Basic Amounts & Balances ---
    { "amt", "amount" },
    { "amount", "amount" },
    { "total", "totalamount" },
    { "totalamt", "totalamount" },
    { "total_amount", "totalamount" },
    { "grandtotal", "totalamount" },
    { "grand_total", "totalamount" },
    { "balance", "balance" },
    { "bal", "balance" },
    { "available_balance", "balance" },
    { "avail_bal", "balance" },
    { "curr_bal", "balance" },
    { "current_balance", "balance" },
    { "ending_balance", "balance" },
    { "statement_balance", "balance" },
    { "subtotal", "subtotal" },
    { "sub_total", "subtotal" },

    // --- Pricing, Costs & Fees ---
    { "price", "price" },
    { "unit_price", "price" },
    { "cost", "cost" },
    { "net_cost", "cost" },
    { "gross_cost", "cost" },
    { "fee", "fee" },
    { "service_fee", "fee" },
    { "processing_fee", "fee" },
    { "charge", "fee" },
    { "surcharge", "fee" },
    { "penalty", "fee" },
    { "late_fee", "fee" },
    { "convenience_fee", "fee" },
    { "interest", "interest" },
    { "apr", "interest" },
    { "rate", "interest" },
    { "interest_rate", "interest" },

    // --- Taxes & Discounts ---
    { "tax", "tax" },
    { "tax_amount", "tax" },
    { "vat", "tax" },
    { "vat_amount", "tax" },
    { "gst", "tax" },
    { "hst", "tax" },
    { "sales_tax", "tax" },
    { "tax_total", "tax" },
    { "duty", "tax" },
    { "excise", "tax" },
    { "withholding", "tax" },
    { "discount", "discount" },
    { "discount_amount", "discount" },
    { "rebate", "discount" },
    { "rebate_amount", "discount" },
    { "promo_discount", "discount" },
    { "coupon_amount", "discount" },
    { "markdown", "discount" },

    // --- Quantities & Metrics ---
    { "qty", "quantity" },
    { "quantity", "quantity" },
    { "units", "quantity" },
    { "count", "quantity" },
    { "volume", "quantity" },
    { "percent", "percentage" },
    { "pct", "percentage" },
    { "percentage", "percentage" },
    { "ratio", "percentage" },
    { "margin", "percentage" },

    // --- Payments & Transactions ---
    { "payment_amount", "paymentamount" },
    { "paid", "paymentamount" },
    { "paymentamt", "paymentamount" },
    { "pmt_amt", "paymentamount" },
    { "remittance", "paymentamount" },
    { "settlement", "paymentamount" },
    { "deposit", "deposit" },
    { "withdrawal", "withdrawal" },
    { "debit", "debit" },
    { "dbt", "debit" },
    { "credit", "credit" },
    { "crdt", "credit" },
    { "cr", "credit" },
    { "dr", "debit" },
    { "refund", "refund" },
    { "reversal", "refund" },

    // --- Banking & Account Info ---
    { "account_number", "accountnumber" },
    { "acct_no", "accountnumber" },
    { "acctnum", "accountnumber" },
    { "account_no", "accountnumber" },
    { "acc_no", "accountnumber" },
    { "bank_id", "bankid" },
    { "routing_number", "routingnumber" },
    { "routing_no", "routingnumber" },
    { "rt_no", "routingnumber" },
    { "transit_no", "routingnumber" },
    { "aba", "routingnumber" },
    { "swift", "swiftcode" },
    { "bic", "swiftcode" },
    { "iban", "iban" },
    { "clabe", "iban" }, // Mexican standard
    { "bsb", "routingnumber" }, // Australian standard
    { "sort_code", "routingnumber" }, // UK standard

    // --- Identifiers & Tracking ---
    { "invoice_number", "invoiceid" },
    { "invoice_no", "invoiceid" },
    { "inv_no", "invoiceid" },
    { "inv_num", "invoiceid" },
    { "order_number", "orderid" },
    { "order_no", "orderid" },
    { "ord_no", "orderid" },
    { "po_number", "orderid" },
    { "po_no", "orderid" },
    { "txn_id", "transactionid" },
    { "transaction_id", "transactionid" },
    { "trans_id", "transactionid" },
    { "paymentid", "paymentid" },
    { "payment_id", "paymentid" },
    { "check_number", "checknumber" },
    { "cheque_no", "checknumber" },
    { "check_no", "checknumber" },
    { "ref_no", "referenceid" },
    { "reference_number", "referenceid" },
    { "confirmation_no", "referenceid" },

    // --- Currency ---
    { "currency", "currency" },
    { "curr", "currency" },
    { "iso_currency", "currency" },
    { "ccy", "currency" },
    { "currency_code", "currency" },
    { "denom", "currency" },
    { "denomination", "currency" },

    // --- Cards & Methods ---
    { "card_number", "cardnumber" },
    { "cc_num", "cardnumber" },
    { "pan", "cardnumber" },
    { "card_type", "cardtype" },
    { "exp_date", "expiry" },
    { "expiry", "expiry" },
    { "cvv", "securitycode" },
    { "cvc", "securitycode" },
    { "payment_method", "paymentmethod" },
    { "pay_type", "paymentmethod" },

    // --- Accounting Concepts ---
    { "revenue", "revenue" },
    { "income", "revenue" },
    { "sales", "revenue" },
    { "expense", "expense" },
    { "expenditure", "expense" },
    { "profit", "profit" },
    { "net_profit", "profit" },
    { "earnings", "profit" },
    { "loss", "loss" },
    { "asset", "asset" },
    { "liability", "liability" },
    { "equity", "equity" },
    { "principal", "principal" },
    { "escrow", "escrow" },
    { "amortization", "amortization" },
    { "depreciation", "depreciation" }
};

            public static Dictionary<string, string> ProductInventoryDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Product Identification ---
    { "product", "productname" },
    { "productname", "productname" },
    { "product_name", "productname" },
    { "item", "productname" },
    { "itemname", "productname" },
    { "item_name", "productname" },
    { "description", "productname" },
    { "desc", "productname" },
    { "prod_desc", "productname" },
    { "label", "productname" },
    { "title", "productname" },
    { "commodity", "productname" },
    { "merchandise", "productname" },
    { "goods", "productname" },

    // --- Unique Identifiers & Codes ---
    { "sku", "sku" },
    { "stock_keeping_unit", "sku" },
    { "part_number", "sku" },
    { "part_no", "sku" },
    { "pn", "sku" },
    { "p_n", "sku" },
    { "barcode", "sku" },
    { "bar_code", "sku" },
    { "upc", "sku" },
    { "upc_code", "sku" },
    { "ean", "sku" },
    { "gtin", "sku" },
    { "isbn", "sku" }, // Book specific
    { "mpn", "sku" }, // Manufacturer Part Number
    { "serial", "serialnumber" },
    { "serialnumber", "serialnumber" },
    { "serial_no", "serialnumber" },
    { "sn", "serialnumber" },
    { "s_n", "serialnumber" },
    { "vin", "serialnumber" }, // Vehicle specific
    { "asset_tag", "serialnumber" },

    // --- Brand & Origin ---
    { "brand", "brand" },
    { "brand_name", "brand" },
    { "make", "brand" },
    { "manufacturer", "brand" },
    { "mfg", "brand" },
    { "mfr", "brand" },
    { "vendor", "brand" },
    { "supplier", "brand" },
    { "producer", "brand" },
    { "origin", "brand" },
    { "coo", "brand" }, // Country of Origin

    // --- Classification & Attributes ---
    { "model", "model" },
    { "model_number", "model" },
    { "mod_no", "model" },
    { "model_name", "model" },
    { "version", "model" },
    { "category", "category" },
    { "cat", "category" },
    { "dept", "category" },
    { "department", "category" },
    { "class", "category" },
    { "group", "category" },
    { "family", "category" },
    { "collection", "category" },
    { "type", "type" },
    { "prod_type", "type" },
    { "subtype", "type" },
    { "sub_type", "type" },
    { "kind", "type" },
    { "style", "type" },
    { "color", "variant" },
    { "colour", "variant" },
    { "size", "variant" },
    { "material", "variant" },
    { "fabric", "variant" },
    { "finish", "variant" },

    // --- Stock & Inventory Levels ---
    { "stock", "inventorylevel" },
    { "inventory", "inventorylevel" },
    { "on_hand", "inventorylevel" },
    { "qty_on_hand", "inventorylevel" },
    { "qoh", "inventorylevel" },
    { "available", "inventorylevel" },
    { "qty_avail", "inventorylevel" },
    { "stock_level", "inventorylevel" },
    { "on_order", "inventorylevel" },
    { "backorder", "inventorylevel" },
    { "reorder_point", "inventorylevel" },
    { "safety_stock", "inventorylevel" },
    { "allocated", "inventorylevel" },
    { "shrinkage", "inventorylevel" },

    // --- Warehouse & Logistics ---
    { "warehouse", "location" },
    { "wh", "location" },
    { "loc", "location" },
    { "location", "location" },
    { "bin", "location" },
    { "aisle", "location" },
    { "shelf", "location" },
    { "slot", "location" },
    { "bay", "location" },
    { "facility", "location" },
    { "dc", "location" }, // Distribution Center
    { "node", "location" },

    // --- Physical Dimensions ---
    { "weight", "weight" },
    { "wgt", "weight" },
    { "mass", "weight" },
    { "net_weight", "weight" },
    { "gross_weight", "weight" },
    { "length", "dimensions" },
    { "width", "dimensions" },
    { "height", "dimensions" },
    { "depth", "dimensions" },
    { "dims", "dimensions" },
    { "dimensions", "dimensions" },
    { "size_dims", "dimensions" },
    { "volume", "dimensions" },

    // --- Packaging & Units ---
    { "uom", "unitofmeasure" },
    { "unit", "unitofmeasure" },
    { "measure", "unitofmeasure" },
    { "pack", "unitofmeasure" },
    { "package", "unitofmeasure" },
    { "pkg", "unitofmeasure" },
    { "case", "unitofmeasure" },
    { "pallet", "unitofmeasure" },
    { "ea", "unitofmeasure" }, // Each
    { "pcs", "unitofmeasure" }, // Pieces
    { "ctn", "unitofmeasure" }  // Carton
};

            public static Dictionary<string, string> MeasurementQuantityDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- General Quantity & Count ---
    { "number_of_items", "quantity" },
    { "count", "quantity" },
    { "qty", "quantity" },
    { "quantity", "quantity" },
    { "amount", "quantity" },
    { "total_count", "quantity" },
    { "item_count", "quantity" },
    { "units", "quantity" },
    { "pieces", "quantity" },
    { "pcs", "quantity" },
    { "vol", "quantity" },
    { "magnitude", "quantity" },
    { "amt", "quantity" },

    // --- Weight & Mass ---
    { "weight", "weight" },
    { "mass", "weight" },
    { "wgt", "weight" },
    { "wt", "weight" },
    { "net_weight", "weight" },
    { "gross_weight", "weight" },
    { "tare_weight", "weight" },
    { "lbs", "weight" },
    { "pounds", "weight" },
    { "kg", "weight" },
    { "kilograms", "weight" },
    { "grams", "weight" },
    { "oz", "weight" },
    { "ounces", "weight" },
    { "tonnage", "weight" },
    { "load", "weight" },

    // --- Length & Distance ---
    { "length", "length" },
    { "len", "length" },
    { "distance", "length" },
    { "dist", "length" },
    { "height", "length" },
    { "hgt", "length" },
    { "width", "length" },
    { "wth", "length" },
    { "depth", "length" },
    { "dpt", "length" },
    { "thickness", "length" },
    { "gauge", "length" },
    { "span", "length" },
    { "reach", "length" },
    { "diameter", "length" },
    { "dia", "length" },
    { "radius", "length" },
    { "circumference", "length" },
    { "perimeter", "length" },

    // --- Physical Size & Dimensions ---
    { "size", "size" },
    { "dimension", "size" },
    { "dimensions", "size" },
    { "dims", "size" },
    { "measurement", "size" },
    { "measure", "size" },
    { "scale", "size" },
    { "proportion", "size" },
    { "footprint", "size" },
    { "area", "size" },
    { "surface_area", "size" },
    { "sqft", "size" },
    { "square_footage", "size" },

    // --- Volume & Capacity ---
    { "volume", "volume" },
    { "capacity", "volume" },
    { "displacement", "volume" },
    { "liters", "volume" },
    { "litres", "volume" },
    { "ml", "volume" },
    { "gallons", "volume" },
    { "gal", "volume" },
    { "fluid_oz", "volume" },
    { "cc", "volume" },
    { "cubic_measure", "volume" },

    // --- Rates, Ratios & Percentages ---
    { "ratio", "percentage" },
    { "rate", "percentage" },
    { "percent", "percentage" },
    { "percentage", "percentage" },
    { "pct", "percentage" },
    { "portion", "percentage" },
    { "fraction", "percentage" },
    { "proportion_rate", "percentage" },
    { "coefficient", "percentage" },
    { "factor", "percentage" },
    { "multiplier", "percentage" },

    // --- Technical & Engineering ---
    { "tolerance", "specification" },
    { "clearance", "specification" },
    { "allowance", "specification" },
    { "margin", "specification" },
    { "buffer", "specification" },
    { "threshold", "specification" },
    { "limit", "specification" },
    { "spec", "specification" },
    { "specification", "specification" },
    { "parameter", "specification" },

    // --- Values & Numbers ---
    { "amount_value", "value" },
    { "val", "value" },
    { "value", "value" },
    { "numeric", "value" },
    { "reading", "value" },
    { "score", "value" },
    { "index", "value" },
    { "level", "value" },
    { "intensity", "value" },
    { "degree", "value" },
    { "extent", "value" },

    // --- Units of Measure (UOM) ---
    { "uom", "unit" },
    { "unit", "unit" },
    { "unit_of_measure", "unit" },
    { "measure_unit", "unit" },
    { "metric", "unit" },
    { "system", "unit" }
};

            public static Dictionary<string, string> TemporalAuditDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Creation & Origin ---
    { "creation_time", "createddate" },
    { "created_date", "createddate" },
    { "created_at", "createddate" },
    { "create_dt", "createddate" },
    { "crt_dt", "createddate" },
    { "origination_date", "createddate" },
    { "inserted_at", "createddate" },
    { "added_date", "createddate" },
    { "entry_date", "timestamp" },
    { "entry_dt", "timestamp" },
    { "initiation_date", "createddate" },
    { "start_date", "createddate" },

    // --- Modification & Updates ---
    { "lastmodified", "modifieddate" },
    { "last_modified", "modifieddate" },
    { "last_mod", "modifieddate" },
    { "update_time", "modifieddate" },
    { "updated_at", "modifieddate" },
    { "updated_date", "modifieddate" },
    { "upd_dt", "modifieddate" },
    { "edit_date", "modifieddate" },
    { "change_date", "modifieddate" },
    { "modified_at", "modifieddate" },
    { "revised_date", "modifieddate" },
    { "revision_time", "modifieddate" },
    { "refresh_date", "modifieddate" },

    // --- Deletion & Expiration ---
    { "deleted_time", "deleteddate" },
    { "deleted_at", "deleteddate" },
    { "deleted_date", "deleteddate" },
    { "del_dt", "deleteddate" },
    { "removed_at", "deleteddate" },
    { "deactivated_date", "deleteddate" },
    { "expiration_date", "expirydate" },
    { "expiry_date", "expirydate" },
    { "exp_dt", "expirydate" },
    { "end_date", "expirydate" },
    { "termination_date", "expirydate" },
    { "valid_until", "expirydate" },
    { "void_date", "expirydate" },

    // --- General Timestamps & Logging ---
    { "logtime", "timestamp" },
    { "logdate", "timestamp" },
    { "timestamp", "timestamp" },
    { "ts", "timestamp" },
    { "event_time", "timestamp" },
    { "occurred_at", "timestamp" },
    { "activity_date", "timestamp" },
    { "system_date", "timestamp" },
    { "server_time", "timestamp" },
    { "utc_timestamp", "timestamp" },
    { "local_time", "timestamp" },

    // --- Scheduling & Deadlines ---
    { "due_date", "deadline" },
    { "deadline", "deadline" },
    { "target_date", "deadline" },
    { "scheduled_time", "deadline" },
    { "expected_date", "deadline" },
    { "cutoff_time", "deadline" },
    { "appointment_date", "deadline" },
    { "ship_date", "deadline" },
    { "delivery_date", "deadline" },

    // --- Fiscal & Calendar Periods ---
    { "year", "period" },
    { "yr", "period" },
    { "quarter", "period" },
    { "qtr", "period" },
    { "month", "period" },
    { "mo", "period" },
    { "week", "period" },
    { "wk", "period" },
    { "day", "period" },
    { "fiscal_year", "period" },
    { "fy", "period" },
    { "period_start", "period" },
    { "period_end", "period" },

    // --- Time Duration & Intervals ---
    { "duration", "interval" },
    { "elapsed_time", "interval" },
    { "time_spent", "interval" },
    { "runtime", "interval" },
    { "lead_time", "interval" },
    { "age", "interval" },
    { "tenure", "interval" },
    { "frequency", "interval" },

    // --- Audit & User Tracking ---
    { "created_by", "audituser" },
    { "creator", "audituser" },
    { "author", "audituser" },
    { "modified_by", "audituser" },
    { "editor", "audituser" },
    { "updated_by", "audituser" },
    { "deleted_by", "audituser" },
    { "owner", "audituser" },
    { "user_id", "audituser" },
    { "last_user", "audituser" }
};

            public static Dictionary<string, string> ElectionPoliticalDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Political Parties & Affiliation ---
    { "party", "party" },
    { "party_name", "party" },
    { "political_party", "party" },
    { "party_affiliation", "party" },
    { "affiliation", "party" },
    { "party_id", "party" },
    { "party_code", "party" },
    { "party_abbr", "party" },
    { "caucus", "party" },
    { "faction", "party" },
    { "coalition", "party" },

    // --- Candidates & Incumbency ---
    { "candidate", "candidate" },
    { "candidate_name", "candidate" },
    { "cand_name", "candidate" },
    { "nominee", "candidate" },
    { "contender", "candidate" },
    { "incumbent", "candidate" },
    { "running_mate", "candidate" },
    { "ticket", "candidate" },
    { "candidate_id", "candidate" },
    { "office_sought", "office" },
    { "seat", "office" },
    { "position", "office" },

    // --- Election Events ---
    { "election", "election" },
    { "election_date", "election" },
    { "election_dt", "election" },
    { "election_type", "election" },
    { "election_name", "election" },
    { "primary", "election" },
    { "general_election", "election" },
    { "runoff", "election" },
    { "special_election", "election" },
    { "by_election", "election" },
    { "midterm", "election" },
    { "cycle", "election" },
    { "election_year", "election" },

    // --- Votes & Ballots ---
    { "vote", "vote" },
    { "votes", "vote" },
    { "vote_count", "vote" },
    { "tally", "vote" },
    { "ballot", "ballot" },
    { "ballot_id", "ballot" },
    { "ballot_box", "ballot" },
    { "paper_ballot", "ballot" },
    { "absentee_ballot", "ballot" },
    { "provisional_ballot", "ballot" },
    { "spoiled_ballot", "ballot" },
    { "cast_vote", "vote" },
    { "vote_share", "vote" },
    { "percentage_vote", "vote" },

    // --- Voters & Registration ---
    { "voter", "voter" },
    { "voterid", "voterid" },
    { "voter_id", "voterid" },
    { "voter_reg_no", "voterid" },
    { "registration_id", "voterid" },
    { "elector", "voter" },
    { "constituent", "voter" },
    { "registered_voter", "voter" },
    { "voter_status", "voterstatus" },
    { "eligibility", "voterstatus" },
    { "voter_file", "voter" },

    // --- Geography & Administrative Units ---
    { "polling_station", "pollingstation" },
    { "polling_place", "pollingstation" },
    { "poll_site", "pollingstation" },
    { "precinct", "precinct" },
    { "precinct_code", "precinct" },
    { "pct", "precinct" },
    { "ward", "precinct" },
    { "district", "district" },
    { "dist", "district" },
    { "constituency", "district" },
    { "const", "district" },
    { "electoral_district", "district" },
    { "riding", "district" }, // Canadian/UK term
    { "jurisdiction", "district" },
    { "boundary", "district" },
    { "division", "district" },
    { "senate_district", "district" },
    { "house_district", "district" },
    { "congressional_district", "district" },

    // --- Referendums & Measures ---
    { "referendum", "referendum" },
    { "referendum_id", "referendum" },
    { "ballot_measure", "referendum" },
    { "proposition", "referendum" },
    { "prop", "referendum" },
    { "initiative", "referendum" },
    { "plebiscite", "referendum" },
    { "question", "referendum" },

    // --- Campaign Finance & Data ---
    { "contribution", "finance" },
    { "donation", "finance" },
    { "donor", "finance" },
    { "pac", "finance" },
    { "super_pac", "finance" },
    { "fec_id", "finance" },
    { "expenditure", "finance" },
    { "disbursement", "finance" },
    { "campaign_fund", "finance" },

    // --- Results & Metrics ---
    { "winner", "result" },
    { "loser", "result" },
    { "margin_of_victory", "result" },
    { "mov", "result" },
    { "turnout", "turnout" },
    { "voter_turnout", "turnout" },
    { "abstention", "turnout" },
    { "spoilt", "turnout" },
    { "precincts_reporting", "progress" },
    { "reporting_status", "progress" }
};

            public static Dictionary<string, string> MiscMetadataDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Notes & Commentary ---
    { "details", "notes" },
    { "commentary", "notes" },
    { "remark_text", "notes" },
    { "remarks", "notes" },
    { "notes", "notes" },
    { "notes_text", "notes" },
    { "comments", "notes" },
    { "comment_body", "notes" },
    { "feedback", "notes" },
    { "annotation", "notes" },
    { "memo", "notes" },
    { "observation", "notes" },
    { "explanation", "notes" },
    { "summary", "notes" },
    { "brief", "notes" },

    // --- Descriptions ---
    { "description", "description" },
    { "description_text", "description" },
    { "desc", "description" },
    { "narrative", "description" },
    { "abstract", "description" },
    { "caption", "description" },
    { "info", "description" },
    { "information", "description" },
    { "about", "description" },
    { "content", "description" },
    { "body_text", "description" },

    // --- Attributes & Metadata ---
    { "attribute", "attribute" },
    { "attribute_name", "attribute" },
    { "attribute_value", "attribute" },
    { "attr_name", "attribute" },
    { "attr_val", "attribute" },
    { "property", "attribute" },
    { "prop", "attribute" },
    { "metadata", "attribute" },
    { "meta", "attribute" },
    { "extra", "attribute" },
    { "additional_info", "attribute" },
    { "params", "attribute" },
    { "parameters", "attribute" },
    { "settings", "attribute" },
    { "config", "attribute" },
    { "spec", "attribute" },
    { "specifications", "attribute" },

    // --- Status & Workflow Flags ---
    { "indicator_flag", "flag" },
    { "status_flag", "flag" },
    { "flag", "flag" },
    { "is_active", "flag" },
    { "active_flg", "flag" },
    { "enabled", "flag" },
    { "disabled", "flag" },
    { "status", "status" },
    { "state", "status" },
    { "stage", "status" },
    { "phase", "status" },
    { "condition", "status" },
    { "priority", "priority" },
    { "urgency", "priority" },
    { "severity", "priority" },

    // --- Approval & Verification ---
    { "approval_status", "isapproved" },
    { "approved", "isapproved" },
    { "is_approved", "isapproved" },
    { "appr_flg", "isapproved" },
    { "verification_status", "isverified" },
    { "verified", "isverified" },
    { "is_verified", "isverified" },
    { "authenticated", "isverified" },
    { "validated", "isverified" },
    { "confirmed", "isverified" },
    { "cert_status", "isverified" },

    // --- Security & Locking ---
    { "locked_flag", "islocked" },
    { "is_locked", "islocked" },
    { "lock_status", "islocked" },
    { "read_only", "islocked" },
    { "protected", "islocked" },
    { "restricted", "islocked" },
    { "private", "islocked" },
    { "hidden", "islocked" },
    { "internal_only", "islocked" },

    // --- Audit & System Metadata ---
    { "source", "source" },
    { "origin", "source" },
    { "channel", "source" },
    { "medium", "source" },
    { "platform", "source" },
    { "version_no", "version" },
    { "ver", "version" },
    { "revision", "version" },
    { "rev", "version" },
    { "build", "version" },
    { "checksum", "hash" },
    { "hash", "hash" },
    { "fingerprint", "hash" },
    { "guid", "id" },
    { "uuid", "id" },
    { "external_id", "id" },
    { "ext_ref", "id" },
    { "reference", "id" },

    // --- Formatting & UI ---
    { "label", "ui" },
    { "display_text", "ui" },
    { "tooltip", "ui" },
    { "placeholder", "ui" },
    { "hint", "ui" },
    { "alt_text", "ui" },
    { "icon", "ui" },
    { "image_url", "ui" },
    { "thumbnail", "ui" },
    { "css_class", "ui" },
    { "theme", "ui" },
    { "style_name", "ui" }
};

            public static Dictionary<string, string> EmploymentHrDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Job Titles & Roles ---
    { "title", "jobtitle" },
    { "job_title", "jobtitle" },
    { "position", "jobtitle" },
    { "role", "jobtitle" },
    { "designation", "jobtitle" },
    { "occ", "jobtitle" },
    { "occupation", "jobtitle" },
    { "rank", "jobtitle" },
    { "function", "jobtitle" },
    { "work_role", "jobtitle" },

    // --- Employee Identifiers ---
    { "employee_id", "employeeid" },
    { "emp_id", "employeeid" },
    { "eid", "employeeid" },
    { "staff_id", "employeeid" },
    { "badge_number", "employeeid" },
    { "clock_number", "employeeid" },
    { "worker_id", "employeeid" },
    { "personnel_number", "employeeid" },
    { "per_no", "employeeid" },

    // --- Employment Status & Type ---
    { "status", "employmentstatus" },
    { "emp_status", "employmentstatus" },
    { "work_status", "employmentstatus" },
    { "active", "employmentstatus" },
    { "fte", "employmenttype" }, // Full-Time Equivalent
    { "employment_type", "employmenttype" },
    { "contract_type", "employmenttype" },
    { "pt", "employmenttype" }, // Part-Time
    { "ft", "employmenttype" }, // Full-Time
    { "temp", "employmenttype" },
    { "contractor", "employmenttype" },
    { "consultant", "employmenttype" },
    { "intern", "employmenttype" },

    // --- Hierarchy & Reporting ---
    { "manager", "manager" },
    { "mgr", "manager" },
    { "supervisor", "manager" },
    { "supv", "manager" },
    { "reports_to", "manager" },
    { "direct_report", "manager" },
    { "lead", "manager" },
    { "head", "manager" },
    { "dept_head", "manager" },
    { "executive", "manager" },

    // --- Compensation & Benefits ---
    { "salary", "compensation" },
    { "wage", "compensation" },
    { "pay_rate", "compensation" },
    { "hourly_rate", "compensation" },
    { "comp", "compensation" },
    { "remuneration", "compensation" },
    { "bonus", "compensation" },
    { "commission", "compensation" },
    { "allowance", "compensation" },
    { "stipend", "compensation" },
    { "equity", "compensation" },
    { "benefits", "benefits" },
    { "perks", "benefits" },
    { "insurance_plan", "benefits" },

    // --- Key HR Dates ---
    { "hire_date", "hiredate" },
    { "hired_on", "hiredate" },
    { "start_date", "hiredate" },
    { "anniversary", "hiredate" },
    { "termination_date", "terminationdate" },
    { "end_date", "terminationdate" },
    { "exit_date", "terminationdate" },
    { "last_day", "terminationdate" },
    { "seniority_date", "hiredate" },
    { "tenure", "tenure" },

    // --- Performance & Skills ---
    { "skills", "skills" },
    { "competencies", "skills" },
    { "qualifications", "skills" },
    { "certifications", "skills" },
    { "certs", "skills" },
    { "rating", "performance" },
    { "score", "performance" },
    { "review_cycle", "performance" }
};

            public static Dictionary<string, string> TechnicalAssetsDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- File Metadata ---
    { "filename", "filename" },
    { "file_name", "filename" },
    { "fname", "filename" }, // Note: Possible conflict with 'First Name'—context matters!
    { "ext", "extension" },
    { "extension", "extension" },
    { "file_type", "extension" },
    { "format", "extension" },
    { "mimetype", "extension" },
    { "content_type", "extension" },
    { "size", "filesize" },
    { "file_size", "filesize" },
    { "filesize", "filesize" },
    { "bytes", "filesize" },
    { "kb", "filesize" },
    { "mb", "filesize" },

    // --- Media & Images ---
    { "width", "width" },
    { "w", "width" },
    { "height", "height" },
    { "h", "height" },
    { "resolution", "resolution" },
    { "res", "resolution" },
    { "dpi", "resolution" },
    { "pixels", "resolution" },
    { "px", "resolution" },
    { "aspect_ratio", "ratio" },
    { "bitrate", "bitrate" },
    { "fps", "framerate" },
    { "frame_rate", "framerate" },
    { "duration", "duration" },
    { "length", "duration" },

    // --- Network & Security ---
    { "ip_address", "ipaddress" },
    { "ip", "ipaddress" },
    { "host", "hostname" },
    { "hostname", "hostname" },
    { "domain", "hostname" },
    { "mac_address", "macaddress" },
    { "mac", "macaddress" },
    { "port", "port" },
    { "protocol", "protocol" },
    { "scheme", "protocol" },
    { "apikey", "apikey" },
    { "api_key", "apikey" },
    { "token", "token" },
    { "access_token", "token" },
    { "secret", "secret" },
    { "client_id", "clientid" },
    { "user_agent", "useragent" },
    { "ua", "useragent" }
};

            public static Dictionary<string, string> HealthcareMedicalDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    // --- Patient Information ---
    { "patient", "patientname" },
    { "patient_name", "patientname" },
    { "pt_name", "patientname" },
    { "mrn", "patientid" }, // Medical Record Number
    { "medical_record_no", "patientid" },
    { "patient_id", "patientid" },
    { "chart_no", "patientid" },
    { "dob", "dateofbirth" }, // Already in your person dict, but common here
    { "age", "age" },

    // --- Clinical Vitals ---
    { "bp", "bloodpressure" },
    { "blood_pressure", "bloodpressure" },
    { "sys", "systolic" },
    { "dia", "diastolic" },
    { "hr", "heartrate" },
    { "heart_rate", "heartrate" },
    { "pulse", "heartrate" },
    { "temp", "temperature" },
    { "temperature", "temperature" },
    { "spo2", "oxygensaturation" },
    { "oxygen_sat", "oxygensaturation" },
    { "height", "height" },
    { "weight", "weight" },
    { "bmi", "bodymassindex" },

    // --- Providers & Insurance ---
    { "provider", "providername" },
    { "physician", "providername" },
    { "doctor", "providername" },
    { "dr", "providername" },
    { "md", "providername" },
    { "npi", "providerid" }, // National Provider Identifier
    { "specialty", "specialty" },
    { "clinic", "location" },
    { "facility", "location" },
    { "insurance", "insurancecarrier" },
    { "carrier", "insurancecarrier" },
    { "payer", "insurancecarrier" },
    { "policy_no", "policynumber" },
    { "group_no", "groupnumber" },
    { "member_id", "memberid" }
};
        }
    }

}
