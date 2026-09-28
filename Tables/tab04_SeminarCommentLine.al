table 50104 "CSD Seminar Comment Line"
// the purpose is to store comments/notes related to seminars, seminar registrations, posted seminars, or registrations
{
    DataClassification = ToBeClassified;
    Caption = 'Seminar Comment Line';
    LookupPageId = "CSD Seminar Comment List";
    DrillDownPageId = "CSD Seminar Comment List";
    
    fields
    {
        field(10; "Table Name"; Option)
        { // identifies the type of record that the comment belongs to.
            DataClassification = ToBeClassified;
            Caption = 'Table Name';
            OptionMembers =  "Seminar", "Seminar Registration", "Posted Seminar", "Registration"; // defines the four possible record types for comments
        }

        field(20; "Document Line No."; Integer)
        { // stores the document line number to which the comment belongs.
            DataClassification = ToBeClassified;
            Caption = 'Document Line No.';
        } // This allows comments to be associated with a particular line of a document, rather than only the document itself.

        field(30; "No."; Code[20])
        { // The lookup table depends on the selected Table Name.
            // If Table Name = Seminar, the No. comes from CSD Seminar.
            DataClassification = ToBeClassified;
            Caption = 'No.';
            
            TableRelation = if ("Table Name" = CONST(Seminar)) "CSD Seminar" 
                else if ("Table Name" = const("Seminar Registration")) "CSD Seminar Reg. Header";
        }

        field(40; "Line No."; Integer)
        { // stores the comment's line number
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }

        field(50; Date; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date';
        }

        field(60; Code; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }

        field(70; Comment; Text[50])
        { // stores the actual comment text
            DataClassification = ToBeClassified;
            Caption = 'Comment';
        }
    }
    
    keys
    {
        key(PK; "Table Name", "Document Line No.", "No.", "Line No.") // a comment is uniquely identified by the combination of these four values
        {
            Clustered = true;
        }
    }
    
    fieldgroups
    {
        // Add changes to field groups here
    }

    procedure SetupNewLine()
    var
        SeminarCommentLine: Record "CSD Seminar Comment Line";
    begin
        SeminarCommentLine.SetRange("Table Name", "Table Name");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
        SeminarCommentLine.SetRange(Date, WorkDate);
        if SeminarCommentLine.IsEmpty then
            Date := WorkDate;
    end; // look for an existing comment line for the same table, document number, document line, and working date. If none exists, give this new comment line the current working date.
}