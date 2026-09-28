table 50105 "CSD Seminar Reg. Header"
// Chapter 6 - Lab 1
{
    Caption = 'Seminar Registration Header'; // human-readable name shown to users
    DataClassification = ToBeClassified; //related to BC's data privacy/data classification system
    LookupPageId = "CSD Seminar Registration List"; // when the user looks up this table, BC can use the "CSD Seminar Registration List" page
    DrillDownPageId = "CSD Seminar Registration List"; 

    fields
    { //the fields section defines all the columns in the table 
        field(1; "No."; Code[20])
        { // the unique registration number (ni kama ID kwa normal databases e.g Postgres)
            Caption = 'No.';
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                if "No." = '' then begin
                    SeminarSetup.Get();//If the No. field is empty, the system fetches the seminar setup  record(SeminarSetup.Get()) and verifies that a numbering series is defined (SeminarSetup.TESTFIELD("Seminar Registration Nos.")).
                    SeminarSetup.TESTFIELD("Seminar Registration Nos."); 
                    // if "Seminar Registration Nos." is empty, BC throws an error
                    
                    "No. Series" := SeminarSetup."Posted Seminar Reg. Nos."; // assign number series
                    "No." := NoSeries.GetNextNo("No. Series", WorkDate(), true); //get the next number from the number series 
                end
            end;
        }

        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Starting Date" <> xRec."Starting Date" then
                    TestField(Status, Status::Planning);
            end;
            //The OnValidate trigger checks if the Starting Date has changed compared to the previous value (xRec."Starting Date"). If it has, it ensures that the seminar's status is still set to Planning using the TestField function.
        }
        field(3; "Seminar No."; Code[20])
        { // identifies which seminar is being registered
            Caption = 'Seminar No.';
            DataClassification = ToBeClassified;
            TableRelation = "CSD Seminar" where(Blocked = const(false));//Specifies that the field relates to the CSD Seminar table, but only if the Blocked field is false (i.e., the seminar is not blocked).
            trigger OnValidate()
            begin
                IF "Seminar No." = xRec."Seminar No." THEN
                    exit;//trigger ensures that the seminar number isn't changed to a value that is already set.

                Seminar.GET("Seminar No.");
                Seminar.TESTFIELD(Blocked, FALSE);
                Seminar.TESTFIELD("Gen. Prod. Posting Group");
                Seminar.TESTFIELD("VAT Prod. Posting Group");
                "Seminar Name" := Seminar.Name;
                Duration := Seminar."Seminar Duration";
                "Seminar Price" := Seminar."Seminar Price";
                "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                "Minimum Participants" := Seminar."Minimum Participants";
                "Maximum Participants" := Seminar."Maximum Participants";
            end;//If the seminar number changes, it retrieves the seminar details (using Seminar.GET("Seminar No.")), checks certain fields (like Blocked), and populates seminar-related fields such as name, duration, price, and others.
        }
        field(4; "Seminar Name"; Text[50])
        { 
            Caption = 'Seminar Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Instructor Resource No."; Text[50])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = ToBeClassified;
            TableRelation = Resource where(Type = const(Person));// Establishes a relation with the Resource table, but only where the Type field equals Person (indicating it’s a human resource, not equipment, etc.).
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            //  DataClassification = ToBeClassified;
            CalcFormula = Lookup(Resource.Name where ("No."=Field("Instructor Resource No."), Type=const(Person)));

            Editable = false;
            FieldClass = FlowField; // a calculated field (calculated by BC rom the Resource table)
        } // find the Resource whose No. equals "Instructor Resource No." and return its Name
        field(7; Status; Option)
        {
            OptionMembers = "Planning","Registration","Closed","Cancelled";
            DataClassification = ToBeClassified;
        } // different riggers use this status to control what users can modify or delete
        field(8; Duration; Decimal)
        {
            Caption = 'Duration (Minutes)';
            DataClassification = ToBeClassified;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = ToBeClassified;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = ToBeClassified;
        } // these values are copied from the Seminar table when "Seminar No." is selected.
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = ToBeClassified;
            TableRelation = Resource where(Type = const(Machine));
            trigger OnValidate()
            var
                SeminarRoom: Record Resource;
            begin
                if "Room Resource No." = xRec."Room Resource No." then
                    exit;//checks if the new room resource number is the same as the previous one. If it is the same, the trigger exits early, preventing unnecessary validation.

                IF "Room Resource No." = '' THEN BEGIN
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address 2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room County" := '';
                    "Room Country/Region Code" := '';//If the "Room Resource No." field is cleared (i.e., set to an empty value), the associated room details ("Room Name", "Room Address", etc.) are also cleared. This ensures that when no room is selected, the other room-related fields are emptied.
                END ELSE BEGIN
                    SeminarRoom.GET("Room Resource No.");
                    "Room Name" := SeminarRoom.Name;
                    "Room Address" := SeminarRoom.Address;
                    "Room Address 2" := SeminarRoom."Address 2";
                    "Room Post Code" := SeminarRoom."Post Code";
                    "Room City" := SeminarRoom.City;
                    "Room County" := SeminarRoom.County;
                    "Room Country/Region Code" := SeminarRoom."Country/Region Code";//If a room resource is selected, the system retrieves the corresponding room record from the Resource table using the GET method (SeminarRoom.GET("Room Resource No.");).
                    //After fetching the room record, it populates the associated fields in the registration header with details about the selected room (e.g., name, address, city, etc.).

                    IF CurrFieldNo = 0 THEN
                        exit;//This checks if the field number (CurrFieldNo) is 0, meaning the field isn’t currently being processed on the UI. If this condition is true, the trigger exits, skipping the next validations.

                    IF (SeminarRoom."CSD Maximum Participants" <> 0) AND
                       (SeminarRoom."CSD Maximum Participants" < "Maximum Participants")//checks if the room's maximum participant capacity (SeminarRoom."CSD Maximum Participants") is less than the seminar's maximum participants ("Maximum Participants").
                    THEN BEGIN
                        IF CONFIRM(ChangeSeminarRoomQst, TRUE,
                             "Maximum Participants",
                             SeminarRoom."CSD Maximum Participants",
                             FIELDCAPTION("Maximum Participants"),
                             "Maximum Participants",
                             SeminarRoom."CSD Maximum Participants")
                        THEN
                            "Maximum Participants" := SeminarRoom."CSD Maximum Participants";
                        //If the room's capacity is exceeded, a confirmation prompt (CONFIRM) is shown to the user. The prompt contains the following parameters:Current "Maximum Participants",Room's "CSD Maximum Participants",Seminar’s "Maximum Participants".
                        //If the user agrees, the seminar's "Maximum Participants" value is updated to the room's maximum capacity (SeminarRoom."CSD Maximum Participants").
                    END;
                END;
            end;
        }
        field(12; "Room Name"; Text[50])
        {
            Caption = 'Room Name';
            DataClassification = ToBeClassified;
        }
        field(13; "Room Address"; Text[80])
        {
            Caption = 'Room Address';
            DataClassification = ToBeClassified;
        }
        field(14; "Room Address 2"; Text[50])
        {
            Caption = 'Room Address 2';
            DataClassification = ToBeClassified;
        }
        field(15; "Room Post Code"; Code[50])
        {
            Caption = 'Room Post Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";//linked to the Post Code table, which stores postal code data. This relationship ensures that users can only enter valid postal codes that exist in this table.
            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Room City",
                    "Room Post Code",
                    "Room County",
                    "Room Country/Region Code",
                    (CurrFieldNo <> 0) and GuiAllowed);
                //method that checks the validity of the entered postal code against the city, county, and country/region code fields. It ensures that the postal code is consistent with these other related fields:"Room City": The city where the seminar room is located."Room County": The county where the seminar room is located."Room Country/Region Code": The country or region code where the seminar room is located.
                //checks if the field is currently being processed on the user interface (UI). This ensures that the validation only happens when appropriate.
            end;
        }
        field(16; "Room City"; Text[50])
        {
            Caption = 'Room City';
            DataClassification = ToBeClassified;
        }
        field(17; "Room Country/Region Code"; Code[50])
        {
            Caption = 'Room Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(18; "Room County"; Text[50])
        {
            Caption = 'Room County';
            DataClassification = ToBeClassified;
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // when the Seminar Price is changed and the registration is not canceled, ask whether to update the price on all unregistered seminar registration lines. 
                IF("Seminar Price" <> xRec."Seminar Price") AND (Status <> Status::Cancelled) THEN BEGIN
                    SeminarRegLine.Reset();
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, false);
                    IF SeminarRegLine.FindSet(true) then
                        IF Confirm(ConfirmUpdateLinesQst, false,
                            FieldCaption("Seminar Price"),
                            SeminarRegLine.TableCaption) then repeat
                            SeminarRegLine.VALIDATE("Seminar Price", 
                            "Seminar Price");
                            SeminarRegLine.Modify;
                        until SeminarRegLine.NEXT = 0;
                        Modify;
                END
            end;
        }
        field(20; "Gen. Prod. Posting Group"; Code[50])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(21; "VAT Prod. Posting Group"; Code[50])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        // These are used for BC's posting/accounting logic.
        // They determine things such as how the seminar transaction is posted to the General Ledger and VAT system.
        field(22; Comment; Boolean)
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(25; "Reason Code"; Code[50])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        } // Reason codes are commonly used to explain why a transaction or adjustment was made.
        field(26; "No. Series"; Code[50])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(27; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";//ensures that the "Posting No. Series" field only accepts values from valid numbering series defined in the No. Series table.
            trigger OnValidate()
            begin
                if "Posting No. Series" = '' then
                    exit;//Check for Empty Field: If the "Posting No. Series" field is empty, the code exits and no further validation is performed. This ensures the user cannot proceed with an empty value.
                TestField("Posting No.", '');

                SeminarSetup.Get();//retrieves the current seminar setup record.
                SeminarSetup.TestField("Seminar Registration Nos.");//ensures that a seminar registration number series is defined in the setup.
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");//ensures that a posted seminar registration number series is defined.
                NoSeries.TestAreRelated(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");//checks if the selected series is valid by verifying that the "Posting No. Series" is part of the defined "Posted Seminar Reg. Nos." from the seminar setup. This ensures consistency and prevents the user from selecting an invalid or inappropriate series.
            end;

            trigger OnLookup()//called when the user attempts to look up values for the "Posting No. Series" field (e.g., via a dropdown or selection window).
            begin
                SeminarRegHeader := Rec;//temporarily stores the current seminar registration header record.
                SeminarSetup.Get();//retrieves the current seminar setup record.
                SeminarSetup.TestField("Seminar Registration Nos.");//ensures that a seminar registration number series is defined in the setup.
                SeminarSetup.TestField("Posted Seminar Reg. Nos.");//ensures that a posted seminar registration number series is defined.
                if NoSeries.LookupRelatedNoSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series") then
                    Validate("Posting No. Series");// LookupRelatedNoSeries() displays the number series related to the configured posting number series and stores the selected series in "Posting No. Series".

                Rec := SeminarRegHeader;//After the lookup and validation process, the original SeminarRegHeader record is restored with Rec := SeminarRegHeader;.
                //TestField for "Posting No.": The TestField("Posting No.", '') ensures that the "Posting No." field is empty when setting the posting number series. If there’s already a value in the "Posting No." field, an error will be raised, preventing a number series from being applied after a number has already been assigned.
            end;
        }
        field(28; "Posting No."; Code[50])
        {
            Caption = 'Posting No.';
            DataClassification = ToBeClassified;
        }
        field(29; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(32; Description; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(33; "Approval Status"; Enum "CSD Approval Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Approval Status';
            Editable = false;
        } // stores the approval stage of the seminar registration. it is read-only because its value is updated by the approval process

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Seminar No.", "Seminar Name", "Starting Date")
        {

        }// This controls which fields are shown in dropdown/lookup representations of the record.
    }

    var
        SeminarSetup: Record "CSD Seminar Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement; // NoSeriesManagement is obsolete
        NoSeries: Codeunit "No. Series";
        PostCode: Record "Post Code";
        Seminar: Record "CSD Seminar";
        SeminarRegHeader: Record "CSD Seminar Reg. Header";
        SeminarCommentLine: Record "CSD Seminar Comment Line";
        SeminarRegLine: Record "CSD Seminar Registration Line";
        SeminarCharge: Record "CSD seminar Charge";
        ErrCannotDeleteLine: Label 'Cannot delete the Seminar Registration, there exists at least one %1 where %2=%3.';
        ErrCannotDeleteCharge: Label 'Cannot delete the Seminar Registration, there exists at least one %1.';
        ChangeSeminarRoomQst: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        ConfirmUpdateLinesQst: Label 'Do you want to update %1 on all %2?';
        ErrApprovalStatus: Label 'Cannot modify the record because the approval status is %1.';

    trigger OnInsert()
    begin
        if "No." = '' then begin//The trigger first checks if the "No." field is empty. This field represents the unique identifier or code for the record. If the field is empty, the system needs to generate a new number for the record using a numbering series.
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");

            "No. Series" := SeminarSetup."Seminar Registration Nos.";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate(), true);
            // generate a new registration number from the number series configured in Seminar Setup.
            // the modern "No. Series" codeunit replaces the legacy NoSeriesManagement codeunit. GetNextNo() retrieves the next available number and advances the number series.
        end;
        InitRecord;//initializes some default values for the record, such as setting dates or other fields. In this case, it initializes fields like the "Posting Date" and "Document Date" to the current working date.

        if GetFilter("Seminar No.") = '' then
            exit;//GetFilter() method returns any filter applied to the specified field. If there is no filter (meaning the field is empty), the system exits the trigger without proceeding further.

        IF GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") THEN
            Validate("Seminar No.", GetRangeMin("Seminar No."));
        //If there is a filter on the "Seminar No." field, the system checks whether the range of the filter's minimum and maximum values is the same. If the range has only one value (i.e., the same minimum and maximum), it means a specific seminar number is selected.
        //The system then uses the Validate() method to validate the "Seminar No." field with the minimum value from the range. This triggers any validation logic defined for the "Seminar No." field (such as checking if the seminar is blocked or if required fields are set).
    end;

    trigger OnDelete()
    begin
        if (CurrFieldNo > 0) then
            TestField(Status, Status::Cancelled);
        //The system checks whether the current field being processed (CurrFieldNo) is greater than 0, meaning the record is being manually deleted (as opposed to being automatically deleted by the system).
        //If this condition is true, the system validates that the Status of the record must be set to Cancelled.
        //If the status is not Cancelled, the deletion process is stopped, and an error is thrown. This ensures that only records that have been explicitly cancelled can be deleted, which is useful for preventing accidental deletion of active or planned seminar registrations    
        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", "No.");
        SeminarRegLine.SETRANGE(Registered, TRUE);
        IF SeminarRegLine.FIND('-') THEN
            ERROR(
              ErrCannotDeleteLine,
              SeminarRegLine.TABLECAPTION,
              SeminarRegLine.FIELDCAPTION(Registered),
              TRUE);
        //The system resets the SeminarRegLine table and sets a range filter on the "Document No." field to match the "No." of the current seminar registration record. It also filters to only include lines where the Registered field is set to TRUE.
        //If any related seminar registration lines are found with Registered = TRUE, the system raises an error using the predefined error message (ErrCannotDeleteLine). This prevents deletion of seminar registration headers if there are any associated registered seminar lines.
        SeminarRegLine.SETRANGE(Registered);//If there are no registered seminar lines, the system resets the range on the Registered field, removing any filters, and proceeds to delete all seminar registration lines associated with the current document (i.e., seminar registration header).
        SeminarRegLine.DELETEALL(TRUE);//deletes all records that match the specified filters (in this case, all lines related to the current registration).

        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", "No.");//The system checks the SeminarCharge table for any related records by filtering on the "Document No." field to match the current seminar registration number.
        IF NOT SeminarCharge.ISEMPTY THEN
            ERROR(ErrCannotDeleteCharge, SeminarCharge.TABLECAPTION);
        //If any seminar charges exist, the system raises an error using the predefined error message (ErrCannotDeleteCharge). This prevents the deletion of the seminar registration header if there are related seminar charges, as these charges must be addressed before the registration can be deleted.
        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange(
            SeminarCommentLine."Table Name", SeminarCommentLine."Table Name"::"Seminar Registration");
        //The system resets the SeminarCommentLine table and filters for records where the "Document Type" is set to Seminar Registration and the "No." matches the current seminar registration number.
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.DeleteAll();
        //After applying these filters, it proceeds to delete all related seminar comment lines using the DeleteAll() method. This ensures that any comments related to the seminar registration are also removed when the registration header is deleted.
    end;

    trigger OnModify()
    begin
        Description := "No.";
    end;

    procedure InitRecord();
    begin
        if "Posting Date" = 0D then
            "Posting Date" := Today();

        "Document Date" := Today();
        Description := "No.";
        SeminarSetup.Get();
        SeminarSetup.TestField("Posted Seminar Reg. Nos.");
        //NoSeries.SetDefaultSeries("Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");
        "Posting No. Series" := SeminarSetup."Posted Seminar Reg. Nos.";
        //set the default posting number series from Seminar Setup
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record "CSD Seminar Reg. Header"): Boolean
    // a helper procedure used to allow the user to change/select the number series.
    begin
        SeminarRegHeader := Rec;//stores the current seminar registration record in a local variable, SeminarRegHeader. This ensures that the original record is preserved for reference during the process of assisting with the editing of the numbering series.
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");

        if not NoSeries.LookupRelatedNoSeries(
            SeminarSetup."Seminar Registration Nos.",//SeminarSetup."Seminar Registration Nos.": The numbering series defined in the seminar setup for registrations.
            OldSeminarRegHeader."No. Series", "No. Series") then//OldSeminarRegHeader."No. Series": The old numbering series that was previously selected."No. Series": The field in the current record where the selected numbering series will be stored.
            exit(false);//If the user cancels the selection or an error occurs (i.e., the method returns false), the procedure immediately exits, returning false to indicate that the edit was not completed.

        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Registration Nos.");
        //NoSeries.SetSeries("No.");

        Rec := SeminarRegHeader;//restores the original record by assigning SeminarRegHeader (which was saved at the beginning) back to Rec. This ensures that any other fields in the record are not altered unintentionally during the numbering series selection.
        exit(TRUE);//If the procedure completes successfully, it returns true, indicating that the numbering series has been successfully edited or assigned.
    end;
}

// this table is essentially the central document that controls a seminar event, while the related tables provide the seminar definition, instructor, room, participants, comments, and charges.