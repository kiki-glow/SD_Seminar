table 50101 "CSD Seminar"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 5 - Lab 2-2
{
    Caption = 'Seminar';
    LookupPageId = 50102;
    DrillDownPageId = 50102;
    
    fields
    {
        field(10;"No."; Code[20])
        {
            Caption = 'No.';
            
            trigger OnValidate()

            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.Get();
                    NoSeries.TestManual(SeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }

        field(20; "Name"; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            
            begin
                if ("Search Name"=UpperCase(xRec.Name)) or ("Search Name"='') then
                "Search Name" := Name;
            end;
        }

        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0:1;
        }

        field(40; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }

        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }

        field(60; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }

        field(70; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
        }

        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }

        field(90; "Comment"; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            //FieldClass=FlowField;
            //CalcFormula=exist("Seminar Comment Line" 
            //where("Table Name"= const("Seminar"), 
            //  "No."=Field("No.")));
        }

        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
        }

        field(110; "Gen. Prod. Posting Group"; Code[50])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            
            begin
                if (xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group") then begin
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup,"Gen. Prod. Posting Group") then
                    Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
                end;
            end;
        }

        field(120; "VAT Prod. Posting Group"; Code[50])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }

        field(130; "No. Series"; Code[50]) // change to -> Code[20] (the standard No. Series code length
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }
    
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }

        key(Key1; "Search Name") 
        {

        }
    }
    
    fieldgroups
    {
        // Add changes to field groups here
    }
    
    var
        SeminarSetup: Record "CSD Seminar Setup";
        // CommentLine: record "CSD Seminar Comment Line";
        Seminar: Record "CSD Seminar";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeries: Codeunit "No. Series";
    
    trigger OnInsert()
    begin
        if "No."='' then begin
            SeminarSetup.get;
            SeminarSetup.TestField("Seminar Nos.");
            "No. Series" := SeminarSetup."Seminar Nos.";
            "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;
    
    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;
    
    trigger OnDelete()
    begin
        // CommentLine.Reset;
        // CommentLine.SetRange("Table Name",
        // CommentLine."Table Name"::Seminar);
        // CommentLine.SetRange("No.","No.");
        // CommentLine.DeleteAll;
    end;
    
    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    procedure AssistEdit() : Boolean
    begin
        // Seminar := Rec;
        SeminarSetup.Get();
        SeminarSetup.TestField("Seminar Nos.");

        if NoSeries.LookupRelatedNoSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", Seminar."No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;

        exit(false);
    end;
    
}