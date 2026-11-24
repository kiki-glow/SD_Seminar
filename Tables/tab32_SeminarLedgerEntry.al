// Stores the permanent audit trail created when seminar journal lines are posted.
table 50132 "CSD Seminar Ledger Entry"
{
    Caption = 'Seminar Ledger Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            // Uniquely identifies this posted ledger entry.
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
            // Identifies the seminar affected by this entry.
            TableRelation = "CSD Seminar";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(5; "Entry Type"; Enum "CSD Seminar Journal Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            // Preserves whether the posting registered or cancelled a participant.
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
        }
        field(9; "Charge Type"; Enum "Seminar Journal Charge Type")
        {
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
            // Identifies the instructor, room, or participant charge posted.
        }
        field(10; Type; Enum "CSD Seminar Charge Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            // Identifies whether the posted charge uses a resource or G/L account.
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(13; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
        }
        field(14; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            DataClassification = CustomerContent;
        }
        field(15; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            DataClassification = CustomerContent;
        }
        field(16; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            DataClassification = CustomerContent;
        }
        field(17; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = CustomerContent;
        }
        field(18; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = CustomerContent;
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(20; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            DataClassification = CustomerContent;
        }
        field(21; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(22; "Source Type"; Enum "Seminar Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
            // Records the type of source document that created the entry.
        }
        field(23; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            // Stores the source record number for traceability.
        }
        field(24; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(25; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
        }
        field(26; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(27; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(28; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            // Records the user who posted the entry.
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                SelectedUser: Record User;
                UserSelection: Codeunit "User Selection";
            begin
                // Opens the supported user lookup and stores the selected user name.
                if UserSelection.Open(SelectedUser) then
                    "User ID" := SelectedUser."User Name";
            end;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Index01; "Document No.", "Posting Date") { }
    }
}
