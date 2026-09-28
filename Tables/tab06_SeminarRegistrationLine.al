table 50106 "CSD Seminar Registration Line"
{
    Caption = 'CSD Seminar Registration Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Bill-to Customer No."; Code[20])
        { // this field identifies the customer who will be billed for the participant
            Caption = 'Bill-to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer where(Blocked = const(" "));//There is a filter applied to this relation: where(Blocked = const(" ")), meaning that only active (non-blocked) customers can be selected in this field. If a customer is blocked, it won't appear as an option for billing purposes.
            trigger OnValidate()
            begin
                TestField(Registered, false);//ensures that changes to the billing customer can only be made before the participant is officially registered for the seminar. Once the registration is complete (i.e., Registered = true), the "Bill-to Customer No." cannot be modified.
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
            trigger OnValidate()
            begin
                if ("Bill-to Customer No." = '') or
                ("Participant Contact No." = '')
                then
                    exit;//If either "Bill-to Customer No." or "Participant Contact No." is empty, the process exits early.

                Contact.Get("Participant Contact No.");
                ContactBusinessRelation.Reset;
                ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                if not ContactBusinessRelation.FindFirst then
                    exit;
                if ContactBusinessRelation."Contact No." <> Contact."Company Name" then begin
                    Error(ContactHasDifferentCompanyThanCustomer, Contact."No.", Contact."Company Name", "Bill-to Customer No.");
                end;
                //table is checked for a relationship between the selected contact and the customer specified in the "Bill-to Customer No.".
                //If the contact is not related to the specified customer (i.e., the contact is linked to a different customer), an error message is triggered:
            end;

            trigger OnLookup()
            begin
                ContactBusinessRelation.Reset;
                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                if not ContactBusinessRelation.FindFirst then
                    exit;
                Contact.Reset;
                Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                if Page.RunModal(Page::"Contact List", Contact) = ACTION::LookupOK then begin
                    "Participant Contact No." := Contact."No.";
                    "Participant Name" := Contact."Name";
                end;
            end;
            //The ContactBusinessRelation table is filtered by the customer specified in the "Bill-to Customer No." field.
            //If a business relation is found, the system retrieves the relevant contact records associated with that customer.
            //The Contact list page is displayed to the user, allowing them to choose a contact. If the user confirms their choice (LookupOK), the "Participant Contact No." field is populated with the selected contact's number, and the "Participant Name" is updated with the corresponding name.
        }
        field(5; "Participant Name"; Text[30])
        {
            caption = 'Participant Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Registration Date"; Date)
        {
            caption = 'Registration Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            caption = 'To Invoice';
            DataClassification = ToBeClassified;
            InitValue = true; //the participant is intended to be invoiced unless someone changes the value.
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
            DataClassification = ToBeClassified;
        }
        field(9; "Confirmation Date"; Date)
        {
            caption = 'Confirmation Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Seminar Price"; Decimal)
        {
            caption = 'Seminar Price';
            DataClassification = ToBeClassified;
            AutoFormatType = 2;
            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            caption = 'Line Discount %';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;//discount percentage cannot exceed 100%, which ensures no discount can be more than the total seminar price.
            DecimalPlaces = 0 : 5;//specifies that the discount percentage can have a maximum of 5 decimal places, allowing for fine-grained control over the discount amount.
            trigger OnValidate()
            begin
                if "Seminar Price" = 0 then begin
                    "Line Discount Amount" := 0//If the "Seminar Price" is 0, the system sets the "Line Discount Amount" to 0 because a discount percentage applied to a price of 0 would result in no discount.
                end else begin
                    "Line Discount Amount" := Round("Line Discount %" * "Seminar Price" * 0.01, GLSetup."Amount Rounding Precision");
                end;//If the "Seminar Price" is greater than 0, the system calculates the discount amount based on the discount percentage. 
                UpdateAmount;//updates the total amount on the line (after applying the discount).
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Seminar Price" = 0 then begin
                    "Line Discount %" := 0//If the "Seminar Price" is 0, the system sets the "Line Discount %" to 0. This is to prevent division by zero when calculating the discount percentage, as there’s no basis for calculating a discount on a price of zero.
                end else begin
                    GLSetup.Get;
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, GLSetup."Amount Rounding Precision");
                    //If the "Seminar Price" is greater than 0, the discount percentage is recalculated 
                end;
                UpdateAmount;
            end;
        }
        field(13; Amount; Decimal)
        {
            caption = 'Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestField("Bill-to Customer No.");
                TestField("Seminar Price");
                //It first checks that the "Bill-to Customer No." and "Seminar Price" are not empty using the TestField function. This is important to ensure that the calculations are valid and that the required fields are populated.
                GLSetup.Get;//General Ledger Setup is retrieved using GLSetup.Get to ensure that any necessary rounding precision settings are applied.
                Amount := Round(Amount, GLSetup."Amount Rounding Precision");
                "Line Discount Amount" := "Seminar Price" - Amount;
                if "Seminar Price" = 0 then begin
                    "Line Discount %" := 0;//If the "Seminar Price" is 0, the "Line Discount %" is set to 0 to avoid division by zero errors.
                end else begin
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, GLSetup."Amount Rounding Precision");
                end;//If the seminar price is greater than zero, the trigger recalculates the "Line Discount %"
            end;
        }
        field(14; Registered; Boolean)
        {
            caption = 'Registered';
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(16; "Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'amount paid';
            DecimalPlaces = 2;
        }
        field(17; Balance; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2;
            Caption = 'Balance';
        }
        field(18; Description; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }


    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }


    var
        GLSetup: Record "General Ledger Setup";
        SeminarRegHeader: Record "CSD Seminar Reg. Header";
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        ContactHasDifferentCompanyThanCustomer: Label 'Contact %1 %2 is related to a different company than customer %3.';


    trigger OnInsert()
    begin
        GetSeminarRegHeader();//checks if the SeminarRegHeader record is already loaded based on the "Document No." and retrieves it if not. This ensures that the seminar registration header data is accessible for the current line.
        "Seminar Price" := SeminarRegHeader."Seminar Price";//initialized by setting the "Seminar Price" field of the new line record to the price retrieved from the SeminarRegHeader.
        Amount := SeminarRegHeader."Seminar Price";//initialized to the same value as the "Seminar Price". 
        UpdateAmount();
        Description := "Document No.";
    end;

    trigger OnModify()
    begin
        Description := "Document No.";
    end;

    trigger OnDelete()
    begin
        TestField(Registered, false);//TestField function is called to ensure that the Registered field is false. This field indicates whether the participant is registered for the seminar.If Registered is true, the deletion will be prevented.

    end;

    procedure GetSeminarRegHeader();
    begin
        if SeminarRegHeader."No." <> "Document No." then begin
            SeminarRegHeader.Get("Document No.");//checks if the No. field of the SeminarRegHeader record is different from the "Document No." of the current line. If they differ, it indicates that the relevant seminar registration header data needs to be retrieved.
            //SeminarRegHeader.Get("Document No.") statement fetches the header record that corresponds to the specified document number. This ensures that all relevant data (like seminar price) is accessible for use in subsequent calculations or validations.
        end;
    end;

    procedure CalculateAmount();
    begin
        Amount := Round(("Seminar Price" / 100) * (100 - "Line Discount %"));//The Amount is computed by taking the "Seminar Price", dividing it by 100, and then multiplying by (100 - "Line Discount %"). This effectively reduces the seminar price by the discount percentage to arrive at the net amount due.
        //The resulting value is then rounded to ensure it fits within the desired financial precision.
    end;

    procedure UpdateAmount();
    begin
        GLSetup.Get;//fetches the current settings for general ledger rounding precision from the "General Ledger Setup" table. This ensures that any calculations performed align with the financial rounding rules defined in the system.
        Amount := Round("Seminar Price" - "Line Discount Amount", GLSetup."Amount Rounding Precision");//The amount is calculated as the difference between the seminar price ("Seminar Price") and the line discount amount ("Line Discount Amount").
        //The result is rounded using the rounding precision obtained from the GLSetup record. This ensures that the final value of Amount adheres to any specified decimal or rounding constraints.
    end;


}