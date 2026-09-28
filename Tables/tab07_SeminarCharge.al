table 50107 "CSD Seminar Charge"
{
    Caption = 'Seminar Charge';
    DataClassification = ToBeClassified;
    LookupPageId = "CSD Seminar Charge";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "CSD Seminar Reg. Header"; // establishes a relationship with the seminar reg. header table
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Resource,"G/L Account";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Type = xRec.Type then//The first line checks if the new value of Type (Type) is the same as the old value (xRec.Type).
                    exit;//If they are the same, the procedure exits early using exit;
                Description := '';//This ensures that the description is cleared whenever the type changes, as the description is likely dependent on the type selected (either Resource or G/L Account).
            end;
        }
        field(4; "No."; code[20])
        { // this stores the actual number/code of the resource or G/L account.
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = if
                (Type = const(Resource)) Resource where(Type = const(Person), Blocked = const(false))
            else
            if (Type = const("G/L Account")) "G/L Account" where(Blocked = const(false), "Direct Posting" = const(false));
            trigger OnValidate()
            begin
                case Type of//case statement checks the value of the Type field
                    Type::Resource://For Resource:
                        begin
                            Resource.Get("No.");//The code retrieves the Resource record whose value in "No.". 
                            Resource.TestField(Blocked, false);//It checks if the resource is not blocked.
                            Resource.TestField(Type, Resource.Type::Person);//It verifies that the resource type is Person.
                            Resource.TestField("Gen. Prod. Posting Group");//It also checks that the Gen. Prod. Posting Group field is populated.
                            Description := Resource.Name;
                            "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group";
                            "Unit of Measure Code" := Resource."Base Unit of Measure";
                            "Unit Price" := Resource."Unit Cost";
                            //If all checks pass, it populates the Description, Gen. Prod. Posting Group, VAT Prod. Posting Group, Unit of Measure Code, and Unit Price fields based on the resource details.
                        end;
                    Type::"G/L Account":
                        begin
                            GLAccount.Get("No.");//retrieves the general ledger account using the Get method with the "No." value.
                            GLAccount.CheckGLAcc();//validates that the account is a proper G/L account through the CheckGLAcc method.
                            GLAccount.TestField("Direct Posting", true);//It ensures that the account allows direct posting (Direct Posting must be true).
                            Description := GLAccount.Name;
                            "Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";
                            //If valid, it populates the Description, Gen. Prod. Posting Group, and VAT Prod. Posting Group fields from the G/L account.
                        end;
                end;
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {// stores how many units are being charged
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                "Total Price" := Round("Unit Price" * Quantity, 0.01);//ensure that the Total Price is correctly calculated and updated based on the Quantity entered.
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            MinValue = 0.0; // the unit price cannot be negative
            AutoFormatType = 2; // tells BC to apply an appropriate numeric/currency formatting style
            trigger OnValidate()
            begin
                "Total Price" := Round("Unit Price" * Quantity, 0.01);
            end;
        }
        field(8; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = ToBeClassified;
            Editable = false; // the user cannot manually edit it. instead, the system calculates it
            AutoFormatType = 2;

            // trigger OnValidate()
            // begin
            //     if (Quantity <> 0) then
            //         "Unit Price" := Round("Total Price" / Quantity, 0.01)
            //     else
            //         "Unit Price" := 0;
            // end; // When the user changes the Total Price, the system calculates the Unit Price.
        }
        field(9; "To Invoice"; Boolean)
        { // this indicates whether the charge should be included in invoicing
            Caption = 'To Invoice';
            DataClassification = ToBeClassified;
            InitValue = true; // by default, the charge is intended to be invoiced
        }
        field(10; "Bill-to Customer No."; code[20])
        {// stores the customer who will be billed
            Caption = 'Bill-to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer; // the value must correspond to a Customer record
        }
        field(11; "Unit of Measure Code"; code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = if
                (Type = const(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            "Unit of Measure".Code;

            trigger OnValidate()
            var
                ResourceUofM: Record "Resource Unit of Measure";
            begin
                case Type of//If the Type is Resource:
                    Type::Resource:
                        begin
                            Resource.Get("No.");//The record corresponding to the selected resource is fetched using the "No." field.
                            if "Unit of Measure Code" = '' then begin
                                "Unit of Measure Code" := Resource."Base Unit of Measure";
                                //If the "Unit of Measure Code" is empty, it is automatically set to the resource's "Base Unit of Measure".
                            end;
                            ResourceUofM.Get("No.", "Unit of Measure Code");
                            "QTY. per Unit of Measure" := ResourceUofM."Qty. per Unit of Measure";//The corresponding record from the Resource Unit of Measure table is retrieved to get the "Qty. per Unit of Measure", which indicates how many of the base unit are in one unit of measure.
                            "Total Price" := Round(Resource."Unit Price" * "QTY. per Unit of Measure");//The "Total Price" is then calculated as the product of the resource's "Unit Price" and the "Qty. per Unit of Measure".
                        end;
                    Type::"G/L Account"://If the Type is "G/L Account"
                        begin
                            "QTY. per Unit of Measure" := 1;//The "QTY. per Unit of Measure" is set to 1, indicating a single unit is counted for general ledger accounts.
                        end;
                end;
                if CurrFieldNo = FieldNo("Unit of Measure Code") then begin
                    Validate("Unit Price");
                    //If the current field being modified is the Unit of Measure Code, the "Unit Price" is validated to ensure that it is appropriate given the selected unit of measure.
                end;
            end;
        }
        field(12; "Gen. Prod. Posting Group"; code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(13; "VAT Prod. Posting Group"; code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(14; "QTY. per Unit of Measure"; Decimal)
        { // stores how many base units are represented by one selected unit of measure.
            Caption = 'QTY. per Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(15; Registered; Boolean)
        {
            Caption = 'Registered';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        } // the unique identity of a charge line is Document No. + Line No.
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        Resource: Record Resource; // this creates a variable that represents a record from the Resource table.
        GLAccount: Record "G/L Account"; 

    trigger OnDelete()
    begin
        TestField(Registered, false);//TestField function is called to ensure that the Registered field is false. This field indicates whether the participant is registered for the seminar.If Registered is true, the deletion will be prevented.
    end;
}