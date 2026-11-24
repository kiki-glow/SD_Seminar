// stores the posting instructions that create seminar ledger entries.
table 50131 "CSD Seminar Journal Line"
{
    Caption = 'Seminar Journal Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal Template Name"; Code[20])
        {
            Caption = 'Journal Template Name';
            DataClassification = CustomerContent;
            // groups journal lines by their posting template.
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            // provides the unique sequence within a journal batch.
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
            // identifies the seminar affected by the posting.
            TableRelation = "CSD Seminar";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Document Date" := "Posting Date";
            end;
            // specifies the date for the entry. this is the date that the transaction occurred.
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(6; "Entry Type"; Enum "CSD Seminar Journal Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            // determines whether the line registers or cancels a participant.
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(11; "Charge Type"; Enum "Seminar Journal Charge Type")
        {
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
            // determines whether this is an instructor, room, or participant charge.
        }
        field(12; Type; Enum "CSD Seminar Charge Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            // determines whether the charge is based on a resource or G/L account.
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(14; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(15; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
        }
        field(16; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            DataClassification = CustomerContent;
            TableRelation = Contact;
        }
        field(17; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            DataClassification = CustomerContent;
        }
        field(18; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            DataClassification = CustomerContent;
        }
        field(19; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            DataClassification = CustomerContent;
            // Rooms are represented by Machine resources in the standard Resource table.
            TableRelation = Resource where(Type = const(Machine));
        }
        field(20; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource where(Type = const(Person));
        }
        field(21; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(22; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            DataClassification = CustomerContent;
        }
        field(23; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "Res. Ledger Entry";
        }
        field(30; "Source Type"; Enum "Seminar Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
            // controls which table supplies the Source No. lookup.
        }
        field(31; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            // points to the originating seminar when Source Type is Seminar.
            TableRelation = if ("Source Type" = const(Seminar)) "CSD Seminar";
        }
        field(32; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(33; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            Editable = false;
        }
        field(34; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(35; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure EmptyLine(): Boolean
    begin
        // a line without a seminar and quantity has no posting effect.
        exit(("Seminar No." = '') and (Quantity = 0));
    end;
}
